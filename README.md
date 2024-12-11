[![Actions Status](https://github.com/raku-community-modules/Config-INI/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/Config-INI/actions) [![Actions Status](https://github.com/raku-community-modules/Config-INI/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/Config-INI/actions) [![Actions Status](https://github.com/raku-community-modules/Config-INI/actions/workflows/windows.yml/badge.svg)](https://github.com/raku-community-modules/Config-INI/actions)

NAME
====

Config::INI - parse standard configuration files (.ini files)

SYNOPSIS
========

```raku
use Config::INI;
my %hash = Config::INI::parse_file('config.ini');
#or
%hash = Config::INI::parse($file_contents);
say %hash<_><root_property_key>;
say %hash<section><in_section_key>;
```

DESCRIPTION
===========

This module provides 2 functions: parse() and parse_file(), both taking one `Str` argument, where parse_file is just parse(slurp $file). Both return a hash which keys are either toplevel keys or a section names. For example, the following config file:

```ini
foo=bar
[section]
another=thing
```

would result in the following hash:

```raku
{ '_' => { foo => "bar" }, section => { another => "thing" } }
```

AUTHORS
=======

Tadeusz Sośnierz

Nobuo Danjou

COPYRIGHT AND LICENSE
=====================

Copyright 2010 - 2017 Tadeusz Sośnierz

Copyright 2024 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

