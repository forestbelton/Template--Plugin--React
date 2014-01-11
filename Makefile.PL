use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Template::Plugin::React',
    VERSION_FROM => 'lib/Template/Plugin/React.pm',
    INC          => `js-config --cflags`,
    LIBS         => `js-config --libs`,
    OBJECT       => 'RESimple.o RESimple_wrap.o',
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
