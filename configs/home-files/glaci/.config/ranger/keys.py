from ranger.defaults.keys import *

map = extra_keys = KeyMapWithDirections()

# b: Tag only this file, watch it and mark it watched
@map('b')
def watch(arg):
    cwd = arg.fm.env.cwd
    sel = cwd.get_selection()

    arg.fm.tag_toggle(cwd.filenames, False);
    arg.fm.tag_toggle([x.path for x in sel], True);

    arg.fm.run(app='watchmark', files=sel);

# B: Tag only this file, watch it
@map('B')
def watch(arg):
    cwd = arg.fm.env.cwd
    sel = cwd.get_selection()

    arg.fm.tag_toggle(cwd.filenames, False);
    arg.fm.tag_toggle([x.path for x in sel], True);

    arg.fm.run(app='mplayer', files=sel);


map = keymanager.get_context('browser')
map.merge(extra_keys)
