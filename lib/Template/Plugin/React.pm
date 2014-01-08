# ABSTRACT: Renders FB React templates from Template Toolkit
use strict;
use warnings;
package Template::Plugin::React;

use base qw(Template::Plugin);
use Template::Plugin;

use JSPL;
use JSON;

sub from_file {
    my ($fname) = @_;

    my $out = '';
    open my $fh, '<', $fname or die $!;
    {
        local $/;
        $out = <$fh>;
    }
    close $fh;

    return $out;
}

sub new {
    my ($self, $context, @params) = @_;
    return $self;
}

sub load {
    my ($class, $context) = @_;
    my $constants = $context->config->{CONSTANTS};

    my $prelude   = from_file $constants->{react_js};
    my $templates = $constants->{react_templates};

    bless {
        prelude   => $prelude,
        templates => $templates
    }, $class;
}

sub render {
    my ($self, $name, $data) = @_;
    my $json = to_json($data // {});

    my $built = from_file $self->{templates};
    my $res = JSPL->stock_context->eval(qq|
var console = {
    warn:  function(){},
    error: say
};

var global = {};
$self->{prelude};
var React = global.React;

$built;
var result;
React.renderComponentToString($name($json), function(s) {
    result = s;
});
result;
    |);
}

1;
