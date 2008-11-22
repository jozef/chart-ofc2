package Chart::OFC2::Bar;

use Moose;
extends 'Chart::OFC2::BarLineBase';

has '+type_name' => (default => 'bar');
has 'alpha'      => (is => 'rw', isa => 'Num',);

1;


package Chart::OFC2::Bar::3D;
use Moose;
extends 'Chart::OFC2::Bar';

has '+type_name' => (default => 'bar_3d');

1;


package Chart::OFC2::Bar::Fade;
use Moose;
extends 'Chart::OFC2::Bar';

has '+type_name' => (default => 'bar_fade');

1;


package Chart::OFC2::Bar::Glass;
use Moose;
extends 'Chart::OFC2::Bar';

has '+type_name' => (default => 'bar_glass');

1;


package Chart::OFC2::Bar::Sketch;
use Moose;
extends 'Chart::OFC2::Bar';

has '+type_name' => (default => 'bar_sketch');

1;


package Chart::OFC2::Bar::Filled;
use Moose;
extends 'Chart::OFC2::Bar';

has '+type_name'     => (default => 'bar_filled');
has 'outline_collor' => (is => 'rw', isa => 'Str',);


1;


package Chart::OFC2::Bar::Stack;
use Moose;
extends 'Chart::OFC2::Bar';

has '+type_name' => (default => 'bar_stack');
has 'text'       => (is => 'rw', isa => 'Str',);

1;
