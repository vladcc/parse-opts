# <user_events>
function on_context_arg_type() {
	data_or_err()
	save_context_arg_type($2)

}

function on_context_var_name() {
	data_or_err()
	save_context_var_name($2)

}

function on_unbound_arg_code() {
	#data_or_err()
	save_unbound_arg_code(get_code())

}

function on_on_error_code() {
	#data_or_err()
	save_on_error_code(get_code())

}

function on_long_name() {
	data_or_err()
	save_long_name($2)

}

function on_short_name() {
	data_or_err()
	save_short_name($2)

}

function on_takes_args() {
	data_or_err()
	save_takes_args($2)

}

function on_handler_code() {
	#data_or_err()
	save_handler_code(get_code())

}

function on_help_code() {
	#data_or_err()
	save_help_code(get_code())

}

function on_end() {
	#data_or_err()
	#save_end($2)

}

function init() {
	if (Help)
		print_help()
	if (Version)
		print_version()
	if (ARGC != 2)
		print_use_try()
}

function on_BEGIN() {
	init()
}

function on_END() {
	main()
}

# <user_messages>
function use_str() {
	return sprintf("Use: %s <input-file>", SCRIPT_NAME())
}

function print_use_try() {
	print_puts_err(use_str())
	print_puts_err(sprintf("Try '%s -vHelp=1' for more info", SCRIPT_NAME()))
	exit_failure()
}

function print_version() {
	print_puts(sprintf("%s %s", SCRIPT_NAME(), SCRIPT_VERSION()))
	exit_success()
}

function print_help() {
print sprintf("--- %s %s ---", SCRIPT_NAME(), SCRIPT_VERSION())
print use_str()
print "A line oriented state machine parser."
print ""
print "Options:"
print "-vVersion=1 - print version"
print "-vHelp=1    - print this screen"
print ""
print "Rules:"
print "'->' means 'must be followed by'"
print "'|'  means 'or'"
print "Each line of the input file must begin with a rule."
print "The rules must appear in the below order of definition."
print "Empty lines and lines which start with '#' are ignored."
print ""
print "context_arg_type -> context_var_name"
print "context_var_name -> unbound_arg_code"
print "unbound_arg_code -> on_error_code"
print "on_error_code -> long_name"
print "long_name -> short_name"
print "short_name -> takes_args"
print "takes_args -> handler_code"
print "handler_code -> help_code"
print "help_code -> end"
print "end -> long_name"
	exit_success()
}
# </user_messages>
# </user_events>

# <user_code>
# v1.11

function get_cname(name) {
	gsub("-", "_", name)
	return name
}
function get_long_cname(name) {
	return (get_cname(name) "_opt_long")
}
function get_short_cname(name) {
	return (get_cname(name) "_opt_short")
}

function gen_names(opt_num,    long_name, sanitized, ret) {
	long_name = get_long_name(opt_num)
	
	ret = sprintf("static const char %s = '%s';",
		get_short_cname(long_name), get_short_name(opt_num))
	ret = (ret "\n" sprintf("static const char %s[] = \"%s\";",
		get_long_cname(long_name),
		long_name)\
	)
	ret = (ret "\n")
	
	return ret
}

function END_CODE() {return "end_code"}

function get_code(    code_str) {
	while ((getline > 0) && (END_CODE() != $1))
		code_str = (code_str $0 "\n")
	return code_str
}

function RET_TYPE() {return "static void"}
function HANDLER_UNBOUND() {return "on_unbound_arg"}
function HANDLER_ERROR() {return "on_error"}

function gen_handler_defn(opt_num,
    title_cmnt, opt_declr, fname, sign, long_name, arg_t, code) {
    
	long_name = get_long_name(opt_num)
	arg_t = get_context_arg_type(1)
	name = get_cname(long_name)
	title_cmnt = sprintf("// %s", long_name)
	opt_declr = ""
	code = ""
	
	if (match(long_name, HANDLER_UNBOUND())) {
		code = get_unbound_arg_code(1)
		sign = "const char * arg, void * ctx"
	} else if (match(long_name, HANDLER_ERROR())) {
		code = get_on_error_code(1)
		sign = "opts_err_code err_code, const char * err_opt, void * ctx"
	} else {
		title_cmnt = sprintf("// --%s|-%s", long_name, get_short_name(opt_num))
		code = get_handler_code(opt_num)
		name = sprintf("handle_%s", name)
		sign = "const char * opt, char * opt_arg, void * ctx"
		opt_declr = gen_names(opt_num)
	}
	
	print_ind_line(title_cmnt)	
	
	if (opt_declr)
		print_ind_str(opt_declr)
		
	print_ind_line(sprintf("%s %s(%s)", RET_TYPE(), name, sign))
		
	print_ind_line("{")
	print_ind_str(code)
	print_ind_line("}")
	print_ind_line()
}

function gen_help_defn(opt_num,    long_name) {
	long_name = get_long_name(opt_num)
	
	print_ind_line(sprintf(\
		"%s help_%s(const char * short_name, const char * long_name)",\
		RET_TYPE(), get_cname(long_name))\
	)
	print_ind_line("{")
	print_ind_str(get_help_code(opt_num))
	print_ind_line("}")
	print_ind_line()
}

function gen_default_handlers() {
	save_long_name("on_unbound_arg")
	gen_handler_defn(get_long_name_count())
	
	save_long_name("on_error")
	gen_handler_defn(get_long_name_count())
}

function open_tbl() {
	print_ind_line("opts_table the_tbl;")
	print_ind_line("opts_entry all_entries[] = {")
	print_inc_indent()
}

function gen_tbl_entry(opt_num,    ctx, long_name, underscores, short_name) {
	long_name = get_long_name(opt_num)
	ctx = (match(long_name, "^help$")) ? "(&the_tbl)" : get_context_var_name(1)
	short_name = get_short_name(opt_num)
	
	underscores = get_cname(long_name)
	print_ind_line("{")
	print_inc_indent()
	print_ind_line(".names = {")
		print_inc_indent()
		print_ind_line(sprintf(".long_name = %s,", get_long_cname(long_name)))
		print_ind_line(sprintf(".short_name = %s", get_short_cname(long_name)))
		print_dec_indent()
	print_ind_line("},")
	print_ind_line(".handler = {")
		print_inc_indent()
		print_ind_line(sprintf(".handler = handle_%s,", underscores))
		print_ind_line(sprintf(".context = (void *)%s,", ctx))
		print_dec_indent()
	print_ind_line("},")
	print_ind_line(sprintf(".print_help = help_%s,", underscores))
	print_ind_line(sprintf(".takes_arg = %s,", get_takes_args(opt_num)))
	print_dec_indent()
	print_ind_line("},")
}

function close_tbl(    src) {
	print_dec_indent()
	print_ind_line("};")
	print_ind_line()
	print_ind_line("the_tbl.tbl = all_entries;")
    print_ind_line("the_tbl.length = sizeof(all_entries)/sizeof(*all_entries);")
    print_ind_line()
}

function opts_parse_data() {
	print_ind_line("opts_parse_data parse_data = {")
	print_inc_indent()
	print_ind_line(".the_tbl = &the_tbl,")
	print_ind_line(".on_unbound = {")
		print_inc_indent()
		print_ind_line(sprintf(".handler = %s,", HANDLER_UNBOUND()))
		print_ind_line(sprintf(".context = (void *)%s,", get_context_var_name(1)))
		print_dec_indent()
	print_ind_line("},")
	print_ind_line(".on_error = {")
		print_inc_indent()
		print_ind_line(sprintf(".handler = %s,", HANDLER_ERROR()))
		print_ind_line(sprintf(".context = (void *)%s,", get_context_var_name(1)))
		print_dec_indent()
	print_ind_line("}")
	print_dec_indent()
	print_ind_line("};")
}

function main(    i, end, opt) {
	end = get_long_name_count()
	
	print_puts("// <opts_definitions>")
	print_ind_line()
	for (i = 1; i <= end; ++i) {
		gen_handler_defn(i)
		gen_help_defn(i)
	}
	gen_default_handlers()
	print_puts("// </opts_definitions>")

	print_puts("// <opts_process>")
	open_tbl()
	for (i = 1; i <= end; ++i)
		gen_tbl_entry(i)
	close_tbl()
	
	opts_parse_data()
	
	print_ind_line()
	print_ind_line("opts_parse(argc-1, argv+1, &parse_data);")
	print_puts("// </opts_process>")
}
# </user_code>
