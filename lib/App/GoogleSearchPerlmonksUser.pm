package App::GoogleSearchPerlmonksUser;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

our %SPEC;

$SPEC{google_search_perlmonks_user} = {
    v => 1.1,
    summary => 'Search Google for user mentions in perlmonks.org',
    description => <<'_',

Basically a shortcut for launching Google search for a user (specifically, user
mentions in discussion threads) in `perlmonks.org` site, with some unwanted
pages excluded.

_
    args => {
        user => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
    },
};
sub google_search_perlmonks_user {
    require Browser::Open;
    require URI::Escape;

    my %args = @_;
    # XXX schema
    my $user = $args{user} or return [400, "Please specify user"];

    my $query = join(
        " ",
        "site:perlmonks.org",
        $user,
        qq(-inurl:/bare), # skip bare pages
        qq(-intitle:"$user\'s scratchpad"), # skip scratchpad

        # skip some versions of pages
        qq(-inurl:"displaytype=print"),
        qq(-inurl:"displaytype=xml"),
        qq(-inurl:"displaytype=edithistory"),

        qq(-intitle:"Perl Monks User Search"), # skip search result page

        # TODO: how to exclude "Other Users" box? it would be nice if
        # perlmonks.org marks some sections to be excluded by google, ref:
        # http://www.perlmonks.org/?node_id=1136864
    );

    my $url = "https://www.google.com/search?num=100&q=".
        URI::Escape::uri_escape($query);

    my $res = Browser::Open::open_browser($url);

    $res ? [500, "Failed"] : [200, "OK"];
}

1;
#ABSTRACT:

=head1 SYNOPSIS

Use the included script L<google-search-perlmonks-user>.
