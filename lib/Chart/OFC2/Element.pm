package Chart::OFC2::Element;

=head1 NAME

Chart::OFC2::Element - OFC2 base module for chart elements

=head1 SYNOPSIS

    use Moose;
    extends 'Chart::OFC2::Element';

=head1 DESCRIPTION

=cut

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;

use Chart::OFC2::Extremes;

our $VERSION = '0.01';

=head1 PROPERTIES

    has 'type_name'    => (is => 'rw', isa => enum([qw(bar bar_filled pie hbar line line_dot line_hollow area_hollow scatter)]), required => 1);
    has 'values'       => (is => 'rw', isa => 'ArrayRef', trigger => sub { $_[0]->extremes->reset('y' => $_[1]); } );
    has 'extremes'     => (is => 'rw', isa => 'Chart-OFC2-Extremes',  default => sub { Chart::OFC2::Extremes->new() }, lazy => 1, coerce  => 1);
    has 'use_extremes' => (is => 'rw', isa => 'Bool',  default => 0 );
    has 'on-click'     => (is => 'rw', isa => 'Str', );
    has 'tip'          => (is => 'rw', isa => 'Str',);
    has 'alpha'        => (is => 'rw', isa => 'Num',);
    has 'colour'       => (is => 'rw', isa => 'Str',);

=cut

has 'type_name'    => (is => 'rw', isa => enum([qw(bar bar_filled pie hbar line line_dot line_hollow area_hollow scatter)]), required => 1);
has 'values'       => (is => 'rw', isa => 'ArrayRef', trigger => sub { $_[0]->extremes->reset('y' => $_[1]); } );
has 'extremes'     => (is => 'rw', isa => 'Chart-OFC2-Extremes',  default => sub { Chart::OFC2::Extremes->new() }, lazy => 1, coerce  => 1);
has 'use_extremes' => (is => 'rw', isa => 'Bool',);
has 'on-click'     => (is => 'rw', isa => 'Str', );
has 'tip'          => (is => 'rw', isa => 'Str',);
has 'alpha'        => (is => 'rw', isa => 'Num',);
has 'colour'       => (is => 'rw', isa => 'Str',);


=head1 METHODS

=head2 new()

Object constructor.

=head2 TO_JSON()

Returns HashRef that is possible to give to C<encode_json()> function.

=cut

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


__END__

=head1 AUTHOR

Jozef Kutej

=cut
