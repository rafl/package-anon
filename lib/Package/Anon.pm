use strict;
use warnings;

package Package::Anon;

use XSLoader;

XSLoader::load(
    'Package::Anon',
    $Package::Anon::{VERSION} ? ${ $Package::Anon::{VERSION} } : (),
);

use Symbol ();
use Scalar::Util ();

sub new {
    my ($class, $name) = @_;

    my $stash = $class->_new_anon_stash(defined $name ? $name : '__ANON__');

    my $weak_stash = $stash;
    Scalar::Util::weaken($weak_stash);

    $stash->add_method(isa => sub {
        my ($obj, $class) = @_;

        return $class == $weak_stash
            if ref $class;

        return '';
    });

    return $stash;
}

sub add_method {
    my ($self, $name, $code) = @_;

    my $gv = Symbol::gensym;

    *$gv = $code;
    $self->{$name} = *$gv;

    return;
}

1;
