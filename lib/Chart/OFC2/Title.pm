package Chart::OFC2::Title;

use Moose;

has 'text'  => (is => 'rw', isa => 'Str', Default => '');
has 'style' => (is => 'rw', isa => 'Str', Default => '{font-size:20px; font-family:Verdana; text-align:center;}');

1;
