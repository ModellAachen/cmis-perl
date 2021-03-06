package WebService::Cmis;

use warnings;
use strict;

=head1 NAME

WebService::Cmis 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

CMIS bindings for perl

    use WebService::Cmis;

    my $client = WebService::Cmis::getClient(...);
    ...

=head1 DESCRIPTION

Provides a CMIS client library for Perl that can be used to work with
CMIS-compliant repositories such as Alfresco, IBM FileNet, Nuxeo and others.
CMIS is a proposed specification with backing by major ECM players including
those mentioned as well as Microsoft, Oracle, and SAP. 

CMIS providers must expose both Web Services and Restful AtomPub bindings.
WebService::Cmis uses the Restful AtomPub binding to communicate with the CMIS
repository. All you have to tell WebService::Cmis is the repository's service
URL and your credentials. There is nothing to install on the server side. 

Note: this implementation is inspired by the Pyhton implementation
L<http://code.google.com/p/cmislib> written by Jeff Potts.

See the L<http://docs.oasis-open.org/cmis/CMIS/v1.0/cs01/cmis-spec-v1.0.html>
for a full understanding of what CMIS is.

=head1 METHODS

=over 4

=cut

use Error qw(:try);
use Exporter qw(import);

use Carp;
$Carp::Verbose = 1;

our @ISA = qw(Exporter);

our @_namespaces = qw(ATOM_NS APP_NS CMISRA_NS CMIS_NS OPENSEARCH_NS);

our @_contenttypes = qw(ATOM_XML_TYPE ATOM_XML_ENTRY_TYPE ATOM_XML_ENTRY_TYPE_P
   ATOM_XML_FEED_TYPE ATOM_XML_FEED_TYPE_P CMIS_TREE_TYPE CMIS_TREE_TYPE_P
   CMIS_QUERY_TYPE CMIS_ACL_TYPE);

our @_relations = qw(DOWN_REL FIRST_REL LAST_REL NEXT_REL PREV_REL SELF_REL UP_REL
   TYPE_DESCENDANTS_REL VERSION_HISTORY_REL FOLDER_TREE_REL RELATIONSHIPS_REL
   ROOT_DESCENDANTS_REL ACL_REL CHANGE_LOG_REL POLICIES_REL);

our @_collections = qw(QUERY_COLL TYPES_COLL CHECKED_OUT_COLL UNFILED_COLL
   ROOT_COLL);

our @_utils = qw(writeCmisDebug);

our @EXPORT_OK = (@_namespaces, @_contenttypes, @_relations, @_collections, @_utils);
our %EXPORT_TAGS = (
 namespaces => \@_namespaces,
 contenttypes => \@_contenttypes,
 relations => \@_relations,
 collections => \@_collections,
 utils => \@_utils,
);

# Namespaces
use constant ATOM_NS => 'http://www.w3.org/2005/Atom';
use constant APP_NS => 'http://www.w3.org/2007/app';
use constant CMISRA_NS => 'http://docs.oasis-open.org/ns/cmis/restatom/200908/';
use constant CMIS_NS => 'http://docs.oasis-open.org/ns/cmis/core/200908/';
use constant OPENSEARCH_NS => 'http://a9.com/-/spec/opensearch/1.1/';

# Content types
# Not all of these patterns have variability, but some do. It seemed cleaner
# just to treat them all like patterns to simplify the matching logic
use constant ATOM_XML_TYPE => 'application/atom+xml';
use constant ATOM_XML_ENTRY_TYPE => 'application/atom+xml;type=entry';
use constant ATOM_XML_ENTRY_TYPE_P => qr/^application\/atom\+xml.*type.*entry/;
use constant ATOM_XML_FEED_TYPE => 'application/atom+xml;type=feed';
use constant ATOM_XML_FEED_TYPE_P => qr/^application\/atom\+xml.*type.*feed/;
use constant CMIS_TREE_TYPE => 'application/cmistree+xml';
use constant CMIS_TREE_TYPE_P => qr/^application\/cmistree\+xml/;
use constant CMIS_QUERY_TYPE => 'application/cmisquery+xml';
use constant CMIS_ACL_TYPE => 'application/cmisacl+xml';

# Standard rels
use constant DOWN_REL => 'down';
use constant FIRST_REL => 'first';
use constant LAST_REL => 'last';
use constant NEXT_REL => 'next';
use constant PREV_REL => 'prev';
use constant SELF_REL => 'self';
use constant UP_REL => 'up';
use constant VERSION_HISTORY_REL => 'version-history';

use constant ACL_REL => 'http://docs.oasis-open.org/ns/cmis/link/200908/acl';
use constant CHANGE_LOG_REL => 'http://docs.oasis-open.org/ns/cmis/link/200908/changes';
use constant FOLDER_TREE_REL => 'http://docs.oasis-open.org/ns/cmis/link/200908/foldertree';
use constant POLICIES_REL => 'http://docs.oasis-open.org/ns/cmis/link/200908/policies';
use constant RELATIONSHIPS_REL => 'http://docs.oasis-open.org/ns/cmis/link/200908/relationships';
use constant ROOT_DESCENDANTS_REL => 'http://docs.oasis-open.org/ns/cmis/link/200908/rootdescendants';
use constant TYPE_DESCENDANTS_REL => 'http://docs.oasis-open.org/ns/cmis/link/200908/typedescendants';

# Collection types
use constant QUERY_COLL => 'query';
use constant TYPES_COLL => 'types';
use constant CHECKED_OUT_COLL => 'checkedout';
use constant UNFILED_COLL => 'unfiled';
use constant ROOT_COLL => 'root';

=item writeCmisDebug($msg)

static utility to write debug output to STDERR. Set the CMIS_DEBUG
environment variable to switch on these messages.

=cut

sub writeCmisDebug {
  print STDERR "WebService::Cmis - $_[0]\n" if $ENV{CMIS_DEBUG};
}

=item getClient(%args) -> $cmisClient

static method to create a cmis client.

=cut

sub getClient {
  require WebService::Cmis::Client;
  return new WebService::Cmis::Client(@_);
}

=back

=head1 AUTHOR

Michael Daum C<< <daum at michaeldaumconsulting.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-cmis at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-Cmis>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::Cmis


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-Cmis>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-Cmis>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-Cmis>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-Cmis/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Michael Daum.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;
