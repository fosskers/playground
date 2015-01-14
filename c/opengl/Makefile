TARGET=opengl
WARNINGS=-Wall -Wshadow -Wunreachable-code
CFLAGS=$(WARNINGS) -g -O -fdiagnostics-color
LDFLAGS=-lGL -lglfw -lGLEW -lpthread -lm
HEADERS=ogls/opengl-shader.h ogls/dbg.h ogls/colour.h
OBJECTS=ogls/opengl-shaders.o opengl.o

default: $(TARGET)
all: default

%.o: %.c $(HEADERS)
	gcc $(CFLAGS) -c $< -o $@

opengl: $(OBJECTS)
	gcc $(OBJECTS) $(CFLAGS) $(LDFLAGS) -o $@

clean:
	rm -f $(OBJECTS)
	rm -f $(TARGET)

# Compile Check
cc:
	make clean
	make all
