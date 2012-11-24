package MyHandler;

use strict;
use warnings;
use v5.14;
use Moose;

has 'global_ref', is => 'ro', 'isa' => 'HashRef', required => 1;
has 'voting_data', is => 'ro', isa => 'HashRef', builder => '_build_voting_data';

sub _build_voting_data {
    my $self = shift;

    $self->global_ref->{voting_data} = {
        perl   => 60,
        python => 60,
        ruby   => 60,
    }
}

sub vote_for {
    my ( $self, $lang ) = @_;

    $self->voting_data->{$lang} += 20;
}

sub run {
    my $self = shift;

    return sub {
        my $socket = shift;

        $socket->on('message' => sub {
                my $sender = shift;
                my ( $message ) = @_;

                my $last = $self->global_ref->{last_message};
                $self->global_ref->{last_message} = $message;

                # $sender->broadcast->emit( 'message', $message );
                $sender->sockets->emit( 'message', { text => $message, prev => $last } );
            });

        $socket->on('vote' => sub {
                my ($sender, $vote) = @_;
                $self->vote_for( $vote );

                $sender->sockets->emit( 'votes', $self->voting_data );
            });
    }
}

1;

