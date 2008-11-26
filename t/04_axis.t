#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 14;
use Test::Differences;

use JSON::XS;

use FindBin qw($Bin);
use lib "$Bin/lib";

BEGIN {
    use_ok ( 'Chart::OFC2::Axis' ) or exit;
}

exit main();

sub main {
    my %x_axis_attributes = (
        stroke      => 10,
        colour      => 'red',
        tick_height => 3,
        grid_colour => 'black',
        offset      => 1,
        steps       => 11,
        '3d'        => 1,
        labels      => [ qw( a b c d ) ],
    );
    my %y_axis_attributes = (
        stroke      => 10,
        colour      => 'red',
        tick_length => 3,
        grid_colour => 'black',
        offset      => 1,
        steps       => 11,
        '3d'        => 1,
        labels      => [ qw( a b c d ) ],
    );
    
    my $x_axis   = Chart::OFC2::XAxis->new(%x_axis_attributes);
    my $y_axis   = Chart::OFC2::YAxis->new(%y_axis_attributes);
    my $y_axis_r = Chart::OFC2::YAxisRight->new();
    isa_ok($x_axis, 'Chart::OFC2::Axis');
    isa_ok($y_axis, 'Chart::OFC2::Axis');
    isa_ok($y_axis_r, 'Chart::OFC2::Axis');
    isa_ok($x_axis, 'Chart::OFC2::XAxis');
    isa_ok($y_axis, 'Chart::OFC2::YAxis');
    isa_ok($y_axis_r, 'Chart::OFC2::YAxis');
    isa_ok($y_axis_r, 'Chart::OFC2::YAxisRight');
    
    is($x_axis->name, 'x_axis', 'check default name');
    is($y_axis->name, 'y_axis', 'check default name');
    is($y_axis_r->name, 'y_axis_right', 'check default name');
    
    eq_or_diff(
        $x_axis->TO_JSON,
        { %x_axis_attributes, labels => bless({ labels => [ qw( a b c d ) ] }, 'Chart::OFC2::Labels'),},
        'x axis hash encoding'
    );
    
    eq_or_diff(
        $y_axis->TO_JSON,
        { %y_axis_attributes, labels => bless({ labels => [ qw( a b c d ) ] }, 'Chart::OFC2::Labels'),},
        'y axis hash encoding'
    );
    
    eq_or_diff(
        $y_axis->labels->TO_JSON,
        [ qw( a b c d ) ],
        'y axis labels'
    );
    
    return 0;
}
