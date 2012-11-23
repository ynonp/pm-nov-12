#!/usr/bin/env perl
use Dancer;
use chatterbox;

use Plack::Builder;

setting apphandler => 'PSGI';

my $app = sub {
    my $env     = shift;
    my $request = Dancer::Request->new( env => $env );
    Dancer->dance($request);
};

builder {
    mount "/" => builder {$app};
};

