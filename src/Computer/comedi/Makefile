CC=gcc 

CFLAGS=-c -Wall -fPIC

SOURCES=comedi_bridge.c 
OBJECTS=$(SOURCES:.c=.o)

.c.o:
	$(CC) $(CFLAGS) $< -o $@ 

lib: $(OBJECTS)
	$(CC) -shared -fPIC -lcomedi -lm -o comedi_bridge.so $(OBJECTS)

clean:
	rm *.o *.so
