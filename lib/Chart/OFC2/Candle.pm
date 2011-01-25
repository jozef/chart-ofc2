package Chart::OFC2::Candle;

=head1 NAME

Chart::OFC2::Candle - OFC2 candle chart

=head1 SYNOPSIS

    use Chart::OFC2;
    use Chart::OFC2::Axis;
    use Chart::OFC2::Candle;
    
    my $chart = Chart::OFC2->new(
        'title'  => 'Candle chart test',
        'x_axis' => Chart::OFC2::XAxis->new(
            'labels' => [ 'Jan', 'Feb', 'Mar', 'Apr', 'May' ],
        ),
        'y_axis' => {
            'max' => 'a',
            'min' => 'a',
        },
    );

    my $candle = Chart::OFC2::Candle->new();

To define high, top, bottom and low yourself (allows those inside-out candles where bottom is higher than top)

    $candle->values([
        { high   => 8,
          top    => 4.4,
          bottom => 2,
          low    => 1
        },
        { high   => 7,
          top    => 5,
          bottom => 4,
          low    => 2
        },
       ] );
    $chart->add_element($candle);

or to have auto-sorted (most typical usage) candles: high > top > bottom > low

    $candle->values([
        [ 9, 8, 7, 2 ],
        [ 7, 5, 4, 2 ],
       ] );
    $chart->add_element($candle);

    print $chart->render_chart_data();

=head1 DESCRIPTION

	extends 'Chart::OFC2::BarLineBase';

=cut

use Moose;
use MooseX::StrictConstructor;

our $VERSION = '0.08_02';

extends 'Chart::OFC2::BarLineBase';

=head1 PROPERTIES

	has '+type_name' => (default => 'candle');
    has '+tip'       => (is => 'rw', isa => 'Str', );
    has 'values'     => (is => 'rw', isa => 'ArrayRef', trigger => sub { $_[0]->extremes->reset('y' => $_[1]);
                                                                         $_[0]->process_values( $_[1] ) } );

=cut

has '+type_name' => ( default => 'candle');
has '+tip'       => (is => 'rw', isa => 'Str', );
has 'values'     => (is => 'rw', isa => 'ArrayRef', trigger => sub { $_[0]->extremes->reset('y' => $_[1]);
                                                                     $_[0]->process_values( $_[1] ) } );

=head2 process_values()

Candle can have data in two formats:

 [ [ 10, 8, 5, 1 ], [ 8, 3, 2, 1 ] ]
or
 [ { 'high' => 10, 'top' => 8, 'bottom' => 5, 'low' => 1 }, { 'high' => 8, 'top' => 3, 'bottom' => 2, 'low' => 1 } ]
If value sets are passed in the later format, nothing needs to be done.
If value sets are passed in the first format, they should be transformed to the later format so that
the data output will be usable by the graph

=cut

sub process_values{
    my( $self, $values ) = @_;

    foreach my $idx( 0 .. scalar( @{ $values } ) ){
        if( ref $values->[$idx] eq 'ARRAY' ){
            my @sorted = sort{ $a <=> $b }( @{ $values->[$idx] } );
            $values->[$idx] =  { 'low'    => $sorted[0],
                                 'bottom' => $sorted[1],
                                 'top'    => $sorted[2],
                                 'high'   => $sorted[3] };
        }
    }
}


1;

__END__

=head1 AUTHOR

Robin Clarke

=cut
