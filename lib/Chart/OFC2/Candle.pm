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

=cut

has '+type_name' => ( default => 'candle');
has '+tip'       => (is => 'rw', isa => 'Str', );


# Override the standard TO_JSON to do good output for the values.
# Better would be to have a trigger on "values" to check the values and format them
# when they are added.
sub TO_JSON {
    my $self = shift;
    
    my %hash = (
        map  { my $v = $self->$_; (defined $v ? ($_ => $v) : ()) }
        grep { $_ ne 'extremes' }
        grep { $_ ne 'type_name' }
        grep { $_ ne 'values' }
        grep { $_ ne 'use_extremes' }
        map  { $_->name }
        $self->meta->get_all_attributes
    );
    $hash{'type'} = $self->type_name;
    
    my @values;
    foreach my $entry( @{ $self->values } ){
        if( ref( $entry ) eq 'ARRAY' ){
            Chart::OFC2::Element::_make_numbers_numbers($entry);
            my @sorted = sort{ $a <=> $b }( @$entry );
            push( @values, { 'low'    => $sorted[0],
                             'bottom' => $sorted[1],
                             'top'    => $sorted[2],
                             'high'   => $sorted[3] } );
        }else{
            push( @values, $entry )
        }
    }
    $hash{'values'} = \@values;

    return \%hash;
}

1;

__END__

=head1 AUTHOR

Robin Clarke

=cut
