# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import *

# A simple command for demonstration purposes follows.
#------------------------------------------------------------------------------

# You can import any python module as needed.
import os
import subprocess

# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.  
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.acitons, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    def tab(self):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()

class copyclip(Command):
    """
    :copyclip

    Copies the selected files to clipboard, so that you can paste them
    in oter desktop applications, like you had copied them with nautilus
    or thunar or any other gui application

    Requires xclip
    """

    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        uris = ["file://" + os.path.abspath(f.path) for f in marked_files]
        command = "printf \"copy\n" + "\n".join(uris) + "\"" \
                + " | xclip -i -selection clipboard " \
                + "-t x-special/gnome-copied-files"
        self.fm.run(command)

class empty(Command):
    """
    :empty

    Empties the trash directory ~/.local/share/Trash/files

    """

    def execute(self):
        self.fm.run("rm -rf ~/.local/share/Trash/files/{*,.[^.]*}")

class extracthere(Command):
    def execute(self):
        """ Extract copied files to current directory """
        copied_files = tuple(self.fm.env.copy)

        if not copied_files:
            return

        def refresh(_):
            cwd = self.fm.env.get_directory(original_path)
            cwd.load_content()

        one_file = copied_files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-X', cwd.path]
        au_flags += self.line.split()[1:] 
        au_flags += ['-e']
        self.fm.env.copy.clear()
        self.fm.env.cut = False
        if len(copied_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags \
                + [f.path for f in copied_files], descr=descr)
        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)


class compress(Command):
    def execute(self):
        """ Compress marked files to current directory """
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.env.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]
        descr = "compressing files in: " + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr)
        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self):
        """ Complete with current folder name """
        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(self.fm.thisdir.path) + ext for ext in extension]

class sxivmark(Command):
    """ Use sxiv to mark, unmark or toggle mark image files. Requieres sxiv
        to be installed. By default files are marked. """
    def execute(self):
        toggle = False
        val = True
        if self.arg(1) == "toggle":
            toggle = True
        elif self.arg(1) == "unmark":
            val = False
        elif self.arg(1) and self.arg(1) != "mark":
            self.fm.notify('Wrong argument: ' + self.arg(1), bad=True)
            return

        cwd = self.fm.thisdir
        sel = subprocess.run(["sxiv", "-to", cwd.path], stdout=subprocess.PIPE)
        paths = sel.stdout.decode('utf-8').split()
        files = [os.path.basename(f) for f in paths]
        fobjs = [f for f in cwd.files if f.basename in files]
        for fobj in fobjs:
            if toggle:
                cwd.toggle_mark(fobj)
            else:
                cwd.mark_item(fobj, val)
