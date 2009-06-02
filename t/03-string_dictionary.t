use strict;
use warnings;

use Test::More qw/no_plan/;
use String::Dictionary;

my @terms = sort qw/jezebel jezer jezerit jeziah jeziel jezliah jezoar jezrahiah jezreel jezreelites jibsam jidlaph/;

my $dict = String::Dictionary->new;
for (@terms) {
    $dict->append($_);
}

is $dict->search_index('jezebel'),   0;
is $dict->search_index('jezer'),     1;
is $dict->search_index('jezerit'),   2;
is $dict->search_index('jeziah'),    3;

is $dict->search_index('jeziel'),    4;
is $dict->search_index('jezliah'),   5;
is $dict->search_index('jezoar'),    6;
is $dict->search_index('jezrahiah'), 7;

is $dict->search_index('jezreel'),      8;
is $dict->search_index('jezreelites'),  9;
is $dict->search_index('jibsam'),      10;
is $dict->search_index('jidlaph'),     11;

is $dict->search_index('hoge'), undef;
