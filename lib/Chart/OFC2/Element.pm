package Chart::OFC2::Element;

use Moose;
use Moose::Util::TypeConstraints;

use Chart::OFC2::Extremes;

has 'type_name'    => (is => 'rw', isa => enum(['bar', 'bar_filled', 'pie']), required => 1);
has 'values'       => (is => 'rw', isa => 'ArrayRef', trigger => sub { $_[0]->extremes->reset('y' => $_[1]); } );
has 'extremes'     => (is => 'rw', isa => 'Chart-OFC2-Extremes',  default => sub { Chart::OFC2::Extremes->new() }, lazy => 1);
has 'use_extremes' => (is => 'rw', isa => 'Bool',  default => 1 );
has 'on-click'     => (is => 'rw', isa => 'Str', );


sub TO_JSON {
    my $self = shift;
    
    my %hash = (
        map  { my $v = $self->$_; (defined $v ? ($_ => $v) : ()) }
        grep { $_ ne 'extremes' }
        grep { $_ ne 'type_name' }
        grep { $_ ne 'use_extremes' }
        map  { $_->name }
        $self->meta->compute_all_applicable_attributes
    );
    $hash{'type'} = $self->type_name;
    
    return \%hash;
}

1;
