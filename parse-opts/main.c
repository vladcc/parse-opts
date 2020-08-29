#include <stdio.h>
#include <stdlib.h>
#include "parse_opts.h"

static const char prog_name[] = "my-program";

// --i-flag|-i
static const char i_flag_opt_short = 'i';
static const char i_flag_opt_long[] = "i-flag";
static void handle_i_flag(const char * opt, char * opt_arg, void * ctx)
{
	printf("%s\n", opt);
}

static void help_i_flag(const char * short_name, const char * long_name)
{
	printf("help for flag %s, %s\n", short_name, long_name);
}

// --j-flag|-j
static const char j_flag_opt_short = 'j';
static const char j_flag_opt_long[] = "j-flag";
static void handle_j_flag(const char * opt, char * opt_arg, void * ctx)
{
	printf("%s\n", opt);
}

static void help_j_flag(const char * short_name, const char * long_name)
{
	printf("help for flag %s, %s\n", short_name, long_name);
}

// --k-flag|-k
static const char k_flag_opt_short = 'k';
static const char k_flag_opt_long[] = "k-flag";
static void handle_k_flag(const char * opt, char * opt_arg, void * ctx)
{
	printf("%s\n", opt);
}

static void help_k_flag(const char * short_name, const char * long_name)
{
	printf("help for flag %s, %s\n", short_name, long_name);
}

// --a-option|-a
static const char a_option_opt_short = 'a';
static const char a_option_opt_long[] = "a-option";
static void handle_a_option(const char * opt, char * opt_arg, void * ctx)
{
	printf("%s %s\n", opt, opt_arg);
}

static void help_a_option(const char * short_name, const char * long_name)
{
	printf("help for option %s, %s\n", short_name, long_name);
}

// --help|-h
static const char help_opt_short = 'h';
static const char help_opt_long[] = "help";
static void handle_help(const char * opt, char * opt_arg, void * ctx)
{
	opts_print_help((opts_table *)ctx);
}

static void help_help(const char * short_name, const char * long_name)
{
	printf("help for option %s, %s\n", short_name, long_name);
}

// --sub-args|-s
static const char sub_args_opt_short = 's';
static const char sub_args_opt_long[] = "sub-args";
static void handle_sub_args(const char * opt, char * opt_arg, void * ctx)
{
    printf("%s ", opt);
    char * sub_arg, ** parg = &opt_arg;
    while ((sub_arg = opts_get_sub_arg(parg, ',')))
        printf("'%s' ", sub_arg);
    putchar('\n');
}

static void help_sub_args(const char * short_name, const char * long_name)
{
    printf("help for option %s, %s\n", short_name, long_name);
}

// on_unbound_arg
static void on_unbound_arg(const char * arg, void * ctx)
{
	printf("arg without option: %s\n", arg);
}

// on_error
static void on_error(opts_err_code err_code, const char * err_opt, void * ctx)
{
	FILE * where = stdout; // preserve output order
	fprintf(where, "%s: error: ", prog_name);
	switch (err_code)
	{
		case OPTS_UNKOWN_OPT_ERR:
			fprintf(where, "option '%s' unknown\n", err_opt);
			return;
		break;
		case OPTS_ARG_REQ_ERR:
			fprintf(where, "option '%s' requires an argument\n", err_opt);
		break;
		case OPTS_NO_ARG_REQ_ERR:
			fprintf(where, "option '%s' does not take arguments\n", err_opt);
		break;
		default:
		break;
	}
	
	exit(EXIT_FAILURE);
}


int main(int argc, char * argv[])
{
    if (argc < 2)
    {
        puts("Use: <prog> <options>");
        return -1;
    }

	void * the_context = NULL;

	opts_table the_tbl;
	opts_entry all_entries[] = {
		{
			.names = {
				.long_name = i_flag_opt_long,
				.short_name = i_flag_opt_short
			},
			.handler = {
				.handler = handle_i_flag,
				.context = (void *)the_context,
			},
			.print_help = help_i_flag,
			.takes_arg = false,
		},
		{
			.names = {
				.long_name = j_flag_opt_long,
				.short_name = j_flag_opt_short
			},
			.handler = {
				.handler = handle_j_flag,
				.context = (void *)the_context,
			},
			.print_help = help_j_flag,
			.takes_arg = false,
		},
		{
			.names = {
				.long_name = k_flag_opt_long,
				.short_name = k_flag_opt_short
			},
			.handler = {
				.handler = handle_k_flag,
				.context = (void *)the_context,
			},
			.print_help = help_k_flag,
			.takes_arg = false,
		},
		{
			.names = {
				.long_name = a_option_opt_long,
				.short_name = a_option_opt_short
			},
			.handler = {
				.handler = handle_a_option,
				.context = (void *)the_context,
			},
			.print_help = help_a_option,
			.takes_arg = true,
		},
		{
			.names = {
				.long_name = help_opt_long,
				.short_name = help_opt_short
			},
			.handler = {
				.handler = handle_help,
				.context = (void *)(&the_tbl),
			},
			.print_help = help_help,
			.takes_arg = false,
		},
		{
			.names = {
				.long_name = sub_args_opt_long,
				.short_name = sub_args_opt_short
			},
			.handler = {
				.handler = handle_sub_args,
				.context = (void *)the_context,
			},
			.print_help = help_sub_args,
			.takes_arg = true,
		},
	};

	the_tbl.tbl = all_entries;
	the_tbl.length = sizeof(all_entries)/sizeof(*all_entries);
	
	opts_parse_data parse_data = {
		.the_tbl = &the_tbl,
		.on_unbound = {
			.handler = on_unbound_arg,
			.context = (void *)the_context,
		},
		.on_error = {
			.handler = on_error,
			.context = (void *)the_context,
		}
	};

	opts_parse(argc-1, argv+1, &parse_data);
    return 0;
}
