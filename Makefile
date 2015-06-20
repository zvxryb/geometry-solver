.DEFAULT_GOAL := build
.PHONY: test build clean

export PATH := node_modules/.bin:$(PATH)

BIN = geometrySolver.min.js
BIN_DEBUG = geometrySolver.debug.js
SRC_SUBDIRS = core geometry math
SRC_DIRS    = src $(addprefix src/, $(SRC_SUBDIRS))
SRC_PATTERN = $(addsuffix /*.coffee, $(SRC_DIRS))
SRC = $(wildcard $(SRC_PATTERN))
OBJ = $(SRC:.coffee=.js)

test: build
	jasmine

build: $(BIN) $(BIN_DEBUG)

$(BIN): build.js $(OBJ)
	mkdir -p build
	r.js -o build.js

$(BIN_DEBUG): build.js $(OBJ)
	mkdir -p build
	r.js -o build.js optimize=none out=geometrySolver.debug.js

src/%.js: src/%.coffee
	coffee -c $<

clean:
	rm -f $(BIN) $(BIN_DEBUG) $(OBJ)
	rm -rf build

