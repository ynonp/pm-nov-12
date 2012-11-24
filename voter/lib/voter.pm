package voter;
use Dancer ':syntax';
use Data::Dumper;

our $VERSION = '0.1';

get '/' => sub {
    template 'index', {
        voting_data => to_json(request->{env}->{global_ref}->{voting_data})
    }, { layout => undef };
};


true;
