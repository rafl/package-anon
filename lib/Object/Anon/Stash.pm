use strict;
use warnings;

package Object::Anon::Stash;

use Symbol ();

sub add_method {
    my ($self, $name, $code) = @_;

    my $gv = Symbol::gensym;

    *$gv = $code;
    $self->{$name} = *$gv;

    return;
}

1;
