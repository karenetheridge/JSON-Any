use strict;
use warnings;

use Test::More;
use JSON::Any;

SKIP: {
    eval { require JSON; };
    skip "JSON not installed: $@", 1 if $@;

    $ENV{JSON_ANY_ORDER} = qw(JSON);
    JSON::Any->import();
    skip "JSON not installed: $@", 1 if $@;
    is_deeply( $ENV{JSON_ANY_ORDER}, qw(JSON) );
    is( JSON::Any->handlerType, 'JSON' );
}

SKIP: {
    my $has_cpanel = eval { require Cpanel::JSON::XS; 1 };
    my $has_json_xs; $has_json_xs = eval { require JSON::XS; 1 } if not $has_cpanel;
    skip 'Cpanel::JSON::XS nor JSON::XS are installed', 1 if $@;

    $ENV{JSON_ANY_ORDER} = 'CPANEL XS';

    JSON::Any->import();
    is(
        JSON::Any->handlerType,
        ($has_cpanel ? 'Cpanel::' : '') . 'JSON::XS',
        'got the right handlerType',
    );

    my ($json);
    ok( $json = JSON::Any->new() );
    eval { $json->encode("dahut") };
    ok( $@, 'trapped a failure' );
    undef $@;
    $ENV{JSON_ANY_CONFIG} = 'allow_nonref=1';
    ok( $json = JSON::Any->new() );
    ok( $json->encode("dahut"), qq["dahut"] );
    is( $@, undef, 'no failure' );
}

done_testing;
