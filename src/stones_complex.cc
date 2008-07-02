/*
 * Copyright (C) 2002,2003,2004 Daniel Heck
 * Copyright (C) 2007 Ronald Lamprecht
 *
 * This program is free software; you can redistribute it and/ or
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

#include "errors.hh"
#include "laser.hh"
#include "SoundEffectManager.hh"
#include "server.hh"
#include "player.hh"
#include "Inventory.hh"
#include "stones_internal.hh"
#include "stones/ConnectiveStone.hh"
#include "actors.hh"
#include "main.hh"
#include "Value.hh"

#include "ecl_util.hh"

#include <algorithm>
#include <iostream>

using namespace std;

namespace enigma { 

/* -------------------- PullStone -------------------- */

// When pushed this stone acts like pulled.
// When pushed by an actor it exchanges its position with the actor.

namespace
{
    struct PulledActor {
        // Variables
        Actor *actor;
        V2     speed;

        // Constructor
        PulledActor(Actor *actor_, const V2& speed_)
        : actor(actor_), speed(speed_)
        {
        }

    };

    class PullInfo {
        list<PulledActor>  actors;
        YieldedGridStone  *ystone;

    public:
        PullInfo(Stone *st)
        : ystone(st ? new YieldedGridStone(st) : 0)
        {}
        ~PullInfo() { delete ystone; }

        void add_actor(Actor *actor, const V2& speed) {
            actors.push_back(PulledActor(actor, speed));
        }

        list<PulledActor>& get_actors() { return actors; }

        void set_stone(GridPos pos) { if (ystone) ystone->set_stone(pos); }
        void dispose() { if (ystone) ystone->dispose(); }
    };


    class PullStone : public Stone, public TimeHandler {
        DECL_TRAITS;
        // Variables.
        enum State { IDLE, MOVING, VANISHED } state;
        Direction  m_movedir;
        PullInfo  *pull_info;   // information about moved objects (only valid during pull)

    public:
        PullStone();
        ~PullStone();

    private:
        // Object interface.
        PullStone *clone();
        void       dispose();
        
        // Stone interface.
        void actor_hit(const StoneContact &sc) {
            if (state == IDLE)
                maybe_push_stone(sc);
        }
        void on_impulse(const Impulse& impulse, bool isWireImpulse=false);
        bool is_removable() const {
            return state == IDLE;
        }

        // TimeHandler interface.
        void alarm();

        // Functions.
        void change_state(State new_state);
        void set_move_state(bool appearing, Direction move_dir);

    };
    DEF_TRAITSM(PullStone, "st-pull", st_pull, MOVABLE_IRREGULAR);    
}

PullStone::PullStone()
: state(IDLE), m_movedir(NODIR) , pull_info(0)
{}

PullStone::~PullStone() {
    GameTimer.remove_alarm(this);
    delete pull_info;
}

PullStone *PullStone::clone() {
    PullStone *other = new PullStone(*this);
    other->pull_info = 0;
    return other;
}

void PullStone::dispose() {
    if (state == MOVING && pull_info != 0)
        pull_info->dispose();
    delete this;
}

void PullStone::set_move_state (bool appearing, Direction move_dir) {
    if (appearing) {
        m_movedir = move_dir;
        // only the half-stone on the new field gets an alarm
        // wherein it completes the move
        GameTimer.set_alarm(this, 0.09, false);
    }
    else
        m_movedir = reverse(move_dir);
    change_state(MOVING);
}

void PullStone::change_state (State new_state) {
    switch (new_state) {
    case IDLE: set_model("st-pull"); break;
    case MOVING: {
            string mname = string("st-pull") + to_suffix(m_movedir);
            set_model(mname);
            break;
        }
    case VANISHED: break;
    }
    state = new_state;
}

void PullStone::alarm() {
    ASSERT(state == MOVING, XLevelRuntime, "PullStone: alarm called with inconsistent state");
    GridPos oldpos = move (get_pos(), reverse(m_movedir));

    // remove the disappearing half of the PullStone :
    PullStone *oldStone = dynamic_cast<PullStone*>(GetStone(oldpos));
    ASSERT(oldStone, XLevelRuntime, "PullStone: oldStone non-existent in alarm");
    oldStone->change_state(VANISHED);
    KillStone(oldpos);

    if (pull_info) {            // have other objects been moved ?
        pull_info->set_stone(oldpos); // re-sets any pulled stone

        // set pulled actor(s):
        list<PulledActor>::iterator e = pull_info->get_actors().end();
        for (list<PulledActor>::iterator i = pull_info->get_actors().begin(); i != e; ++i) {
            PulledActor& pulled = *i;
            pulled.actor->get_actorinfo()->vel = pulled.speed;
        }
        delete pull_info;
        pull_info = 0;
    }

    change_state(IDLE);
}

void PullStone::on_impulse(const Impulse& impulse, bool isWireImpulse) 
{
    if (state != IDLE)
        return;

    Direction       move_dir    = reverse(impulse.dir);
    const GridPos&  oldPos      = get_pos();
    GridPos         newPos      = move(oldPos, move_dir);
    Stone          *other_stone = GetStone(newPos);

    if (!IsInsideLevel(newPos) || (other_stone && (!other_stone->is_removable() || 
        (IsLevelBorder(newPos) && server::GameCompatibility != GAMET_ENIGMA)))) {
        return;                 // avoid unremoveable and border stones
    }

    PullStone *newStone = this->clone();

    if (other_stone) {
        // yield other_stone:
        newStone->pull_info = new PullInfo(other_stone);
    }
    else {
        newStone->pull_info = new PullInfo(0);
    }

    // search for affected actors
    vector<Actor*> found_actors;
    const double   range_one_field = 1.415; // approx. 1 field [ > sqrt(1+1) ]
    GetActorsInRange(newPos.center(), range_one_field, found_actors);
    vector<Actor*>::iterator e = found_actors.end();
    for (vector<Actor*>::iterator i = found_actors.begin(); i != e; ++i) {
        Actor     *actor     = *i;
        GridPos    actor_pos(actor->get_pos());

        if (actor_pos == newPos) { // if the actor is in the dest field
            V2 vel = actor->get_vel();
            V2 mid_dest = actor->get_pos();

            mid_dest[0] = ecl::Clamp<double> (mid_dest[0], oldPos.x+0.01, oldPos.x+0.99);
            mid_dest[1] = ecl::Clamp<double> (mid_dest[1], oldPos.y+0.01, oldPos.y+0.99);
            WarpActor(actor, mid_dest[0], mid_dest[1], false);

            newStone->pull_info->add_actor(actor, vel);
        }
    }

    SetStone(newPos, newStone);
    newStone->set_move_state(true, move_dir);
    set_move_state(false, move_dir);

    sound_event("moveslow");
}


/* -------------------- Oneway stones -------------------- */

// These stone can only be passed in one direction.

namespace
{
    class OneWayBase : public Stone {
    protected:
        OneWayBase(Direction dir);

        void init_model();
        virtual Value message(const Message &m);

        void actor_hit (const StoneContact&);
        StoneResponse collision_response(const StoneContact &sc);
        bool is_floating() const { return true; }

        Direction get_orientation() const {
            return to_direction(getAttr("orientation"));
        }
        void set_orientation(Direction dir) {
            setAttr("orientation", Value(dir));
        }

        virtual bool actor_may_pass (Actor *a) = 0;
    };

    class OneWayStone : public OneWayBase {
    public:
        OneWayStone(Direction dir=SOUTH) : OneWayBase(dir) {}
    private:
        CLONEOBJ(OneWayStone);
        DECL_TRAITS;
        virtual bool actor_may_pass (Actor *a) {
            const ActorTraits &at = a->get_traits();
            return at.id != ac_bug && at.id != ac_horse;
        }
    };
    DEF_TRAITS(OneWayStone, "st-oneway", st_oneway);

    class OneWayStone_black : public OneWayBase {
    public:
        OneWayStone_black(Direction dir=SOUTH)
            : OneWayBase(dir) {}
    private:
        CLONEOBJ(OneWayStone_black);
        DECL_TRAITS;
        virtual bool actor_may_pass (Actor *a) {
            Value accolor = a->getAttr("color");
            return accolor && accolor == BLACK;
        }
        void actor_hit (const StoneContact&) {
            // do nothing if hit by actor
        }
    };
    DEF_TRAITS(OneWayStone_black, "st-oneway_black", st_oneway_black);

    class OneWayStone_white : public OneWayBase {
    public:
        OneWayStone_white(Direction dir=SOUTH)
            : OneWayBase(dir) {}
    private:
        CLONEOBJ(OneWayStone_white);
        DECL_TRAITS;
        virtual bool actor_may_pass (Actor *a) {
            Value accolor = a->getAttr("color");
            return accolor && accolor == WHITE;
        }
        void actor_hit (const StoneContact&) {
            // do nothing if hit by actor
        }
    };
    DEF_TRAITS(OneWayStone_white, "st-oneway_white", st_oneway_white);
}

OneWayBase::OneWayBase(Direction dir)
{
    set_orientation(dir);
}

void OneWayBase::init_model()
{
    string mname = get_kind();
    mname += to_suffix(get_orientation());
    set_model (mname);
}

Value OneWayBase::message(const Message &m) {
    if (m.message == "direction" && m.value.getType() == Value::DOUBLE) {
        set_orientation(to_direction(m.value));
        init_model();
        return Value();
    }
    else if (m.message == "signal" || m.message == "flip") {
        Direction dir = get_orientation();
        set_orientation(reverse(dir));
        init_model();
        return Value();
    }
    return Stone::message(m);
}

void OneWayBase::actor_hit(const StoneContact &sc) {
    Direction o=get_orientation();

    if (has_dir(contact_faces(sc), o)) {
        if (player::WieldedItemIs (sc.actor, "it-magicwand")) {
            set_orientation(reverse(o));
            init_model();
        }
    }
}

StoneResponse OneWayBase::collision_response(const StoneContact &sc) {
    DirectionBits dirs=contact_faces(sc);
    Direction o=get_orientation();

    if (!sc.actor->is_flying() && actor_may_pass(sc.actor))
        return has_dir(dirs,o) ? STONE_REBOUND : STONE_PASS;
    else
        return STONE_REBOUND;
}


/* -------------------- Volcano -------------------- */
namespace
{
    class VolcanoStone : public Stone {
        CLONEOBJ(VolcanoStone);
        DECL_TRAITS;
    public:
        enum State {INACTIVE, ACTIVE, FINISHED, BREAKING};
        VolcanoStone( State initstate=INACTIVE) : state( initstate) {}
    private:
        enum State state;

        void init_model() {
            switch( state) {
            case FINISHED:
            case INACTIVE: set_model( "st-plain"); break;
            case ACTIVE: set_anim( "st-farting"); break;
            case BREAKING: set_anim("st-stone_break-anim"); break;
            }
        }

        void animcb() {
            if (state == ACTIVE) {
                // Spread
                GridPos p = get_pos();
                if (DoubleRand(0, 1) > 0.7) spread (move(p, NORTH));
                if (DoubleRand(0, 1) > 0.7) spread (move(p, EAST));
                if (DoubleRand(0, 1) > 0.7) spread (move(p, SOUTH));
                if (DoubleRand(0, 1) > 0.7) spread (move(p, WEST));

                // Be finished at random time
                if (DoubleRand(0, 1) > 0.95)
                    state = FINISHED;
                init_model();
            } else if( state == BREAKING) {
                KillStone( get_pos());
            }
        }

        virtual Value message(const Message &m) {
            if (m.message == "_trigger" || m.message == "toggle") {
                if (state == INACTIVE) {
                    state = ACTIVE;
                    init_model();
                }
                return Value();
            }
            return Stone::message(m);
        }

        void spread( GridPos p) {
            Stone *st = GetStone(p);
            if( !st) {
                Item *it = MakeItem("it-seed_volcano");
                SetItem( p, it);
                SendMessage( it, "grow");
            }
        }

        void actor_hit(const StoneContact &sc) {
            Actor *a = sc.actor;

            if( state == ACTIVE && player::WieldedItemIs (a, "it_hammer")) {
                state = BREAKING;
                init_model();
            }
        }
    };
    DEF_TRAITSM(VolcanoStone, "st-volcano", st_volcano, MOVABLE_BREAKABLE);    
}


///* -------------------- Puzzle stones -------------------- */ 

/** \page st-puzzle Puzzle Stone

Puzzle stones can be connected to other stones of the same type.  Any
of the four faces of the stone can have ``socket''.  If the adjoining
faces of two neighboring stones both have a socket, the two stones
link up and henceforth move as group.

A cluster of puzzle stones may for example look like this:

\verbatim
+---+---+---+---+
|   |   |   |   |
| --+-+-+---+-+ |
|   | | |   | | |
+---+-+-+---+-+-+
    | | |   | | |
    | | |   | | |
    |   |   |   |
    +---+   +---+
\endverbatim

This example actually presents the special case of a ``complete''
cluster.  A cluster is complete if none of its stones has an
unconnected socket.

When touched with a magic wand the puzzle stones rotate
row- or columnwise.  

\subsection puzzlea Attributes

- \b connections
   number between 1 an 16.  Each bit in (connections-1) corresponds to
   a socket on one of the four faces.  You will normally simply use
   one of the Lua constants \c PUZ_0000 to \c PUZ_1111.

- \b oxyd
   If 1 then the puzzle stones act oxyd-compatible: Complete clusters
   explode, when they get touched. All other puzzle stones rotate row-
   or columnwise. Groups of oxyd-compatible puzzle stones are shuffled
   randomly at level startup.

\subsection puzzlee Example
<table>
<tr>
<td> \image html st-puzzletempl_0001.png "PUZ_0000"
<td> \image html st-puzzletempl_0002.png "PUZ_0001"
<td> \image html st-puzzletempl_0003.png "PUZ_0010"
<td> \image html st-puzzletempl_0004.png "PUZ_0011"
<tr>
<td> \image html st-puzzletempl_0005.png "PUZ_0100"
<td> \image html st-puzzletempl_0006.png "PUZ_0101"
<td> \image html st-puzzletempl_0007.png "PUZ_0110"
<td> \image html st-puzzletempl_0008.png "PUZ_0111"
<tr>
<td> \image html st-puzzletempl_0009.png "PUZ_1000"
<td> \image html st-puzzletempl_0010.png "PUZ_1001"
<td> \image html st-puzzletempl_0011.png "PUZ_1010"
<td> \image html st-puzzletempl_0012.png "PUZ_1011"
<tr>
<td> \image html st-puzzletempl_0013.png "PUZ_1100"
<td> \image html st-puzzletempl_0014.png "PUZ_1101"
<td> \image html st-puzzletempl_0015.png "PUZ_1110"
<td> \image html st-puzzletempl_0016.png "PUZ_1111"
</tr>
</table>
*/
namespace
{
    class PuzzleStone : public ConnectiveStone, public TimeHandler {
        INSTANCELISTOBJ(PuzzleStone);
        DECL_TRAITS;
    public:
        PuzzleStone(int connections, bool oxyd1_compatible_);  
        
        virtual void lightDirChanged(DirectionBits oldDirs, DirectionBits newDirs);
        
    protected:
        virtual ~PuzzleStone() {
            GameTimer.remove_alarm (this);
        }     
    private:
        typedef vector<GridPos> Cluster;

        /* ---------- Private methods ---------- */

        bool oxyd1_compatible() const { return getAttr("oxyd") != 0; }

        static bool visit_dir(vector<GridPos> &stack, GridPos curpos,
                              Direction dir, int wanted_oxyd_attrib);
        static void visit_adjacent(vector<GridPos>& stack, GridPos curpos,
                                   Direction dir, int wanted_oxyd_attrib);

        bool find_cluster(Cluster &);
        void find_adjacents(Cluster &);
        void find_row_or_column_cluster(Cluster &c, GridPos startpos,
                                        Direction  dir, int wanted_oxyd_attrib);

        bool cluster_complete();
        bool can_move_cluster (Cluster &c, Direction dir);
        void maybe_move_cluster(Cluster &c, bool is_complete, bool actor_with_wand, 
                                Direction dir);
        void rotate_cluster(const Cluster &c);
        void maybe_rotate_cluster(Direction dir);

        int get_modelno() const;

        void        trigger_explosion(double delay);
        static void trigger_explosion_at(GridPos p, double delay, int wanted_oxyd_attrib);
        void        explode();
        bool        explode_complete_cluster();

        /* ---------- TimeHandler interface ---------- */

        void alarm();

        /* ---------- Stone interface ---------- */

        virtual Value message(const Message &m);

        void on_creation (GridPos p);
        void on_impulse (const Impulse& impulse, bool isWireImpulse=false);

        bool is_floating() const;

        StoneResponse collision_response(const StoneContact &sc);
        void actor_hit (const StoneContact &sc);
        void actor_contact (Actor *a);

        /* ---------- Variables ---------- */
        bool visited;           // flag for DFS
        enum { IDLE, EXPLODING } state;
    };
    DEF_TRAITSM(PuzzleStone, "st-puzzle", st_puzzle, MOVABLE_IRREGULAR);
}

PuzzleStone::InstanceList PuzzleStone::instances;

PuzzleStone::PuzzleStone(int connections, bool oxyd1_compatible_) : ConnectiveStone(connections), 
  state (IDLE)
//  illumination (NODIRBIT)
{
    setAttr("oxyd", int(oxyd1_compatible_));
}


bool PuzzleStone::visit_dir(vector<GridPos> &stack, GridPos curpos, 
        Direction dir, int wanted_oxyd_attrib)
{
    GridPos newpos = move(curpos, dir);
    PuzzleStone *pz = dynamic_cast<PuzzleStone*>(GetStone(newpos));

    if ((!pz) || (wanted_oxyd_attrib != (int)pz->getAttr("oxyd")))
        return false;

    DirectionBits cfaces = pz->get_connections();

    if (cfaces==NODIRBIT || has_dir(cfaces, reverse(dir))) {
        // Puzzle stone at newpos is connected to stone at curpos
        if (!pz->visited) {
            pz->visited = true;
            stack.push_back(newpos);
        }
        return true;
    } else {
        // The two stones are adjacent but not connected
        return false;
    }
}

/* Use a depth first search to determine the group of all stones that
   are connected to the current stone.  Returns true if the cluster is
   ``complete'' in the sense defined above. */
bool PuzzleStone::find_cluster(Cluster &cluster) {
    for (unsigned i=0; i<instances.size(); ++i)
        instances[i]->visited=false;

    vector<GridPos> pos_stack;
    bool is_complete = true;
    pos_stack.push_back(get_pos());
    this->visited = true;
    int wanted_oxyd_attrib = getAttr("oxyd");

    while (!pos_stack.empty())
    {
        GridPos curpos = pos_stack.back();
        pos_stack.pop_back();

        PuzzleStone *pz = dynamic_cast<PuzzleStone*>(GetStone(curpos));
        ASSERT(pz, XLevelRuntime, "PuzzleStone: missing stone in find_cluster");

        cluster.push_back(curpos);
        DirectionBits cfaces = pz->get_connections();

        if (cfaces==NODIRBIT)
            cfaces = DirectionBits(NORTHBIT | SOUTHBIT | EASTBIT | WESTBIT);

        if (has_dir(cfaces, NORTH))
            is_complete &= visit_dir(pos_stack, curpos, NORTH, wanted_oxyd_attrib);
        if (has_dir(cfaces, EAST))
            is_complete &= visit_dir(pos_stack, curpos, EAST, wanted_oxyd_attrib);
        if (has_dir(cfaces, SOUTH))
            is_complete &= visit_dir(pos_stack, curpos, SOUTH, wanted_oxyd_attrib);
        if (has_dir(cfaces, WEST))
            is_complete &= visit_dir(pos_stack, curpos, WEST, wanted_oxyd_attrib);
    }
    return is_complete;
}

void PuzzleStone::visit_adjacent (vector<GridPos>& stack, GridPos curpos, 
                                  Direction dir, int wanted_oxyd_attrib)
{
    GridPos newpos = move(curpos, dir);
    if (PuzzleStone *pz = dynamic_cast<PuzzleStone*>(GetStone(newpos))) {
        if (!pz->visited) {
            if (wanted_oxyd_attrib == (int)pz->getAttr("oxyd")) {
                pz->visited = true;
                stack.push_back(newpos);
            }
        }
    }
}

/* Use a depth first search to determine the group of all puzzle stones
   with the same "oxyd" attrib that are adjacent to the current stone
   (or to any other member of the group).
*/
void PuzzleStone::find_adjacents(Cluster &cluster) {
    for (unsigned i=0; i<instances.size(); ++i)
        instances[i]->visited=false;

    vector<GridPos> pos_stack;
    pos_stack.push_back(get_pos());
    this->visited = true;

    int wanted_oxyd_attrib = getAttr("oxyd");

    while (!pos_stack.empty()) {
        GridPos curpos = pos_stack.back();
        pos_stack.pop_back();

        cluster.push_back(curpos);
        visit_adjacent(pos_stack, curpos, NORTH, wanted_oxyd_attrib);
        visit_adjacent(pos_stack, curpos, SOUTH, wanted_oxyd_attrib);
        visit_adjacent(pos_stack, curpos, EAST, wanted_oxyd_attrib);
        visit_adjacent(pos_stack, curpos, WEST, wanted_oxyd_attrib);
    }
}

/* searches from 'startpos' into 'dir' for puzzle-stones.
   wanted_oxyd_attrib == -1 -> take any puzzle stone
                      else  -> take only puzzle stones of same type
*/

void PuzzleStone::find_row_or_column_cluster(Cluster &c, GridPos startpos, 
                                             Direction dir, int wanted_oxyd_attrib)
{
    ASSERT(dir != NODIR, XLevelRuntime,
        "PuzzleStone: no direction in find_row_or_column_cluster");

    GridPos p = startpos;
    while (Stone *puzz = dynamic_cast<PuzzleStone*>(GetStone(p))) {
        if (wanted_oxyd_attrib != -1 && wanted_oxyd_attrib != (int)puzz->getAttr("oxyd"))
            break; // stop when an unrequested puzzle stone type is readed
        c.push_back(p);
        p.move(dir);
    }
}

bool PuzzleStone::can_move_cluster (Cluster &c, Direction dir)
{
    sort(c.begin(), c.end());
    Cluster mc(c);              // Moved cluster
    Cluster diff;               // Difference between mc and c

    for (unsigned i=0; i<mc.size(); ++i)
        mc[i].move(dir);

    set_difference(mc.begin(), mc.end(), c.begin(), c.end(),
                   back_inserter(diff));

    // Now check whether all stones can be placed at their new
    // position
    bool move_ok = true;
    for (unsigned i=0; i<diff.size(); ++i)
        if (GetStone(diff[i]) != 0)
            move_ok = false;

    return move_ok;    
}

void PuzzleStone::maybe_move_cluster(Cluster &c, bool is_complete, 
                                     bool actor_with_wand, Direction dir)
{
    sort(c.begin(), c.end());
    Cluster mc(c);              // Moved cluster
    Cluster diff;               // Difference between mc and c

    for (unsigned i=0; i<mc.size(); ++i)
        mc[i].move(dir);

    set_difference(mc.begin(), mc.end(), c.begin(), c.end(),
                   back_inserter(diff));

    // Now check whether all stones can be placed at their new
    // position
    bool move_ok = true;
    for (unsigned i=0; i<diff.size(); ++i)
        if (GetStone(diff[i]) != 0)
            move_ok = false;

    if (!move_ok)
        return;

    // If the floor at a complete cluster's new position consists
    // exclusively of abyss or water, create a bridge instead of
    // moving the cluster.
    //
    // For partial clusters build bridges only on water and if the
    // wielded item is NOT the magic wand.

    bool create_bridge = true;

    for (unsigned i=0; create_bridge && i<mc.size(); ++i) {
        if (Floor *fl = GetFloor(mc[i])) {
            if (fl->is_kind("fl-abyss")) {
                if (!is_complete)
                    create_bridge = false;
            }
            else if (fl->is_kind("fl-water")) {
                if (!is_complete && actor_with_wand) 
                    create_bridge = false;
            }
            else
                create_bridge = false;
        }
    }

    // Finally, either move the whole cluster or create a bridge
    sound_event("movebig");
    if (create_bridge) {
        for (unsigned i=0; i<c.size(); ++i) {
            KillStone(c[i]);
            SetFloor(mc[i], MakeFloor("fl-gray"));
        }
    } 
    else {
        vector<Stone*> clusterstones;
        for (unsigned i=0; i<c.size(); ++i)
            clusterstones.push_back(YieldStone(c[i]));

        for (unsigned i=0; i<c.size(); ++i) {
            SetStone(mc[i], clusterstones[i]);
            clusterstones[i]->on_move();
        }
    }

    server::IncMoveCounter (static_cast<int> (c.size()));
}

bool PuzzleStone::cluster_complete() {
    Cluster c;
    return find_cluster(c);
}

int PuzzleStone::get_modelno() const {
    int modelno = getAttr("connections");
    if (oxyd1_compatible()) modelno += 16;
    return modelno;
}

void PuzzleStone::rotate_cluster(const Cluster &c) {
    size_t size = c.size();
    if (size > 1) {
        int cn = GetStone(c[size-1])->getAttr("connections");
        for (size_t i=size-1; i>0; --i) {
            PuzzleStone *st = dynamic_cast<PuzzleStone*> (GetStone (c[i]));
            st->setAttr("connections", GetStone(c[i-1])->getAttr("connections"));
            st->init_model();
        }
        GetStone(c[0])->setAttr("connections", cn);
        dynamic_cast<PuzzleStone*> (GetStone(c[0]))->init_model();
    }
}

StoneResponse PuzzleStone::collision_response(const StoneContact &/*sc*/) {
    if (get_connections() == NODIRBIT)
        return STONE_PASS;
    return STONE_REBOUND;
}

void PuzzleStone::trigger_explosion(double delay) {
    if (state == IDLE) {
        state = EXPLODING;
        GameTimer.set_alarm(this, delay, false);
    }
}

void PuzzleStone::trigger_explosion_at (GridPos p, double delay,
                                        int wanted_oxyd_attrib)
{
    PuzzleStone *puzz = dynamic_cast<PuzzleStone*>(GetStone(p));
    if (puzz && wanted_oxyd_attrib == (int)puzz->getAttr("oxyd")) {
        // explode adjacent puzzle stones of same type
        puzz->trigger_explosion(delay);
    }
}

void PuzzleStone::explode() {
    GridPos p       = get_pos();
    int     ox_attr = getAttr("oxyd");

    // exchange puzzle stone with explosion
    sound_event("stonedestroy");
    SetStone(p, MakeStone("st-explosion"));

    // trigger all adjacent puzzle stones :
    const double DEFAULT_DELAY = 0.2;
    trigger_explosion_at(move(p, NORTH), DEFAULT_DELAY, ox_attr);
    trigger_explosion_at(move(p, SOUTH), DEFAULT_DELAY, ox_attr);
    trigger_explosion_at(move(p, EAST),  DEFAULT_DELAY, ox_attr);
    trigger_explosion_at(move(p, WEST),  DEFAULT_DELAY, ox_attr);

    // @@@ FIXME: At the moment it's possible to push partial puzzle stones
    // next to an already exploding cluster. Then the part will explode as well.
    // Possible fix : mark whole cluster as "EXPLODING_SOON" when explosion is initiated

    // ignite adjacent fields
//     SendExplosionEffect(p, DYNAMITE);
}

void PuzzleStone::alarm() {
    explode();
}

Value PuzzleStone::message(const Message &m) {
    if (m.message == "scramble") {
        // oxyd levels contain explicit information on how to
        // scramble puzzle stones. According to that information
        // a "scramble" message is send to specific puzzle stones
        // together with information about the direction.
        //
        // enigma levels may create scramble messages using
        // AddScramble() and SetScrambleIntensity()

        Direction dir = to_direction(m.value);
        Cluster   c;
        find_row_or_column_cluster(c, get_pos(), dir, oxyd1_compatible());

        size_t size = c.size();

        // warning("received 'scramble'. dir=%s size=%i", to_suffix(dir).c_str(), size);

        if (size >= 2) {
            int count = IntegerRand(0, static_cast<int> (size-1));
            while (count--)
                rotate_cluster(c);
        }
        else {
            warning("useless scramble (cluster size=%i)", size);
        }
        return Value();
    }
    return ConnectiveStone::message(m);
}

void PuzzleStone::on_impulse(const Impulse& impulse, bool isWireImpulse) 
{
//    if (!oxyd1_compatible() && state == IDLE) {
    if (state == IDLE) {
        Cluster c;
        bool    is_complete     = find_cluster(c);
        bool    actor_with_wand = false;

        if (Actor *ac = dynamic_cast<Actor*>(impulse.sender)) 
            actor_with_wand = player::WieldedItemIs (ac, "it-magicwand");

        maybe_move_cluster(c, is_complete, actor_with_wand, impulse.dir);
    }
}

bool PuzzleStone::explode_complete_cluster() 
{
    // @@@ FIXME: explode_complete_cluster should mark the whole cluster
    // as "EXPLODING_SOON" (otherwise it may be changed before it explodes completely)

    ASSERT(state == IDLE, XLevelRuntime,
        "PuzzleStone: explode_complete_cluster called with inconsistent state");
    bool exploded = false;

    Cluster complete;
    if (find_cluster(complete)) {
        Cluster all;
        find_adjacents(all);

        // If all adjacent stones build one complete cluster explode it
        if (all.size() == complete.size()) {
            explode();          // explode complete cluster
            exploded = true;
        }
        else {
            ASSERT(all.size() > complete.size(), XLevelRuntime,
                "PuzzleStone: sizes don't match in explode_complete_cluster");
            if (!oxyd1_compatible()) {
                // check if 'all' is made up of complete clusters :

                sort(all.begin(), all.end());

                while (1) {
                    sort(complete.begin(), complete.end());

                    // remove one complete cluster from 'all'
                    {
                        Cluster rest;
                        set_symmetric_difference(all.begin(), all.end(),
                                                 complete.begin(), complete.end(),
                                                 back_inserter(rest));
                        // now rest contains 'all' minus 'complete'
                        swap(all, rest);
                    }

                    if (all.empty()) { // none left -> all were complete
                        exploded = true;
                        break;
                    }

                    // look for next complete cluster :
                    complete.clear();
                    {
                        PuzzleStone *pz = dynamic_cast<PuzzleStone*>(GetStone(all[0]));
                        ASSERT(pz, XLevelRuntime,
                            "PuzzleStone: missing stone in explode_complete_cluster");
                        if (!pz->find_cluster(complete)) {
                            break; // incomplete cluster found -> don't explode
                        }
                    }
                }

                if (exploded) {
//                     warning("exploding complete cluster");
                    explode();
                }
            }
        }
    }

    return exploded;
}

bool PuzzleStone::is_floating() const {
    return get_connections() == 0;
}

void PuzzleStone::maybe_rotate_cluster(Direction dir) 
{
    if (dir != NODIR) {
        Cluster c;
        find_row_or_column_cluster(c, get_pos(), dir, (int)getAttr("oxyd"));
        if (c.size() >= 2) {
//             warning("ok -> rotate");
            rotate_cluster(c);
        }
    }
}

void PuzzleStone::on_creation (GridPos p) {
    activatePhoto();
    ConnectiveStone::on_creation (p);
}


void PuzzleStone::lightDirChanged(DirectionBits oldDirs, DirectionBits newDirs) {
    if (state == IDLE && newDirs != NODIRBIT) {
        if (!explode_complete_cluster() && oxyd1_compatible()) {
            if (newDirs & SOUTHBIT) maybe_rotate_cluster(SOUTH);
            if (newDirs & NORTHBIT) maybe_rotate_cluster(NORTH);
            if (newDirs & WESTBIT)  maybe_rotate_cluster(WEST);
            if (newDirs & EASTBIT)  maybe_rotate_cluster(EAST);
        }
    }
}

void PuzzleStone::actor_hit(const StoneContact &sc) 
{
    if (get_connections() == NODIRBIT)
        return;                 // Puzzle stone is hollow

    if (state == EXPLODING)
        return;

    Cluster c;
    find_cluster (c);

    Direction rotate_dir = reverse (contact_face (sc));
    Direction move_dir = get_push_direction(sc);

    if (oxyd1_compatible()) {
        // Oxyd 1

        if (explode_complete_cluster())
            return;

        // 1) If unconnected puzzle stones -> try to move it
        if (c.size() == 1 && move_dir != NODIR) {
            // if cluster contains single stone
            // -> move it if dest pos is free
            GridPos dest = move(c[0], move_dir);
            if (GetStone(dest) == 0) {
                Stone *puzz = YieldStone(c[0]);
                SetStone(dest, puzz);
                puzz->on_move();
                sound_event ("movesmall");
            } else
                maybe_rotate_cluster (rotate_dir);
        } 
        // 2) If more than one stone, 
        else 
            maybe_rotate_cluster (rotate_dir);
    }
    else {
        // Not Oxyd 1

        bool has_magic_wand = player::WieldedItemIs (sc.actor, "it-magicwand");

        // 1) Try to start explosion of complete cluster
        if (has_magic_wand && explode_complete_cluster())
            return;

        // 2) Failed? Try to move the cluster
        if (move_dir != NODIR && can_move_cluster (c, move_dir)) {
            sc.actor->send_impulse(get_pos(), move_dir);
            return;
        }

        // 3) Last chance: try to rotate the row or column 
        if (has_magic_wand)
            maybe_rotate_cluster (rotate_dir);
    }
}

void PuzzleStone::actor_contact (Actor *a)
{
    if (state == EXPLODING)
        SendMessage(a, "shatter");
}



/* -------------------- DoorBase -------------------- */

// Base class for everything that behaves like a door, i.e., it has
// four states OPEN, CLOSED, OPENING, CLOSING.
namespace
{
    class DoorBase : public Stone {
    protected:
        enum State { OPEN, CLOSED, OPENING, CLOSING } state;

        DoorBase(const char *name, State initstate=CLOSED)
        : Stone(name), state(initstate)
        {}

        State get_state() const { return state; }
        void set_state(State st) { state=st; }

        void change_state(State newstate) ;
        virtual Value message(const Message &m);
    private:
        // DoorBase interface
        virtual string model_basename() { return get_kind(); }
        virtual void init_model();
        virtual string opening_sound() const { return ""; }
        virtual string closing_sound() const { return ""; }

        // Private methods

        StoneResponse collision_response(const StoneContact &sc);

        void animcb();

        // Stone interface
        virtual bool is_transparent (Direction) const
        { return state==OPEN; }

        virtual bool is_sticky (const Actor *) const
        { return false; }

    private:
        FreezeStatusBits get_freeze_bits() { return FREEZEBIT_NO_STONE; }   
    };
}

Value DoorBase::message(const Message &m) {
    State newstate = state;

    if (m.message == "open") {
        newstate = OPENING;
    } else if (m.message == "close") {
        newstate = CLOSING;
    } else if (m.message == "openclose" || m.message == "toggle") {
        newstate = (state==OPEN || state==OPENING) ? CLOSING : OPENING;
    } else if (m.message == "signal") {
        newstate = m.value.to_bool() ? OPENING : CLOSING;
    } else {
        return Stone::message(m);
    }
    
    if (newstate==OPENING && (state==CLOSED || state==CLOSING))
        change_state(OPENING);
    else if (newstate==CLOSING && (state==OPEN || state==OPENING))
        change_state(CLOSING);
    return Value();
}

void DoorBase::init_model() {
    string mname = model_basename();
    if (state == CLOSED)
        mname += "-closed";
    else if (state==OPEN)
        mname += "-open";
    set_model(mname);
}

void DoorBase::animcb() {
    if (state == OPENING)
        change_state(OPEN);
    else if (state == CLOSING)
        change_state(CLOSED);
}

StoneResponse
DoorBase::collision_response(const StoneContact &/*sc*/)
{
    return (state == OPEN) ? STONE_PASS:STONE_REBOUND;
}

void DoorBase::change_state(State newstate) 
{
    string basename = model_basename();

    switch (newstate) {
    case OPEN:
        set_model(basename+"-open");
        MaybeRecalcLight(get_pos());
        break;
    case CLOSED:
        set_model(basename+"-closed");
        ShatterActorsInsideField (get_pos());
        MaybeRecalcLight(get_pos()); // maybe superfluous
        break;
    case OPENING:
        sound_event (opening_sound().c_str());
        if (state == CLOSING)
            get_model()->reverse();
        else
            set_anim(basename+"-opening");
        break;
    case CLOSING:
        sound_event (closing_sound().c_str());
        if (state == OPENING)
            get_model()->reverse();
        else
            set_anim(basename+"-closing");
        ShatterActorsInsideField (get_pos());
        MaybeRecalcLight(get_pos());
        break;
    }
    set_state(newstate);
}


/* -------------------- Door -------------------- */

// Attributes:
//
// :type        h or v for a door that opens horizontally or vertically
namespace
{
    class Door : public DoorBase {
        CLONEOBJ(Door);
    public:
        Door(const char *type="h", bool open=false)
        : DoorBase("st-door", open ? OPEN : CLOSED)
        {
            setAttr("type", type);
        }
    private:
        virtual string opening_sound() const { return "dooropen"; }
        virtual string closing_sound() const { return "doorclose"; }
        virtual const char *collision_sound() { return "electric"; }
        string get_type() const {
            string type(getDefaultedAttr("type", "h"));
            return type;
        }

        bool is_transparent (Direction) const;
        bool is_floating () const {
            return true;        // don't let door press buttons
        }

        void actor_hit(const StoneContact &sc)
        {
            Log << "door knocking\n";
            // door knocking
            Item *it = GetItem(get_pos());
            if (it != NULL && server::GameCompatibility != GAMET_PEROXYD 
                    && (server::GameCompatibility != GAMET_ENIGMA || server::EnigmaCompatibility < 1.10 ))
                SendMessage(it, "_hit", sc.actor);
            else
                performAction(sc.actor);
        }

        string model_basename() { return string("st-door")+get_type(); }
        StoneResponse collision_response(const StoneContact &sc);
    };

    class Door_a : public DoorBase {
        CLONEOBJ(Door_a);
    public:
        Door_a() : DoorBase("st-door_a") {}
    };

    class Door_b : public DoorBase {
        CLONEOBJ(Door_b);
    public:
        Door_b() : DoorBase("st-door_b") {}
    };

    class Door_c : public DoorBase {
        CLONEOBJ(Door_c);
    public:
        Door_c() : DoorBase("st-door_c") {}
        Value message(const Message &m) {
            if (m.message == "ignite" && server::GameCompatibility == GAMET_OXYD1) {
                KillStone(get_pos());  // TODO animation & sound
                return Value();
            } else {
                return DoorBase::message(m);
            }
        }
    };
    
    class Door_c_open : public DoorBase {  // a hack for oxyd compatibility tests
        CLONEOBJ(Door_c_open);
    public:
        Door_c_open() : DoorBase("st-door_c", OPEN) {}
    };    
}

bool Door::is_transparent (Direction dir) const {
    if (get_type() == "h")
        return state==OPEN || dir==EAST || dir==WEST;
    else
        return state==OPEN || dir==NORTH || dir==SOUTH;
}

StoneResponse
Door::collision_response(const StoneContact &sc)
{
    Direction cf = contact_face(sc);
    if (state == OPEN)
        return STONE_PASS;
    else if (state == CLOSING)
        return STONE_REBOUND;
    else {
        string t = get_type();
        return ((t == "v" && (cf==WEST || cf==EAST)) ||
                (t == "h" && (cf==SOUTH || cf==NORTH)))
            ? STONE_REBOUND
            : STONE_PASS;
    }
}


/* -------------------- ShogunStone -------------------- */

// Attributes:
//
// :holes            1..7
namespace
{
    class ShogunStone : public Stone {
        CLONEOBJ(ShogunStone);
        DECL_TRAITS;

        enum Holes { SMALL = 1, MEDIUM = 2, LARGE = 4};
        static Holes smallest_hole(Holes s);
        void set_holes(Holes h) { setAttr("holes", h); }

    public:
        ShogunStone(int holes=SMALL) {
            set_holes(static_cast<Holes>(holes));
        }
    private:
        Holes get_holes() const;
        void notify_item();

        virtual Value message(const Message &m) {
            if (m.message == "_init") { // request from ShogunDot (if set _after_ ShogunStone)
                notify_item();
                return Value();
            }
            return Stone::message(m);
        }

        void add_hole(Holes h) {
            setAttr("holes", get_holes() | h);
            init_model();
            notify_item();
        }

        void on_creation (GridPos p) {
            init_model();
            notify_item();
        }

        void on_removal(GridPos p) {
            Stone::on_removal(p);
            if (Item *it = GetItem(p))
                SendMessage(it, "noshogun");
        }

        void on_impulse(const Impulse& impulse, bool isWireImpulse=false);

        void init_model() {
            set_model(ecl::strf("st-shogun%d", int(get_holes())));
        }

        void actor_hit (const StoneContact &sc) {
            maybe_push_stone (sc);
        }

        FreezeStatusBits get_freeze_bits() {
            return (get_holes() == SMALL) ? FREEZEBIT_STANDARD : FREEZEBIT_NO_STONE;
        }
    };
    DEF_TRAITSM(ShogunStone, "st-shogun", st_shogun, MOVABLE_IRREGULAR);
}

ShogunStone::Holes ShogunStone::get_holes() const {
    int h = getAttr("holes");
    if (h>=1 && h<=7)
        return Holes(h);
    else {
        warning("Wrong 'holes' attribute (%i)", h);
        return SMALL;
    }
}

ShogunStone::Holes ShogunStone::smallest_hole(Holes s) {
    if (s & SMALL) return SMALL;
    if (s & MEDIUM) return MEDIUM;
    if (s & LARGE) return LARGE;
    throw XLevelRuntime ("ShogunStone: internal error");
}

void ShogunStone::notify_item ()
{
    if (Item *it = GetItem(get_pos())) {
        switch (get_holes()) {
        case SMALL:                    SendMessage(it, "shogun1"); break;
        case (MEDIUM | SMALL):         SendMessage(it, "shogun2"); break;
        case (LARGE | MEDIUM | SMALL): SendMessage(it, "shogun3"); break;
        default:                       SendMessage(it, "noshogun"); break;
        }
    }
}

void ShogunStone::on_impulse(const Impulse& impulse, bool isWireImpulse) {
    GridPos destpos     = move(get_pos(), impulse.dir);
    Holes holes         = get_holes();
    Holes smallest      = smallest_hole(holes);
    ShogunStone *target = 0;

    if (Stone *st = GetStone(destpos)) {
        target = dynamic_cast<ShogunStone*>(st);

        /* If the stone at `p' is not a shogun stone or if smallest hole
           does not fit into target, do not transfer the smallest hole. */
        if (!target || smallest >= smallest_hole(target->get_holes()))
            return;
    }

    /* It's important to remove the old stone before setting the new
       one: otherwise it is possible to activate two triggers with one
       shogun stone when shifting from one shogun target to a second
       adjacent shogun target. */

    GridPos my_pos = get_pos();
    string  old_name;

    // Remove/modify source stone:
    if (Holes newholes = Holes(holes & ~smallest)) {
        set_holes(newholes);
        init_model();
        notify_item();
    }
    else {
        if (Value v = getAttr("name")) old_name = v.get_string(); // store name of disappearing stone
        SendMessage(GetItem(my_pos), "noshogun");
        KillStone(my_pos);
    }

    // Modify/create target stone:
    if (target) {
        target->add_hole(smallest);
//         target->sound_event("st-magic");
//         sound::PlaySound("st-magic", my_pos.center()); // object already disappeared
    }
    else {                       // create new
        target = new ShogunStone(smallest);
        int targetId = target->getId();
        SetStone(destpos, target);
        // Shogunstone might have disappeared via some triggered action.
        // Most important example: Last box in a sokoban.
        if (Stone *st = GetStone(destpos))
            if (st->getId() == targetId)
                st->on_move();
    }

    if (!old_name.empty())
        NameObject(target, old_name);

    server::IncMoveCounter();
    sound::EmitSoundEvent ("movesmall", my_pos.center());
}


/* -------------------- Stone impulse stones -------------------- */

// Messages:
//
// :trigger
namespace
{
    class StoneImpulse_Base : public Stone {
    protected:
        StoneImpulse_Base() : state(IDLE), incoming(NODIR), nobackfire (false)
        {}

        enum State { IDLE, PULSING, CLOSING };
        State     state;
        Direction incoming; // direction of incoming impulse (may be NODIR)
        bool      nobackfire;

        void change_state(State st);

        virtual void on_impulse(const Impulse& impulse, bool isWireImpulse=false) {
            incoming = impulse.dir;
            change_state(PULSING);
        }

    private:

        virtual void notify_state(State st) = 0;

        virtual Value message(const Message &m) {
            if (m.message == "_trigger" && m.value.to_bool()) {
                incoming = NODIR;
                if (m.sender != NULL)
                    incoming = direction_fromto(dynamic_cast<GridObject *>(m.sender)->get_pos(), get_pos());
                
                if (state == IDLE && incoming != NODIR) {
                    nobackfire = true;
                }
                change_state(PULSING);
                return Value();
            }
            else if (m.message == "signal" && (to_double(m.value) != 0 || 
                    (server::EnigmaCompatibility < 1.10 /*&& m.value.getType() == Value::NIL*/))) { // hack for old trigger without value
                incoming = NODIR;
                change_state (PULSING);
                return Value();
            }
            return Stone::message(m);
        }

        void animcb() {
            if (state == PULSING)
                change_state (CLOSING);
            else if (state == CLOSING)
                change_state (IDLE);
        }

        void processLight(Direction dir) {
            incoming = dir;
            change_state(PULSING);
        }

        FreezeStatusBits get_freeze_bits() { return FREEZEBIT_NO_STONE; }
    };
}

void StoneImpulse_Base::change_state(State new_state) {
    if (new_state == state) return;

    GridPos p = get_pos();
    switch (new_state) {
        case IDLE: {
            state = new_state;
            notify_state(state);
            break;
        }
        case PULSING:
            if (state != IDLE) {
                return;         // do not set new state
            }
            state = new_state;
            notify_state(state);
            sound_event("impulse");
            break;
        case CLOSING: {
            GridPos targetpos[4];
            bool    haveStone[4];

            // set CLOSING model _before_ sending impulses !!!
            // (any impulse might have side effects that move this stone)

            state = new_state;
            notify_state(state);

            for (int d = 0; d < 4; ++d) {
                targetpos[d] = move(p, Direction(d));
                haveStone[d] = GetStone(targetpos[d]) != 0;
            }

            for (int d = int(incoming)+1; d <= int(incoming)+4; ++d) {
                int D = d%4;
                if (!nobackfire || reverse(incoming) != D) {
                    if (haveStone[D]) {
                        send_impulse(targetpos[D], Direction(D));
                    }
                }
            }

            incoming = NODIR;   // forget impulse direction
            nobackfire = false;
            break;
        }
    }
}


namespace
{
    class StoneImpulseStone : public StoneImpulse_Base {
        CLONEOBJ(StoneImpulseStone);
        DECL_TRAITS;
    public:
        StoneImpulseStone()
        {}

    private:
        void notify_state(State st) {
            switch (st) {
            case IDLE:
                init_model();
                break;
            case PULSING:
                set_anim("st-stoneimpulse-anim1");
                break;
            case CLOSING:
                set_anim("st-stoneimpulse-anim2");
                break;
            }
        }

        void actor_hit(const StoneContact &/*sc*/) {
            change_state(PULSING);
        }
    };
    DEF_TRAITS(StoneImpulseStone, "st-stoneimpulse", st_stoneimpulse);

    class HollowStoneImpulseStone : public StoneImpulse_Base {
        CLONEOBJ(HollowStoneImpulseStone);
        DECL_TRAITS;
    public:
        HollowStoneImpulseStone()
        {}
    private:
        void notify_state(State st) {
            switch (st) {
            case IDLE:
                init_model();
                MaybeRecalcLight(get_pos());
                break;
            case PULSING:
                MaybeRecalcLight(get_pos());
                set_anim("st-stoneimpulse-hollow-anim1");
                break;
            case CLOSING:
                set_anim("st-stoneimpulse-hollow-anim2");
                break;
            }
        }

        StoneResponse collision_response(const StoneContact &/*sc*/) {
            return (state == IDLE) ? STONE_PASS : STONE_REBOUND;
        }
        void actor_inside(Actor *a) {
            if (state == PULSING || state == CLOSING)
                SendMessage(a, "shatter");
        }

        bool is_floating () const {
            return true;
        }

        void processLight(Direction d) {
            // hollow StoneImpulseStones cannot be activated using lasers
        }
    };
    DEF_TRAITS(HollowStoneImpulseStone, "st-stoneimpulse-hollow",
               st_stoneimpulse_hollow);

    class MovableImpulseStone : public StoneImpulse_Base {
        CLONEOBJ(MovableImpulseStone);
        DECL_TRAITS;
    public:
        MovableImpulseStone()
        : repulse(false)
        {}

    private:

        void notify_state(State st) {
            switch (st) {
            case IDLE:
                if (repulse) {
                    repulse = false;
                    change_state(PULSING);
                }
                else
                    init_model();
                break;
            case PULSING:
                set_anim("st-stoneimpulse-anim1");
                break;
            case CLOSING:
                set_anim("st-stoneimpulse-anim2");
                break;
            }
        }

        void init_model() {
            set_model("st-stoneimpulse");
        }

        // Stone interface:

        void actor_hit(const StoneContact &sc) {
            if (!maybe_push_stone (sc)) {
                incoming = NODIR; // bad, but no real problem!
                if (state == IDLE)
                    change_state(PULSING);
            }
        }

        void on_impulse(const Impulse& impulse, bool isWireImpulse) {
            State oldstate = state;

            if (move_stone(impulse.dir)) {
                notify_state(oldstate); // restart anim if it was animated before move

                Actor *hitman = dynamic_cast<Actor*>(impulse.sender);
                if (hitman && player::WieldedItemIs (hitman, "it-magicwand")) {
                    return;     // do not change state to PULSING
                }
            }

            if (state == IDLE)
                change_state(PULSING);
        }

        void on_move() {
            if (state != PULSING)
                repulse = true; // pulse again
            Stone::on_move();
        }

        // Variables.
        bool repulse;
    };
    DEF_TRAITSM(MovableImpulseStone, "st-stoneimpulse_movable",
                st_stoneimpulse_movable, MOVABLE_STANDARD);
}


/* -------------------- Turnstiles -------------------- */
namespace
{
    class Turnstile_Arm;

    /*
    ** The stone at the center of a turnstile
    */
    class Turnstile_Pivot_Base : public Stone {
    public:
        Turnstile_Pivot_Base();

    protected:
        bool rotate(bool clockwise, Object *impulse_sender);

        friend class Turnstile_Arm; // uses rotate

    private:
        // Object interface
        virtual Value message(const Message &m);
        virtual void animcb();

        // Private methods
        DirectionBits arms_present() const;
        bool          no_stone (int xoff, int yoff) const;
        void set_arm (Direction dir);
        void remove_arms (DirectionBits arms);
        void rotate_arms (DirectionBits arms, bool clockwise);
        void handleActorsAndItems(bool clockwise, Object *impulse_sender);

        // Turnstile_Pivot_Base interface
        virtual const char *model() const    = 0;
        virtual const char *anim() const     = 0;
        virtual bool oxyd_compatible() const = 0;

        // Variables
        bool active;
    };

    class Turnstile_Pivot : public Turnstile_Pivot_Base {
        CLONEOBJ(Turnstile_Pivot);
        DECL_TRAITS;
    public:
        Turnstile_Pivot() {}

        const char *model() const { return "st-turnstile"; }
        const char *anim() const  { return "st-turnstile-anim"; }
        bool oxyd_compatible() const { return true; }
    };
    DEF_TRAITS(Turnstile_Pivot, "st-turnstile", st_turnstile);

    class Turnstile_Pivot_Green : public Turnstile_Pivot_Base {
        CLONEOBJ(Turnstile_Pivot_Green);
        DECL_TRAITS;
    public:
        Turnstile_Pivot_Green() {}

        const char *model() const { return "st-turnstile-green"; }
        const char *anim() const  { return "st-turnstile-green-anim"; }
        bool oxyd_compatible() const { return false; }
    };
    DEF_TRAITS(Turnstile_Pivot_Green, "st-turnstile-green", st_turnstile_green);    

    /*
    ** The base class for any of the four arms of the turnstile
    */
    class Turnstile_Arm : public Stone {
        virtual Direction get_dir() const = 0;

        void actor_hit(const StoneContact &sc);
        void on_impulse(const Impulse& impulse, bool isWireImpulse=false);

        Turnstile_Pivot_Base *get_pivot() {
            Stone *st = GetStone (move (get_pos(), reverse(get_dir())));
            return dynamic_cast<Turnstile_Pivot_Base*>(st);
        }

    protected:
        Turnstile_Arm() {}
    };

    class Turnstile_N : public Turnstile_Arm {
        CLONEOBJ(Turnstile_N);
        DECL_TRAITS;
    public:
        Turnstile_N() {}
        Direction get_dir () const { return NORTH; }
    };
    DEF_TRAITSM(Turnstile_N, "st-turnstile-n", st_turnstile_n, MOVABLE_IRREGULAR);
    
    class Turnstile_S : public Turnstile_Arm {
        CLONEOBJ(Turnstile_S);
        DECL_TRAITS;
        Direction get_dir () const { return SOUTH; }
    public:
        Turnstile_S() {}
    };
    DEF_TRAITSM(Turnstile_S, "st-turnstile-s", st_turnstile_s, MOVABLE_IRREGULAR);

    class Turnstile_E : public Turnstile_Arm {
        CLONEOBJ(Turnstile_E);
        DECL_TRAITS;
        Direction get_dir () const { return EAST; }
    public:
        Turnstile_E() {}
    };
    DEF_TRAITSM(Turnstile_E, "st-turnstile-e", st_turnstile_e, MOVABLE_IRREGULAR);

    class Turnstile_W : public Turnstile_Arm {
        CLONEOBJ(Turnstile_W);
        DECL_TRAITS;
        Direction get_dir () const { return WEST; }
    public:
        Turnstile_W() {}
    };
    DEF_TRAITSM(Turnstile_W, "st-turnstile-w", st_turnstile_w, MOVABLE_IRREGULAR);
}


/* -------------------- Turnstile_Arm -------------------- */

void Turnstile_Arm::on_impulse(const Impulse& impulse, bool isWireImpulse) {
    enum Action { ROTL, ROTR, stay };
    static Action actions[4][4] = {
        { stay, ROTL, stay, ROTR }, // west arm
        { ROTR, stay, ROTL, stay }, // south arm
        { stay, ROTR, stay, ROTL }, // east arm
        { ROTL, stay, ROTR, stay }  // north arm
    };

    Turnstile_Pivot_Base *pivot = get_pivot();

    if (pivot) {
        Action a = actions[get_dir()][impulse.dir];
        if (a != stay) {
            bool clockwise = (a == ROTR);
            Actor *a = dynamic_cast<Actor*>(impulse.sender);
            if ((pivot->get_traits().id == st_turnstile_green) && a != NULL &&
                    player::WieldedItemIs(a, "it_wrench"))
                clockwise = !clockwise;
            pivot->rotate(clockwise, impulse.sender); // ROTR is clockwise
        }
    }
    else {
        // Move arms not attached to a pivot individually
        move_stone(impulse.dir);
    }
}

void Turnstile_Arm::actor_hit(const StoneContact &sc) 
{
    maybe_push_stone(sc);
}

// --------------------------------------------
//      Turnstile_Pivot_Base implementation
// --------------------------------------------

Turnstile_Pivot_Base::Turnstile_Pivot_Base()
: active (false)
{}

void Turnstile_Pivot_Base::animcb() 
{ 
    set_model(model()); 
    active = false;
}

Value Turnstile_Pivot_Base::message(const Message &m)
{
    if (m.message == "signal") {
        int val = m.value;
        if (val == 1)
            rotate(false, 0);
        else
            rotate(true, 0);
        return Value();
    }
    return Stone::message(m);
}


DirectionBits
Turnstile_Pivot_Base::arms_present() const
{
    DirectionBits arms = NODIRBIT;
    GridPos p = get_pos();
    if (dynamic_cast<Turnstile_N*>(GetStone(move(p, NORTH))))
        ecl::set_flags (arms, NORTHBIT);
    if (dynamic_cast<Turnstile_S*>(GetStone(move(p, SOUTH))))
        ecl::set_flags (arms, SOUTHBIT);
    if (dynamic_cast<Turnstile_E*>(GetStone(move(p, EAST))))
        ecl::set_flags (arms, EASTBIT);
    if (dynamic_cast<Turnstile_W*>(GetStone(move(p, WEST))))
        ecl::set_flags (arms, WESTBIT);
    return arms;
}

bool Turnstile_Pivot_Base::no_stone (int xoff, int yoff) const {
    GridPos p = get_pos();
    p.x += xoff;
    p.y += yoff;
    return (0 == GetStone(p));
}

void Turnstile_Pivot_Base::remove_arms (DirectionBits arms) {
    GridPos p = get_pos();
    if (arms & NORTHBIT) KillStone (move (p, NORTH));
    if (arms & EASTBIT) KillStone (move (p, EAST));
    if (arms & SOUTHBIT) KillStone (move (p, SOUTH));
    if (arms & WESTBIT) KillStone (move (p, WEST));
}

void Turnstile_Pivot_Base::rotate_arms (DirectionBits arms, bool clockwise) {
    GridPos p = get_pos();

//    RBI_vector Nrubs;
//    RBI_vector Erubs;
//    RBI_vector Srubs;
//    RBI_vector Wrubs;

//    if (arms & NORTHBIT) GiveRubberBands(GetStone(move (p, NORTH)), Nrubs);
//    if (arms & EASTBIT) GiveRubberBands(GetStone(move (p, EAST)), Erubs);
//    if (arms & SOUTHBIT) GiveRubberBands(GetStone(move (p, SOUTH)), Srubs);
//    if (arms & WESTBIT) GiveRubberBands(GetStone(move (p, WEST)), Wrubs);

    remove_arms(arms);

    if (clockwise) {
	if (arms & NORTHBIT) set_arm(EAST);
	if (arms & EASTBIT)  set_arm(SOUTH);
	if (arms & SOUTHBIT) set_arm(WEST);
	if (arms & WESTBIT)  set_arm(NORTH);
    }
    else {
	if (arms & NORTHBIT) set_arm(WEST);
	if (arms & EASTBIT)  set_arm(NORTH);
	if (arms & SOUTHBIT) set_arm(EAST);
	if (arms & WESTBIT)  set_arm(SOUTH);
    }
}

void Turnstile_Pivot_Base::set_arm (Direction dir) {
    const char *names[4] = { "st-turnstile-w", "st-turnstile-s",
                             "st-turnstile-e", "st-turnstile-n" };
    Stone   *st   = MakeStone(names[dir]);
    GridPos  newp = move(get_pos(), dir);
    SetStone (newp, st);

    if (Item *it = GetItem(newp))
        it->on_stonehit(st);

//    if (!rubs.empty())
//	for (RBI_vector::iterator i = rubs.begin(); i != rubs.end(); ++i)
//	    AddRubberBand (i->act, st, i->data);
}

bool Turnstile_Pivot_Base::rotate(bool clockwise, Object *impulse_sender) {
    if (active)
        return false;

    DirectionBits arms       = arms_present();
    bool          can_rotate = true;

    if (clockwise)  {
        if (arms & NORTHBIT) {
            can_rotate &= no_stone(+1,-1);
            if (! (arms & EASTBIT)) can_rotate &= no_stone(+1,0);
        }
        if (arms & WESTBIT) {
            can_rotate &= no_stone(-1,-1);
            if (! (arms & NORTHBIT)) can_rotate &= no_stone(0,-1);
        }
        if (arms & SOUTHBIT) {
            can_rotate &= no_stone(-1,+1);
            if (! (arms & WESTBIT)) can_rotate &= no_stone(-1,0);
        }
        if (arms & EASTBIT) {
            can_rotate &= no_stone(+1,+1);
            if (! (arms & SOUTHBIT)) can_rotate &= no_stone(0,+1);
        }
    }
    else {
        if (arms & NORTHBIT) {
            can_rotate &= no_stone(-1,-1);
            if (! (arms & WESTBIT)) can_rotate &= no_stone(-1,0);
        }
        if (arms & WESTBIT) {
            can_rotate &= no_stone(-1,+1);
            if (! (arms & SOUTHBIT)) can_rotate &= no_stone(0,+1);
        }
        if (arms & SOUTHBIT) {
            can_rotate &= no_stone(+1,+1);
            if (! (arms & EASTBIT)) can_rotate &= no_stone(+1,0);
        }
        if (arms & EASTBIT) {
            can_rotate &= no_stone(+1,-1);
            if (! (arms & NORTHBIT)) can_rotate &= no_stone(0,-1);
        }
    }

    if (can_rotate) {
        sound_event (clockwise ? "turnstileright" : "turnstileleft");
        sound_event("movesmall");

        active = true;
        set_anim(anim());
	    rotate_arms(arms, clockwise);
        handleActorsAndItems(clockwise, impulse_sender);

        performAction(clockwise == 0);
        server::IncMoveCounter();
    }
    return can_rotate;
}

namespace {
    bool calc_arm_seen (bool cw, DirectionBits arms, int field) {
        // for each field calculate whether an arm has passed by, first
        // counterclockwise and then clockwise:
        const DirectionBits neededArm[2][8] = {
            {WESTBIT, NORTHBIT, NORTHBIT, EASTBIT, EASTBIT, SOUTHBIT, SOUTHBIT, WESTBIT},
            {NORTHBIT, NORTHBIT, EASTBIT, EASTBIT, SOUTHBIT, SOUTHBIT, WESTBIT, WESTBIT}
        };
        return (arms & neededArm[cw][field]) != 0;
    }
}

void Turnstile_Pivot_Base::handleActorsAndItems(bool clockwise, Object *impulse_sender) {
    const int to_index[3][3] = { // (read this transposed)
        { 0, 7, 6 }, // x == 0
        { 1,-1, 5 }, // x == 1
        { 2, 3, 4 }  // x == 2
    };
    const int to_x[8] = { -1, 0, 1, 1, 1, 0, -1, -1 };
    const int to_y[8] = { -1, -1, -1, 0, 1, 1, 1, 0 };

    bool arm_seen[8];
    DirectionBits arms = arms_present(); // Note: already the rotated state
    for (int i = 0; i<8; ++i)
        arm_seen[i] = calc_arm_seen (clockwise, arms, i);

    // ---------- Handle items in range ----------
    GridPos pv_pos = get_pos();
    for (int i = 0; i<8; ++i) 
        if (arm_seen[i]) {
            GridPos item_pos(pv_pos.x+to_x[i], pv_pos.y+to_y[i]);
            if (Item *it = GetItem(item_pos)) { 
                if (it->get_traits().id == it_laserbeam)
                    KillItem(item_pos); 
                else
                    it->on_stonehit(this); // hit with pivot (shouldn't matter)
            }
        }

    // ---------- Handle actors in range ----------
    vector<Actor*> actorsInRange;

    // tested range is sqrt(sqr(1.5)+sqr(1.5)) 
    if (!GetActorsInRange(pv_pos.center(), 2.124, actorsInRange))
        return;

    vector<Actor*>::iterator iter = actorsInRange.begin(), end = actorsInRange.end();
    for (; iter != end; ++iter) {
        Actor *ac = *iter;
        const V2 &ac_center = ac->get_pos();
        GridPos   ac_pos(ac_center);
        int dx  = ac_pos.x-pv_pos.x;
        int dy  = ac_pos.y-pv_pos.y;

        // ignore if actor is not inside the turnstile square or is not
        // in distance of the the rotating arms
        if ((dx<-1 || dx>1 || dy<-1 || dy>1) || 
                (length(ac->get_pos() - pv_pos.center()) > 1.58114 + ac->get_actorinfo()->radius))
            continue;

        int idx_source = to_index[dx+1][dy+1];
        if (idx_source == -1) 
            continue;       // actor inside pivot -- should not happen

        const int rot_index[4][8] = {
            // The warp-destinations for actors. Why different destinations
            // for oxyd/non-oxyd-type turnstiles? Imagine the actor on position
            // 1 (North of pivot), the turnstile rotates anticlockwise. Then
            // a green turnstile-arm, if at all, would push the actor one field
            // to the left (position 0). Now assume it's a red turnstile. If the
            // actor is to be warped, it has to be the one that activated the
            // turnstile. Yet it is on position 1, in principle not able to
            // hit an arm. But it can, if it hits fast enough on the edge of
            // pivot and left arm. In this case, the actor should be handled
            // as if on position 1, thus warping to 6.
            { 6,  0, 0,  2, 2,  4, 4,  6 }, // anticlockwise
            { 2,  2, 4,  4, 6,  6, 0,  0 }, // clockwise
            { 6,  6, 0,  0, 2,  2, 4,  4 }, // anticlockwise (oxyd-compatible)
            { 2,  4, 4,  6, 6,  0, 0,  2 }, // clockwise (oxyd-compatible)
        };

        bool compatible = oxyd_compatible();
        int  idx_target = rot_index[clockwise+2*compatible][idx_source]; // destination index
        bool do_warp = false; // move the actor along with the turnstile?

        if (compatible) {
            // Move only the actor that hit the turnstile in Oxyd mode
            do_warp = (ac == dynamic_cast<Actor*>(impulse_sender));
            if (!do_warp && arm_seen[idx_source])
                SendMessage(ac, "shatter"); // hit by an arm
        } else { // green turnstile
            // move all actors only if pushed by an arm
            do_warp = arm_seen[idx_source];
        }

        if (!do_warp) 
            continue;

        // Pushing an actor out of the level results in a shatter (no warp) instead
        GridPos ac_target_pos(pv_pos.x+to_x[idx_target], pv_pos.y+to_y[idx_target]);

        if(!IsInsideLevel(ac_target_pos)) {
            SendMessage(ac, "shatter");
            continue;
        }

        WarpActor(ac, ac_target_pos.x+.5, ac_target_pos.y+.5, false);

        if (Stone *st = GetStone(ac_target_pos)) {

            // destination is blocked

            Turnstile_Arm *arm = dynamic_cast<Turnstile_Arm*>(st);
            if (arm && !compatible) { // if blocking stone is turnstile arm -> hit it!
                const int impulse_dir[2][8] = {
                    // anticlockwise
                    { SOUTHBIT|WESTBIT, WESTBIT, NORTHBIT|WESTBIT, NORTHBIT,
                      NORTHBIT|EASTBIT, EASTBIT, SOUTHBIT|EASTBIT, SOUTHBIT },
                    // clockwise
                    { NORTHBIT|EASTBIT, EASTBIT, SOUTHBIT|EASTBIT, SOUTHBIT,
                      SOUTHBIT|WESTBIT, WESTBIT, NORTHBIT|WESTBIT, NORTHBIT }
                };

                DirectionBits possible_impulses =
                    static_cast<DirectionBits>(impulse_dir[clockwise][idx_target]);

                for (int d = 0; d<4; ++d) 
                    if (has_dir(possible_impulses, Direction(d))) 
                        ac->send_impulse(ac_target_pos, Direction(d));

//                 if (GetStone(ac_target_pos) == 0)  // arm disappeared
//                     break;
            }
        }
    }

// @@@ FIXME: it's possible that two actors are moved to the same
// destination field.  In that case the second actor is put on top of
// the first actor (happens only in non-oxyd-compat-mode with three
// balls or pullers/impulsestones)
//
// Note: With black and whiteball it's normally no problem, because
// when one of the actors was moving, it's looking natural.  Problems
// occur when small balls come into play.

}


/* -------------------- Mail stone -------------------- */

namespace
{
    class MailStone : public Stone {
        CLONEOBJ(MailStone);
        Direction m_dir;


        MailStone (const char *kind, Direction dir);
        void actor_hit (const StoneContact &sc);

        GridPos find_pipe_endpoint();
    public:
        static void setup();
    };
}

void MailStone::setup()
{
    Register (new MailStone ("st-mail-n", NORTH));
    Register (new MailStone ("st-mail-e", EAST));
    Register (new MailStone ("st-mail-s", SOUTH));
    Register (new MailStone ("st-mail-w", WEST));
}

MailStone::MailStone (const char *kind, Direction dir)
: Stone(kind), m_dir(dir)
{}


void MailStone::actor_hit (const StoneContact &sc) 
{
    if (enigma::Inventory *inv = player::GetInventory(sc.actor)) {
        if (Item *it = inv->get_item(0)) {
            GridPos p = find_pipe_endpoint();
            if (IsInsideLevel(p) && it->can_drop_at (p)) {
                it = inv->yield_first();
                player::RedrawInventory (inv);
                it->drop(sc.actor, p);
            }
        }
    }
}

/** About recursion detection while finding the end of a mailpipe
 *  
 *  Since there are no possibilities for forking a mailpipe, there is only one 
 *  cause that may lead to a closed, circular mailpipe. This is if a pipeitem is
 *  placed exactly under the mailstone. But not every pipepiece is dangerous,
 *  there are some that can be placed under the mailstone without problems.
 * 
 *  The mailpipe is only closed to a circular one if the pipepiece under the
 *  mailstone has the same 'output'-direction as the stone.
 */
GridPos MailStone::find_pipe_endpoint() 
{
    GridPos p = get_pos();
    Direction move_dir = m_dir;
    GridPos q = p; // Store the stonepos for recursion detection.

    while (move_dir != NODIR) {
        p.move (move_dir);
        if (Item *it = GetItem(p)) {
            switch (get_id(it)) {
            case it_pipe_h:
                if (!(move_dir == EAST || move_dir == WEST))
                    move_dir = NODIR;
                break;
            case it_pipe_v:
                if (!(move_dir == SOUTH || move_dir == NORTH))
                    move_dir = NODIR;
                break;
            case it_pipe_ne:
                if (move_dir == SOUTH)     move_dir = EAST;
                else if (move_dir == WEST) move_dir = NORTH;
                else                       move_dir = NODIR;
                break;
            case it_pipe_es:
                if (move_dir == NORTH)     move_dir = EAST;
                else if (move_dir == WEST) move_dir = SOUTH;
                else                       move_dir = NODIR;
                break;
            case it_pipe_sw:
                if (move_dir == NORTH)     move_dir = WEST;
                else if (move_dir == EAST) move_dir = SOUTH;
                else                       move_dir = NODIR;
                break;
            case it_pipe_wn:
                if (move_dir == SOUTH)     move_dir = WEST;
                else if (move_dir == EAST) move_dir = NORTH;
                else                       move_dir = NODIR;
                break;
            default:
                move_dir = NODIR;; // end of pipe reached
            }
        } else
            move_dir = NODIR;

        if (p == q)
            ASSERT(move_dir != m_dir, XLevelRuntime, "Mailpipe is circular! Recursion detected!");   
    }
    return p;
}


// --------------------------------------------------------------------------------

void Init_complex()
{
    Register(new Door);
    Register("st-door-h", new Door("h"));
    Register("st-door-v", new Door("v"));
    Register("st-door-h-open", new Door("h", true));
    Register("st-door-v-open", new Door("v", true));
    Register(new Door_a);
    Register(new Door_b);
    Register(new Door_c);
    Register("st-door_c-open", new Door_c_open);

    Register(new HollowStoneImpulseStone);

    MailStone::setup();

    Register(new MovableImpulseStone);

    Register(new OneWayStone);
    Register("st-oneway-n", new OneWayStone(NORTH));
    Register("st-oneway-e", new OneWayStone(EAST));
    Register("st-oneway-s", new OneWayStone(SOUTH));
    Register("st-oneway-w", new OneWayStone(WEST));
    Register(new OneWayStone_black);
    Register("st-oneway_black-n", new OneWayStone_black(NORTH));
    Register("st-oneway_black-e", new OneWayStone_black(EAST));
    Register("st-oneway_black-s", new OneWayStone_black(SOUTH));
    Register("st-oneway_black-w", new OneWayStone_black(WEST));
    Register(new OneWayStone_white);
    Register("st-oneway_white-n", new OneWayStone_white(NORTH));
    Register("st-oneway_white-e", new OneWayStone_white(EAST));
    Register("st-oneway_white-s", new OneWayStone_white(SOUTH));
    Register("st-oneway_white-w", new OneWayStone_white(WEST));


    Register (new PullStone);

    Register( new VolcanoStone);
    Register("st-volcano_inactive", new VolcanoStone(VolcanoStone::INACTIVE));
    Register("st-volcano_active", new VolcanoStone(VolcanoStone::ACTIVE));

    // PerOxyd/Enigma compatible puzzle stones:
    Register(new PuzzleStone(0, false));
    Register("st-puzzle-hollow", new PuzzleStone(1, false));
    Register("st-puzzle-n", new PuzzleStone(9, false));
    Register("st-puzzle-e", new PuzzleStone(5, false));
    Register("st-puzzle-s", new PuzzleStone(3, false));
    Register("st-puzzle-w", new PuzzleStone(2, false));
    Register("st-puzzle-ne", new PuzzleStone(13, false));
    Register("st-puzzle-nw", new PuzzleStone(10, false));
    Register("st-puzzle-es", new PuzzleStone(7, false));
    Register("st-puzzle-sw", new PuzzleStone(4, false));
    Register("st-puzzle-ns", new PuzzleStone(11, false));
    Register("st-puzzle-ew", new PuzzleStone(6, false));
    Register("st-puzzle-nes", new PuzzleStone(15, false));
    Register("st-puzzle-new", new PuzzleStone(14, false));
    Register("st-puzzle-nsw", new PuzzleStone(12, false));
    Register("st-puzzle-esw", new PuzzleStone(8, false));
    Register("st-puzzle-nesw", new PuzzleStone(16, false));

    // Oxyd1 compatible puzzle stones:
    Register("st-puzzle2-hollow", new PuzzleStone(1, true));
    Register("st-puzzle2-n", new PuzzleStone(9, true));
    Register("st-puzzle2-e", new PuzzleStone(5, true));
    Register("st-puzzle2-s", new PuzzleStone(3, true));
    Register("st-puzzle2-w", new PuzzleStone(2, true));
    Register("st-puzzle2-ne", new PuzzleStone(13, true));
    Register("st-puzzle2-nw", new PuzzleStone(10, true));
    Register("st-puzzle2-es", new PuzzleStone(7, true));
    Register("st-puzzle2-sw", new PuzzleStone(4, true));
    Register("st-puzzle2-ns", new PuzzleStone(11, true));
    Register("st-puzzle2-ew", new PuzzleStone(6, true));
    Register("st-puzzle2-nes", new PuzzleStone(15, true));
    Register("st-puzzle2-new", new PuzzleStone(14, true));
    Register("st-puzzle2-nsw", new PuzzleStone(12, true));
    Register("st-puzzle2-esw", new PuzzleStone(8, true));
    Register("st-puzzle2-nesw", new PuzzleStone(16, true));

    Register(new ShogunStone);
    Register("st-shogun-s", new ShogunStone(1));
    Register("st-shogun-m", new ShogunStone(2));
    Register("st-shogun-sm", new ShogunStone(3));
    Register("st-shogun-l", new ShogunStone(4));
    Register("st-shogun-sl", new ShogunStone(5));
    Register("st-shogun-ml", new ShogunStone(6));
    Register("st-shogun-sml", new ShogunStone(7));

    Register(new StoneImpulseStone);

    Register (new Turnstile_Pivot); // oxyd-comaptible
    Register (new Turnstile_Pivot_Green); // not oxyd-comaptible
    Register (new Turnstile_N);
    Register (new Turnstile_S);
    Register (new Turnstile_E);
    Register (new Turnstile_W);

}

} // namespace enigma
