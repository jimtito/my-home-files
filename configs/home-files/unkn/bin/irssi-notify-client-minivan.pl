#!/usr/bin/perl

use strict;
use warnings;
use Desktop::Notify;
use IPC::Message::Minivan;
use Encode;

my $notify_timeout = 5000;
my $icon = "/usr/share/pixmaps/pidgin/protocols/scalable/irc.svg";
#my $icon = "gnome-irc.png";

my $van = IPC::Message::Minivan->new(host => 'localhost');
$van->subscribe("#irssi");
our $notify = Desktop::Notify->new();
my $notification = $notify->create(summary => 'Minivan', body => 'Connection established', timeout => $notify_timeout, app_icon => $icon);
$notification->show();

while (1) {
	if (my $cmd = $van->get(5,[])) {
		if ($cmd->[0] eq '#irssi') {
			my $c=$cmd->[1];
			
			my $message = Encode::encode("utf-8",$c->{msg});
			my $summary = $c->{summary};
			
			$notification->summary($summary);
			$notification->body($message);
			$notification->show();
		}
	}
}

$notification->close();
