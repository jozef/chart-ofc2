package Chart::OFC2::Pie;

use strict;
use warnings;

use base 'Chart::OFC2::Element';

sub new {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self                                 = $self->SUPER::new();
    $self->{'element_props'}->{'type'}    = 'pie';
    $self->{'element_props'}->{'alpha'}   = 0.5;
    $self->{'element_props'}->{'colours'} = [
        Chart::OFC2::random_color(),
        Chart::OFC2::random_color(),
        Chart::OFC2::random_color(),
        Chart::OFC2::random_color(),
        Chart::OFC2::random_color(),
    ];
    $self->{'element_props'}->{'border'}      = 2;
    $self->{'element_props'}->{'animate'}     = 0;
    $self->{'element_props'}->{'start-angle'} = 0;

    $self->{'element_props'}->{'values'} = [
        { 'value' => rand(255), 'text' => 'linux' },
        { 'value' => rand(255), 'text' => 'windows' },
        { 'value' => rand(255), 'text' => 'vax' },
        { 'value' => rand(255), 'text' => 'NexT' },
        { 'value' => rand(255), 'text' => 'solaris' }
    ];

    return $self;
}

1;
