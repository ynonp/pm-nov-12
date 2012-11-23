package PocketHandler;

use strict;
use warnings;
use v5.14;
use Moose;

sub run {
    return sub {
        my $socket = shift;

        $socket->on('message' => sub {
                my $sender = shift;
                my ( $message ) = @_;

                $sender->send( $message );
            });
    }
}

1;
