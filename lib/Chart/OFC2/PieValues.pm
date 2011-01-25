package Chart::OFC2::PieValues;

=head1 NAME

Chart::OFC2::PieValues - OFC2 values for pie charts object

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use Moose;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;

use Carp::Clan 'croak';
use List::MoreUtils 'any';

our $VERSION = '0.07';

coerce 'Chart::OFC2::PieValues'
    => from 'ArrayRef'
    => via { Chart::OFC2::PieValues->_new_from_arrayref($_) };

=head1 PROPERTIES

    has 'values' => ( is => 'rw', isa => 'ArrayRef', );
    has 'texts'  => ( is => 'rw', isa => 'ArrayRef',  );
	has 'tips'   => ( is => 'rw', isa => 'ArrayRef', );
	has 'clicks' => ( is => 'rw', isa => 'ArrayRef', );

=cut

has 'values'  => ( is => 'rw', isa => 'ArrayRef', 'required' => 1);
has 'labels'  => ( is => 'rw', isa => 'ArrayRef',  );
has 'colours' => ( is => 'rw', isa => 'ArrayRef', );
has 'tips'    => ( is => 'rw', isa => 'ArrayRef', );
has 'clicks'  => ( is => 'rw', isa => 'ArrayRef', );


=head1 METHODS

=head2 new()

Object constructor.

=head1 _new_from_arrayref

Allow object creation by coerce of ArrayRef.

=cut

sub _new_from_arrayref {
    my $class           = shift;
    my $arrayref_values = shift;
    
    croak 'pass ArrayRef as argument'
        if not ref $arrayref_values ne 'ArrayRef';
    
    my (@values, @labels, @colours, @tips, @clicks);
    foreach my $value (@{$arrayref_values}) {
        if (ref $value eq 'HASH') {
            push @values,  $value->{'value'};
            push @labels,  $value->{'label'};
            push @colours, $value->{'colour'};
			push @tips,    $value->{'tip'};
			push @clicks,  $value->{'click'};
        }
        else {
            push @values, $value;
            push @labels, undef;
            push @colours, undef;
			push @tips, undef;
			push @clicks, undef;
        }
    }
    
    return $class->new(
        'values'  => \@values,
        'labels'  => \@labels,
        'tips'    => \@tips,
        'clicks'  => \@clicks,
        ((any { defined $_ } @colours) ? ('colours' => \@colours) : ())
    );
}

=head2 TO_JSON()

Returns HashRef that is possible to give to C<encode_json()> function.

=cut

sub TO_JSON {
    my ($self) = @_;
    
    my @values_with_labels;
    my @values = @{$self->values};
    my @labels = @{$self->labels};
    my @tips = @{$self->tips};
    my @clicks = @{$self->clicks};
    for (my $i = 0; $i < @values; $i++) {
		my $value;
		if (defined($labels[$i]) || defined($tips[$i]) || defined($clicks[$i])) {
			$value = { value => $values[$i] };
			$value->{label} = $labels[$i] if defined($labels[$i]);
			$value->{tip} = $tips[$i] if defined($tips[$i]);
			$value->{'on-click'} = $clicks[$i] if defined($clicks[$i]);
		} else {
			$value = $values[$i];
		}
        push(@values_with_labels, $value);
    }
    
    return \@values_with_labels;
}

__PACKAGE__->meta->make_immutable;

1;


__END__

=head1 AUTHOR

Jozef Kutej

=cut
