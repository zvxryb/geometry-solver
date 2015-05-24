.DEFAULT_GOAL := build
.PHONY: test build clean

COFFEEQUATE_DIR = lib/Coffeequate/coffeequate/src
COFFEEQUATE_SRC = $(wildcard $(COFFEEQUATE_DIR)/*.coffee $(COFFEEQUATE_DIR)/operators/*.coffee)
COFFEEQUATE_OBJ = $(COFFEEQUATE_SRC:.coffee=.js)
COFFEEQUATE_BIN = build/lib/coffeequate.js
BIN = build/openjscad-solve.min.js
BIN_DEBUG = build/openjscad-solve.debug.js
SRC = $(wildcard src/*.coffee)
OBJ = $(SRC:.coffee=.js)

test: build
	jasmine

build: $(BIN) $(BIN_DEBUG)

$(BIN): build.js $(COFFEEQUATE_BIN) $(OBJ)
	mkdir -p build
	r.js -o build.js

$(BIN_DEBUG): build.js $(COFFEEQUATE_OBJ) $(OBJ)
	mkdir -p build
	r.js -o build.js optimize=none out=build/openjscad-solve.debug.js

src/%.js: src/%.coffee
	coffee -c $<

$(COFFEEQUATE_BIN): build-lib-coffeequate.js $(COFFEEQUATE_OBJ)
	r.js -o build-lib-coffeequate.js

$(COFFEEQUATE_DIR)/%.js: $(COFFEEQUATE_DIR)/%.coffee
	coffee -c $<

clean:
	rm -f $(COFFEEQUATE_OBJ)
	rm -f $(OBJ)
	rm -rf build

