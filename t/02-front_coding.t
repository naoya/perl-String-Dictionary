use strict;
use warnings;

use Test::More qw/no_plan/;
use String::Dictionary::Util;

my $code = encode_fc('jezebel', '');
is decode_vb(\$code, 0), 0;
is decode_vb(\$code, 1), 7;
is substr($code, 2), 'jezebel';

$code = encode_fc('jezer', 'jezebel');
is decode_vb(\$code, 0), 4;
is decode_vb(\$code, 1), 1;
is substr($code, 2), 'r';

$code = encode_fc('jezerit', 'jezer');
is decode_vb(\$code, 0), 5;
is decode_vb(\$code, 1), 2;
is substr($code, 2), 'it';

is_deeply [ decode_fc(\encode_fc('jezebel', ''), '', 0) ], [ 'jezebel', 9 ];
is_deeply [ decode_fc(\encode_fc('jezer', 'jezebel'), 'jezebel', 0) ], [ 'jezer', 3 ];
is_deeply [ decode_fc(\encode_fc('jezerit', 'jezer'), 'jezer', 0) ], [ 'jezerit', 4 ];
