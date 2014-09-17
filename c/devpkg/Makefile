TARGET=devpkg
WARNINGS=-Wall -Wshadow -Wunreachable-code
CFLAGS=$(WARNINGS) -g -O -rdynamic -fdiagnostics-color -I/usr/include/apr-1
LDFLAGS=-lbstrlib -lapr-1
HEADERS=dbg.h db.h
OBJECTS=db.o shell.o commands.o devpkg.o

default: $(TARGET)
all: default

%.o: %.c $(HEADERS)
	gcc $(CFLAGS) -c $< -o $@

devpkg: $(OBJECTS)
	gcc $(OBJECTS) $(CFLAGS) $(LDFLAGS) -o $@

clean:
	rm -f $(OBJECTS)
	rm -f $(TARGET)

# Compile Check
cc:
	make all
	make clean
