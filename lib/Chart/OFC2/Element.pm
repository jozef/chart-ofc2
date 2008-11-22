package Chart::OFC2::Element;

use Moose;
use Moose::Util::TypeConstraints;

use Chart::OFC2::Extremes;

subtype 'Chart-OFC2-Extremes'
    => as 'Object'
    => where { $_[0]->isa('Chart::OFC2::Extremes') };

has 'type_name' => (is => 'rw', isa => enum(['bar', 'pie']), required => 1);
has 'values'    => (is => 'rw', isa => 'ArrayRef', trigger => sub { $_[0]->extremes->reset('y' => $_[1]); } );
has 'extremes'  => (is => 'rw', isa => 'Chart-OFC2-Extremes',  default => sub { Chart::OFC2::Extremes->new() }, lazy => 1);


sub to_hash {
    my $self = shift;
    
    return {
        'type_name' => $self->type_name,
        'values'    => $self->values,
    };
}

1;
