#include <stdio.h>
#include "parse_opts.h"

static void hnd_flag_i(char * opt, char * arg, void * p)
{
    printf("%s\n", opt);
}

static void hlp_flag_i(char * short_name, char * long_name)
{
    printf("help for flag %s, %s\n", short_name, long_name);
}

static void hnd_flag_j(char * opt, char * arg, void * p)
{
    printf("%s\n", opt);
}

static void hlp_flag_j(char * short_name, char * long_name)
{
    printf("help for flag %s, %s\n", short_name, long_name);
}

static void hnd_flag_k(char * opt, char * arg, void * p)
{
    printf("%s\n", opt);
}

static void hlp_flag_k(char * short_name, char * long_name)
{
    printf("help for flag %s, %s\n", short_name, long_name);
}

static void hnd_a(char * opt, char * arg, void * p)
{
    printf("%s %s\n", opt, arg);
}

static void hlp_a(char * short_name, char * long_name)
{
    printf("help for option %s, %s\n", short_name, long_name);
}

static void hnd_help(char * opt, char * arg, void * p)
{
    opts_print_help(p);
}

static void hlp_help(char * short_name, char * long_name)
{
    printf("help for option %s, %s\n", short_name, long_name);
}

static void hnd_s_args(char * opt, char * arg, void * p)
{
    printf("%s ", opt);
    char * sub_arg, ** parg = &arg;
    while ((sub_arg = opts_get_sub_arg(parg, ',')))
        printf("'%s' ", sub_arg);
    putchar('\n');
}

static void hlp_s_args(char * short_name, char * long_name)
{
    printf("help for option %s, %s\n", short_name, long_name);
}


static void unknown(char * opt, char * arg, void * p)
{
    printf("unknown option: '%s'\n", opt);
}

static void unbound_arg(char * opt, char * arg, void * p)
{
    printf("arg without option: %s\n", arg);
}

int main(int argc, char * argv[])
{
    if (argc < 2)
    {
        puts("Use: <prog> <options>");
        return -1;
    }

    opts_table the_tbl;
    opts_entry all_entries[] = {
		{
			.short_name = 'i',
			.long_name = "i-flag",
			.takes_arg = false,
			.callback = hnd_flag_i,
			.callback_arg = NULL,
			.print_help = hlp_flag_i
		},
		{
			.short_name = 'j', 
			.long_name = "j-flag", 
			.takes_arg = false,
			.callback = hnd_flag_j, 
			.callback_arg = NULL,
			.print_help = hlp_flag_j
		},
		{
			.short_name = 'k', 
			.long_name = "k-flag", 
			.takes_arg = false,
			.callback = hnd_flag_k, 
			.callback_arg = NULL,
			.print_help = hlp_flag_k
		},
		{
			.short_name = 'a', 
			.long_name = "a-option", 
			.takes_arg = true,
			.callback = hnd_a, 
			.callback_arg = NULL,
			.print_help = hlp_a
		},
		{
			.short_name = 'h', 
			.long_name = "help", 
			.takes_arg = false,
			.callback = hnd_help,
			.callback_arg = &the_tbl,
			.print_help = hlp_help
		},
		{
			.short_name = 's', 
			.long_name = "sub-args", 
			.takes_arg = true,
			.callback = hnd_s_args, 
			.callback_arg = NULL,
			.print_help = hlp_s_args
		},
    };

    the_tbl.tbl = all_entries;
    the_tbl.length = sizeof(all_entries)/sizeof(*all_entries);

	opts_parse_data parse_data = {
		.program_name = "my-program",
		.the_tbl = &the_tbl,
		.handle_unbound_arg = unbound_arg,
		.unbound_arg_arg = NULL,
		.handle_unknown_opt = unknown
	};

    opts_parse(argc-1, argv+1, &parse_data);
    return 0;
}
