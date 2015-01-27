TARGET=coordinates
WARNINGS=-Wall -Wshadow -Wunreachable-code
CFLAGS=$(WARNINGS) -g -O -fdiagnostics-color
LDFLAGS=-lGL -lglfw -lGLEW -lpthread -lm -lSOIL
HEADERS=ogls/opengl-shader.h ogls/dbg.h ogls/colour.h ogll/opengl-linalg.h
OBJECTS=ogls/opengl-shaders.o ogll/opengl-linalg.o coordinates.o
COMPILER=gcc

default: $(TARGET)
all: default

%.o: %.c $(HEADERS)
	$(COMPILER) $(CFLAGS) -c $< -o $@

coordinates: $(OBJECTS)
	$(COMPILER) $(OBJECTS) $(CFLAGS) $(LDFLAGS) -o $@

clean:
	rm -f $(OBJECTS)
	rm -f $(TARGET)

# Compile Check
cc:
	make clean
	make all
