package Chart::OFC2::Legend;

=head1 NAME

Chart::OFC2::Legend - OFC2 legend object

=head1 SYNOPSIS

    use Chart::OFC2;
    use Chart::OFC2::Legend;

    $chart = Chart::OFC2->new(
        'x_legend'  => 'Legend for the X axis',
    );

    $chart = Chart::OFC2->new(
        'x_legend'  => Chart::OFC2::Legend->new(
            'text'  => 'Legend for the X Axis',
            'style' => '{font-size:20px; font-family:Verdana; text-align:center;}',
        ),
    );

=head1 DESCRIPTION

=cut

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;

our $VERSION = '0.08_02';

coerce 'Chart::OFC2::Legend'
    => from 'Str'
    => via { Chart::OFC2::Legend->new('text' => $_) };

coerce 'Chart::OFC2::Legend'
    => from 'HashRef'
    => via { Chart::OFC2::Legend->new( $_ ) };

=head1 PROPERTIES

    has 'text'  => (is => 'rw', isa => 'Str', );
    has 'style' => (is => 'rw', isa => 'Str', );

=cut

has 'text'  => (is => 'rw', isa => 'Str', );
has 'style' => (is => 'rw', isa => 'Str', default => '{}', required => 1 );


=head1 METHODS

=head2 new()

Object constructor.

=head2 TO_JSON()

Returns HashRef that is possible to give to C<encode_json()> function.

=cut

sub TO_JSON {
    my $self = shift;
    
    return {
        map  { my $v = $self->$_; (defined $v ? ($_ => $v) : ()) }
        map  { $_->name }
        $self->meta->get_all_attributes
    };
}

__PACKAGE__->meta->make_immutable;

1;


__END__

=head1 AUTHOR

Robin Clarke

=cut
