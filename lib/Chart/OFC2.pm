package Chart::OFC2;

use Moose;
use Moose::Util::TypeConstraints;

use Carp::Clan 'croak';
use JSON::XS qw();

use Chart::OFC2::Axis;
use Chart::OFC2::Bar;
use Chart::OFC2::Title;
use Chart::OFC2::Extremes;
use List::Util 'min', 'max';
use List::MoreUtils 'any';

has 'data_load_type' => (is => 'rw', isa => 'Str',  default => 'inline_js');
has 'bootstrap'      => (is => 'rw', isa => 'Bool', default => '1');
has 'title'          => (is => 'rw', isa => 'Chart-OFC2-Title', default => sub { Chart::OFC2::Title->new() }, lazy => 1, coerce  => 1);
has 'x_axis'         => (is => 'rw', isa => 'Chart-OFC2-XAxis', default => sub { Chart::OFC2::XAxis->new() }, lazy => 1,);
has 'y_axis'         => (is => 'rw', isa => 'Chart-OFC2-YAxis', default => sub { Chart::OFC2::YAxis->new() }, lazy => 1, );
has 'elements'       => (is => 'rw', isa => 'ArrayRef', default => sub{[]}, lazy => 1);
has 'extremes'       => (is => 'rw', isa => 'Chart-OFC2-Extremes',  default => sub { Chart::OFC2::Extremes->new() }, lazy => 1);
has '_json'          => (is => 'rw', isa => 'Object',  default => sub { JSON::XS->new->pretty(1)->convert_blessed(1) }, lazy => 1);


# elements are the data series items, usually containing values to plot
sub get_element {
    my ($self, $element_name) = @_;
    
    my $element_module = (
        $element_name eq 'bar' ? 'Chart::OFC2::Bar'
        : undef
    );
    croak 'unsupported element - ', $element_name
        if not defined $element_name;
    
    return $element_module->new();
}

sub add_element {
    my ($self, $element) = @_;
    
    if ($element->use_extremes) {
        $self->y_axis->max('a');
        $self->y_axis->min('a');
    }
    
    push(@{ $self->elements }, $element);
}

sub render_chart_data {
    my $self = shift;

    $self->auto_extremes();
    
    return $self->_json->encode({
        'title'    => $self->title,
        'x_axis'   => $self->x_axis,
        'y_axis'   => $self->y_axis,
        'elements' => $self->elements,
    });
}

sub auto_extremes {
    my $self = shift;
        
    foreach my $axis_name ('x_axis', 'y_axis') {
        my $axis = $self->$axis_name;
        next if not defined $axis;
        
        foreach my $axis_type ('min', 'max') {
            my $axis_value = $axis->$axis_type;
            if ((defined $axis_value) and ($axis_value eq 'a')) {
                $axis->$axis_type($self->smooth($axis_name, $axis_type));
            }
        }
    }
    
    return;
}

sub render_swf {
    my ($self, $width, $height, $data_url, $div_id) = @_;
    
    $div_id ||= 'my_chart';

    my $html = '';

    if ($self->data_load_type eq 'inline_js') {
        if ($self->bootstrap) {
            $html .= '<script type="text/javascript" src="swfobject.js"></script>';
            $self->{'skip_bootstrap'} = 1;
        }
        $html .= qq^
            <div id="$div_id"></div>
            <script type="text/javascript">
                swfobject.embedSWF(
                    "open-flash-chart.swf", "$div_id", "$width", "$height",
                    "9.0.0", "expressInstall.swf",
                    {"data-file":"$data_url"}
                );
            </script>
        ^;
    }
    else {
        $html .= qq^
            <object
                classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
                codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0"
                width="$width"
                height="$height"
                id="graph_2"
                align="middle">
            <param name="allowScriptAccess" value="sameDomain" />
            <param name="movie" value="open-flash-chart.swf?width=$width&height=$height&data=$data_url"/>
            <param name="quality" value="high" />
            <param name="bgcolor" value="#FFFFFF" />
            <embed
                src="open-flash-chart.swf?width=$width&height=$height&data=$data_url"
                quality="high"
                bgcolor="#FFFFFF"
                width="$width"
                height="$height"
                name="open-flash-chart"
                align="middle"
                allowScriptAccess="sameDomain"
                type="application/x-shockwave-flash"
                pluginspage="http://www.macromedia.com/go/getflashplayer"
            />
            </object>
        ^;
    }

    return $html;
}

=head1 GENERAL HELPERS

=cut

sub to_json {
    my ($data_structure, $name) = @_;

    my $tmp = '';

    if (defined($name) && $name ne '') {
        $name =~ s/\"/\'/gi;
        $tmp .= "\n\"$name\" : ";
    }

    if (ref $data_structure eq 'ARRAY') {
        $tmp .= "[";
        for (@$data_structure) {
            $tmp .= to_json($_, '');
        }
        $tmp =~ s/,$//g;
        $tmp .= "]";
    }
    elsif (ref $data_structure eq 'HASH') {
        $tmp .= "{" if defined($name);
        for (keys %{$data_structure}) {
            $tmp .= to_json($data_structure->{$_}, $_ || '');
        }
        $tmp =~ s/,$//g;
        $tmp .= "}" if defined($name);

    }
    else {

        if (!defined($data_structure)) {
            return;
        }

        if ($data_structure =~ /^-{0,1}[\d.]+$/) {

            #number
            $tmp .= $data_structure;
        }
        else {

            #not number
            $data_structure =~ s/\"/\'/gi;
            $tmp .= "\"$data_structure\"";
        }
    }

    return $tmp . ',';
}

sub random_color {
    my @hex;
    for (my $i = 0 ; $i < 64 ; $i++) {
        my ($rand, $x);
        for ($x = 0 ; $x < 3 ; $x++) {
            $rand = rand(255);
            $hex[$x] = sprintf("%x", $rand);
            if ($rand < 9) {
                $hex[$x] = "0" . $hex[$x];
            }
            if ($rand > 9 && $rand < 16) {
                $hex[$x] = "0" . $hex[$x];
            }
        }
    }
    return "\#" . $hex[0] . $hex[1] . $hex[2];
}

# URL-encode string
sub url_escape {
    my ($toencode) = @_;
    $toencode =~ s/([^a-zA-Z0-9_\-. ])/uc sprintf("%%%02x",ord($1))/eg;
    $toencode =~ tr/ /+/;                                                 # spaces become pluses
    return $toencode;
}

# round the number up a bit to a nice round number
# also changes number to an int
sub smoother_number {
    my $number  = shift;
    my $min_max = shift;
    my $n       = $number;
    
    return
        if not defined $number;

    if ($min_max eq 'max') {
        $n += 1;
    }
    else {
        $n -= 1;
    }
    if ($n <= 10) { $n = int($n) }
    elsif ($n < 30)    { $n = $n + (-$n % 5) }
    elsif ($n < 100)   { $n = $n + (-$n % 10) }
    elsif ($n < 500)   { $n = $n + (-$n % 50) }
    elsif ($n < 1000)  { $n = $n + (-$n % 100) }
    elsif ($n < 10000) { $n = $n + (-$n % 200) }
    else               { $n = $n + (-$n % 500) }
    return int($n);
}

sub smooth {
    my $self      = shift;
    my $axis_name = shift;
    my $axis_type = shift;
    
    my $extremes_name = $axis_name.'_'.$axis_type;
    my $cmp_function  = ($axis_type eq 'min' ? \&min : \&max);
    
    my $number;
    foreach my $element (@{$self->elements}) {
        my $element_number = $element->extremes->$extremes_name;
        
        next
            if not defined $element_number;
        $number = $element_number
            if not defined $number;
        $number = $cmp_function->($number, $element_number);
    }
    
    return smoother_number($number, $axis_type);
}

1;
