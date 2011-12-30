/**
 * Adds all the userstyles to vimperator
 *
 */

var loaduserstyles = function()
{
    /// Userstyles
    var userstyles = [
        [
            "global",
            "*",
            "global.css",
        ],

        [
            "wikipedia:minimal",
            "en.wikipedia.org",
            "wikipedia.css",
        ],

        [
            "wikimedia:minimal",
            "secure.wikimedia.org",
            "wikipedia.css",
        ],

        [
            "scroogle:minimal",
            "https://ssl.scroogle.org/cgi-bin/nbbwssl.cgi",
            "scroogle.css",
        ],

        [
            "reddit:minimal",
            "reddit.com",
            "reddit.css",
        ],

        //[
            //"archlinux-forums:minimal",
            //"bbs.archlinux.org",
            //"archlinux.forum.css",
        //],

        [
            "tokyotosho:minimal",
            "tokyotosho.info",
            "tokyotosho.css"
        ],

        [
            "tvtorrents:minimal",
            "tvtorrents.com",
            "tvtorrents.css",
        ],

        [
            "ixquick:minimal",
            "ixquick.com",
            "ixquick.css",
        ],

        [
            "google:minimal",
            "https://encrypted.google.com/search*",
            "google.css",
        ],

        [
            "dukgo:dark",
            "duckduckgo.com",
            "dukgo.css",
        ],

        [
            "youtube:dark-minimal",
            "youtube.com",
            "youtube.css",
        ],

        [
            "myanimelist:dark",
            "myanimelist.net",
            "myanimelist.css",
        ],

        [
            "vim:dark",
            "vim.org",
            "vim_org.css",
        ],
    ];

    // Get style directory
    var styledir = io.getRuntimeDirectories("styles")[0].path;

    for ([i, [name, filter, file]] in Iterator(userstyles))
    {
      // Remove all sheets with this filter
      styles.removeSheet(false, name)

      // Add the sheet
      styles.addSheet(false, name, filter,
          File(styledir+"/"+file).read())
    }
}

// Initial load
loaduserstyles()

// Add it as a command
commands.add(
    ["loaduserstyles"],
    "Load all user styles",
    loaduserstyles
);
