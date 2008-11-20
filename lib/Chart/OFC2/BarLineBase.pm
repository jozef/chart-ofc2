package Chart::OFC2::BarLineBase;

use strict;
use warnings;

use base 'Chart::OFC2::Element';

sub new {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self                                   = $self->SUPER::new();
    $self->{'element_props'}->{'colour'}    = Chart::OFC2::random_color();
    $self->{'element_props'}->{'text'}      = 'text';
    $self->{'element_props'}->{'font-size'} = 10;

    #$self->{'element_props'}->{'show_y2'} = 'false';
    #$self->{'element_props'}->{'y2_lines'} = [];
    #$self->{'element_props'}->{'values_2'} = [];

    return $self;
}

1;
