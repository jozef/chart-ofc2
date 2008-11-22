package Chart::OFC2::Line;

=head1 NAME

Chart::OFC2::Line - OFC2 Line chart

=head1 NOT IMPLEMENTED JET

TBD

=begin skip

our @ISA = qw(bar_and_line_base);

sub new() {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self                               = $self->SUPER::new();
    $self->{'element_props'}->{'type'}  = __PACKAGE__;
    $self->{'element_props'}->{'width'} = 2;
    return $self;
}

package line_dot;
our @ISA = qw(line);

sub new() {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self                                  = $self->SUPER::new();
    $self->{'element_props'}->{'type'}     = __PACKAGE__;
    $self->{'element_props'}->{'dot-size'} = 6;
    return $self;
}

package line_hollow;
our @ISA = qw(line);

sub new() {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self                                  = $self->SUPER::new();
    $self->{'element_props'}->{'type'}     = __PACKAGE__;
    $self->{'element_props'}->{'dot-size'} = 8;
    return $self;
}

package area_hollow;
our @ISA = qw(bar_and_line_base);

sub new() {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self                                    = $self->SUPER::new();
    $self->{'element_props'}->{'type'}       = __PACKAGE__;
    $self->{'element_props'}->{'width'}      = 2;
    $self->{'element_props'}->{'fill'}       = '';
    $self->{'element_props'}->{'text'}       = '';
    $self->{'element_props'}->{'dot-size'}   = 5;
    $self->{'element_props'}->{'halo-size'}  = 2;
    $self->{'element_props'}->{'fill-alpha'} = 0.6;
    return $self;
}

=cut

1;
