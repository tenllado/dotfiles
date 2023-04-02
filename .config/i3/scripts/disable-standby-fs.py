#!/usr/bin/python3

from argparse import ArgumentParser
from subprocess import call
import i3ipc
import subprocess as sp
import signal

parser = ArgumentParser(prog='disable-standby-fs',
        description='''
        Disable standby (dpms) and screensaver when a window becomes fullscreen
        or exits fullscreen-mode. Requires `xorg-xset`.
        ''')
parser.add_argument("b", type=int, help="seconds for blank screen")
parser.add_argument("k", type=int, help="kill signal for i3blocks")

args = parser.parse_args()

p = sp.Popen("xset q | grep -A 2 Saver | grep timeout | sed -rn 's/[^[:digit:]]*([[:digit:]]+).*/\\1/p'", shell=True, stdout=sp.PIPE)
sstimeout = p.stdout.read().strip()
sson = sstimeout != 0

i3 = i3ipc.Connection()

def screen_saver(on):
    if on:
        #print('enabling screen saver')
        call('xset s {}'.format(args.b).split())
    else:
        #print('disabling screen saver')
        call('xset s off'.split())
    #print('done')
    call('pkill -RTMIN+{} i3blocks'.format(args.k).split())

def on_fullscreen_mode(i3, e):
    if len(i3.get_tree().find_fullscreen()):
        screen_saver(False)
    elif sson:
        screen_saver(True)

def on_window_close(i3, e):
    if not len(i3.get_tree().find_fullscreen()) and sson:
        screen_saver(True)

def handler(signo, stack):
    global sson, i3
    sson = not sson
    if not len(i3.get_tree().find_fullscreen()):
        screen_saver(sson)

signal.signal(signal.SIGUSR1, handler)
i3.on('window::fullscreen_mode', on_fullscreen_mode)
i3.on('window::close', on_window_close)
i3.main()
