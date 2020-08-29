# parse-opts
Command line options parsing

Command line option parsing for the classic syntax you'd find on *nix
systems, implemented with callbacks.

Options can have a single character short name which starts with a dash and
a long name which starts with a double dash. Short names of options that do
not takes arguments can be bunched together (e.g. -ixyz). Options that
do take arguments can have the following syntax:
-a Arg-To-a
-aArg-To-a
--a-option Arg-To-a
--a-option=Arg-To-a
--a-option= Arg-To-a
Short names of options with arguments can be bunched together with
options without arguments, given the option with the argument is last
(e.g. -xyzaArg-To-a or -xyza Arg-To-a). Sub-arguments are also supported
as a delimited list by the opts_get_sub_arg() function. A single dash is
seen as an argument to the program (not belonging to any option). Everything
after only a double dash is also seen as program arguments, even option
names. This library does not copy argv, but does change the strings. If a
long option name ends in with a '=', the '=' is replaced with '\0', as is
the first delimiter after a sub-argument when opts_get_sub_arg() is used.

There's a code generator in parse-opts/parse-opts-code-generator, which
generates all needed option code and the option code in main.c is generated from
parse-opts/parse-opts-code-generator/opts-gen.txt. Both files constitute a
comprehensive example. 
