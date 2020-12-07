#!/usr/bin/awk -f

function SCRIPT_NAME() {return "parse-opts-gen.awk"}
function SCRIPT_VERSION() {return "1.0"}

# <user_api>

@include "inc_user_events.awk"

# <user_print>
function print_ind_line(str, tabs) {print_tabs(tabs); print_puts(str)}
function print_ind_str(str, tabs) {print_tabs(tabs); print_stdout(str)}
function print_inc_indent() {print_set_indent(print_get_indent()+1)}
function print_dec_indent() {print_set_indent(print_get_indent()-1)}
function print_tabs(tabs,	 i, end) {
	end = tabs + print_get_indent()
	for (i = 1; i <= end; ++i)
		print_stdout("\t")
}
function print_new_lines(num,    i) {
	for (i = 1; i <= num; ++i)
		print_stdout("\n")
}

function print_set_indent(tabs) {__indent_count__ = tabs}
function print_get_indent(tabs) {return __indent_count__}
function print_puts(str) {__print_puts(str)}
function print_puts_err(str) {__print_puts_err(str)}
function print_stdout(str) {__print_stdout(str)}
function print_stderr(str) {__print_stderr(str)}
function print_set_stdout(str) {__print_set_stdout(str)}
function print_set_stderr(str) {__print_set_stderr(str)}
function print_get_stdout() {return __print_get_stdout()}
function print_get_stderr() {return __print_get_stderr()}
# </user_print>

# <user_error>
function error(msg) {__error(msg)}
function error_input(msg) {__error_input(msg)}
# </user_error>

# <user_exit>
function exit_success() {__exit_success()}
function exit_failure() {__exit_failure()}
# </user_exit>

# <user_utils>
function data_or_err() {
	if (NF < 2)
		error_input(sprintf("no data after '%s'", $1))
}

function reset_all() {
	reset_context_arg_type()
	reset_context_var_name()
	reset_unbound_arg_code()
	reset_on_error_code()
	reset_long_name()
	reset_short_name()
	reset_takes_args()
	reset_handler_code()
	reset_help_code()
	reset_end()
}

function get_last_rule() {return __state_get()}

function save_context_arg_type(context_arg_type) {__context_arg_type_arr__[++__context_arg_type_num__] = context_arg_type}
function get_context_arg_type_count() {return __context_arg_type_num__}
function get_context_arg_type(num) {return __context_arg_type_arr__[num]}
function reset_context_arg_type() {delete __context_arg_type_arr__; __context_arg_type_num__ = 0}

function save_context_var_name(context_var_name) {__context_var_name_arr__[++__context_var_name_num__] = context_var_name}
function get_context_var_name_count() {return __context_var_name_num__}
function get_context_var_name(num) {return __context_var_name_arr__[num]}
function reset_context_var_name() {delete __context_var_name_arr__; __context_var_name_num__ = 0}

function save_unbound_arg_code(unbound_arg_code) {__unbound_arg_code_arr__[++__unbound_arg_code_num__] = unbound_arg_code}
function get_unbound_arg_code_count() {return __unbound_arg_code_num__}
function get_unbound_arg_code(num) {return __unbound_arg_code_arr__[num]}
function reset_unbound_arg_code() {delete __unbound_arg_code_arr__; __unbound_arg_code_num__ = 0}

function save_on_error_code(on_error_code) {__on_error_code_arr__[++__on_error_code_num__] = on_error_code}
function get_on_error_code_count() {return __on_error_code_num__}
function get_on_error_code(num) {return __on_error_code_arr__[num]}
function reset_on_error_code() {delete __on_error_code_arr__; __on_error_code_num__ = 0}

function save_long_name(long_name) {__long_name_arr__[++__long_name_num__] = long_name}
function get_long_name_count() {return __long_name_num__}
function get_long_name(num) {return __long_name_arr__[num]}
function reset_long_name() {delete __long_name_arr__; __long_name_num__ = 0}

function save_short_name(short_name) {__short_name_arr__[++__short_name_num__] = short_name}
function get_short_name_count() {return __short_name_num__}
function get_short_name(num) {return __short_name_arr__[num]}
function reset_short_name() {delete __short_name_arr__; __short_name_num__ = 0}

function save_takes_args(takes_args) {__takes_args_arr__[++__takes_args_num__] = takes_args}
function get_takes_args_count() {return __takes_args_num__}
function get_takes_args(num) {return __takes_args_arr__[num]}
function reset_takes_args() {delete __takes_args_arr__; __takes_args_num__ = 0}

function save_handler_code(handler_code) {__handler_code_arr__[++__handler_code_num__] = handler_code}
function get_handler_code_count() {return __handler_code_num__}
function get_handler_code(num) {return __handler_code_arr__[num]}
function reset_handler_code() {delete __handler_code_arr__; __handler_code_num__ = 0}

function save_help_code(help_code) {__help_code_arr__[++__help_code_num__] = help_code}
function get_help_code_count() {return __help_code_num__}
function get_help_code(num) {return __help_code_arr__[num]}
function reset_help_code() {delete __help_code_arr__; __help_code_num__ = 0}

function save_end(end) {__end_arr__[++__end_num__] = end}
function get_end_count() {return __end_num__}
function get_end(num) {return __end_arr__[num]}
function reset_end() {delete __end_arr__; __end_num__ = 0}
# </user_utils>
# </user_api>
#==============================================================================#
#                        machine generated parser below                        #
#==============================================================================#
# <gen_parser>
# <gp_print>
function __print_set_stdout(f) {__gp_fout__ = ((f) ? f : "/dev/stdout")}
function __print_get_stdout() {return __gp_fout__}
function __print_stdout(str) {__print(str, __print_get_stdout())}
function __print_puts(str) {__print_stdout(sprintf("%s\n", str))}
function __print_set_stderr(f) {__gp_ferr__ = ((f) ? f : "/dev/stderr")}
function __print_get_stderr() {return __gp_ferr__}
function __print_stderr(str) {__print(str, __print_get_stderr())}
function __print_puts_err(str) {__print_stderr(sprintf("%s\n", str))}
function __print(str, file) {printf("%s", str) > file}
# </gp_print>
# <gp_exit>
function __exit_skip_end_set() {__exit_skip_end__ = 1}
function __exit_skip_end_clear() {__exit_skip_end__ = 0}
function __exit_skip_end_get() {return __exit_skip_end__}
function __exit_success() {__exit_skip_end_set(); exit(0)}
function __exit_failure() {__exit_skip_end_set(); exit(1)}
# </gp_exit>
# <gp_error>
function __error(msg) {
	__print_puts_err(sprintf("%s: error: %s", SCRIPT_NAME(), msg))
	__exit_failure()
}
function __error_input(msg) {
	__error(sprintf("file '%s', line %d: %s", FILENAME, FNR, msg))
}
function GP_ERROR_EXPECT() {return "'%s' expected, but got '%s' instead"}
function __error_parse(expect, got) {
	__error_input(sprintf(GP_ERROR_EXPECT(), expect, got))
}
# </gp_error>
# <gp_state_machine>
function __state_set(state) {__state__ = state}
function __state_get() {return __state__}
function __state_match(state) {return (__state_get() == state)}
function __state_transition(_next) {
	if (__state_match("")) {
		if (__R_CONTEXT_ARG_TYPE() == _next) __state_set(_next)
		else __error_parse(__R_CONTEXT_ARG_TYPE(), _next)
	}
	else if (__state_match(__R_CONTEXT_ARG_TYPE())) {
		if (__R_CONTEXT_VAR_NAME() == _next) __state_set(_next)
		else __error_parse(__R_CONTEXT_VAR_NAME(), _next)
	}
	else if (__state_match(__R_CONTEXT_VAR_NAME())) {
		if (__R_UNBOUND_ARG_CODE() == _next) __state_set(_next)
		else __error_parse(__R_UNBOUND_ARG_CODE(), _next)
	}
	else if (__state_match(__R_UNBOUND_ARG_CODE())) {
		if (__R_ON_ERROR_CODE() == _next) __state_set(_next)
		else __error_parse(__R_ON_ERROR_CODE(), _next)
	}
	else if (__state_match(__R_ON_ERROR_CODE())) {
		if (__R_LONG_NAME() == _next) __state_set(_next)
		else __error_parse(__R_LONG_NAME(), _next)
	}
	else if (__state_match(__R_LONG_NAME())) {
		if (__R_SHORT_NAME() == _next) __state_set(_next)
		else __error_parse(__R_SHORT_NAME(), _next)
	}
	else if (__state_match(__R_SHORT_NAME())) {
		if (__R_TAKES_ARGS() == _next) __state_set(_next)
		else __error_parse(__R_TAKES_ARGS(), _next)
	}
	else if (__state_match(__R_TAKES_ARGS())) {
		if (__R_HANDLER_CODE() == _next) __state_set(_next)
		else __error_parse(__R_HANDLER_CODE(), _next)
	}
	else if (__state_match(__R_HANDLER_CODE())) {
		if (__R_HELP_CODE() == _next) __state_set(_next)
		else __error_parse(__R_HELP_CODE(), _next)
	}
	else if (__state_match(__R_HELP_CODE())) {
		if (__R_END() == _next) __state_set(_next)
		else __error_parse(__R_END(), _next)
	}
	else if (__state_match(__R_END())) {
		if (__R_LONG_NAME() == _next) __state_set(_next)
		else __error_parse(__R_LONG_NAME(), _next)
	}
}
# </gp_state_machine>
# <gp_awk_rules>
function __R_CONTEXT_ARG_TYPE() {return "context_arg_type"}
function __R_CONTEXT_VAR_NAME() {return "context_var_name"}
function __R_UNBOUND_ARG_CODE() {return "unbound_arg_code"}
function __R_ON_ERROR_CODE() {return "on_error_code"}
function __R_LONG_NAME() {return "long_name"}
function __R_SHORT_NAME() {return "short_name"}
function __R_TAKES_ARGS() {return "takes_args"}
function __R_HANDLER_CODE() {return "handler_code"}
function __R_HELP_CODE() {return "help_code"}
function __R_END() {return "end"}

$1 == __R_CONTEXT_ARG_TYPE() {__state_transition($1); on_context_arg_type(); next}
$1 == __R_CONTEXT_VAR_NAME() {__state_transition($1); on_context_var_name(); next}
$1 == __R_UNBOUND_ARG_CODE() {__state_transition($1); on_unbound_arg_code(); next}
$1 == __R_ON_ERROR_CODE() {__state_transition($1); on_on_error_code(); next}
$1 == __R_LONG_NAME() {__state_transition($1); on_long_name(); next}
$1 == __R_SHORT_NAME() {__state_transition($1); on_short_name(); next}
$1 == __R_TAKES_ARGS() {__state_transition($1); on_takes_args(); next}
$1 == __R_HANDLER_CODE() {__state_transition($1); on_handler_code(); next}
$1 == __R_HELP_CODE() {__state_transition($1); on_help_code(); next}
$1 == __R_END() {__state_transition($1); on_end(); next}
$0 ~ /^[[:space:]]*$/ {next} # ignore empty lines
$0 ~ /^[[:space:]]*#/ {next} # ignore comments
{__error_input(sprintf("'%s' unknown", $1))} # all else is error

function __init() {
	__print_set_stdout()
	__print_set_stderr()
	__exit_skip_end_clear()
}
BEGIN {
	__init()
	on_BEGIN()
}

END {
	if (!__exit_skip_end_get()) {
		if (__state_get() != __R_END())
			__error_parse(__R_END(), __state_get())
		else
			on_END()
	}
}
# </gp_awk_rules>
# </gen_parser>

# <user_input>
# Command line:
# -vScriptName=parse-opts-gen.awk
# -vScriptVersion=1.0
# Rules:
# context_arg_type -> context_var_name
# context_var_name -> unbound_arg_code
# unbound_arg_code -> on_error_code
# on_error_code -> long_name
# long_name -> short_name
# short_name -> takes_args
# takes_args -> handler_code
# handler_code -> help_code
# help_code -> end
# end -> long_name
# </user_input>
# generated by scriptscript.awk 2.21
