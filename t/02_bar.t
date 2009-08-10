#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 5;
use Test::Differences;

use File::Slurp 'write_file';
use File::Spec;

use FindBin qw($Bin);
use lib "$Bin/lib";

our $BASE_PATH = File::Spec->catfile($Bin, 'output');

BEGIN {
    use_ok ( 'Chart::OFC2' )      or exit;
    use_ok ( 'Chart::OFC2::Bar' ) or exit;
}

exit main();

sub main {
    my $chart = Chart::OFC2->new(
        'title'  => 'Bar chart test',
        'x_axis' => Chart::OFC2::XAxis->new(
            'labels' => [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun' ],
        ),
        'y_axis' => {
            'max' => 'a',
            'min' => 'a',
        },
    );
    
    my $bar = Chart::OFC2::Bar->new(
        'values' => [ map { (12 - $_).q() } 0..5 ],
        'colour' => '#40FF0D',
    );
    $bar->values();
    $chart->add_element($bar);

    eq_or_diff(
        $bar->TO_JSON,
        {
            'colour' => '#40FF0D',
            'type'   => 'bar',
            'values' => [ 12,11,10,9,8,7 ],
        },
        'bar element TO_JSON'
    );

    my $bar2 = Chart::OFC2::Bar::Filled->new(
        'colour' => '#186000',
    );
    $bar2->values([ 10..15 ]);
    $chart->add_element($bar2);
    
    my $chart_data = $chart->render_chart_data();
    ok($chart_data, 'generate bar chart data');
    
    # write output to file
    my $output_filename = File::Spec->catfile($BASE_PATH, 'bar-data.json');
    ok(write_file($output_filename, $chart_data), 'saving bar-chart JSON to "'.$output_filename.'"');
    
    return 0;
}
