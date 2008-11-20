package Chart::OFC2::Axis;

use Moose;
use Moose::Util::TypeConstraints;

has 'name'   => ( is => 'rw', isa => enum(['x_axis', 'y_axis', 'y_axis_right']), required => 1 );
has 'labels' => ( is => 'rw', isa => 'ArrayRef', default => sub{[]}, lazy => 1 );
has 'stroke' => ( is => 'rw', isa => 'Int', );
has 'color' => ( is => 'rw', isa => 'Str', default => '#D7E4A3', );
has 'offset' => ( is => 'rw', isa => 'Bool', );
has 'grid_color' => ( is => 'rw', isa => 'Str', default => '#A2ACBA', );
has '3d' => ( is => 'rw', isa => 'Bool', );
has 'steps' => ( is => 'rw', isa => 'Int', );
has 'visible' => ( is => 'rw', isa => 'Bool',  );
has 'min' => ( is => 'rw', isa => 'Int|Undef', );
has 'max' => ( is => 'rw', isa => 'Int|Undef', );

sub to_key_value {
    my ($self) = @_;
    
    return
        $self->name => {
            map  { my $v = $self->$_; (defined $v ? ($_ => $v) : ()) }
            grep { $_ ne 'name' }
            map  { $_->name } $self->meta->compute_all_applicable_attributes
        }
    ;
}

1;

package Chart::OFC2::XAxis;
use Moose;

extends 'Chart::OFC2::Axis';

has '+name'        => ( default => 'x_axis', );
has 'tick_height' => ( is => 'rw', isa => 'Int', default => 5 );

1;

package Chart::OFC2::YAxis;
use Moose;

extends 'Chart::OFC2::Axis';

has '+name'        => ( default => 'y_axis' );
has 'tick_length' => ( is => 'rw', isa => 'Int', default => 5 );

1;

package Chart::OFC2::YAxisRight;

use Moose;

extends 'Chart::OFC2::YAxis';

has '+name' => ( default => 'y_axis_right' );

1;

