use strict;
use warnings;

use Test::More tests => 9;

use String::Dictionary::Util;

is_deeply [ decode_vb( \encode_vb(0) ) ], [0, 1];
is_deeply [ decode_vb( \encode_vb(1) ) ], [1, 1];
is_deeply [ decode_vb( \encode_vb(5) ) ], [5, 1];
is_deeply [ decode_vb( \encode_vb(127) ) ], [127, 1];
is_deeply [ decode_vb( \encode_vb(128) ) ], [128, 2];
is_deeply [ decode_vb( \encode_vb(255) ) ], [255, 2];
is_deeply [ decode_vb( \encode_vb(256) ) ], [256, 2];
is_deeply [ decode_vb( \encode_vb(300) ) ], [300, 2];
is_deeply [ decode_vb( \encode_vb(123456) ) ], [123456, 3];
