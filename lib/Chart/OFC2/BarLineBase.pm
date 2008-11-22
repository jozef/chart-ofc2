package Chart::OFC2::BarLineBase;

use Moose;

extends 'Chart::OFC2::Element';

has 'color'     => (is => 'rw', isa => 'Str', );
has 'text'      => (is => 'rw', isa => 'Str', );
has 'font_size' => (is => 'rw', isa => 'Int', );

1;
