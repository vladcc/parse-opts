.PHONY: help
help:
	@echo 'make all       - test'
	@echo 'make test      - compile and run tests'
	@echo 'make clean     - clean the obj/ directory'
	@echo 'make clean_ic  - clean the opts_*.ic files'
	@echo 'make clean_all - clean + clean_ic'
	@echo 'make help      - this screen'

OBJ_DIR := ./obj
SRC_DIR := ./src
TOOLS_DIR := ./tools

MAIN_O := $(OBJ_DIR)/main.o
PARSE_OPTS_O := $(OBJ_DIR)/parse_opts.o
TEST_BIN := $(OBJ_DIR)/test

OPTS_GEN := $(TOOLS_DIR)/parse-opts-gen.awk
OPTS_DEFN := $(TOOLS_DIR)/opts-example-defn.txt
OPTS_C_DEFN := opts_definitions.ic
OPTS_C_PROC := opts_process.ic
OPTS_C_SRC := $(OPTS_C_DEFN) $(OPTS_C_PROC)

CC := gcc
CFLAGS := -Wall -Wfatal-errors

.PHONY: all
all: test

.PHONY: test
test: $(OPTS_C_SRC) $(TEST_BIN)
	bash ./tests/run-tests.sh $(TEST_BIN)
	
$(OPTS_C_SRC) &: $(OPTS_DEFN)
	awk -f $(OPTS_GEN) $^

$(TEST_BIN): $(MAIN_O) $(PARSE_OPTS_O) $(OPTS_DEFN)
	$(CC) $(MAIN_O) $(PARSE_OPTS_O) -o $@ $(CFLAGS)

$(MAIN_O): main.c
	$(CC) -c $^ -o $@ -I $(SRC_DIR) $(CFLAGS)

$(PARSE_OPTS_O): $(SRC_DIR)/parse_opts.c
	$(CC) -c $^ -o $@ $(CFLAGS)

.PHONY: clean_all
clean_all: clean clean_ic

.PHONY: clean
clean:
	rm -f $(OBJ_DIR)/*
	
.PHONY: clean_ic
clean_ic:
	rm -f ./opts_*.ic
