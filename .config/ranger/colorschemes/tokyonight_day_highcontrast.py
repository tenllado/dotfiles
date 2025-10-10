from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class TokyoNightDayHighContrast(ColorScheme):
    progress_bar_color = 24  # darker blue

    def use(self, context):
        fg, bg, attr = default_colors

        # High-contrast Tokyonight-Day 256-color mapping
        black   = 235
        red     = 160
        green   = 64
        yellow  = 180
        blue    = 24
        magenta = 90
        cyan    = 37
        white   = 250
        grey    = 244

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr |= reverse
            if context.directory:
                fg = blue
            elif context.executable and not context.media:
                fg = green
            elif context.media:
                fg = cyan
            elif context.container:
                fg = magenta
            elif context.link:
                fg = cyan
            elif context.socket:
                fg = magenta
            elif context.fifo or context.device:
                fg = yellow
            if context.empty or context.error:
                fg = red
            if context.marked:
                attr |= bold

        elif context.in_titlebar:
            # default titlebar text color
            fg = black

            if context.directory:
                fg = blue

            # hostname coloring
            if context.hostname:
                fg = green if context.good else red

            # active / inactive tabs
            if context.tab:
                if context.good:  # "good" marks the active tab
                    fg = blue
                    attr |= reverse
                #else:
                #    bg = 251

            # current directory (not tab label) → black text, no bg change
            if context.directory and not context.tab:
                fg = blue

        elif context.in_statusbar:
            fg = grey
            if context.permissions:
                fg = green if context.good else red
            if context.marked:
                attr |= bold
            if context.message:
                fg = yellow
            if context.loaded:
                fg = cyan

        elif context.in_taskview:
            if context.selected:
                attr |= reverse
            fg = grey

        return fg, bg, attr
