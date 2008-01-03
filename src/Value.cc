/*
 * Copyright (C) 2002,2003,2004 Daniel Heck
 * Copyright (C) 2007 Ronald Lamprecht
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 */

#include "Value.hh"

#include "errors.hh"
#include "enigma.hh"
#include "ecl.hh"
#include "main.hh"
#include "Object.hh"
#include "world.hh"

#include <set>
#include <vector>

using namespace std;
using namespace ecl;

namespace enigma {
    
/* -------------------- Value implementation -------------------- */

    Value::Value() : type (NIL) {
    }
    
    Value::Value(const char* str) : type (STRING) {
        val.str = new char[strlen(str)+1];
        strcpy(val.str, str);
    }
    
    Value::Value(double d) : type (DOUBLE) {
         val.dval[0] = d;
    }
    
    Value::Value(int i) : type (DOUBLE) {
         val.dval[0] = i;
    }
    
    Value::Value(bool b) : type (BOOL) {
         val.dval[0] = b;
    }
    
    Value::Value(Object *obj) : type (OBJECT) {
         if (obj != NULL)
             val.dval[0] = obj->getId();
         else
             val.dval[0] = 0;
    }
    
    Value::Value(ObjectList aList) : type (GROUP) {
        std::string descriptor;
        ObjectList::iterator it;
        for (it = aList.begin(); it != aList.end(); ++it) {
            if (*it == NULL)
                descriptor.append("#0,");
            else {
                Value v = (*it)->getAttr("name");
                if (v && v.type == STRING && strcmp(v.val.str, "") != 0) {
                    descriptor.append(v);
                    descriptor.append(",");
                } else {
                    descriptor.append(ecl::strf("#%d,", (*it)->getId()));
                }   
            }
        }
        val.str =  new char[descriptor.size() + 1];
        strcpy(val.str, descriptor.c_str());
    //    Log << "Value ObjectList '" << descriptor << "'\n";
    }
    
    Value::Value(TokenList aList) : type (TOKENS) {
        std::string descriptor;
        TokenList::iterator it;
        for (it = aList.begin(); it != aList.end(); ++it) {
            switch ((*it).type) {
                case STRING :
                    ASSERT((*it).val.str[0] != 0, XLevelRuntime, "TokenList: illegal empty string value");                
                    descriptor.append((*it).val.str);
                    break;
                case OBJECT :
                    descriptor.append(ecl::strf("#%d", (int)((*it).val.dval[0])));
                    break;
                case GROUP :
                    descriptor.append("%");
                    descriptor.append((*it).val.str);
                    break;
                default :
                    ASSERT(false, XLevelRuntime, "TokenList: illegal value type");
                    break;
            }
            descriptor.append(";");
        }
        val.str =  new char[descriptor.size() + 1];
        strcpy(val.str, descriptor.c_str());
     
    //    Log << "Value TokenList '" << descriptor << "'\n";
    }
    
    Value::Value(ecl::V2 pos) : type (POSITION) {
         val.dval[0] = pos[0];
         val.dval[1] = pos[1];
    }
    
    Value::Value(GridPos gpos) : type (POSITION) {
         val.dval[0] = gpos.x;
         val.dval[1] = gpos.y;
    }
    
    Value::Value(Type t) : type (t) {
        switch (t) {
            case POSITION :
                val.dval[1] = 0;
                // fall thorough
            case DOUBLE :
                val.dval[0] = 0;
                break;
            case STRING :
            case GROUP :
            case TOKENS :
                val.str = new char[1];
                val.str[0] = 0;
                break;
            case BOOL :
                val.dval[0] = false;
                break;
            case OBJECT :
                val.dval[0] = (double) NULL;
                break;
        }
    }
    
    Value::~Value() { 
        clear(); 
    }
    
    
    Value::Value(const string& str) : type(STRING) {
        val.str = new char[str.length()+1];
        strcpy(val.str, str.c_str());
    }
    
    Value::Value (const Value& other) : type(NIL) {
        this->operator=(other);
    }
    
    Value& Value::operator= (const Value& other) {
        if (this != &other) {
            switch (other.type) {
                case STRING:
                    assign(other.val.str);
                    break;
                case GROUP:
                    assign(other.val.str);
                    type = GROUP;
                    break;
                default:
                    clear();
                    type = other.type;
                    val = other.val;
            }
        }
        return *this;
    }
    
    bool Value::operator==(const Value& other) const {
        if (type != other.type)
            return false;
        else
            switch (type) {
                case DOUBLE :
                case BOOL :
                case OBJECT :
                    return val.dval[0] == other.val.dval[0];
                case STRING :
                case GROUP :
                case TOKENS :
                    return strcmp(val.str, other.val.str) == 0;
                case POSITION :
                    return (val.dval[0] == other.val.dval[0]) && (val.dval[1] == other.val.dval[1]);
            }
        return true;
    }
    
    bool Value::operator!=(const Value& other) const {
        return ! (*this == other);
    }
    
    bool Value::operator==(int i) const {
        return (int) *this == i;
    }
    
    bool Value::operator!=(int i) const {
        return (int) *this != i;
    }
    
    bool Value::operator<=(int i) const {
        return (int) *this <= i;
    }
    
    bool Value::operator>=(int i) const {
        return (int) *this >= i;
    }
    
    Value::operator bool() const {
        if (isDefault())
            return false;
        else
            return true;
    }
    
    Value::operator double() const {
        switch (type) {
            case DOUBLE: 
                return val.dval[0];
            case BOOL: 
                return (val.dval[0] != 0) ? 1 : 0;
            case STRING:
                return atof(val.str);  // TODO use strtod and eval remaining part of string
            default:
                return 0.0;
        }
    }
    
    Value::operator int() const {
        switch (type) {
            case DOUBLE:
                return round_nearest<int>(val.dval[0]);
            case BOOL: 
                return (val.dval[0] != 0) ? 1 : 0;
            case STRING: 
                return atoi(val.str);  //TODO use strtol and eval remaining part of string
            default: return 0;
        }
    }
    
    Value::operator Object *() const {
        switch (type) {
            case OBJECT:
                return Object::getObject(round_nearest<int>(val.dval[0]));
            case STRING:
                return GetNamedObject(val.str);            
            default: 
                return NULL;
        }
    }
    
    Value::operator ObjectList() const {
        ObjectList result;
        switch (type) {
            case STRING:
                if (std::string(val.str).find_first_of("*?") != std::string::npos) {
                    // wildcards in object name - we need to add all objects
                    result = GetNamedGroup(val.str);
                    break;
                }
                // else it is a single object name - fall through
            case OBJECT:
                result.push_back(*this);
                break;
            case GROUP:
                std::vector<std::string> vs;
                ecl::split_copy(std::string(val.str), ',', back_inserter(vs));
                for (std::vector<std::string>::iterator it = vs.begin(); it != vs.end(); ++it) {
                    if (it->size() > 0) {
                        if ((*it)[0] == '#') {
                            result.push_back(Object::getObject(atoi((*it).c_str() + 1)));
                        } else {
                            result.push_back(GetNamedObject(*it));
                        }
                    }
                }
                break;
        }
        return result;
    }
    
    Value::operator TokenList() const {
        TokenList result;
        switch (type) {
            case OBJECT:
            case STRING:
            case GROUP:
                result.push_back(*this);
                break;
            case TOKENS:
                std::vector<std::string> vs;
                ecl::split_copy(std::string(val.str), ';', back_inserter(vs));
                for (std::vector<std::string>::iterator it = vs.begin(); it != vs.end(); ++it) {
                    if (it->size() > 0) {
                        if ((*it)[0] == '#') {
                            // an object id
                            Value v(OBJECT);
                            v.val.dval[0] = atoi((*it).c_str() + 1);
                            result.push_back(v);
                        } else if ((*it)[0] == '%'){
                            // a group
                            Value v(NIL);
                            v.assign((*it).c_str() + 1);
                            v.type = GROUP;
                            result.push_back(v);
                        } else {
                            // a string
                            result.push_back(Value(*it));
                        }
                    }
                }
                break;
        }
        return result;
    }
    
    Value::operator ecl::V2() const {
        switch (type) {
            case POSITION: {
                return ecl::V2(val.dval[0], val.dval[1]);
            }
            default:
                return ecl::V2(0, 0);
        }
    }
    
    Value::operator GridPos() const {
        switch (type) {
            case POSITION:
                return GridPos(round_down<int>(val.dval[0]), round_down<int>(val.dval[1]));
            default:
                return GridPos(0, 0);
        }
    }
    
    Value::operator const char*() const {
        static std::string s;
        switch (type) {
            case Value::DOUBLE:
                s = ecl::strf("%g", val.dval[0]);  // need drop of trailing zeros and point for int
                return s.c_str();
            case Value::STRING: 
                return val.str;
            case Value::NIL:
            case Value::DEFAULT:
            default: 
                s.clear();
                return s.c_str();
        }
    }
    
    void Value::assign(const char* s) {
        clear();
        type = STRING;
        val.str = new char[strlen(s)+1];
        strcpy(val.str, s);
    }
    
    void Value::assign(double d) { 
        clear(); type=DOUBLE; val.dval[0]=d; 
    }
    
    void Value::clear() {
        switch (type) {
            case STRING:
            case GROUP:
               delete[] val.str;
               break;
        }
        type = NIL;
    }
    
    Value::Type Value::getType() const {
        return type;
    }
    
    double Value::get_double() const throw(){
        ASSERT(type == DOUBLE, XLevelRuntime, "get_double: type not double");
        return val.dval[0];
    }
    
    const char* Value::get_string() const throw() {
        ASSERT(type == STRING, XLevelRuntime, "get_string: type not string");
        return val.str;
    }
    
    bool Value::isDefault() const {
        return type == DEFAULT;
    }
    
    std::string Value::to_string() const{
        return std::string(*this);
    }
    
    bool Value::to_bool() const {
        switch (type) {
            case BOOL :
            case DOUBLE :
                return val.dval[0] != 0;
            case NIL :
            case DEFAULT :
                return false;
            default :
                return true;
        }
    }
    
    
    int to_int(const Value &v) {
        return v;
    }
    
    bool to_bool(const Value &v) {
        return v.to_bool();
    }
    
    double to_double(const Value &v) {
        return v;
    }
    
    std::string to_string(const Value &v) {
        return v.to_string();
    }
    
    Direction to_direction (const Value &v) {
        int val = Clamp(to_int(v), 0, 3);
        return static_cast<Direction>(val);
    }
    
} // namespace enigma
