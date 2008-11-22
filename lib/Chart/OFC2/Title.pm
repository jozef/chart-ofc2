package Chart::OFC2::Title;

use Moose;
use Moose::Util::TypeConstraints;

subtype 'Chart-OFC2-Title'
    => as 'Object'
    => where { $_[0]->isa('Chart::OFC2::Title') };
coerce 'Chart-OFC2-Title'
    => from 'Str'
    => via { Chart::OFC2::Title->new('text' => $_) };

has 'text'  => (is => 'rw', isa => 'Str', Default => '');
has 'style' => (is => 'rw', isa => 'Str', Default => '{font-size:20px; font-family:Verdana; text-align:center;}');

sub to_hash {
    my $self = shift;
    
    return {
        'text'  => $self->text,
        'style' => $self->style,
    };
}

1;
