

all: main.js


main.js: src/Main.elm src/People.elm src/Teaching.elm src/Research.elm src/Publications.elm src/Utils.elm
	elm-make src/Main.elm --output main.js


.PHONY: clean

clean:
	rm main.js
