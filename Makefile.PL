use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Template::Plugin::React',
    VERSION      => '0.002',
    INC          => `js-config --cflags`,
    LIBS         => `js-config --libs`,
    OBJECT       => 'RESimple.o RESimple_wrap.o',
    macro        => {
        BASEEXT => 'RESimple'
    },
    clean        => {
        FILES => ['RESimple.pm', 'RESimple_wrap.cxx']
    }
);

sub MY::postamble {
    <<EOF;
RESimple_wrap.cxx: RESimple.i
	swig -c++ -perl -shadow \$<
EOF
}
