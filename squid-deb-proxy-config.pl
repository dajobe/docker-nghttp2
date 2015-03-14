#!/usr/bin/perl
#
# Configure apt-get for using squid-deb-proxy if is present on the
# default route IP port 8000
#
# USAGE perl squid-deb-proxy-config.pl

use strict;
use warnings;
use IO::Socket::INET qw[SOCK_STREAM];

our $filename = "/etc/apt/apt.conf.d/30proxy";

our $port = 8000;

our $host;
open(ROUTE, "ip route | ");
while(<ROUTE>) {
  $host = $1 if /^default \S+ (\S+)/;
}
close(ROUTE);

my $socket = new IO::Socket::INET (
    PeerHost => $host,
    PeerPort => $port,
    Proto => 'tcp',
    Type => SOCK_STREAM,
    Timeout => 1
);

die "$0: cannot connect to $host:$port $!\n" unless $socket;

#binmode($socket);

my $buf = "GET / HTTP/1.1\r\nHost: $host:$port\r\n\r\n";
my $len = length $buf;
syswrite($socket, $buf, $len, 0);

# receive a response of up to $len from server
$buf='';
$len = 1024;
if(0) {
  sysread($socket, $buf, $len, length $buf);
} else {
  while(1) {
    my $r = sysread($socket, $buf, $len, length $buf);
    if (defined $r) { last unless $r; $len -= $r; }
  }
}
$socket->close();

if($buf =~ /squid-deb-proxy/) {
  my $proxy_url="http://$host:$port";
  print "$0: configuring apt use of squid-deb-proxy at $proxy_url\n";
  open my $out, '>', $filename or die "Cannot create $filename - $!\n";
  print $out qq{Acquire::http::Proxy "$proxy_url";};
  close $out;
}
