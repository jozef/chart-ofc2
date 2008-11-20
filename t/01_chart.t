#!/usr/bin/perl

use strict;
use warnings;

#use Test::More 'no_plan';
use Test::More tests => 5;

use File::Slurp 'write_file', 'read_file';

use FindBin qw($Bin);
use lib "$Bin/lib";


our $BASE_PATH = File::Spec->catfile($Bin, 'output');

BEGIN {
    use_ok ( 'Chart::OFC2' ) or exit;
}

exit main();

sub main {
    my $chart = Chart::OFC2->new();
    isa_ok($chart, 'Chart::OFC2');
    
    $chart = Chart::OFC2->new(
        'title' => 'test',
    );
    is($chart->title->text, 'test', 'title name coercion');
    
    my $bar_html = $chart->render_swf(600, 400, 'bar-data.json?'.time(), 'bar-chart');    # time() to avoid caching
    ok($bar_html, 'generate bar chart html');

    my $pie_html = $chart->render_swf(600, 400, 'pie-data.json?'.time(), 'pie-chart');    # time() to avoid caching
    ok($pie_html, 'generate pie chart html');
    
    my $html = read_file(File::Spec->catfile($BASE_PATH, '_header.html'));
    
    $html .= '<h1>Bar chart</h1>';
    $html .= $bar_html;
    $html .= '<h1>Pie chart</h1>';
    $html .= $pie_html;
    
    $html .= read_file(File::Spec->catfile($BASE_PATH, '_footer.html'));
    
    $html .= write_file(File::Spec->catfile($BASE_PATH, 'index.html'), $html);
    
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
