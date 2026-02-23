prefix ?= /usr/local
destdir ?= $(prefix)
config ?= release
arch ?=
static ?= false
linker ?=

PONYC_FLAGS ?=

BUILD_DIR ?= build/$(config)
SRC_DIR ?= pony_lint
binary := $(BUILD_DIR)/pony-lint

ifdef config
	ifeq (,$(filter $(config),debug release))
		$(error Unknown configuration "$(config)")
	endif
endif

ifeq ($(config),debug)
	PONYC_FLAGS += --debug
endif

ifneq ($(arch),)
	PONYC_FLAGS += --cpu $(arch)
endif

ifdef static
	ifeq (,$(filter $(static),true false))
		$(error "static must be true or false)
	endif
endif

ifeq ($(static),true)
	LINKER += --static
endif

ifneq ($(linker),)
	LINKER += --link-ldcmd=$(linker)
endif

# Default to version from `VERSION` file but allowing overriding on the
# make command line like:
# make version="nightly-19710702"
# overridden version *should not* contain spaces or characters that aren't
# legal in filesystem path names
ifndef version
	version := $(shell cat VERSION)
	ifneq ($(wildcard .git),)
		sha := $(shell git rev-parse --short HEAD)
		tag := $(version)-$(sha)
	else
		tag := $(version)
	endif
else
	foo := $(shell touch VERSION)
	tag := $(version)
endif

SOURCE_FILES := $(shell find $(SRC_DIR) -name \*.pony)
VERSION := "$(tag) [$(config)]"
GEN_FILES_IN := $(shell find $(SRC_DIR) -name \*.pony.in)
GEN_FILES = $(patsubst %.pony.in, %.pony, $(GEN_FILES_IN))

%.pony: %.pony.in VERSION
	sed s/%%VERSION%%/$(version)/ $< > $@

$(binary): $(GEN_FILES) $(SOURCE_FILES) | $(BUILD_DIR)
	corral fetch
	corral run -- ponyc $(PONYC_FLAGS) $(LINKER) $(SRC_DIR) -o $(BUILD_DIR) -b pony-lint

install: $(binary)
	@echo "install"
	mkdir -p $(DESTDIR)$(prefix)/bin
	cp $^ $(DESTDIR)$(prefix)/bin

test: $(binary)
	corral fetch
	corral run -- ponyc $(PONYC_FLAGS) $(LINKER) test -o $(BUILD_DIR) -b test
	$(BUILD_DIR)/test --sequential

lint: $(binary)
	$(binary) $(SRC_DIR) test

clean:
	corral clean
	rm -rf $(BUILD_DIR) $(GEN_FILES)

all: test $(binary)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: all clean install test lint
