package WebService::Cmis::AtomFeed::ChangeEntries;

=head1 NAME

WebService::Cmis::AtomFeed::ChangeEntries

=head1 SYNOPSIS

This is a Result sets representing an atom feed of CMIS ChangeEntry objects.

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use WebService::Cmis::AtomFeed ();
use WebService::Cmis::ChangeEntry ();

our @ISA = qw(WebService::Cmis::AtomFeed);

=head1 METHODS

=over 4

=item newEntry(xmlDoc) -> $object

returns a ChangeEntry objct created by parsing the given XML fragment

=cut

sub newEntry {
  my ($this, $xmlDoc) = @_;

  return unless defined $xmlDoc;
  return new WebService::Cmis::ChangeEntry(repository=>$this->{repository}, xmlDoc=>$xmlDoc);
}

=back

=head1 AUTHOR

Michael Daum C<< <daum@michaeldaumconsulting.com> >>

=head1 COPYRIGHT AND LICENSE

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  See L<perlartistic>.

=cut

1;
