Auto Dependency Makefile Example
--------------------------------

Despite having written my fair share of Makefiles, every time I need to start from scratch with a new Makefile, I wonder how it is done. Looking at the last Makefile usually don’t help, since they tend to become quite bloated with time. I also read on Wikipedia that the Makedepend program is now viewed as the last resort. Since I always used it, I wanted to see how else to do it.

There are a lot of “Hello World” examples out there, but I seldom find them complete. There for I made one, mostly for myself. It automatically updates the dependencies from all source files.

So in my example I have a src directory that looks like this:

```bash
ls -1 src/
classA.cc
classA.hh
classB.cc
classB.hh
main.cc
```

The main.cc file has one instance of classA and one of classB. The Makefile requires that there is one main.cc file, but there can be any number of class files.

The Makefile looks like this

```cmake
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
```

Try it out
----------
To see how it works, the easiest thing is to do:

```bash
git clone http://github.com/oddball/autoDependMakefileExample.git
cd autoDependMakefileExample
make
```

PS
--

When writing Makefiles, this is nice page to have in the background
http://www.gnu.org/s/hello/manual/make/Automatic-Variables.html

When doing automatic dependencies, this is an excellent article. Even if I find it incomplete
http://mad-scientist.net/make/autodep.html

Trying to figure out what the switches to g++ mean?
http://linux.die.net/man/1/g++

At last but not least. If you ever had a feeling that your recursive make does odd things, you should read this aegis.sourceforge.net/auug97.pdf
