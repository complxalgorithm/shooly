#!/usr/bin/perl -w

# run this command to connect to server:
# $ perl client.pl
# this will (for now) output the following message:
# "You're on the server"

use strict;
use Socket;

# initialize host and port
my $host = shift || 'localhost';
my $port = shift || 7890;
my $server = "localhost";  # Host IP running the server

# create the socket, connect to the port
socket(SOCKET,PF_INET,SOCK_STREAM,(getprotobyname('tcp'))[2])
   or die "can't create a socket $!\n";
connect( SOCKET, pack_sockaddr_in($port, inet_aton($server)))
   or die "can't connect to port $port \n";

my $line;
while ($line = <SOCKET>) {
        print "$line\n";
}
close SOCKET or die "close: $!";
