package Chart::OFC2::Extremes;

use Moose;
use Carp::Clan 'croak';

has 'x_axis_max' => (is => 'rw', isa => 'Num', );
has 'x_axis_min' => (is => 'rw', isa => 'Num', );
has 'y_axis_max' => (is => 'rw', isa => 'Num', );
has 'y_axis_min' => (is => 'rw', isa => 'Num', );
has 'other'      => (is => 'rw', isa => 'Num', );

sub reset {
    my $self      = shift;
    my $axis_type = shift;
    my $values    = shift;
    
    croak 'pass axis type (x|y) argument'
        if (($axis_type ne 'y') and ($axis_type ne 'x'));
    croak 'pass values argument as array ref'
        if (ref $values ne 'ARRAY');

    my $axis_min = $axis_type.'_axis_min';
    my $axis_max = $axis_type.'_axis_max';
    
    my $max;
    my $min;
    foreach my $value (@{$values}) {
        next if not defined $value;
        
        $max = $value
            if ((not defined $max) or ($value > $max));
        $min = $value
            if ((not defined $min) or ($value < $min));
    }
    
    $self->$axis_min($min);
    $self->$axis_max($max);
}

sub to_hash {
    my $self = shift;
    
    return {
        'x_axis_max' => $self->x_axis_max,
        'x_axis_min' => $self->x_axis_min, 
        'y_axis_max' => $self->y_axis_max,
        'y_axis_min' => $self->y_axis_min,
        'other'      => $self->other,
    };
}

1;
