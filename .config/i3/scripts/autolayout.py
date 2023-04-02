#!/usr/bin/python3
#
# This script does some automatic processing on the tree tailored to my
# personal preferences. It is not a single fixed layout, it allows for a
# plethora of them, but does not allow layouts with more than two columns at the
# highest level. When a window is opened or moved creating a third column at the
# highest level, the window is moved automatically to the second column, tiling
# vertically if it had an horizontal layout. That is:
#
#     +--------------------+                    +---------+-----------+
#     |      |      |      |        is          |         |           |
#     |      |      |      |   automatically    |         |     W2    |
#     |  C1  |  W2  |  W3  |   -------------->  |   C1    +-----------+
#     |      |      |      |   transformed      |         |           |
#     |      |      |      |                    |         |     W3    |
#     +--------------------+                    +---------+-----------+
#
# If the second column contains more than one window, the insertion point is
# bellow the last focused window on that container, allowing you to preset the
# insertion point. It is very similar to the behaviour of the Xmonad default
# layout, the Monad Tall layout in Qtile and similar although not the same to
# the master stack layout from dwm.
#
# Whatever layout is inside the two columns is allowed and not modified, e.g C1
# can be a container with whatever layout (vertical, stacked, tabbed, even
# horizontal, but that would not make much sense), and the container including
# windows W2 and W3 can be set tabbed or stacked if desired. Single column
# vertical splits, tabbed or stacked are not modified.
#
# Why have I done this, i.e. the problem I try to solve is the following. I
# often have one application from which a spawn new windows. Examples are:
# firefox when I open a downloaded file, the mail application when I edit a new
# email, a file manager, ... The idea of i3's manual tiling, where you first
# focus the container where you want the new window and then you spawn it, does
# not work in these examples because you need to focus the main application to
# spawn the new ones. So then you have to spawn it, adjust the tree if needed
# and then move the window. This script does this steps automatically for me, so
# I never have the undesired 3 columns. I prefer to have the main window on the
# left column and the new spawned window on the right, and if I spawn more, tile
# them vertically and stack/tab that column if I want to see more.
#
# Caveats:
#
#  - For the moment only i3 native events are handled, and no event is available
#    to indicate that a container changed its layout. As a consequence, if you
#    create a single vertical split with more than two rows and then you change
#    the orientation to horizontal (mod+e by default) then you get the unwanted
#    three columns (next windows will be added to the second column).
#    This can be solved (I plan to work on it in the future) with an additional
#    socket to communicate with the script, modifying the shortcuts to send
#    special new events to the script. A better solution would require the
#    maintainers of i3 to add events for layout changes.
#
#  - Not as smooth as desired. The transformation illustrated above is fast but
#    it still presents some strange visual effect because when window W3 is
#    created, i3 first places it as a third colum, making W1 and W2 narrower,
#    and then the autolayout script moves W3 bellow W2, making W1 and W2 wide
#    again. This happens very fast but the visual effect is a bit anoying. This
#    of course does not happen on windows not moved by the autolayout script.
#    This cannot be solved with current i3. To avoid this issue i3 maintainers
#    should include a kind of pre-insert events so that the external script
#    could find the desired position for a new window on its creation, the
#    layout script could modify the tree to avoid the creation of a third column
#    (or enforce whatever layout you wish) and set the focus on the desired
#    position for the new window. After that i3 could just create the window in
#    the focused container as normal.
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

def place_node(i3, con, new_con):
    if con.layout == 'splith' and len(con.nodes) == 1 and \
            con.nodes[0].layout == 'splith':
        return place_node(i3, con.nodes[0], new_con)
    elif con.layout != 'splith' or len(con.nodes) < 3:
        return

    child = None
    for i in range(len(con.nodes)):
        if con.nodes[i].id == new_con.id:
            child = i

    if not child:
        return

    d = 2 if child == 1 else 1
    if con.nodes[d].layout == 'splith':
        con.nodes[d].command('split v')
        dest = con.nodes[d]
    else:
        dest = con.nodes[d].find_by_id(con.nodes[d].focus[0])
    dest.command('mark --add _target')
    new_con.command('move container to mark _target')
    dest.command('unmark _target')
    new_con.command('focus')

def new_move_callback(i3, e):
    def get_workspace(i3, e):
        return i3.get_tree().find_by_id(e.container.id).workspace()

    wsp = get_workspace(i3, e)
    if not wsp:
        # This removes problems on i3 start
        return
    new_con = wsp.find_by_id(e.container.id)
    place_node(i3, wsp, new_con)

def fix_layout(workspace):
    new_master = None
    if len(workspace.nodes) == 1 \
        and len(workspace.nodes[0].nodes) > 0 \
        and workspace.nodes[0].layout == 'splitv':
        new_master = workspace.nodes[0].nodes[0]
        if len(workspace.nodes[0].nodes) == 1:
            new_master.command('layout splith')
        else:
            new_master.command('move left')
    return new_master

def close_callback(i3, e):
    new_master = fix_layout(i3.get_tree().find_focused().workspace())
    if new_master:
        new_master.command('focus')

def workspace_callback(i3, e):
    fix_layout(e.current)

i3 = Connection()
i3.on('window::new', new_move_callback)
i3.on('window::move', new_move_callback)
i3.on('window::close', close_callback)
i3.on('workspace::focus', workspace_callback)
i3.main()
