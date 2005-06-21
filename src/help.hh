/*
 * Copyright (C) 2002,2003 Daniel Heck, Ralf Westram
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
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
 *
 * $Id: help.hh,v 1.2 2004/01/09 21:37:56 dheck Exp $
 */

#ifndef ENIGMA_HELP_HH
#define ENIGMA_HELP_HH

namespace enigma {

    void displayHelp (const char **helptext, int xoffset);

}; // end of namespace enigma

#else
#error help.hh included twice
#endif // ENIGMA_HELP_HH

