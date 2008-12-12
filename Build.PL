use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Chart::OFC2',
    license             => 'perl',
    dist_author         => 'Jozef Kutej <jkutej@cpan.org>',
    dist_version_from   => 'lib/Chart/OFC2.pm',
    requires => {
        'Moose'           => 0,
        'Moose::Util::TypeConstraints'
                          => 0,
        'MooseX::StrictConstructor'
                          => 0,
        'Carp::Clan'      => 0,
        'JSON::XS'        => 0,
        'List::MoreUtils' => 0,
        'List::Util'      => 0,
    },
    build_requires => {
        'Test::More'        => 0,
        'Test::Differences' => 0,
        'File::Slurp'       => 0,
    },
    script_files => [
    ],
    add_to_cleanup      => [ 'Chart-OFC2-*' ],
    create_makefile_pl => 'traditional',
    create_readme       => 1,
    sign                => 1,
);

$builder->create_build_script();
