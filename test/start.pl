#!/opt/bin/perl

use strict;
use warnings;

$ENV{MOJO_APP}          = 'MojoX::Catalyst';
$ENV{MOJO_CATALYST_APP} = 'CatTest';
$ENV{CATALYST_ENGINE}   = 'Mojo';

use lib '/home/uwe/ext/mojo/lib';
use Mojo::Script::Daemon;

use lib '/home/uwe/proj/cpan/Catalyst-Engine-Mojo/lib';
use lib '/home/uwe/proj/cpan/Catalyst-Engine-Mojo/test/CatTest/lib';

my $daemon = Mojo::Script::Daemon->new;
$daemon->run(@ARGV);
