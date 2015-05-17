.DEFAULT_GOAL := build
.PHONY: test build clean

COFFEEQUATE_DIR = lib/Coffeequate/coffeequate/
COFFEEQUATE_BIN = $(COFFEEQUATE_DIR)/build/coffeequate.min.js
BIN = src/openjscad-solve.min.js
OBJ = $(addprefix src/, system.js core.js)

test: build
	jasmine

build: $(BIN)

$(BIN): $(COFFEEQUATE_BIN) $(OBJ)
	mkdir -p build
	r.js -o build.js

src/%.js: src/%.coffee
	coffee -c $<

$(COFFEEQUATE_BIN):
	pushd $(COFFEEQUATE_DIR)
	sh compile.sh
	popd

clean:
	rm -f src/*.js
	rm -rf build

