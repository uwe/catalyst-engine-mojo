package Catalyst::Engine::Mojo;

use strict;
use warnings;

use base 'Catalyst::Engine';

use URI;


__PACKAGE__->mk_accessors('mojo');


sub run {
    my ($self, $c, $tx) = @_;

    $self->mojo($tx);

    $c->handle_request;
}

sub finalize_headers {
    my ($self, $c) = @_;

    my $res = $self->mojo->res;

    # HTTP status
    $res->code($c->res->status);

    # HTTP headers
    my $headers = $c->res->headers;
    foreach my $name ($headers->header_field_names) {
        $res->headers->header($name, $headers->header($name));
    }
}

sub prepare_connection {
    my ($self, $c) = @_;

    my $req = $self->mojo->req;

    my $base = $req->url->base;

    ###TODO### remote_addr
    #$c->req->address(...)

    ###TODO### proxy check?

    $c->req->hostname($base->host);
    $c->req->protocol($base->scheme);
    ###TODO### remote_user
    #$c->req->user(...);
    $c->req->method($req->method);

    ###TODO### HTTPS

    if ($base->port == 443) {
        $c->req->secure(1);
    }
}

sub prepare_headers {
    my ($self, $c) = @_;

    my $headers = $self->mojo->req->headers;
    foreach my $name ($headers->names) {
        $c->req->headers->header($name, [$headers->header($name)]);
    }
}

sub prepare_path {
    my ($self, $c) = @_;

    my $req = $self->mojo->req;

    ###TODO### Catalyst::Engine::CGI says this is too slow

    my $base = $req->url->base->to_string;
    # base must end with slash
    $base .= '/' unless $base =~ /\/$/;
    $c->req->base(URI->new($base));

    my $url = $req->url->to_string;
    # avoid double slashes
    $url =~ s|^/||;
    $c->req->uri(URI->new($base.$url));
}

sub prepare_query_parameters {
    my ($self, $c) = @_;

    ###TODO### ???
}

sub write {
    my ($self, $c, $buffer) = @_;

    my $res = $self->mojo->res;

    ###HACK###
    $res->body($res->body.$buffer);

    return length $buffer;
}


1;

__END__

=pod

=head1 NAME

Catalyst::Engine::Mojo - Mojo for Catalyst (ALPHA!)

=head1 SYNOPSIS

example startup script:

  #!/usr/bin/perl

  use strict;
  use warnings;

  $ENV{MOJO_APP}          = 'MojoX::Catalyst';
  $ENV{MOJO_CATALYST_APP} = 'CatTest';
  $ENV{CATALYST_ENGINE}   = 'Mojo';

  use Mojo::Script::Daemon;

  my $daemon = Mojo::Script::Daemon->new;
  $daemon->run(@ARGV);

=head1 DESCRIPTION

B<Experimental> and B<alpha> Mojo engine for Catalyst.

There are lots of bugs and unimplemented things.

The API and even module names are likely to change.

B<DO NOT USE FOR PRODUCTION.>

=head1 REPOSITORY

    http://github.com/uwe/catalyst-engine-mojo/tree/master

=head1 SEE ALSO

L<Mojo>, L<Catalyst>

=head1 AUTHOR

Uwe Voelker, <uwe.voelker@gmx.de>

=cut
