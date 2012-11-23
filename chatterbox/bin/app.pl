#!/usr/bin/env perl
use Dancer;
use chatterbox;

use Plack::Builder;
use PocketIO;
use Plack::App::File;

setting apphandler => 'PSGI';

my $root;

BEGIN {
    use File::Basename ();
    use File::Spec     ();

    $root = File::Basename::dirname(__FILE__) . '/..';
    $root = File::Spec->rel2abs($root);



    unshift @INC, "$root/../../lib";
}


my $app = sub {
    my $env     = shift;
    my $request = Dancer::Request->new( env => $env );
    Dancer->dance($request);
};

builder {
    mount '/socket.io/socket.io.js' =>
      Plack::App::File->new(file => "$root/public/javascripts/socket.io.js");

    mount '/socket.io' => PocketIO->new(
        class => 'PocketHandler',
        method => 'run',
    );
    mount "/" => builder {$app};
};

