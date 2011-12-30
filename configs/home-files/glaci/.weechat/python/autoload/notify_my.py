import weechat
import os

SCRIPT_NAME = "notify"
SCRIPT_AUTHOR = "Lucas de Vries <lucas@glacicle.org>"
SCRIPT_VERSION = "1"
SCRIPT_LICENSE = "GPL3"
SCRIPT_DESC = "Call a notification on highlight or private message."

def nt_unload(*args):
    return True

def nt_highlight(*args):
    msg = args[2].replace("&", "&amp;").replace("'","`")
    subj, summ = msg.split("\t")

    os.system("notify-send '{0}' '{1}' &> /dev/null".format(subj, summ))

    return True

def nt_highlight_pv(*args):
    msg = args[2].replace("&", "&amp;").replace("'","`").split("!", 1)

    subj = msg[0][1:]
    summ = msg[1].split(" :",1)[1]

    if subj != "identica":
        os.system("notify-send '{0}' '{1}' &> /dev/null".format(subj, summ))
    return True

if __name__ == "__main__":
    if weechat.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, 
                        SCRIPT_LICENSE, SCRIPT_DESC, "nt_unload", ""):

        weechat.hook_signal("weechat_highlight", "nt_highlight", "")
        weechat.hook_signal("irc_pv", "nt_highlight_pv", "")
