use Test::More;

if (!$ENV{TEST_SPELLING}) {
    plan skip_all => 
      "Set the environment variable TEST_SPELLING to enable this test.";
}

eval 'use Test::Spelling;';

plan skip_all => "Test::Spelling required for testing POD spelling"
    if $@;

add_stopwords(qw(
	Jozef Kutej
	OFC
	API
	JSON
	TBD
	html
	ChartOFC
	isa
	rw
	AnnoCPAN
	CPAN
	GPL
	GitHub
	IRC
	blog
	RT
	PositiveInt
));
all_pod_files_spelling_ok();
