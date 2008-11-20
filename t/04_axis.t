#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 13;
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
        color       => 'red',
        tick_height => 3,
        grid_color  => 'black',
        offset      => 1,
        steps       => 11,
        '3d'        => 1,
        labels      => [ qw( a b c d ) ],
    );
    my %y_axis_attributes = (
        stroke      => 10,
        color       => 'red',
        tick_length => 3,
        grid_color  => 'black',
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
        { $x_axis->to_key_value() },
        { 'x_axis' => \%x_axis_attributes },
        'x axis hash encoding'
    );
    
    eq_or_diff(
        { $y_axis->to_key_value() },
        { 'y_axis' => \%y_axis_attributes },
        'y axis hash encoding'
    );
    
    return 0;
}
