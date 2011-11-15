use strict;
use warnings;
use Test::More;

use Package::Anon;
use Symbol;
use overload ();

my $stash = Package::Anon->new('Foo');

{
    my $gv = Symbol::gensym;
    *$gv = {};
    $stash->{OVERLOAD} = $gv;
}

{
    my $gv = Symbol::gensym;
    *$gv = \&overload::nil;
    *$gv = \undef;
    $stash->{'()'} = $gv;
}

*{ $stash->{OVERLOAD} }{HASH}->{dummy}++;

$stash->add_method('(""' => sub { "overloaded!" });

my $foo = $stash->bless({});
is "$foo", "overloaded!";

done_testing;
