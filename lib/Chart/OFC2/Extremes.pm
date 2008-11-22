package Chart::OFC2::Extremes;

use Moose;
use Moose::Util::TypeConstraints;
use Carp::Clan 'croak';

subtype 'Chart-OFC2-Extremes'
    => as 'Object'
    => where { $_[0]->isa('Chart::OFC2::Extremes') };

has 'x_axis_max' => (is => 'rw', isa => 'Num|Undef', );
has 'x_axis_min' => (is => 'rw', isa => 'Num|Undef', );
has 'y_axis_max' => (is => 'rw', isa => 'Num|Undef', );
has 'y_axis_min' => (is => 'rw', isa => 'Num|Undef', );
has 'other'      => (is => 'rw', isa => 'Num|Undef', );

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
    my @values_to_check = @{$values};
    while (scalar @values_to_check) {
        my $value = shift @values_to_check;
        
        next if not defined $value;
        push @values_to_check, @{$value}
            if ref $value eq 'ARRAY';
        
        next if ref $value ne '';
        
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
