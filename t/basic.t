use strict;
use warnings;
use Test::More;

use Object::Anon;

sub __ANON__::foo { die 23 }

my ($obj, $stash) = anon_object {};
isa_ok($obj, '__ANON__');

ok(!$obj->can('foo'));

$stash->add_method(foo => sub { 42 });
can_ok($obj, 'foo');
is($obj->foo, 42);

can_ok($obj, 'VERSION');
$stash->add_method(VERSION => sub { 13 });
can_ok($obj, 'VERSION');
is($obj->VERSION, 13);

$stash->add_method(AUTOLOAD => sub { our $AUTOLOAD });
is($obj->moo, '__ANON__::moo');

done_testing;
