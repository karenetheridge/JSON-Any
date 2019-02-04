use strict;
use warnings;

use Test::More;
use Test::Fatal;
use JSON::Any;

my @backends = qw(CPANEL XS PP JSON DWIW);

plan tests => @backends * 2 * 3;

test ($_) for @backends;

sub test {
    my ($backend) = @_;

    SKIP: {
        my $j = eval {
            JSON::Any->import($backend);
            JSON::Any->new;
        };

        note("$backend: " . $@), skip("Backend $backend failed to load", 2 * 3) if $@;

        $j and $j->handler or next;

        note "handler is " . ( ref( $j->handler ) || $j->handlerType );

        for my $json ( 'null', '42', '"hello"' ) {
            my $data;
            isnt(
                exception { $data = $j->jsonToObj($json) },
                undef,
                "decoding '$json' is not supported",
            );
        }

        for my $object ( undef, 42, 'hello' ) {
            my $json;
            my $printable_object = $object // 'undef';
            isnt(
                exception { $json = $j->objToJson($object) },
                undef,
                "encoding '$printable_object' is not supported",
            );
        }
    };
}
