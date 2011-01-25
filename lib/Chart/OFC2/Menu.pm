package Chart::OFC2::Menu;

=head1 NAME

Chart::OFC2::Menu - OFC2 menu object

=head1 SYNOPSIS

    use Chart::OFC2;
    use Chart::OFC2::Menu;

    $chart = Chart::OFC2->new(
        'menu'  => Chart::OFC2::Menu->new(
			values			=> [
				{"type":"camera-icon","text":"Hello","javascript-function":"save_image"},
				{"type":"camera-icon","text":"Toggle old data","javascript-function":"toggle"}
			],
			colour			=> "#E0E0ff",
			outline_colour	=>"#707070"
        ),
    );

=head1 DESCRIPTION

=cut

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;

our $VERSION = '0.07';

coerce 'Chart::OFC2::Menu'
    => from 'HashRef'
    => via { Chart::OFC2::Menu->new($_) };


=head1 PROPERTIES

	has 'values'			=> ( is => 'rw', isa => 'ArrayRef', 'required' => 1);
	has 'colour'			=> (is => 'rw', isa => 'Str', );
	has 'outline_colour'	=> (is => 'rw', isa => 'Str', );

=cut

has 'values'			=> ( is => 'rw', isa => 'ArrayRef', 'required' => 1);
has 'colour'			=> (is => 'rw', isa => 'Str', );
has 'outline_colour'	=> (is => 'rw', isa => 'Str', );


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

Frederik Jung

=cut
