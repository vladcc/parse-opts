.PHONY: help
help:
	@echo 'make test'
	@echo 'make help'

OBJ_DIR := ./obj
MAIN_O := $(OBJ_DIR)/main.o
PARSE_OPTS_O := $(OBJ_DIR)/parse_opts.o
TEST_BIN := $(OBJ_DIR)/test

CC := gcc
CFLAGS := -Wall -Wfatal-errors

.PHONY: test
test: $(TEST_BIN)

$(TEST_BIN): $(MAIN_O) $(PARSE_OPTS_O)
	$(CC) $^ -o $@ $(CFLAGS)

$(MAIN_O): main.c
	$(CC) -c $^ -o $@ $(CFLAGS)

$(PARSE_OPTS_O): parse_opts.c
	$(CC) -c $^ -o $@ $(CFLAGS)
