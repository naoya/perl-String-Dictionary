package String::Dictionary::Util;
use strict;
use warnings;
use integer;
use Carp qw/croak/;
use Exporter::Lite;

our @EXPORT_OK = qw/encode_vb decode_vb encode_fc decode_fc/;
our @EXPORT = @EXPORT_OK;

sub encode_vb {
    my $n = shift;
    my @bytes;
    while (1) {
        unshift @bytes, $n % 128;
        if ($n < 128) {
            last;
        }
        $n = $n / 128;
    }
    $bytes[-1] += 128;
    return pack('C*', @bytes);
}

sub decode_vb {
    my ($seq, $offset) = @_;
    $offset ||= 0;

    my $n   = 0;
    my $len = length $seq;

    for (my $i = 0; $i < $len; $i++) {
        my $c = unpack('C', substr($$seq, $offset + $i, 1));
        if ($c < 128) {
            $n = 128 * $n + $c;
        } else {
            $n = 128 * $n + ($c - 128);
            return wantarray ? ($n, $i + 1) : $n;
        }
    }
    croak 'assert';
}

sub encode_fc {
    my ($cur, $prev) = @_;
    my @prev = unpack 'C*', $prev;
    my @cur  = unpack 'C*', $cur;
    my $nmatch = 0;
    while ( $nmatch < @prev and
            $nmatch < @cur  and
            $prev[ $nmatch ] == $cur[ $nmatch ] ) {
        $nmatch++;
    }
    substr($cur, 0, $nmatch) = '';
    return join '',encode_vb($nmatch), encode_vb(length $cur), $cur;
}

sub decode_fc {
    my ($seq, $prev, $offset) = @_;
    my ($nmatch, $nmatch_len) = decode_vb($seq, $offset);
    my ($nrest, $nrest_len)   = decode_vb($seq, $offset + $nmatch_len);
    my $term = join '',
        substr($prev, 0, $nmatch),
        substr($$seq, $offset + $nmatch_len + $nrest_len, $nrest);
    return wantarray ? ($term, $nmatch_len + $nrest_len + $nrest) : $term;
}

1;
