#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 5;
use Test::Differences;

use File::Slurp 'write_file';
use File::Spec;

use FindBin qw($Bin);
use lib "$Bin/../lib";

our $BASE_PATH = File::Spec->catfile($Bin, 'output');

BEGIN {
    use_ok ( 'Chart::OFC2' )      or exit;
    use_ok ( 'Chart::OFC2::Candle' ) or exit;
}

exit main();

sub main {
    my $chart = Chart::OFC2->new(
        'title'  => 'Candle chart test',
        'x_axis' => Chart::OFC2::XAxis->new(
            labels => { 
                labels => [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun' ]
            }
        ),
        'y_axis' => {
            'max' => 'a',
            'min' => 'a',
        },
        'y_axis_right' => {
            'max' => 'a',
            'min' => 'a',
        },
        'bg_colour' => 'f0f8ff',
        'x_legend' => 'x_legend',
        'y_legend' => 'y_legend',
    );
    $chart->x_axis->labels->rotate(45);
    $chart->x_axis->labels->colour('#555555');
    
    my $candle = Chart::OFC2::Candle->new(
        'values' => [
                     { high   => 8,
                       top    => 4.4,
                       bottom => 2,
                       low    => 1
                     },
                     { high   => 7,
                       top    => 5,
                       bottom => 4,
                       low    => 3
                     },
                     { high   => 4,
                       top    => 3,
                       bottom => 3,
                       low    => 2
                     },
                     { high   => 9,
                       top    => 5,
                       bottom => 3.4,
                       low    => 3
                     },
                     { high   => 8,
                       top    => 4,
                       bottom => 4.4,
                       low    => 4
                     },
                     { high   => 7,
                       top    => 6.5,
                       bottom => 6.2,
                       low    => 6
                     },
                    ],
        'colour' => '#40FF0D',
        'text'   => 'some legend',
    );
    $candle->values();
    $chart->add_element($candle);

    eq_or_diff(
        $candle->TO_JSON,
        {
          'text' => 'some legend',
          'colour' => '#40FF0D',
          'type' => 'candle',
          'values' => [
                        {
                          'high' => 8,
                          'top' => '4.4',
                          'low' => 1,
                          'bottom' => 2
                        },
                        {
                          'high' => 7,
                          'top' => 5,
                          'low' => 3,
                          'bottom' => 4
                        },
                        {
                          'high' => 4,
                          'top' => 3,
                          'low' => 2,
                          'bottom' => 3
                        },
                        {
                          'high' => 9,
                          'top' => 5,
                          'low' => 3,
                          'bottom' => '3.4'
                        },
                        {
                          'high' => 8,
                          'top' => 4,
                          'low' => 4,
                          'bottom' => '4.4'
                        },
                        {
                          'high' => 7,
                          'top' => '6.5',
                          'low' => 6,
                          'bottom' => '6.2'
                        }
                      ]
        },
        'candle element TO_JSON'
    );

    my $chart_data = $chart->render_chart_data();
    ok($chart_data, 'generate candle chart data');
    
    # write output to file
    my $output_filename = File::Spec->catfile($BASE_PATH, 'candle-data.json');
    ok(write_file($output_filename, $chart_data), 'saving candle-chart JSON to "'.$output_filename.'"');

    return 0;
}
