use strict;
use warnings;

package Package::Anon;
# ABSTRACT: Anonymous packages

use XSLoader;

XSLoader::load(
    'Package::Anon',
    $Package::Anon::{VERSION} ? ${ $Package::Anon::{VERSION} } : (),
);

use Symbol ();
use Scalar::Util ();

=head1 SYNOPSIS

  my $stash = Package::Anon->new;
  $stash->add_method(bar => sub { 42 });

  my $obj = $stash->bless({});

  $obj->foo; # 42

=method new ($name?)

  my $stash = Package::Anon->new;

  my $stash = Package::Anon->new('Foo');

Create a new anonymous package. If the optional C<$name> argument is provided,
it will be used to set the stash's name. Note that the name is there merely as
an aid for debugging - the stash won't be reachable from the global symbol table
by the given name.

With no C<$name> given, C<__ANON__> will be used.

=cut

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

=method bless ($reference)

  my $instance = $stash->bless({});

Bless a C<$reference> into the anonymous package.

=method add_method ($name, $code)

  $stash->add_method(foo => sub { 42 });

Register a new method in the anonymous package.

=cut

sub add_method {
    my ($self, $name, $code) = @_;

    my $gv = Symbol::gensym;

    *$gv = $code;
    $self->{$name} = *$gv;

    return;
}

=head1 SYMBOL TABLE MANIPULATION

C<add_method> is provided as a convenience method to add code symbols to slots
in the anonymous stash. Other kinds of symbol table manipulations can be
performed as well, but have to be done by hand.

Currently, C<Package::Anon> instances are blessed stash references, so the
following is possible:

  $stash->{$symbol} = *$gv;

However, the exact details of how to get a hold of the actual stash reference
might change in the future.

=cut

1;
