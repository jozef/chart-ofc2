package Chart::OFC2::Labels;

=head1 NAME

Chart::OFC2::Labels - OFC2 labels object

=head1 SYNOPSIS

    use Chart::OFC2::Labels;
    
    'x_axis' => Chart::OFC2::XAxis->new(
        'labels' => [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun' ],
    ),

    'x_axis' => Chart::OFC2::XAxis->new(
        'labels' => Chart::OFC2::Labels->new(
            'labels' => [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun' ],
            'color'  => '#555555'
        ),
    ),

=head1 DESCRIPTION

=cut

use Moose;
use Moose::Util::TypeConstraints;

our $VERSION = '0.01';

subtype 'Chart-OFC2-Labels'
    => as 'Object'
    => where { $_[0]->isa('Chart::OFC2::Labels') };

coerce 'Chart-OFC2-Labels'
    => from 'ArrayRef'
    => via { Chart::OFC2::Labels->new('labels' => $_) };

=head1 PROPERTIES

    has 'labels' => ( is => 'rw', isa => 'ArrayRef', );
    has 'color'  => ( is => 'rw', isa => 'Str',  );

=cut

has 'labels' => ( is => 'rw', isa => 'ArrayRef', );
has 'color'  => ( is => 'rw', isa => 'Str',  );


=head1 METHODS

=head2 new()

Object constructor.

=head2 TO_JSON()

Returns HashRef that is possible to give to C<encode_json()> function.

=cut

sub TO_JSON {
    my ($self) = @_;
    
    return {
        map  { my $v = $self->$_; (defined $v ? ($_ => $v) : ()) }
        map  { $_->name } $self->meta->compute_all_applicable_attributes
    };
}

1;


__END__

=head1 AUTHOR

Jozef Kutej

=cut
