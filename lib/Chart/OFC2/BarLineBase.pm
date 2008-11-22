package Chart::OFC2::BarLineBase;

=head1 NAME

Chart::OFC2::BarLineBase - OFC2 Bar and Line chart base module

=head1 SYNOPSIS

	use Moose;
	extends 'Chart::OFC2::BarLineBase';

=head1 DESCRIPTION

=cut

use Moose;
extends 'Chart::OFC2::Element';

our $VERSION = '0.01';

=head1 PROPERTIES

	has 'color'     => (is => 'rw', isa => 'Str', );
	has 'text'      => (is => 'rw', isa => 'Str', );
	has 'font_size' => (is => 'rw', isa => 'Int', );

=cut

has 'color'     => (is => 'rw', isa => 'Str', );
has 'text'      => (is => 'rw', isa => 'Str', );
has 'font_size' => (is => 'rw', isa => 'Int', );

1;


__END__

=head1 AUTHOR

Jozef Kutej

=cut
