package Chart::OFC2::Bar;

use strict;
use warnings;

use base 'Chart::OFC2::BarLineBase';

sub new {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self                               = $self->SUPER::new();
    $self->{'element_props'}->{'type'}  = 'bar';
    $self->{'element_props'}->{'alpha'} = 0.5;
    return $self;
}

package Chart::OFC2::Bar::3D;

use strict;
use warnings;

use base 'Chart::OFC2::Bar';

sub new() {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self = $self->SUPER::new();
    $self->{'element_props'}->{'type'} = 'bar_3d';
    return $self;
}

package Chart::OFC2::Bar::Fade;

use strict;
use warnings;

use base 'Chart::OFC2::Bar';

sub new() {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self = $self->SUPER::new();
    $self->{'element_props'}->{'type'} = 'bar_fade';
    return $self;
}

package Chart::OFC2::Bar::Glass;

use strict;
use warnings;

use base 'Chart::OFC2::Bar';

sub new() {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self = $self->SUPER::new();
    $self->{'element_props'}->{'type'} = 'bar_glass';
    return $self;
}

package Chart::OFC2::Bar::Sketch;

use strict;
use warnings;

use base 'Chart::OFC2::Bar';

sub new {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self = $self->SUPER::new();
    $self->{'element_props'}->{'type'} = 'bar_sketch';
    return $self;
}

package Chart::OFC2::Bar::Filled;

use strict;
use warnings;

use base 'Chart::OFC2::Bar';

sub new {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self                                        = $self->SUPER::new();
    $self->{'element_props'}->{'type'}           = 'bar_filled';
    $self->{'element_props'}->{'outline-colour'} = Chart::OFC2::random_color();
    return $self;
}

package Chart::OFC2::Bar::Stack;

use strict;
use warnings;

use base 'Chart::OFC2::Bar';

sub new {
    my ($proto) = @_;
    my $class = ref($proto) || $proto;
    my $self = {};
    bless $self, $class;
    $self                                = $self->SUPER::new();
    $self->{'element_props'}->{'type'}   = 'bar_stack';
    $self->{'element_props'}->{'text'}   = 'bar_stack' . ' ' . $self->{'element_props'}->{'text'};
    $self->{'element_props'}->{'values'} = [
        [ { "val" => 1 }, { "val" => 3 } ],
        [ { "val" => 1 }, { "val" => 1 }, { "val" => 2.5 } ],
        [
            { "val" => 5 },
            { "val" => 5 },
            { "val" => 2 },
            { "val" => 2 },
            { "val" => 2, "colour" => main::random_color() },
            { "val" => 2 },
            { "val" => 2 }
        ]
    ];

    return $self;
}

#stackbar must override set_extremes() because of nested value list
sub set_extremes {
    my ($self) = @_;
    my $extremes = {
        'x_axis_max' => undef,
        'x_axis_min' => undef,
        'y_axis_max' => undef,
        'y_axis_min' => undef,
        'other'      => undef
    };
    for my $v (@{ $self->{'element_props'}->{'values'} }) {
        my $bar_ext = {
            'x_axis_max' => undef,
            'x_axis_min' => undef,
            'y_axis_max' => undef,
            'y_axis_min' => undef,
            'other'      => undef
        };
        if (ref($v) eq 'ARRAY') {
            for (@$v) {
                next if !defined($_->{'val'});
                if (!defined($bar_ext->{'y_axis_max'})) {
                    $bar_ext->{'y_axis_max'} = $_->{'val'};
                }
                else {
                    $bar_ext->{'y_axis_max'} += $_->{'val'};
                }
            }
        }
        if ($bar_ext->{'y_axis_max'} > $extremes->{'y_axis_max'}) {
            $extremes->{'y_axis_max'} = $bar_ext->{'y_axis_max'};
        }
    }
    $self->{'extremes'} = $extremes;
}

1;
