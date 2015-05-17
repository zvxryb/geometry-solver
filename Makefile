.DEFAULT_GOAL := build
.PHONY: test build clean coffeequate

COFFEEQUATE_DIR = lib/Coffeequate/coffeequate/
BIN = src/openjscad-solve.min.js
OBJ = $(addprefix src/, system.js core.js)

test: build
	jasmine

build: $(BIN)

$(BIN): coffeequate $(OBJ)
	mkdir -p build
	r.js -o build.js

src/%.js: src/%.coffee
	coffee -c $<

coffeequate:
	cd $(COFFEEQUATE_DIR); sh compile.sh

clean:
	rm -f src/*.js
	rm -rf build

