TARGET=triangle
WARNINGS=-Wall -Wshadow -Wunreachable-code
CFLAGS=$(WARNINGS) -g -O -fdiagnostics-color
LDFLAGS=-lGL -lglfw -lGLEW -lpthread -lm
HEADERS=cog/shaders/shaders.h cog/linalg/linalg.h cog/camera/camera.h cog/dbg.h cog/colour.h
OBJECTS=cog/shaders/shaders.o cog/linalg/linalg.o cog/camera/camera.o triangle.o
COMPILER=clang

default: $(TARGET)
all: default

%.o: %.c $(HEADERS)
	$(COMPILER) $(CFLAGS) -c $< -o $@

triangle: $(OBJECTS)
	$(COMPILER) $(OBJECTS) $(CFLAGS) $(LDFLAGS) -o $@

clean:
	rm -f $(OBJECTS)
	rm -f $(TARGET)

# Compile Check
cc:
	make clean
	make all
