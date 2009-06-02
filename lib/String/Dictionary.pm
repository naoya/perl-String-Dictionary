package String::Dictionary;
use strict;
use warnings;
use integer;

use String::Dictionary::Util;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $self = bless {}, $class;

    $self->{dict}     = '';
    $self->{term_ptr} = [];
    $self->{cur_ptr}  = 0;
    $self->{prev}     = '';
    $self->{count}    = 0;

    return $self;
}

sub append {
    my ($self, $term) = @_;

    if ($self->{count} % 4 == 0) {
        push @{$self->{term_ptr}}, $self->{cur_ptr};
        $self->{prev} = '';
    }

    my $code = encode_fc($term, $self->{prev});

    $self->{dict}    .= $code;
    $self->{cur_ptr} += length $code;
    $self->{prev}     = $term;
    $self->{count}++;

    return $self->{cur_ptr};
}

sub search_block {
    my ($self, $k, $q, $cmp_ref) = @_;
    my $cur  = $self->{term_ptr}->[$k];
    my $prev = '';
    for (my $i = 0; $i < 4; $i++) {
        my ($term, $fc_len) = decode_fc(\$self->{dict}, $prev, $cur);
        $$cmp_ref = $q cmp $term;
        if ($$cmp_ref == 0) {
            return 4 * $k + $i;
        }
        $cur += $fc_len;
        if ($cur == $self->{cur_ptr}) {
            last;
        }
        $prev = $term;
    }
    return;
}

sub search_index {
    my ($self, $q) = @_;

    my $i = 0;
    my $j = @{$self->{term_ptr}} - 1;

    while ($i <= $j) {
        my $cmp;
        my $k = ($i + $j) / 2;
        my $x = $self->search_block($k, $q, \$cmp);
        if (defined $x) {
            return $x;
        }
        if ($cmp == 1) {
            $i = $k + 1;
        } else {
            $j = $k - 1;
        }
    }
    return;
}

1;

__END__
=head1 NAME

String::Dictionary - Perl extension for blah blah blah

=head1 SYNOPSIS

  use String::Dictionary;

  ## Terms must be sorted by lexical order
  my @terms = sort qw/jezebel jezer jezerit jezeiah jeziel/;

  my $dict = String::Dictionary->new;

  for (@terms) {
      $dict->append($_);
  }

  my $i = $dict->search_index('jezerit'); # 2
  say $term_frequency[$i]; # tf for 'jezerit'
  say $postings_list[$i];  # postings_list for 'jezerit'
  ...

=head1 DESCRIPTION

Dictionary as a string with front conding compression

=head1 AUTHOR

Naoyat Ito E<lt>naoya at bloghackers.net<gt>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
