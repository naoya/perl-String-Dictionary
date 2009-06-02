#!/usr/bin/env perl
use strict;
use warnings;
use FindBin::libs;

use Perl6::Say;
use String::Dictionary;

my $dict = String::Dictionary->new;
my @terms = sort qw/jezebel jezer jezerit jeziah jeziel jezliah jezoar/;

for (@terms) {
    $dict->append($_);
}

say $dict->search_index('jezliah');

