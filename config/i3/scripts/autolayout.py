#!/usr/bin/python3

# This script enforces a specific layout on i3 automatically. The intended
# layout is similar to master stacked in dwm, but inserting the new window at
# the end of the stack. We have the aditional benefits of being able to use the
# i3 tabbed and stacked layouts on each of the sides (on the master side you
# have to move the windows once opened) and to use directional movements (left,
# right, up, down).
#     ---------------
#     |      |      |
#     |      |------|
#     |  M   |  S   |
#     |      |------|
#     |      |    <------ new windows inserted here
#     ---------------
#
# If the user adds windows to different containers when they are oppened, the
# script does not modify them, enabling a mix of dynamic and manual tiling
#
# If the initial layout of the workspace is not splith (horizontal), the script
# does nothing.
#
# If the user moves one window to a third column (3 nodes at the root), the
# script ignores that window and keeps on adding new windows on the second
# "column" (if you moved the new container to the second position, that will be
# the container for the stack)
#
# How is that achieved. It is difficult using the i3ipc interface, with limmited
# access to the tree and after the new widow has already been inserted. The way
# it is currently done is as follows:
#
# 1. when a new window is oppened the script checks the correspondig workspace
#    layout. If it is not horizontal the script will do nothing. This allows you
#    to have for instance one container with stacked or tabbed windows, which I
#    often use as a replacement of the monocle layout from dwm
#
# 2. if the workspace is horizontal it looks for the first node/container with
#    more than one child. I do this because sometimes I end up with a root node
#    that just have one child (that could be removed). When descending these
#    removable nodes it checks whether their layout is horizontal. If it is not
#    it quits (nothing is done)
#
# 3. if it finds a first node with at least two childs with an horizontal
#    layout, it makes sure the second one is a container, ingoring the new
#    window just inserted. If it is not it creates a splitv container at that
#    point.
#
# 4. it marks the last child in breadth first order from that container with the
#    special mark (_w<workspacename>_insert)
#
# 5. the new window is moved to the marked container and focused again
#
# GPL License header
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author: Christian Tenllado
# Copyright 2020 Christian Tenllado
# e-mail: ctenllado@gmail.com
#

from i3ipc import Connection

def get_insert_mark(wsp):
    return '_w{}_insert'.format(wsp.name)

def format_and_mark(con):
    mark = get_insert_mark(con.workspace())
    mark_set = False
    if len(con.nodes) == 0:
        con.command('focus')
        con.command('split vertical')
        con.command('mark {}'.format(mark))
        mark_set = True
    else:
        last = con.leaves()[-1]
        last.command('mark {}'.format(mark))
        mark_set = True
    return mark_set

def place_node(con, new_con):
    if not con or con.layout != 'splith' or len(con.nodes) < 1:
        return
    mark_set = False
    if len(con.nodes) == 1:
        place_node(con.nodes[0], new_con)
    elif con.nodes[1] != new_con:
        mark_set = format_and_mark(con.nodes[1])
    elif len(con.nodes) >= 3:
        mark_set = format_and_mark(con.nodes[2])

    if mark_set:
        wsp = new_con.workspace()
        new_con.command('move window to mark {}'.format(get_insert_mark(wsp)))
        new_con.command('focus')

def on_window_new(self, e):
    def get_workspace(cnx, e):
        return cnx.get_tree().find_by_id(e.container.id).workspace()

    cnx = Connection()
    wsp = get_workspace(cnx, e)
    if not wsp:
        # This removes problems on i3 start
        return
    new_con = wsp.find_by_id(e.container.id)
    place_node(wsp, new_con)

i3 = Connection()
i3.on('window::new', on_window_new)
i3.main()
