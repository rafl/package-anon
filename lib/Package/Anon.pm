use strict;
use warnings;

package Package::Anon;

use XSLoader;

XSLoader::load(__PACKAGE__);

use Symbol ();
use Scalar::Util ();

sub new {
    my $class = shift;

    my $stash = $class->_new_anon_stash(@_);

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
