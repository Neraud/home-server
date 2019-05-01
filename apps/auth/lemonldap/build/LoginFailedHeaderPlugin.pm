package Lemonldap::NG::Portal::LoginFailedHeaderPlugin;

use strict;
use Mouse;
use Lemonldap::NG::Portal::Main::Constants qw(PE_OK);

extends 'Lemonldap::NG::Portal::Main::Plugin';

use constant aroundSub => {
    getUser => 'aroundGetUser',
    authenticate => 'aroundAuthenticate'
};

sub init { 1 }

sub aroundGetUser {
    my ( $self, $sub, $req ) = @_;
    my $ret = $sub->($req);

    if($ret != PE_OK) {
        $self->logger->debug("Adding header Lm-Auth-Failed : User failed for $req->{user} ($ret)");
        push @{ $req->{respHeaders} }, 'Lm-Auth-Failed' => "User failed for $req->{user} ($ret)";
    }

    return $ret;
}


sub aroundAuthenticate {
    my ( $self, $sub, $req ) = @_;
    my $ret = $sub->($req);

    if($ret != PE_OK) {
        $self->logger->debug("Adding header Lm-Auth-Failed : Password failed for $req->{user} ($ret)");
        push @{ $req->{respHeaders} }, 'Lm-Auth-Failed' => "Password failed for $req->{user} ($ret)";
    }

    return $ret;
}

1;
