TARGET=scope_main
CFLAGS=-Wall -g -fdiagnostics-color -DNDEBUG
HEADERS=scope.h ../dbg.h
OBJECTS=scope.o scope_main.o

default: $(TARGET)
all: default

%.o: %.c $(HEADERS)
	gcc $(CFLAGS) -c $< -o $@

scope: $(OBJECTS)
	gcc $(OBJECTS) $(CFLAGS) -o $@

clean:
	rm -f $(OBJECTS)
	rm -f $(TARGET)
