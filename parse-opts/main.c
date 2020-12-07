#include <stdio.h>
#include <stdlib.h>
#include "parse_opts.h"

static const char prog_name[] = "my-program";

#include "opts_definitions.ic"

int main(int argc, char * argv[])
{
    if (argc < 2)
    {
        puts("Use: <prog> <options>");
        return -1;
    }

	void * the_context = NULL;

#include "opts_process.ic"

    return 0;
}
