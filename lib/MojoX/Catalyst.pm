package MojoX::Catalyst;

use strict;
use warnings;

our $AUTOLOAD;

use Data::Dump qw(dump);

use base 'Mojo';


__PACKAGE__->attr('cat_app', chained => 1);


$ENV{CATALYST_ENGINE} = 'Mojo';
eval "require $ENV{MOJO_CATALYST_APP}";


sub AUTOLOAD {
    die dump({args   => \@_,
              caller => [caller],
              method => $AUTOLOAD,
             },
            );
}


sub handler {
    my ($self, $tx) = @_;

    $ENV{MOJO_CATALYST_APP}->run($tx);
}


1;
