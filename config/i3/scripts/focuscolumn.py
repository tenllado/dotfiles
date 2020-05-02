#!/usr/bin/python3
#
# if you have two columns at the desktop level this script changes the focus to
# the other colum, regardless of the layout in the containers of each column
#
# GPL License header
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Christian Tenllado Copyright 2020 Christian Tenllado e-mail:
# ctenllado@gmail.com


from i3ipc import Connection

def switch_col(con, focused):
    if con.layout == 'splith' and len(con.nodes) == 1 and \
            con.nodes[0].layout == 'splith':
        return switch_col(con.nodes[0], focused)
    elif con.layout != 'splith' or len(con.nodes) != 2:
        return


    if (len(con.nodes[0].nodes) == 0 and con.nodes[0].window == focused.window)\
            or con.nodes[0].find_by_id(focused.id):
        d = 1
    else:
        d = 0

    if len(con.nodes[d].focus) == 0:
        dest = con.nodes[d]
    else:
        dest = con.nodes[d].find_by_id(con.nodes[d].focus[0])
    dest.command('focus')


def main():
    cnx = Connection()
    focused = cnx.get_tree().find_focused()
    wsp = focused.workspace()
    if not wsp or wsp.name == "__i3_scratch":
        return
    switch_col(wsp, focused)

if __name__ == "__main__":
    main()
