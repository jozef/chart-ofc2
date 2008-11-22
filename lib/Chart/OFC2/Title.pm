package Chart::OFC2::Title;

use Moose;
use Moose::Util::TypeConstraints;

subtype 'Chart-OFC2-Title'
    => as 'Object'
    => where { $_[0]->isa('Chart::OFC2::Title') };
coerce 'Chart-OFC2-Title'
    => from 'Str'
    => via { Chart::OFC2::Title->new('text' => $_) };

has 'text'  => (is => 'rw', isa => 'Str', );
has 'style' => (is => 'rw', isa => 'Str', );

sub TO_JSON {
    my $self = shift;
    
    return {
        map  { my $v = $self->$_; (defined $v ? ($_ => $v) : ()) }
        map  { $_->name }
        $self->meta->compute_all_applicable_attributes
    };
}

1;
