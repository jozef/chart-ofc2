package Chart::OFC2::Scatter;

=head1 NAME

Chart::OFC2::Scatter - OFC2 Scatter chart

=head1 NOT IMPLEMENTED JET

TBD

=begin skip

our @ISA = qw(element);

sub new() {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self                              = $self->SUPER::new();
    $self->{'use_extremes'}            = 1;                   # scatter needs x-y min-maxes to print
    $self->{'element_props'}->{'type'} = __PACKAGE__;
    $self->{'element_props'}->{'values'} = [
        { "x" => -5,  "y" => -5 },
        { "x" => 0,   "y" => 0 },
        { "x" => 5,   "y" => 5, "dot-size" => 20 },
        { "x" => 5,   "y" => -5, "dot-size" => 5 },
        { "x" => -5,  "y" => 5, "dot-size" => 5 },
        { "x" => 0.5, "y" => 1, "dot-size" => 15 }
    ];

    return $self;
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
        $extremes->{'y_axis_max'} = $_->{'y'} if !defined($extremes->{'y_axis_max'});
        if ($_->{'y'} > $extremes->{'y_axis_max'}) {
            $extremes->{'y_axis_max'} = $_->{'y'};
        }
        $extremes->{'y_axis_min'} = $_->{'y'} if !defined($extremes->{'y_axis_min'});
        if ($_->{'y'} < $extremes->{'y_axis_min'}) {
            $extremes->{'y_axis_min'} = $_->{'y'};
        }

        $extremes->{'x_axis_max'} = $_->{'x'} if !defined($extremes->{'x_axis_max'});
        if ($_->{'x'} > $extremes->{'x_axis_max'}) {
            $extremes->{'x_axis_max'} = $_->{'x'};
        }
        $extremes->{'x_axis_min'} = $_->{'x'} if !defined($extremes->{'x_axis_min'});
        if ($_->{'x'} < $extremes->{'x_axis_min'}) {
            $extremes->{'x_axis_min'} = $_->{'x'};
        }

    }
    $self->{'extremes'} = $extremes;
}

=cut

1;
