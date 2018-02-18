# An advanced makefile for the differentiation demo example
# Here we use the macros FC, FFLAGS, F90FLAGS and general rules for compiling 
# .f90 and .f files
# We also use the Macro OBJECTS to not have to keep track of the 
# object files in more than one place.
# The PHONY target clean has also been added

FC = gfortran
LD = gfortran
LDFLAGS = -llapack -lblas 
FFLAGS = -O3 
F90FLAGS = -O3 # -fbounds-check -Wall -fbacktrace -g 

OBJECTS = type_defs.o twilight_module.o wave.o
.PHONY: clean

wave.x: $(OBJECTS)
	$(LD) $(OBJECTS) -o wave.x $(LDFLAGS)

%.o : %.f90
	$(FC) $(F90FLAGS) -c $<

%.o : %.f
	$(FC) $(FFLAGS) -c $<

clean:
	rm -f $(OBJECTS) wave.x *.txt *.mod
