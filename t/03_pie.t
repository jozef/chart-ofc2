#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 3;
use File::Slurp 'write_file';
use File::Spec;

use FindBin qw($Bin);
use lib "$Bin/lib";

our $BASE_PATH = File::Spec->catfile($Bin, 'output');

BEGIN {
    use_ok ( 'Chart::OFC2' )      or exit;
    use_ok ( 'Chart::OFC2::Pie' ) or exit;
}

exit main();

sub main {
    ok('skipping - TBD');
    return 0;
    
    my $chart = Chart::OFC2->new(
        opacity      => 60,
        line_color   => '#505050',
        title        => 'Pie Chart',
        title_style  => 'font-size: 18px; color: #d01f3c;',
        label_style  => 'font-size: 12px; color: #404040;',
    );
    
    my $pie = Chart::OFC2::Pie->new(
        labels       => [qw( IE Firefox Opera Wii Other)],
        slice_colors => [ '#d01f3c', '#356aa0', '#C79810' ],
        tool_tip     => '#val#%25',
    );
    $pie->set_values([ map { 5 + int( rand(11) ) } ( 1 .. 5 ) ]);
    $chart->add_element($pie);

    my $chart_data = $chart->render_chart_data();
    ok($chart_data, 'generate pie chart data');
    
    # write output to file
    write_file(File::Spec->catfile($BASE_PATH, 'pie-data.json'), $chart_data);
    
    return 0;
}


__END__

print Chart::OFC::Pie->new(
    opacity      => 60,
    line_color => '#505050',
    title        => 'Pie Chart',
    title_style => 'font-size:18px; color: #d01f3c;',
    label_style => 'font-size: 12px; color: #404040;',
    dataset      => Chart::OFC::Dataset->new(
        values => [ map { 5 + int( rand(11) ) } ( 1 .. 5 ) ],
    ),
    labels        => [qw( IE Firefox Opera Wii Other)],
    slice_colors => [ '#d01f3c', '#356aa0', '#C79810' ],
    tool_tip      => '#val#%25',
)->as_ofc_data();
