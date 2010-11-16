use strict;
use warnings;

package Object::Anon;

use Object::Anon::Stash;
use XSLoader;

use Sub::Exporter -setup => {
    exports => ['anon_object'],
    groups  => { default => ['anon_object'] },
};

XSLoader::load(__PACKAGE__);

sub anon_object {
    my ($ref) = @_;
    my $stash = _anon_bless($ref);
    return ($ref, $stash);
}

1;
