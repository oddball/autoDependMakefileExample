DIRS    := src
SOURCES := $(foreach dir, $(DIRS), $(wildcard $(dir)/*.cc))
OBJS    := $(patsubst %.cc, %.o, $(SOURCES))
OBJS    := $(foreach o,$(OBJS),./obj/$(o))
DEPFILES:= $(patsubst %.o, %.P, $(OBJS))

CFLAGS   = -Wall -MMD -c
COMPILER = g++

#link the executable
main: $(OBJS)
	$(COMPILER) $(OBJS) -o main

#generate dependency information and compile
obj/%.o : %.cc
	@mkdir -p $(@D)
	$(COMPILER) $(CFLAGS) -o $@ -MF obj/$*.P $<
	@sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
	     -e '/^$$/ d' -e 's/$$/ :/' < obj/$*.P >> obj/$*.P;

#remove all generated files
clean:
	rm -f main
	rm -rf obj

#include the dependency information
-include $(DEPFILES)


#http://www.gnu.org/s/hello/manual/make/Automatic-Variables.html
#http://mad-scientist.net/make/autodep.html
#http://linux.die.net/man/1/g++
