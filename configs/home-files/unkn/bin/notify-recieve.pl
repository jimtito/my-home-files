#!/usr/bin/perl
# r20091107
use strict;
#use brain;
use IO::Socket;

my $ListenPort = $ARGV[0] or 22754;

my $socket = IO::Socket::INET->new(
	Proto => 'udp',
	LocalPort => $ListenPort,
	Reuse => 1,
) or die "socket error: $!";

my ($message, $title, $text);

print "Waiting for notifications on :$ListenPort\n";

while ($socket->recv($message, 1024)) {
	my ($port, $host) = sockaddr_in($socket->peername);
	$host = join '.', unpack "C*", $host;

	my @message = split "\n", $message;
	my ($source, $icon, $title, $text) = @message;
	
	print "(from $host:$port by $source)\n";
	
	if ($title eq "") { next; }
	if ($source eq "") { $source = "unknown"; }
	
	print "[$title]\n";
	print "$text\n\n";

	my @args = ("notify-send");
	push @args, "--icon=$icon" unless $icon eq "";
	push @args, "--category=$source" unless $source eq "";
	push @args, $title;
	push @args, $text unless $text eq "";
	system @args;

}
die "recv error: $!";

