package Socialtext::EvHttp;

use 5.008007;
use strict;
use warnings;
use EV;
use Guard;
use Carp;

#require Exporter;
#use AutoLoader;

# our @ISA = qw(Exporter);
# 
# # Items to export into callers namespace by default. Note: do not export
# # names by default without a very good reason. Use EXPORT_OK instead.
# # Do not simply export all your public functions/methods/constants.
# 
# # This allows declaration	use Socialtext::EvHttp ':all';
# # If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# # will save memory.
# our %EXPORT_TAGS = ( 'all' => [ qw(
# 	
# ) ] );
# 
# our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
# 
# our @EXPORT = qw(
# 	
# );

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('Socialtext::EvHttp', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

our $INSTANCE;

sub new {
    unless ($INSTANCE) {
        $INSTANCE = bless {}, __PACKAGE__;
    }
    return $INSTANCE;
}

sub use_socket {
    my ($self, $sock) = @_;
    $self->{socket} = $sock;
    my $fd = fileno($sock);
    $self->accept_on_fd($fd);
}

sub DIED {
    warn "DIED: $@";
}

package Socialtext::EvHttp::Client;

sub send_response {
    # my ($self, $msg, $hdrs, $body) = @_;
    $_[0]->start_response($_[1], $_[2], 0);
    $_[0]->write_whole_body(ref($_[3]) ? $_[3] : \$_[3]);
}

sub initiate_streaming {
    my $self = shift;
    my $streamer = shift;
    Carp::croak "Socialtext::EvHttp: Expected code reference argument to stream_response"
        unless ref($streamer) eq 'CODE';
    my $start_cb = sub {
        $self->start_response($_[0],$_[1],1);
        return $self;
    };
    @_ = ($start_cb);
    goto &$streamer;
}

package Socialtext::EvHttp;

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Socialtext::EvHttp - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Socialtext::EvHttp;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Socialtext::EvHttp, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Jeremy Stashewsky, E<lt>stash@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Jeremy Stashewsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
