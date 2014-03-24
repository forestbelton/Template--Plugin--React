# ABSTRACT: Renders FB React templates from Template Toolkit
use strict;
use warnings;
package Template::Plugin::React;

our $VERSION = '0.006';

use base qw(Template::Plugin);
use Template::Plugin;

use Template::Plugin::React::RESimple;
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

    my $ctx       = new Template::Plugin::React::RESimple::RESimple;
    my $prelude   = from_file $constants->{react_js};
    my $templates = $constants->{react_templates};

    bless {
        ctx       => $ctx,
        prelude   => $prelude,
        templates => $templates
    }, $class;
}

sub render {
    my ($self, $name, $data) = @_;
    my $json = to_json($data // {});

    my $built = from_file $self->{templates};
    my $res = $self->{ctx}->exec(qq|
(function() {

var console = {
    warn:  function(){},
    error: function(){}
};

var global = {};
$self->{prelude};
var React = global.React;

$built;
return React.renderComponentToString($name($json));

})();
    |);

    if($res) {
        return $self->{ctx}->output();
    } else {
        die $self->{ctx}->output();
    }
}

1;
