TARGET=cello
WARNINGS=-Wshadow -Wunreachable-code
CFLAGS=-std=gnu99 $(WARNINGS) -g -O -fdiagnostics-color -DNDEBUG -I./libCello/include
LDFLAGS=-L./libCello/ -lCello -lm -lpthread -ldl
HEADERS=
OBJECTS=cello.o

default: $(TARGET)
all: default

%.o: %.c $(HEADERS)
	gcc $(CFLAGS) -c $< -o $@

cello: $(OBJECTS)
	gcc $(OBJECTS) $(CFLAGS) $(LDFLAGS) -o $@

clean:
	rm -f $(OBJECTS)
	rm -f $(TARGET)

# Compile Check
cc:
	make clean
	make all
