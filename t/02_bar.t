#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
#use Test::More tests => 3;
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
    my $chart = Chart::OFC2->new();
    
    my $bar = Chart::OFC2::Bar->new();
    $bar->set_values([ map { 12 - $_ } 0..5 ]);
    $chart->add_element($bar);

    my $bar2 = Chart::OFC2::Bar::Filled->new();
    $bar2->set_values([ 10..15 ]);
    $chart->add_element($bar2);
    
    my $chart_data = $chart->render_chart_data();
    ok($chart_data, 'generate bar chart data');
    
    # write output to file
    write_file(File::Spec->catfile($BASE_PATH, 'bar-data.json'), $chart_data);
    
    return 0;
}


__END__

<%@ Language="PerlScript"%>
<% 

# For this test you must have an iis webserver with the perlscript dll installed as a language.
# Also you'll need the open-flash-chart.swf file and the open_flash_chart.pm files together with this one
#

use strict; 
our ($Server, $Request, $Response);
use lib $Server->mappath('.');
use open_flash_chart;

my $g = chart->new();

if ( $Request->QueryString("data")->Item == 1 ) {

  
  my $e = $g->get_element('bar');
  my $data = [];
	for( my $i=0; $i<5; $i++ ) {
		push ( @$data, rand(20) );
	}
  $e->set_values($data);
  $g->add_element($e);

  
  $e = $g->get_element('bar_filled');
  my $data = [];
	for( my $i=0; $i<5; $i++ ) {
		push ( @$data, rand(40) );
	}
  $e->set_values($data);
  $g->add_element($e);  

 
	$Response->write($g->render_chart_data());
  $Response->exit();

} else {
  
%>
<html>
  <head>
    <title>OFC Bar Test</title>
  </head>
  <body>
    <h1>OFC Bar Test</h1>
<%
    $Response->write($g->render_swf(600, 400, '?data=1&'.time()));
%>
<!--#INCLUDE FILE = "list_all_tests.inc"-->

</body>
</html>
<%  
}
%>
