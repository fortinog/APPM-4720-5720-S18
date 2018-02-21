.SUFFIXES: .f .o
.SUFFIXES: .f90 .o
.SUFFIXES: .f90 .mod


FC = gfortran
FFLAGS = -O3 -g #-fbacktrace -fbounds-check
FINC   = 
LDFLAGS= -llapack -lblas

LD=$(FC) 

# Object files 

OBJS = type_defs.o problemsetup.o quad_element.o legendre_module.o appm5720_dg.o assemble.o weights.o 

dg.x: $(OBJS)
	$(LD) -o $@ $(OBJS) $(LDFLAGS)
.f.o:	
	$(FC) -c $(FFLAGS) $(FINC) $<
.f90.o:	
	$(FC) -c $(FFLAGS) $(FINC) $<

clean:
	rm -f *.o *.a *.mod
