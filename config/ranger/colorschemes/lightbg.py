# Colorscheme for light background in ranger
# Author: Christian Tenllado (ctenllado@gmail.com)

from __future__ import (absolute_import, division, print_function)

from ranger.colorschemes.default import Default
from ranger.gui.color import (
    black, blue, cyan, green, magenta, red, white, yellow, default,
    normal, bold, reverse, dim, BRIGHT,
    default_colors,
)


class Scheme(Default):
    progress_bar_color = blue

    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if context.in_titlebar:
            if context.tab:
                if not context.good:
                    bg = cyan
            elif context.file:
                fg = default
        elif context.in_browser:
            if context.main_column and context.selected:
                fg = yellow

        return fg, bg, attr
