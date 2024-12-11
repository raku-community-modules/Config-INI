unit module Config::INI;

grammar INI {
    token TOP      {
                        ^
                        <.eol>*
                        <toplevel>?
                        <sections>*
                        <.eol>*
                        $
                   }
    token toplevel { <keyval>* }
    token sections { <header> <keyval>* }
    token header   { ^^ \h* '[' ~ ']' $<text>=<-[ \] \n ]>+ \h* <.eol>+ }
    token keyval   { ^^ \h* <key> \h* '=' \h* <value>? \h* <.eol>+ }
    regex key      { <![#\[]> <-[;=]>+ }
    regex value    { [ <![#;]> \N ]+ }
    # TODO: This should be just overriden \n once Rakudo implements it
    token eol      { [ <[#;]> \N* ]? \n }
}

class INI::Actions {
    method TOP ($/) {
        my %hash = $<sections>».ast;
        %hash<_> = $<toplevel>.ast.hash if $<toplevel>.?ast;
        make %hash;
    }
    method toplevel ($/) { make $<keyval>».ast.hash }
    method sections ($/) { make $<header><text>.Str => $<keyval>».ast.hash }
    # TODO: The .trim is useless, <!after \h> should be added to key regex,
    # once Rakudo implements it
    method keyval ($/) { make $<key>.Str.trim => $<value>.defined ?? $<value>.Str.trim !! '' }
}

our sub parse (Str $string) {
    INI.parse($string, :actions(INI::Actions.new)).ast;
}

our sub parse_file (Str $file) {
    INI.parsefile($file, :actions(INI::Actions.new)).ast;
}

=begin pod

=head1 NAME

Config::INI - parse standard configuration files (.ini files)

=head1 SYNOPSIS

=begin code :lang<raku>

use Config::INI;
my %hash = Config::INI::parse_file('config.ini');
#or
%hash = Config::INI::parse($file_contents);
say %hash<_><root_property_key>;
say %hash<section><in_section_key>;

=end code

=head1 DESCRIPTION

This module provides 2 functions: parse() and parse_file(), both taking
one C<Str> argument, where parse_file is just parse(slurp $file).
Both return a hash which keys are either toplevel keys or a section
names. For example, the following config file:

=begin code :lang<ini>

foo=bar
[section]
another=thing

=end code

would result in the following hash:

=begin code :lang<raku>

{ '_' => { foo => "bar" }, section => { another => "thing" } }

=end code

=head1 AUTHORS

Tadeusz Sośnierz

Nobuo Danjou

=head1 COPYRIGHT AND LICENSE

Copyright 2010 - 2017 Tadeusz Sośnierz

Copyright 2024 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
