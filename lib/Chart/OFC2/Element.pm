package Chart::OFC2::Element;
use Carp qw(cluck);

our $AUTOLOAD;

sub new {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};

    $self->{'extremes'}      = {};
    $self->{'element_props'} = {
        'type'   => '',
        'values' => [ 1.5, 1.69, 1.88, 2.06, 2.21 ],
    };
    return bless $self, $class;
}

sub set_values {
    my ($self, $values_arg) = @_;
    $self->{'element_props'}->{'values'} = $values_arg if defined($values_arg);
    $self->set_extremes();
}

sub set_extremes {
    my ($self) = @_;
    my $extremes = {
        'x_axis_max' => undef,
        'x_axis_min' => undef,
        'y_axis_max' => undef,
        'y_axis_min' => undef,
        'other'      => undef
    };
    for (@{ $self->{'element_props'}->{'values'} }) {
        if (ref($_) eq 'HASH' || ref($_) eq 'ARRAY') {
            return $extremes;
        }
        $extremes->{'y_axis_max'} = $_ if !defined($extremes->{'y_axis_max'});
        if ($_ > $extremes->{'y_axis_max'}) {
            $extremes->{'y_axis_max'} = $_;
        }
        $extremes->{'y_axis_min'} = $_ if !defined($extremes->{'y_axis_min'});
        if ($_ < $extremes->{'y_axis_min'}) {
            $extremes->{'y_axis_min'} = $_;
        }
    }
    $self->{'extremes'} = $extremes;
}

sub to_json() {
    my ($self) = @_;
    my $json = Chart::OFC2::to_json($self->{'element_props'});
    $json =~ s/,$//g;
    return '{' . $json . '}';
}

sub AUTOLOAD {
    my $self = shift;
    my $type = ref($self) or warn "$self is not an object";

    my $name = $AUTOLOAD;
    $name =~ s/.*://;    # strip fully-qualified portion

    if ($name eq 'values') {
        $self->{'element_props'}->{'values'} = [];
        cluck "You need to call set_values() instead of plain values().";
        return undef;
    }

    $name =~ s/^set_//;    # strip set_
    $name =~ s/^get_//;    # strip get_

    unless (exists $self->{'element_props'}->{$name}) {
        cluck "'$name' is not a valid property in class $type";
        return undef;
    }

    if (@_) {
        return $self->{'element_props'}->{"$name"} = shift;
    }
    else {
        return $self->{'element_props'}->{"$name"};
    }
}
sub DESTROY { }

1;
