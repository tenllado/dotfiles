from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class TokyoNightNightHighContrast(ColorScheme):
    """
    High-contrast Tokyonight Night colorscheme for Ranger (256-color)
    Optimized for dark backgrounds, maintaining good readability.
    """
    progress_bar_color = 33  # bright blue for progress bars

    def use(self, context):
        fg, bg, attr = default_colors

        # Tokyonight Night 256-color approximation
        black   = 234   # almost black background
        red     = 167   # red tones
        green   = 142   # green tones
        yellow  = 214   # mustard yellow
        blue    = 33    # deep blue
        magenta = 139   # muted magenta
        cyan    = 37    # bright cyan
        white   = 252   # off-white
        grey    = 240   # mid gray

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
            fg = white
            if context.directory:
                fg = blue
            if context.hostname:
                fg = green if context.good else red
            if context.tab:
                if context.good:  # active tab
                    fg = blue
                    attr |= reverse
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
