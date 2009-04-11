package WebService::Telnic::Client::Profile;

use strict;
use warnings;

our $VERSION ='0.2';

use Carp;
use WebService::Telnic::Util qw(XMLin);

sub createProfile {
    my $self   = shift;
    my %args   = @_;
    my $domain = $self->{domain};

    croak "No name given for profile" unless defined $args{name};

    my $method = join "#", $self->{namespaces}->{profile}, "createProfileRequest";
    my $body   = qq(<profile:createProfileRequest domainName="$domain"><profile:profile);

    if (defined $args{default}) {
	$body .= $args{default} ? qq( defaule="true") : qq(default="false");
    }
    $body .= qq(>);

    $body .= qq(<profile:name>$args{name}</profile:name>);
    $body .= qq(<profile:records>) . (join " ", @{ $args{records} }) . qq(</profile:records>) if $args{records};

    $body .= qq(</profile:profile></profile:createProfileRequest>);
    
    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml = XMLin( $res->content, RemoveNS => 1, ForceArray => [qw(naptr)] );
    my $id  = $xml->{'Body'}
                  ->{'createProfileResponse'}
                  ->{'id'};

    return $id;
}

sub deleteProfile {
    my $self   = shift;
    my %args   = @_;
    my $domain = $self->{domain};

    croak "No id given for profile" unless defined $args{id};

    my $method = join "#", $self->{namespaces}->{profile}, "deleteProfileRequest";
    my $body   = qq(<profile:deleteProfileRequest domainName="$domain"><profile:profile id="$args{id}" /></profile:deleteProfileRequest>);
    
    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub updateProfile {
    my $self   = shift;
    my %args   = @_;
    my $domain = $self->{domain};

    croak "No id given for profile" unless defined $args{id};

    my $method = join "#", $self->{namespaces}->{profile}, "updateProfileRequest";
    my $body   = qq(<profile:updateProfileRequest domainName="$domain"><profile:profile id="$args{id}");

    if (defined $args{default}) {
	$body .= $args{default} ? qq( defaule="true") : qq(default="false");
    }
    $body .= qq(>);

    $body .= qq(<profile:name>$args{name}</profile:name>) if $args{name};
    $body .= qq(<profile:records>) . (join " ", @{ $args{records} }) . qq(<profile:records>) if $args{records};
    
    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}

sub listProfiles {
    my $self   = shift;
    my $domain = $self->{domain};

    my $method = join "#", $self->{namespaces}->{profile}, "listProfilesRequest";
    my $body   = qq(<profile:listProfilesRequest domainName="$domain" />);
   
    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml = XMLin( $res->content, RemoveNS => 1, ForceArray => [qw(naptr)] );
    my $ids = $xml->{'Body'}
                  ->{'listProfilesResponse'}
                  ->{'profiles'}
                  ->{'ids'};

    return split / /, $ids;
}


sub listProfilesExt {
    my $self   = shift;
    my $domain = $self->{domain};

    my $method = join "#", $self->{namespaces}->{profile}, "listProfilesRequestExt";
    my $body   = qq(<profile:listProfilesExtRequest domainName="$domain" />);
   
    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml      = XMLin( $res->content, RemoveNS => 1, ForceArray => [qw(profile)] );
    my $profiles = $xml->{'Body'}
                       ->{'listProfilesExtResponse'}
                       ->{'profiles'};

    return $profiles;
}


sub getProfile {
    my $self   = shift;
    my %args   = @_;
    my $domain = $self->{domain};

    croak "No id given for profile" unless defined $args{id};

    my $method = join "#", $self->{namespaces}->{profile}, "getProfileRequest";
    my $body   = qq(<profile:getProfileRequest domainName="$domain"><profile:profile id="$args{id}" /></profile:getProfileRequest>);
    
    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml     = XMLin( $res->content, RemoveNS => 1, ForceArray => [qw(profile)] );
    my $profile = $xml->{'Body'}
                      ->{'getProfileResponse'}
                      ->{'profile'};

    return $profile;
}

sub switchToProfile {
    my $self   = shift;
    my %args   = @_;
    my $domain = $self->{domain};

    croak "No id given for profile" unless defined $args{id};

    my $method = join "#", $self->{namespaces}->{profile}, "switchToProfileRequest";
    my $body   = qq(<profile:switchToProfileRequest domainName="$domain"><profile:profile id="$args{id}" /></profile:switchToProfileRequest>);
    
    my $res =  $self->soap($method, $body);
    return unless $res->is_success;
    return 1;
}


sub getActiveProfile {
    my $self   = shift;
    my %args   = @_;
    my $domain = $self->{domain};

    my $method = join "#", $self->{namespaces}->{profile}, "getActiveProfileRequest";
    my $body   = qq(<profile:getActiveProfileRequest domainName="$domain" />);
    
    my $res =  $self->soap($method, $body);
    return unless $res->is_success;

    my $xml     = XMLin( $res->content, RemoveNS => 1, ForceArray => [qw(profile)] );
    my $profile = $xml->{'Body'}
                      ->{'getProfileResponse'}
                      ->{'profile'};

    return $profile;
}

1;
