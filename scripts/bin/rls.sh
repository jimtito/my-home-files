#!/bin/bash

# Scene release manager script. Awezomes!
# Written by Daethorian (daethorian@ninjaloot.se)
# This version is not commented. If you want the comments, mail me and you'll get it.
# Licensed under the GNU GPLv3

version() { # {{{
    echo "rls v1.0"
    echo "Written by Daethorian (daethorian@ninjaloot.se)"
    echo "Licensed under the GNU GPLv3"
} # }}}
setup() { # {{{
    MISSING=0
    CONFIG="$HOME/.rls/rls.rc"
    # introduction {{{
    echo "   rls is a fairly complex release management script."
    echo "   When you run it for the first time, it will recognize that you don't have"
    echo "   a configuration file and assume installation (it just did). The script will create"
    echo "   a directory called .rls/ in your home directory. Any files related to this"
    echo "   script will be found there. When that is done, the script will try to install"
    echo "   itself in /usr/bin so it can be run be calling just 'rls' and nothing else."
    echo
    echo "   Almost every function will be called upon a directory. If no directory is given, the"
    echo "   script will run in the current working directory. Every function (unless otherwise"
    echo "   stated) is fully recursive and will run itself upon any directories found. The sorting"
    echo "   schemes are one notable exceptions. (As they move files, recursion gets alot trickier"
    echo "   to do well.)"
    echo
    read -s -p "   Press enter to proceed with installation. "
    # }}}
    # environment check {{{
    echo
    if ! echo $SHELL | grep -E 'bash$' &> /dev/null; then
	echo "   Warning: You are not using bash."
	echo "            This script relies heavily on bashisms and bash coloring."
	echo "            Output and functionality might be (really) broken."
	echo
    fi

    for i in grep echo mkdir rm tac find tail head sh seq cut date wget sed tr which; do
	if ! which $i &> /dev/null; then
	    echo "$i not found."
	    let MISSING=MISSING+1
	fi
    done

    if [ $MISSING != 0 ] ; then
	echo -e "   ${BRED}Error$NC: Vital tools are missing."
	echo "          You are probably a retard with a broken system. :("
	echo "          Install the missing packages and try again."
	echo
	exit 127
    else
    	echo -e "   ${GREEN}All needed basic packages are present.$NC"
    fi

    if which cksfv &> /dev/null ; then
    	echo -e "   ${GREEN}cksfv found$NC"
    else
        echo -e "   ${BRED}Error$NC: cksfv not found."
        echo "          rls uses cksfv to verify sfv checksums."
        echo "          Please install it and run the script again."
        echo "          http://zakalwe.fi/~shd/foss/cksfv/"
        echo

        exit 127
    fi

    if which mp3info &> /dev/null ; then
    	echo -e "   ${GREEN}mp3info found$NC"
    else
        echo -e "   ${BRED}Error$NC: mp3info not found."
        echo "          rls uses mp3info for mp3 sorting."
        echo "          Please install it and run the script again."
        echo "          http://ibiblio.org/mp3info/"
        echo

        exit 127
    fi # }}}
    # directory setup {{{
    UP=$HOME/up/
    TMP=$HOME/.rls/tmp/
    IMDB=$HOME/.rls/imdb/
    SCANNER=$HOME/.rls/scanner/
    UNDO=$HOME/.rls/undo/
    TEST=$HOME/.rls/test/
    ERASE=$HOME/.rls/erase/

    for i in $HOME/.rls $UP $TMP $IMDB $SCANNER $UNDO $TEST $ERASE; do
        if [ ! -d $i ] ; then
            mkdir $i
        fi
    done # }}}
    # rc-file {{{
    echo "# Default unpacking directory." >> $CONFIG
    echo UP=$UP >> $CONFIG
    echo  >> $CONFIG
    echo "# Temporary unpacking path. Used when unpacking subtitles. This directory should always be empty." >> $CONFIG
    echo TMP=$TMP >> $CONFIG
    echo >> $CONFIG
    echo "# If set to true, unpack all releases to the unpacking directory preserving the release directory." >> $CONFIG
    echo "# eg Foo.Bar-GRP unpacks to /home/<user>/up/Foo.Bar-GRP/" >> $CONFIG
    echo "# If set to false (or anything else, actually), unpack directly into /home/<user>/up/" >> $CONFIG
    echo "# SPLIT=true" >> $CONFIG
    echo >> $CONFIG
    echo >> $CONFIG
    echo >> $CONFIG
    echo >> $CONFIG
    echo "# Regular expressions. Modify only if you know what you are doing." >> $CONFIG
    echo "RXP_GAME=\"(clone(cd|dvd))|(reloaded|f(air)?l(igh)?t|vitality|razor1911|skidrow|un(leashed|loaded)|procyon|hoodlum|deviance|tinyiso|hatred|0X0000(7|8))$)\"" >> $CONFIG
    echo "RXP_TV=\"S?[0-9]?[0-9](E|x)[0-9]{2}\"" >> $CONFIG
    echo "RXP_XXX=\"XXX\"" >> $CONFIG
    echo "RXP_CODEC=\"(xvid|dvdr|(720|1080)(p|i))\"" >> $CONFIG
    echo "RXP_CONSOLE=\"(wii|xbox(360)?|ps(p|x|2|3))\"" >> $CONFIG
    echo "RXP_FIX=\"((track|dir|rar|nfo|s(ync|ub|hit))fix)\"" >> $CONFIG
    echo "RXP_PACK=\"(ScT|PB)\"" >> $CONFIG
    echo "RXP_CD=\"(cd|dvd|disc)[0-9]$\"" >> $CONFIG
    echo "RXP_SUBS=\"((vob)?sub(s)?)$\"" >> $CONFIG
    echo "RXP_SUBDIRS=\"(sample|(vob)?subs?|covers?|(cd|disc|dvd)[0-9])$\"" >> $CONFIG
    echo "RXP_PROPER=\"(proper|re(pack|rip))\"" >> $CONFIG
    echo "RXP_QT=\".(t(ele)?(c(ine)?|s(ync)?)|r5|(dvd)?scr(eener)?|w(ork)?p(rint)?|cam|(s|d)ubbed).\"" >> $CONFIG
    echo "RXP_KFT=\"(nfo|sfv|zip|jpe?g|([0-9]|r)(ar|[0-9]?))$\"" >> $CONFIG
    echo "RXP_MKFT=\"(nfo|sfv|mp3|m3u|jpg)$\"" >> $CONFIG
    echo "RXP_SKFT=\"(avi|mpe?g|mkv)$\"" >> $CONFIG
    echo "RXP_UP=\"(avi|mpe?g|nrg|iso|img|mkv)$\"" >> $CONFIG
    echo "RXP_SFV=\"(bad|missing)$\"" >> $CONFIG
    echo "RXP_SAMPLE=\"sample$\"" >> $CONFIG
    echo "RXP_SDIRS=\"^(m(p3|ovies)|x{3}|tv|fixes|(sub)?packs|imdb|(720|1080)(p|i)|wii|xbox(360)?|ps(p|2|3)|0day|appz|dox|unsortable)$\"" >> $CONFIG
    #echo "RXP_=\"()\"" >> $CONFIG
    #echo "RXP_=\"()\"" >> $CONFIG
    #echo "RXP_=\"()\"" >> $CONFIG
    #echo "RXP_=\"()\"" >> $CONFIG
    #echo "RXP_=\"()\"" >> $CONFIG
    echo >> $CONFIG
    echo >> $CONFIG
    echo >> $CONFIG
    echo >> $CONFIG
    echo "# Do not make changes below this line. All variables past this line are used by the script and should not be changed." >> $CONFIG
    echo "IMDB=$IMDB" >> $CONFIG
    echo "SCANNER=$SCANNER" >> $CONFIG
    echo "UNDO=$UNDO" >> $CONFIG
    echo "TEST=$TEST" >> $CONFIG
    echo "ERASE=$ERASE" >> $CONFIG
    echo -e "   ${GREEN}rc file setup complete$NC" # }}}
    # file installation {{{
    if [ ! -f /usr/bin/rls ] ; then
    	echo
    	echo "   For simplicity of usage, the script will install itself"
    	echo "   in /usr/bin. To do so, root privileges is needed."
    	echo

    	if which sudo &> /dev/null ; then
    	    echo "   sudo was found. "
    	    read -s -p "   Press enter and you will be prompted for your password. "
    	    echo
    	    sudo cp $0 /usr/bin/rls
    	    sudo chmod +x /usr/bin/rls

    	    if [ ! -x /usr/bin/rls ] ; then
    	    	echo
    	    	echo -e "   ${BRED}Error$NC: It seems something went wrong."
	    	echo "          Please manually check if /usr/bin/rls exists"
	    	echo "          and is executable."
	    fi
    	else
    	    echo "   sudo was not found. Please manually copy (or move)"
    	    echo "   the script to /usr/bin/rls. Remember to chmod +x it."
    	fi
    	echo
    fi

    echo
    echo -e "   ${GREEN}All configuration files can be found in $HOME/.rls/."
    echo -e "   ${BGREEN}Installation complete."
    echo
    exit 0 # }}}
} # }}}
help() { # {{{
    echo "   Note: The script will consider anything containing a .nfo file a release."
    echo
    echo "   -s [<directory> [<destination>]]"
    echo "   Uses the main sorting scheme upon <directory> and sorts all releases found"
    echo "   within it. If a <destination> is given, the files will be moved there when"
    echo "   complete."
    echo "   The main sorting scheme will first sort all releases by category."
    echo "   If any mp3, tv, movie or xxx releases are found, the appropriate"
    echo "   sorting scheme will be applied upon them."
    echo "   Long option: --sort"
    echo
    echo "   -ca [<directory> [<destination>]]"
    echo "   Sorts by category. Will sort appropriate releases into categories."
    echo "   Currently capable of: 0day, appz, dox, games, movies, mp3, packs,"
    echo "   subpacks, tv and xxx. Anything that fails will be sorted as unsortable."
    echo "   Long option: --category"
    echo
    echo "   -mg [<directory> [<destination>]]"
    echo "   Sorts mp3 releases by genre. Tagless files and files of non-standard"
    echo "   naming convention will be sorted as unsortable."
    echo "   Long option: --genre"
    echo
    echo "   -ma [<directory> [<destination>]]"
    echo "   Sorts mp3 releases by artist. Tagless files and files of non-standard"
    echo "   naming convention will be sorted as unsortable."
    echo "   Long option: --artist"
    echo
    echo "   -t [<directory> [<destination>]]"
    echo "   Sorts tv releases by series. Fairly straightforward."
    echo "   Long option: --tv"
    echo
    echo "   -co [<directory> [<destination>]]"
    echo "   Sorts video releases by codec."
    echo "   Currently capable of: 1080p, 1080i, 720p, 720i, dvdr and xvid"
    echo "   Long option: --codec"
    echo
    echo "   -i [<directory> [<destination>]]"
    echo "   Sorts by imdb information. Will search through .nfo files for imdb links."
    echo "   If found, it will download and store the imdb pages found and then"
    echo "   make symbolic links by genres, year, score and position in the Top 250."
    echo "   If no imdb link can be found, the release will be sorted as unsortable."
    echo "   This sorting scheme does not move files and is fully recursive."
    echo "   Long option: --imdb"
    echo
    echo "   -iu [<directory> [<destination>]]"
    echo "   Forces updating of imdb information by redownloading all imdb files"
    echo "   and recreating the symbolic link database."
    echo "   Long option: --imdb-update"
    echo
    echo "   -x [<directory> [<destination>]]"
    echo "   Sorts porn. Its only and main function is to separate movies and imgsets."
    echo "   Long option: --xxx"
    echo
    echo "   -cl [<directory>]"
    echo "   Recursively finds all releases and moves them to <directory>."
    echo "   Used to ease sorting."
    echo "   Long option: --collect"
    echo
    echo "   -z [<directory>]"
    echo "   Undoes the last sort or collection."
    echo "   Long option: --undo"
    echo
    echo "   -u [<directory>]"
    echo "   Unpacks any releases found within <directory> to ~/up/."
    echo "   Long option: --unpack"
    echo
    echo "   -c [<directory>]"
    echo "   Recursively sfv checks all releases found in <directory>."
    echo "   Long option: --check"
    echo
    echo "   -q [<directory>]"
    echo "   Recursively scans all releases in <directory> in an attempt to find"
    echo "   errors or outdated releases. Currently found errors are:"
    echo "   Multiple .nfo files, obsoletion (if you have a release that has been propered),"
    echo "   inferior (if you have an R5 and a DVDrip, the R5 is inferior), bad directories,"
    echo "   bad files, sample missing (ScT gets this alot :D) and bad sample."
    echo "   All errors will be logged as symbolic links in ~/.rls/scan/."
    echo "   Long option: --scan"
    echo
    echo "   -r [<directory>]"
    echo "   Finds all music releases containing '_-_' and '--' strings and replaces"
    echo "   them with a single -. Not very scene, but god what I hate those."
    echo "   Long option: --rename"
    echo
    echo "   -d [<directory>]"
    echo "   Recursively removes all symbolic links and subsequently all empty directories."
    echo "   Long option: --delete"
    echo
    echo "   -dd [<directory>]"
    echo "   Recursively removes all empty directories."
    echo "   Long option: --directory"
    echo
    echo "   -dl [<directory>]"
    echo "   Recursively removes all symbolic links"
    echo "   Long option: --unlink"
    echo
    echo "   -db [<directory>]"
    echo "   Recursively removes all broken links"
    echo "   Long option: --broken"
    echo
    echo "   -st [<directory>]"
    echo "   Prints some statistics about your releases. Fun."
    echo "   Long option: --statistics"
} # }}}
rlssort() { # {{{
    ES=`date +'%s'`
    if [ -n "$2" ] ; then
        DEST=$2
    else
        DEST=$1
    fi

    catsort $1 $DEST

    if [ -d $DEST/mp3 ] ; then
	genresort $DEST/mp3/
    fi

    if [ -d $DEST/tv ] ; then
	tvsort $DEST/tv/
    fi

    if [ -d $DEST/movies ] ; then
	codecsort $DEST/movies/
	imdbsort $DEST/movies/
    fi

    if [ -d $DEST/xxx ] ; then
	xxxsort $DEST/xxx/
    	if [ -d $DEST/xxx/movies ] ; then
    	    codecsort $DEST/xxx/movies/
    	fi
    fi

    EE=`date +'%s'`; let T=EE-ES
    echo
    echo -en "   Sorting done in $T seconds"
    if [ -n "$IMST" ] ; then
    	echo -en " ($IMST of which were downloading IMDb data)"
    fi
    echo .
} # }}}
catsort() { # {{{
    if [ -n "$2" ] ; then
        CADEST=$2
    else
        CADEST=$1
    fi

    echo -e "   ${BGREEN}Sorting by category$NC"
    for i in `find $1 -mindepth 1 -maxdepth 1 -type d | sort` ; do
	let CAIDX++
	NFOC=`find $i -maxdepth 1 -iname *.nfo | wc -l`
	RLS[$CAIDX]=$i
	if [ $NFOC -gt 0 ] ; then
	    rls $i
	    if echo $RLS | grep -E $RXP_PACK &> /dev/null ; then
		CAT[$CAIDX]=packs
	    elif echo $RLS | grep 'XXX' &> /dev/null ; then
		CAT[$CAIDX]=xxx
	    elif echo $RLS | grep -E $RXP_TV &> /dev/null ; then
		CAT[$CAIDX]=tv
	    elif ls $i/*.zip &> /dev/null ; then
		CAT[$CAIDX]=0day
	    elif ls $i/*.mp3 &> /dev/null ; then
		CAT[$CAIDX]=mp3
	    elif echo $RLS | grep -Ei $RXP_GAME &> /dev/null ; then
		CAT[$CAIDX]=games
	    elif echo $RLS | grep -Ei $RXP_FIX &> /dev/null ; then
		CAT[$CAIDX]=fixes
	    elif echo $RLS | grep -Ei '(subpack)' &> /dev/null ; then
		CAT[$CAIDX]=subpacks
	    elif echo $RLS | grep -Ei $RXP_CODEC &> /dev/null ; then
	    	CAT[$CAIDX]=movies
	    elif echo $RLS | grep -Ei $RXP_CONSOLE &> /dev/null ; then
		CAT[$CAIDX]=`echo $RLS | grep -Eio $RXP_CONSOLE | tr [[:upper:]] [[:lower:]]`
	    fi

	    if [ -z "${CAT[$CAIDX]}" ] ; then
                atype $i
		if [ -n "$TYPE" ] && [ $TYPE != 0 ]; then
		    S=`du -b $i/$TYPE | cut -f1`
		fi

		if [ -n "$S" ] && [ $S -lt 10000000 ] ; then
		    CAT[$CAIDX]=dox
		elif [ -n "$S" ] && unrar lb $i/$TYPE | grep -Ei '[[:punct:]](bin|img|iso)' &> /dev/null; then
		    CAT[$CAIDX]=appz
		else
		    CAT[$CAIDX]=unsortable
		fi
	    fi

	    if [ -n "$TYPE" ] ; then
		unset TYPE S
	    fi
	else
	    CAT[$CAIDX]=unsortable/nfoless
	fi
    done

    for i in `seq 1 ${#CAT[@]}` ; do
    	parse $1 "$CADEST/" "${CAT[$i]}/" ${RLS[$i]}
    done
} # }}}
genresort() { # {{{
    MP3IDX=1
    if [ -n "$2" ] ; then
        MDEST=$2
    else
        MDEST=$1
    fi

    echo -e "   ${BGREEN}Sorting by genre$NC"
    for i in `find $1 -mindepth 1 -maxdepth 1 -type d | sort`; do
	MP3RLS[$MP3IDX]=$i
	if echo $i | grep -Ei '((\(?OST\)?)|soundtrack)(-|_)' &> /dev/null ; then
	    GENRE[$MP3IDX]=ost
	elif echo $i | grep -E 'VA-' &> /dev/null ; then
	    GENRE[$MP3IDX]=va
	fi

	if [ -z "${GENRE[$MP3IDX]}" ] ; then
            for j in `find $i -type f -iname "*.mp3"` ; do
            	filename $j
            	MF=`echo $FILE | grep -Ei '^(.*-)?((0|1){0,3}(a|0)1?)(-|_|\.)'`

            	if [ -n "$MF" ] ; then
    	    	    MI=`mp3info -p "%g" $i/$MF 2> /dev/null | tr [[:upper:]]/\&+\  [[:lower:]].n..`
	    	    if [ -n "$MI" ] ; then
	    	    	GENRE[$MP3IDX]=$MI
	    	    else
	    	    	GENRE[$MP3IDX]=unsortable/tagless
	    	    fi

	    	    unset MF
            	    break
            	fi
            done
	fi

	if [ -z "${GENRE[$MP3IDX]}" ] ; then
	    GENRE[$MP3IDX]=unsortable
	fi

	let MP3IDX++
    done

    for i in `seq 1 ${#MP3RLS[@]}` ; do
	parse $1 "$MDEST/" "${GENRE[$i]}/" ${MP3RLS[$i]}
    done
} # }}}
artistsort() { # {{{
    AIDX=1
    if [ -n "$2" ] ; then
        ADEST=$2
    else
        ADEST=$1
    fi

    echo -e "   ${BGREEN}Sorting by artists$NC"
    for i in `find $1 -mindepth 1 -maxdepth 1 -type d | sort`; do
	rls $i
	ARLS[$AIDX]=$i
	ARTIST[$AIDX]=`echo $RLS | cut -d- -f1`
	let AIDX++
    done

    for i in `seq 1 ${#ARLS[@]}` ; do
	parse $1 "$ADEST/" "${ARTIST[$i]}/" ${ARLS[$i]}
    done
} # }}}
tvsort() { # {{{
    TIDX=1
    if [ -n "$2" ] ; then
        TDEST=$2
    else
        TDEST=$1
    fi

    echo -e "   ${BGREEN}Sorting TV releases$NC"
    for i in `find $1 -mindepth 1 -maxdepth 1 -type d | sort`; do
	rls $i
	TRLS[$TIDX]=$i
	SHOW[$TIDX]=`echo $RLS | sed -r s/.$RXP_TV.*// | tr [[:upper:]]_ [[:lower:]].`
	let TIDX++
    done

    for i in `seq 1 ${#TRLS[@]}` ; do
	parse $1 "$TDEST/" "${SHOW[$i]}/" ${TRLS[$i]}
    done
} # }}}
codecsort() { # {{{
    CIDX=1
    if [ -n "$2" ] ; then
        CDEST=$2
    else
        CDEST=$1
    fi

    echo -e "   ${BGREEN}Sorting by codecs$NC"
    for i in `find $1 -mindepth 1 -maxdepth 1 -type d | sort`; do
	rls $i
	CRLS[$CIDX]=$i
	if echo $RLS | grep -iE '(xvid|divx)' &> /dev/null ; then
	    CODEC[$CIDX]=xvid
	elif echo $RLS | grep -Eio $RXP_CODEC &> /dev/null ; then
	    CODEC[$CIDX]=`echo $RLS | grep -Eio $RXP_CODEC | tr [[:upper:]] [[:lower:]]`
	else
	    CODEC[$CIDX]=null
	fi

    	let CIDX++
    done

    for i in `seq 1 ${#CRLS[@]}` ; do
	if [ ${CODEC[$i]} != "null" ] ; then
    	    parse $1 "$CDEST/" "${CODEC[$i]}/" ${CRLS[$i]}
    	fi
    done
} # }}}
imdbsort() { # {{{
    if [ -n "$2" ] ; then
        IDEST=$2
    else
        IDEST=$1
    fi

    echo -e "   ${BGREEN}Creating IMDb symlink database$NC"
    for i in `find $1 -type d | sort`; do
	NFOC=`find $i -maxdepth 1 -iname *.nfo | wc -l`
	if [ $NFOC -gt 0 ] ; then
	    rls $i
	    if echo $RLS | grep -Ei $RXP_CODEC &> /dev/null; then
		if ! echo $RLS | grep -E $RXP_TV &> /dev/null ; then
		    IURL=`grep -Eio 'http://.*imdb.com/.*\b' $i/*.nfo | head -n 1`
		    if [ -n "$IURL" ] ; then
			if [ ! -f $IMDB/$RLS.imdb ] || [ `wc -l $IMDB/$RLS.imdb | cut -f1 -d\ ` = 0 ] ; then
    		    	    echo -e "   ${YELLOW}Downloading IMDb data: ${BBLUE}$RLS$NC"
    	    	    	    IB=`date +'%s'`
			    wget -o /dev/null -O $IMDB/$RLS.imdb $IURL
    	    	    	    IA=`date +'%s'`; let IMS=IA-IB ; let IMST=IMST+IMS

			    echo score:`grep -E '^<b>[0-9]\.[0-9]/10</b>[[:space:]]$' $IMDB/$RLS.imdb | grep -Eo '[0-9]\.[0-9]'` >> $IMDB/$RLS

			    T250=`grep -E '^<a href="/chart/top.*">Top 250: #[0-9]+</a>$' $IMDB/$RLS.imdb | grep -Eo '#[0-9]+' | cut -b 2-`
			    if [ -n "$T250" ] ; then
			    	echo top:$T250 >> $IMDB/$RLS
			    fi

			    for j in `grep '<title>' $IMDB/$RLS.imdb | grep -Eo '[0-9]{4}'` ; do
			    	echo year:$j >> $IMDB/$RLS
			    done

			    for j in `grep -i genre $IMDB/$RLS.imdb | grep -E /Sections/Genres/[[:upper:]][[:lower:]]*/ | head -n 1 | sed -r 's/<a class.*//'` ; do
				echo $j | grep -Eo '".*"' | cut -d/ -f4 | tr [[:upper:]] [[:lower:]] | tr \  . | tr / . >> $IMDB/$RLS
			    done
			fi
		    else
			filename $i +0
			parse $1 "$IDEST/" "unsorted/" $i symlink
			touch $IMDB/$RLS
		    fi

		    for j in `cat $IMDB/$RLS`; do
			filename $i +0
			if echo $j | grep 'score:' &> /dev/null; then
			    IS=`echo $j | cut -d: -f2`
			    parse $1 "$IDEST/" "score/`echo $IS | cut -d. -f1`/" $i symlink
			    unset IS
			elif echo $j | grep 'top:' &> /dev/null; then
			    TOP=`echo $j | cut -d: -f2`
			    T250=`printf %03i $TOP`
			    parse $1 "$IDEST/" "top250/" $i symlink
			    unset T250 TOP
			elif echo $j | grep 'year:' &> /dev/null; then
			    parse $1 "$IDEST/" "year/`echo $j | cut -d: -f2`/" $i symlink
			else
			    parse $1 "$IDEST/" "genre/$j/" $i symlink
			fi
		    done
		fi
	    fi
	fi
    done
} # }}}
groupsort() { # {{{
    GIDX=1
    if [ -n "$2" ] ; then
        GDEST=$2
    else
        GDEST=$1
    fi

    echo -e "   ${BGREEN}Sorting by groups$NC"
    for i in `find $1 -mindepth 1 -maxdepth 1 -type d | sort`; do
	rls $i
    	SLASH=`echo $i | grep -o \- | wc -l`; let SLASH=SLASH+1

	GRLS[$GIDX]=$i
	GROUP[$GIDX]=`echo $RLS | cut -d- -f$SLASH`
	let GIDX++
    done

    for i in `seq 1 ${#GRLS[@]}` ; do
	parse $1 "$GDEST/" "${GROUP[$i]}/" ${GRLS[$i]}
    done
} # }}}
xxxsort() { # {{{
    XIDX=1
    if [ -n "$2" ] ; then
        XDEST=$2
    else
        XDEST=$1
    fi

    echo -e "   ${BGREEN}Sorting release index$NC: xxx"
    for i in `find $1 -mindepth 1 -maxdepth 1 -type d | sort`; do
    	XRLS[$XIDX]=$i
    	rls $i
	if echo $RLS | grep -Ei $RXP_CODEC &> /dev/null ; then
    	    XCAT[$XIDX]=movies
	elif echo $RLS | grep -Ei 'ima?ge?set' &> /dev/null ; then
    	    XCAT[$XIDX]=imgset
    	else
    	    XCAT[$XIDX]=unsortable
    	fi

	let XIDX++
    done

    echo -e "   ${BGREEN}Parsing release index$NC: xxx"
    for i in `seq 1 ${#GRLS[@]}` ; do
	parse $1 "$XDEST/" "${XCAT[$i]}/" ${XRLS[$i]}
    done
} # }}}
collect() { # {{{
    MODE=COLLECT
    COIDX=1
    if [ -n "$2" ] ; then 
        CODEST=$2
    else
        CODEST=$1
    fi

    echo -e "   ${BGREEN}Collecting releases$NC"
    for i in `find $1 -mindepth 2 -type d | sort` ; do
	NFOC=`find $i -maxdepth 1 -iname *.nfo | wc -l`
	if [ $NFOC -gt 0 ] ; then
	    CORLS[$COIDX]=$i
	    let COIDX++
	fi
    done

    for i in `seq 1 ${#CORLS[@]}` ; do
	parse ${CORLS[$i]} "$CODEST/" " " ${CORLS[$i]}
    done
} # }}}
unpack() { # {{{
    if [ -n "$1" ] ; then
        UP=$1
    else
    	UP=$UP
    fi

    for i in `find $DIR -type d | sort`; do
	NFOC=`find $i -maxdepth 1 -iname *.nfo | wc -l`
	if [ $NFOC -gt 0 ] ; then
	    rls $i
    	    if [ -n "$SPLIT" ] && [ -z "$1" ] ; then
    	    	SUP=$UP/$RLS
    	    fi
	    DISC=`find $i -mindepth 1 -type d | grep -Ei $RXP_CD`
	    if [ -n "$DISC" ] ; then
		for j in $DISC ; do
		    atype $j
		    urar $j
		done
	    else
	    	atype $i
	    	urar $i
	    fi

	    SC=`find $i -mindepth 1 -type d | grep -Ei $RXP_SUBS`
	    if [ -n "$SC" ] ; then
                for j in $SC ; do
                    unrar x -y $j/*.rar $TMP
                    for k in `find $TMP/*.rar` ; do
                        if unrar e -y $k $TMP ; then
                            rm $k
                        fi
                    done
                done
                mv $TMP/* $UP
	    fi
	else
	    echo -e "   ${BRED}Error$NC: No .nfo files found"
	fi
    done
} # }}}
check() { # {{{
    for i in `find $DIR -type d | sort` ; do
	if [ -f $i/*.nfo ] ; then
	    rls $i
	    echo -e "   $BBLUE$RLS$NC"
	fi

	if [ -f $i/*.sfv ] ; then
	    cksfv -qC $i -f $i/*.sfv
	fi
    done
} # }}}
scan() { # {{{
    SCAN=1
    SIDX=1 # Scanner index
    RIDX=1 # Scanner run index
    PIDX=1 # Proper index
    PRPA[1]=null
    for i in `find $1 -type d | sort`; do
	rls $i
	NFOC=`find $i -maxdepth 1 -iname *.nfo | wc -l`
	if [ $NFOC -gt 0 ] ; then
	    ERRB[$RIDX]=$SIDX
	    if [ $NFOC -gt 1 ] ; then
		report "Multiple nfo files" $BLUE
	    fi

	    if echo $i | grep -Ei $RXP_PROPER &> /dev/null; then
	    	PRP=`echo $RLS | grep -Eio .*$RXP_PROPER | sed -r 's/.(PROPER|RE(PACK|RIP))//g ; s/.REAL// ; s/.[0-9][0-9][0-9][0-9]// ; s/.(CE|DC)//'`
	    	for j in `seq 1 ${#PRPA[@]}`; do
	    	    if [ $PRP = ${PRPA[$j]} ] ; then
	    	    	PF=SET # Proper found
	    	    fi
	    	done

	    	if [ -z "$PF" ] ; then
	    	    PRF=`find $DIR -maxdepth 1 -type d | grep -Ei $PRP` # Proper find
	    	    if [ `echo $PRF | wc -l` -gt 0 ] ; then
	    	    	for j in $PRF ; do
		    	    if ! echo $j | grep -Ei $RXP_SUBDIRS &> /dev/null; then
	    	    	    	if echo $j | grep -Ei $RCP_PROPER &> /dev/null ; then
	    	    	    	    if echo $j | grep -Ei '(REAL|FINAL)' &> /dev/null ; then
	    	    	    		HG=$j
	    	    	    	    elif [ -z $HG ] && ! echo $HG | grep -Ei '(REAL|FINAL)' &> /dev/null; then
	    	    	    	    	HG=$j
	    	    	    	    fi
	    	    	    	fi
	    	    	    fi
	    	    	done
	    	    	for j in $PRF ; do
		    	    if ! echo $j | grep -Ei $RXP_SUBDIRS &> /dev/null; then
			    	if [ -n "$HG" ] && [ $j != $HG ] ; then
			    	    rls $HG
			    	    report "Obsoleted" $WHITE ": $BGREEN$RLS$NC"
			    	fi
			    fi
	    	    	done
	    	    fi

	    	    unset HG
	    	    rls $i
	    	    PRPA[$PIDX]=$PRP
	    	    let PIDX++
	    	else
	    	    unset PF
	    	fi
	    fi

	    if echo $RLS | grep -Ei $RXP_CODEC &> /dev/null; then
		if echo $RLS | grep -Ei $RXP_QT &> /dev/null; then
		    report "Inferior" $CYAN
		fi

		for j in `find $i -mindepth 1 -maxdepth 1 -type d` ; do
		    if ! echo $j | grep -Ei $RXP_SUBDIRS &> /dev/null; then
			filename $j
			report "Bad directory" $RED ": $FILE"
			echo "echo rm -r $j" >> $ERASE/$E
		    fi

		    if echo $j | grep -Ei $RXP_SAMPLE &> /dev/null; then
			SAMPLE=THEGAME
		    fi
		done

		if [ -z "$SAMPLE" ] ; then
		    report "Sample missing" $YELLOW
		 else unset SAMPLE
		fi
	    fi

	    for j in `find $i -type d` ; do
		if ! echo $j | grep -Ei $RXP_SAMPLE &> /dev/null; then
		    FILES=`find $j -maxdepth 1 -type f | sed 's/ /:/g'`
		    for k in $FILES ; do
			if ls $j/*.mp3 &> /dev/null; then
			    if ! echo $k | grep -Ei $RXP_MKFT &> /dev/null; then
				if echo $k | grep -Ei $RXP_SFV &> /dev/null; then
				    filename $k
				    report "SFV check" $BRED ": $FILE"
				else
				    filename $k
				    report "Bad file" $BRED ": $FILE"
				    echo "echo rm $k" >> $ERASE/$E
				fi
			    fi
			else
			    if ! echo $k | grep -Ei $RXP_KFT &> /dev/null; then
				if echo $k | grep -Ei $RXP_UP &> /dev/null; then
				    filename $k
				    report "Unpacked file" $BRED ": $FILE"
				    echo "echo rm $k" >> $ERASE/$E
				elif echo $k | grep -Ei $RXP_SFV &> /dev/null; then
				    filename $k
				    report "SFV check" $BRED ": $FILE"
				else
				    filename $k
				    report "Bad file" $BRED ": $FILE"
				    echo "echo rm $k" >> $ERASE/$E
				fi
			    fi
			fi
		    done
		else
		    for k in `find $j -maxdepth 1 -type f` ; do
			if ! echo $k | grep -Ei $RXP_SKFT &> /dev/null; then
			    filename $k
			    report "Bad sample" $YELLOW ": $FILE"
			    echo "echo rm $k" >> $ERASE/$E
			fi
		    done
		fi
	    done

	    ERRA[$RIDX]=$SIDX
	    if [ ${ERRA[$RIDX]} = ${ERRB[$RIDX]} ] ; then
                CSL=`find $SCANNER -name $RLS -type l`
                if [ -n "$CSL" ] ; then
                    for j in $CSL ; do
                        unlink $j
                    done
                fi
	    fi
	    let RIDX++
        fi
    done

    for i in `seq 1 ${#SRLS[@]}` ; do
	parse null "$SCANNER/" "${ERR[$i]}/" ${SRLS[$i]} symlink
    done
} # }}}
genre() { # {{{
    for i in `find $1 -mindepth 1 | sort` ; do
        rls $i
        IR=$RLS
        for j in `find $2 -mindepth 1 | sort` ; do
            rls $j
            JR=$RLS
            if [ $IR = $JR ] ; then
                echo $RLS
            fi
        done
    done
} # }}}
statistics() { # {{{
    rm $TMP/* &> /dev/null
    # math {{{
    SZ=`du -s $1 | cut -f1`; let GSZ=SZ/1024/1024
    FC=`find $1 -type f | wc -l`
    let AV=SZ/FC/1024
    # }}}
    # rlstypes {{{
    for i in `find $1 -type d | sort`; do
	NFOC=`find $i -maxdepth 1 -iname *.nfo | wc -l`
	if [ $NFOC -gt 0 ] ; then
	    rls $i
	    let RLSC++

	    if echo $RLS | grep $RXP_XXX &> /dev/null ; then
		let XXC++
	    elif ls $i/*.zip &> /dev/null ; then
		let DC++
	    elif echo $RLS | grep -E $RXP_TV &> /dev/null ; then
		let TC++
	    elif ls $i/*.mp3 &> /dev/null ; then
		let mC++
	    elif echo $RLS | grep -Ei $RXP_GAME &> /dev/null ; then
		let GC++
	    elif echo $RLS | grep -Ei $RXP_CODEC &> /dev/null ; then
	    	let MC++
	    elif echo $RLS | grep -Ei $RXP_CONSOLE &> /dev/null ; then
		let VGC++
	    fi

    	    SLASH=`echo $RLS | grep -o \- | wc -l`; let SLASH=SLASH+1
    	    echo $RLS | cut -d- -f$SLASH >> $TMP/groups
	fi
    done # }}}
    # groups {{{
    sort $TMP/groups > $TMP/groups.sort
    uniq $TMP/groups.sort > $TMP/groups.uniq

    for i in `cat $TMP/groups.uniq`; do
    	echo `grep -c $i $TMP/groups` $i >> $TMP/groups.count
    done
    sort -nr $TMP/groups.count > $TMP/groups.count.sort

    GRPC=`grep -c . $TMP/groups.uniq`
    let GRPT=GRPC/5
    if [ $GRPT -gt 15 ] ; then
    	GRPT=15
    fi
    TYC=`echo "$XXC $DC $TC $mC $GC $MC $VGC" | wc -w`

    echo "   $RLSC releases by $GRPC groups."
    echo -n "   " # }}}
    # echo {{{
    for i in `seq 1 $TYC`; do
    	if [ -n "$MC" ] ; then
    	    echo -n $MC movies ; unset MC
    	elif [ -n "$mC" ] ; then
    	    echo -n $mC mp3 ; unset mC
    	elif [ -n "$TC" ] ; then
    	    echo -n $TC tv ; unset TC
    	elif [ -n "$GC" ] ; then
    	    echo -n $GC games ; unset GC
    	elif [ -n "$VGC" ] ; then
    	    echo -n $VGC video games ; unset VGC
    	elif [ -n "$DC" ] ; then
    	    echo -n $DC 0day ; unset DC
    	elif [ -n "$XXC" ] ; then
    	    echo -n $XXC xxx ; unset XXC
    	fi

    	if [ $i = $TYC ] ; then
    	    echo .
    	else
    	    echo -n ", "
    	fi
    done

    echo "   $GSZ GB"
    echo "   $FC files"
    echo "   ${AV}kb average"
    echo
    echo "   Top Groups:"

    for i in `seq 1 $GRPT`; do
    	echo "   `head -n $i $TMP/groups.count.sort | tail -n 1 | cut -d\  -f2` (`head -n $i $TMP/groups.count.sort | tail -n 1 | cut -d\  -f1` releases)"
    done # }}}
    # rm $TMP/* &> /dev/null
} # }}}
monitor() { # {{{
    echo
} # }}}
rls() { # {{{
    if ! echo $1 | grep -E /$ &> /dev/null ; then
        RLSPATH="$1/"
    else
        RLSPATH=$1
    fi

    SLASH=`echo $RLSPATH | grep -o \/ | wc -l`
    RLS=`echo $RLSPATH | cut -d/ -f$SLASH`
} # }}}
filename() { # {{{
    SLASH=`echo $1 | grep -o \/ | wc -l`
    if [ -z "$2" ] ; then
        let SLASH++
    else
        let SLASH=SLASH$2
    fi
    FILE=`echo $1 | cut -d/ -f$SLASH | sed 's/:/ /g'`
} # }}}
atype() { # {{{
    if [ -a $1/*.r01 ] || [ -a $1/*.r001 ] ; then
        TYPE=*.rar
    elif [ -a $1/*.part01.rar ] ; then
        TYPE=*.part01.rar
    elif [ -a $1/*.part001.rar ] ; then
        TYPE=*.part001.rar
    elif [ -a $1/*.001 ] ; then
        TYPE=*.001.rar
    elif [ -a $1/*.rar ] ; then
    	TYPE=*.rar
    else
	if [ -n "$V" ] ; then
	    echo
	    echo -e "   ${BRED}Error$NC: $1"
	    echo "          Unknown archive type or no archive found."
        fi

	TYPE=0
    fi
} # }}}
urar() { # {{{
    if [ $TYPE != 0 ] ; then
    	if [ -n "$SUP" ] ; then
    	    if [ ! -d $SUP ] ; then
    	    	mkdir $SUP
    	    fi
    	    unrar x $1/$TYPE $SUP
    	else
    	    unrar x $1/$TYPE $UP
    	fi
    fi
} # }}}
report() { # {{{
    echo -en "   $BBLUE$RLS$NC:$2 $1$NC"
    if [ -n "$3" ] ; then
    	echo -e $3
    else
    	echo
    fi
    SRLS[$SIDX]=$i
    ERR[$SIDX]=`echo $1 | tr [[:upper:]]\  [[:lower:]].`
    let SIDX++
} # }}}
rename() { # {{{
    for i in `find $1 -type d | sort`; do
	NFOC=`find $i -maxdepth 1 -iname *.nfo | wc -l`
	if [ $NFOC -gt 0 ] ; then
	    if echo $i | grep -E '(--|_-_)' &> /dev/null; then
		rls $i
		RN=`echo $i | sed -r 's/(--|_-_)/-/g'`
		mv $i $RN
		echo mv \'$RN\' \'$i\' >> $UNDO/$E
		echo -e "   ${RED}$RLS$NC"
		let RC++
	    fi
	fi
    done

    if [ -z $RLS ] ; then
    	echo -e "   ${GREEN}Nothing to rename.$NC"
    else
    	echo
    	echo -e "   ${GREEN}Renamed $RC releases.$NC"
    fi
} # }}}
deldirs() { # {{{
    for i in `find $1 -type d | sort | tac`; do
    	if rmdir $i &> /dev/null; then
    	    let DD++
    	fi
    done

    if [ -z $DD ] ; then
    	echo -e "   ${GREEN}No empty directories found.$NC"
    else
    	echo -e "   $GREEN$DD directories deleted.$NC"
    fi
} # }}}
dellinks() { # {{{
    for i in `find $1 -mindepth 1 -type l | sort`; do
    	if unlink $i ; then
    	    let DL++
    	fi
    done

    if [ -z $DL ] ; then
    	echo -e "   ${GREEN}No links found.$NC"
    else
    	echo -e "   $GREEN$DL links deleted.$NC"
    fi
} # }}}
delbroken() { # {{{
    for i in `find $1 -mindepth 1 -type l | sort`; do
    	if file $i | grep broken &> /dev/null; then
    	    unlink $i
    	    let DB++
    	fi
    done

    if [ -z $DB ] ; then
    	echo -e "   ${GREEN}No broken links found.$NC"
    else
    	echo -e "   $GREEN$DB broken links deleted.$NC"
    fi
} # }}}
undo() { # {{{
    RFILE=`ls $UNDO -r | head -n 1`
    tac $UNDO/$RFILE > $UNDO/$RFILE.rev
    sh $UNDO/$RFILE.rev
    rm $UNDO/$RFILE* &> /dev/null

    echo -e "   ${GREEN}Revert complete.$NC"
} # }}}
erase() { # {{{
    EFILE=`ls $ERASE -r | head -n 1`
    sh $ERASE/$EFILE
    rm $ERASE/$EFILE

    echo -e "   ${GREEN}Erasing complete.$NC"
} # }}}
parse() { # {{{
    rls $4
    DST=$2/$3
    if ! echo $RLS | grep -E $RXP_SDIRS &> /dev/null; then
    	FSLASH=`echo $DST | grep -o \/ | wc -l` ; let FSLASH++
    	CSLASH=`echo $2 | grep -o \/ | wc -l` ; let CSLASH++
    	PT=$2
    	for j in `seq $CSLASH $FSLASH` ; do
	    PT+=`echo $DST | cut -d/ -f$j`/
	    if [ ! -d $PT ] ; then
	    	mkdir $PT &> /dev/null
	    	echo rmdir \'$PT\' >> $UNDO/$E
	    fi
    	done

    	if [ -z "$5" ] ; then
	    if [ "$MODE" = "COLLECT" ] ; then
	    	mv $4 $2/
	    	echo mv -p \'$2/$RLS\' \'$1\' >> $UNDO/$E
	    else
	    	mv $4 $DST
	    	echo mv \'$2/$3/$RLS\' \'$1\' >> $UNDO/$E
	    fi
    	else
	    if [ ! -L $2/$3/$RLS ] ; then
	    	if [ -n "$IS" ] ; then
                    if [ ! -L $2/$3/$IS.$RLS ] ; then
		    	ln -s $4 $2/$3/$IS.$RLS
		    	echo unlink \'$2/$3/$IS.$RLS\' >> $UNDO/$E
		    fi
	    	elif [ -n "$T250" ] ; then
                    if [ ! -L $2/$3/$T250.$RLS ] ; then
		    	ln -s $4 $2/$3/$T250.$RLS
		    	echo unlink \'$2/$3/$T250.$RLS\' >> $UNDO/$E
		    fi
	    	else
		    ln -s $4 $2/$3/$RLS
		    if [ -z "$SCAN" ] ; then
		    	echo unlink \'$2/$3/$RLS\' >> $UNDO/$E
		    fi
	    	fi
	    fi
    	fi
    fi
} # }}}
# colors {{{
RED="\033[0;31m"
BRED="\033[1;31m"
GREEN="\033[0;32m"
BGREEN="\033[1;32m"
BLUE="\033[0;34m"
BBLUE="\033[1;34m"
CYAN="\033[0;36m"
BCYAN="\033[1;36m"
YELLOW="\033[0;33m"
BYELLOW="\033[1;33m"
WHITE="\033[0;37m"
BWHITE="\033[1;37m"
DARK="\033[0;30m"
BDARK="\033[1;30m"
NC="\033[0m" # }}}
# predefiners {{{
E=`date +'%Y%m%d.%H%M%S'`

if [ -f $HOME/.rls/rls.rc ] ; then
    source $HOME/.rls/rls.rc
else
    setup
fi

if [ -z "$1" ] ; then
    echo
    echo -e "   ${BRED}Error$NC: No arguments specified."
    echo -e "          Run rls --help for usage information."
    echo
    exit 1
fi

if [ -n "$2" ] ; then
    if [ ! -d $2 ] ; then
	echo
	if echo $2 | grep -E '^/' &> /dev/null; then
	    echo -e "   ${BRED}Error$NC: Directory $BBLUE$2$NC does not exist."
	else
	    echo -e "   ${BRED}Error$NC: Directory $BBLUE$PWD/$2$NC does not exist."
	fi
	echo
	exit 127
    fi
fi

if [ -z "$2" ] ; then
    DIR="$PWD/"
elif ! echo $2 | grep -E /$ &> /dev/null ; then
    DIR="$2/"
else
    DIR=$2
fi
# }}}
# case {{{
echo
case "$1" in
    -h | --help)
	help; ;;
    -s | --sort)
	rlssort $DIR $3 ; ;;
    -ca | --category)
	catsort $DIR $3 ; ;;
    -mg | --genre)
	genresort $DIR $3 ; ;;
    -ma | --artist)
	artistsort $DIR $3 ; ;;
    -t | --tv)
	tvsort $DIR $3 ; ;;
    -co | --codec)
        codecsort $DIR $3 ; ;;
    -i | --imdb)
	imdbsort $DIR $3 ; ;;
    -iu | --imdb-update)
	rm $IMDB/* &> /dev/null
	dellinks $DIR
	deldirs $DIR
	echo
	imdbsort $DIR ; ;;
    -gr | --group)
        groupsort $DIR $3 ; ;;
    -x | --xxx)
	xxxsort $DIR $3 ; ;;
    -cl | --collect)
        collect $DIR ; ;;
    -u | --unpack)
	unpack $4 ; ;;
    -c | --sfv)
	check $DIR ; ;;
    -z | --undo)
	undo ; ;;
    -q | --scan)
	scan $DIR ; ;;
    -e | --erase)
	erase ; ;;
    -d | --delete)
	dellinks $DIR
	deldirs $DIR ; ;;
    -dd | --directory)
	deldirs $DIR ; ;;
    -dl | --unlink)
	dellinks $DIR ; ;;
    -db | --broken)
	delbroken $DIR ; ;;
    -st | --statistics)
	statistics $DIR ; ;;
    -r | --rename)
        rename $DIR ; ;;
    -g | --genre)
        genre $2 $3 ; ;;
    --test)
        tester $DIR ; ;;
    *)
	echo -e "   ${BRED}Error$NC: $BWHITE$1$NC: Unknown command"
	echo
        exit 1
	;;
esac
echo # }}}
