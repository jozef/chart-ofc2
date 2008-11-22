#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 3;
use Test::Differences;

use FindBin qw($Bin);
use lib "$Bin/lib";

BEGIN {
    use_ok ( 'Chart::OFC2::Element' ) or exit;
}

exit main();

sub main {
    my $element = Chart::OFC2::Element->new(
        'type_name' => 'bar',
        'values'    => [ 3,2,1,4,5 ],
    );
    
    eq_or_diff(
        $element->to_hash,
        {
            'type_name'    => 'bar',
            'values'       => [ 3,2,1,4,5 ],
            'use_extremes' => 0,
        },
        'element create'
    );
    
    eq_or_diff(
        $element->extremes->to_hash,
        {
            'x_axis_max' => undef,
            'x_axis_min' => undef, 
            'y_axis_max' => 5,
            'y_axis_min' => 1,
            'other'      => undef,
        },
        'extremes set'
    );
    
    return 0;
}
