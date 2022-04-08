# kittysay
[Vim-Plugin] :KittyWin makes a kitty window that :KittySay says things to.


kitty terminal can be installed with

    sudo apt install kitty

In an instance of vim, first do the ``:KittyWin`` command at least once.

Subseqently, ``:KittySay`` command will tell the window that was opened to run the current python file (or run make if a Makefile exists alongside the current file).

Command ``:KittyCan`` is also provided to send a Control-C signal to the window.

Suggested usage is to define a function which maps the preceding commands to hotkeys of your choice. Then, make an autocommand which will enable those hotkeys under the circumstances of your choosing.

For example, I have it set so that when I edit python files on my desktop or inside of folders that are on my desktop, mappings are added to run ``:KittyWin``, ``:KittySay``, and ``:KittyCan`` by pressing shift-F12, F12, and F11, respectively.


