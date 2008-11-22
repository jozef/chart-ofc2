package Chart::OFC2::Labels;

use Moose;
use Moose::Util::TypeConstraints;

subtype 'Chart-OFC2-Labels'
    => as 'Object'
    => where { $_[0]->isa('Chart::OFC2::Labels') };

coerce 'Chart-OFC2-Labels'
    => from 'ArrayRef'
    => via { Chart::OFC2::Labels->new('labels' => $_) };

has 'labels' => ( is => 'rw', isa => 'ArrayRef', );
has 'color'  => ( is => 'rw', isa => 'Str',  );

sub TO_JSON {
    my ($self) = @_;
    
    return {
        map  { my $v = $self->$_; (defined $v ? ($_ => $v) : ()) }
        map  { $_->name } $self->meta->compute_all_applicable_attributes
    };
}

1;
