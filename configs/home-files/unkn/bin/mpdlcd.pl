#!/usr/bin/perl
use strict;
use IO::Socket;
use Fcntl;


my $host = "localhost";
my $port = "13666";
my $verbose = 6;

print "Connecting to LCDproc at $host\n";
my $remote = IO::Socket::INET->new(
                Proto     => "tcp",
                PeerAddr  => $host,
                PeerPort  => $port,
        ) or die "Cannot connect to LCDproc port\n";
	# Make sure our messages get there right away
$remote->autoflush(1);

sleep 1;        # Give server plenty of time to notice us...
print $remote "hello\n";
my $lcdconnect = <$remote>;
print $lcdconnect if ($verbose >= 5);

# connect LCDproc 0.4.2 protocol 0.3 lcd wid 20 hgt 4 cellwid 5 cellhgt 8
($lcdconnect =~ /lcd.+wid\s+(\d+)\s+hgt\s+(\d+)/);
my $lcdwidth = $1; my $lcdheight= $2;
print "Detected LCD size of $lcdwidth x $lcdheight\n";

# Turn off blocking mode...
fcntl($remote, F_SETFL, O_NONBLOCK);

# Set up some screen widgets...
print $remote "client_set name {MPD}\n";
print $remote "screen_add mpd\n";
print $remote "screen_set mpd name {MPD}\n";
#print $remote "widget_add mpd title title\n";
#print $remote "widget_set mpd title {MPD}\n";
print $remote "widget_add mpd album scroller\n";
print $remote "widget_add mpd time string\n";
print $remote "widget_add mpd song scroller\n";

if `mpc | grep '\[playing\]'`
while (1) {
        # fetch mpd info
	my $album = `mpc --format ':{%album%}|{NA:}'|head -1`;
	my $time = `mpc --format '{%time%}'|head -1`;
	my $song = `mpc --format '{.:.[[%artist% - ]%title%]}|{[%file%]}'|head -1`;
	    print $remote sprintf("widget_set mpd album 1 2 11 2 m 2 $album\n");
            print $remote sprintf("widget_set mpd time 12 2 $time\n");
            print $remote sprintf("widget_set mpd song 1 1 16 1 m 2 $song\n");
	    sleep 5

    }	    

