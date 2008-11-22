package Chart::OFC2::Axis;

use Moose;
use Moose::Util::TypeConstraints;

use Chart::OFC2::Labels;

subtype 'Chart-OFC2-YAxis'
    => as 'Object'
    => where { $_[0]->isa('Chart::OFC2::YAxis') };
subtype 'Chart-OFC2-XAxis' 
    => as 'Object'
    => where { $_[0]->isa('Chart::OFC2::XAxis') };

has 'name'   => ( is => 'rw', isa => enum(['x_axis', 'y_axis', 'y_axis_right']), required => 1 );
has 'labels' => ( is => 'rw', isa => 'Chart-OFC2-Labels', coerce  => 1);
has 'stroke' => ( is => 'rw', isa => 'Int', );
has 'color' => ( is => 'rw', isa => 'Str',  );
has 'offset' => ( is => 'rw', isa => 'Bool', );
has 'grid_color' => ( is => 'rw', isa => 'Str', );
has '3d' => ( is => 'rw', isa => 'Bool', );
has 'steps' => ( is => 'rw', isa => 'Int', );
has 'visible' => ( is => 'rw', isa => 'Bool',  );
has 'min' => ( is => 'rw', isa => 'Num|Str|Undef', );   # can be 'a' for auto too
has 'max' => ( is => 'rw', isa => 'Num|Str|Undef', );   # can be 'a' for auto too

sub TO_JSON {
    my ($self) = @_;
    
    return {
        map  { my $v = $self->$_; (defined $v ? ($_ => $v) : ()) }
        grep { $_ ne 'name' }
        map  { $_->name } $self->meta->compute_all_applicable_attributes
    };
}

1;

package Chart::OFC2::XAxis;
use Moose;

extends 'Chart::OFC2::Axis';

has '+name'        => ( default => 'x_axis', );
has 'tick_height' => ( is => 'rw', isa => 'Int', );

1;

package Chart::OFC2::YAxis;
use Moose;

extends 'Chart::OFC2::Axis';

has '+name'        => ( default => 'y_axis' );
has 'tick_length' => ( is => 'rw', isa => 'Int', );

1;

package Chart::OFC2::YAxisRight;

use Moose;

extends 'Chart::OFC2::YAxis';

has '+name' => ( default => 'y_axis_right' );

1;

