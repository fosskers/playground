TARGET=linalg
WARNINGS=-Wall -Wshadow -Wunreachable-code
CFLAGS=$(WARNINGS) -g -O -fdiagnostics-color
LDFLAGS=-lgsl -lgslcblas -lm
HEADERS=
OBJECTS=$(TARGET).o
COMPILER=gcc

default: $(TARGET)
all: default

%.o: %.c $(HEADERS)
	$(COMPILER) $(CFLAGS) -c $< -o $@

linalg: $(OBJECTS)
	$(COMPILER) $(OBJECTS) $(CFLAGS) $(LDFLAGS) -o $@

clean:
	rm -f $(OBJECTS)
	rm -f $(TARGET)

# Compile Check
cc:
	make clean
	make all
