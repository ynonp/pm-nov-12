#!/usr/bin/env perl
use Dancer;
use voter;

use Plack::Builder;
use PocketIO;
use Plack::App::File;
use MyHandler;

setting apphandler => 'PSGI';

my $root;

BEGIN {
    use File::Basename ();
    use File::Spec     ();

    $root = File::Basename::dirname(__FILE__) . '/..';
    $root = File::Spec->rel2abs($root);

    unshift @INC, "$root/../../lib";
}

my $global_ref = {};

my $app = sub {
    my $env     = shift;
    $env->{global_ref} = $global_ref;

    my $request = Dancer::Request->new( env => $env );
    Dancer->dance($request);
};

builder {
    mount '/socket.io/socket.io.js' =>
      Plack::App::File->new(file => "$root/public/javascripts/socket.io.js");

    mount '/socket.io' => PocketIO->new(
        instance => MyHandler->new( global_ref => $global_ref ),
        method => 'run',
    );

    mount "/" => builder {$app};
};


