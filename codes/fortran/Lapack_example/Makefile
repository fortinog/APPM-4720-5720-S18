# An advanced makefile for the differentiation demo example
# Here we use the macros FC, FFLAGS, F90FLAGS and general rules for compiling 
# .f90 and .f files
# We also use the Macro OBJECTS to not have to keep track of the 
# object files in more than one place.
# The PHONY target clean has also been added

FC = gfortran
LD = gfortran
LDFLAGS = -llapack
FFLAGS = -O3 
F90FLAGS = -O3 -fbounds-check -Wall -fbacktrace -g 

OBJECTS = type_defs.o main.o
.PHONY: clean

heat.x: $(OBJECTS)
	$(LD) $(OBJECTS) -o heat.x $(LDFLAGS)

%.o : %.f90
	$(FC) $(F90FLAGS) -c $<

%.o : %.f
	$(FC) $(FFLAGS) -c $<

clean:
	rm -f $(OBJECTS) diff.x *.eps out.txt output.txt
