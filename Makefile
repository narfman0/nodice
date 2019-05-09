.PHONY: all NoDiceLib NoDice clean

all: NoDiceLib NoDice

###############################################################
# General
###############################################################

# NOTE: If compiling for a big-endian processor, remove "-DLSB_FIRST"

GCC := gcc
CFLAGS := -O3 -I src/NoDiceLib -DLSB_FIRST
AR := ar
ARFLAGS := rcs


###############################################################
# NoDiceLib (Core library)
###############################################################

# NoDiceLib labels
NDLSRCPATH := src/NoDiceLib/
NDLOBJPATH := obj/NoDiceLib/
NDLSOURCES := $(shell find $(NDLSRCPATH) -type f -name '*.c')
NDLOBJS := $(patsubst $(NDLSRCPATH)%, $(NDLOBJPATH)%, $(patsubst %.c,%.o,$(NDLSOURCES)))
NDLLIB := $(NDLOBJPATH)NoDiceLib.a

# NoDiceLib source and objects
$(NDLOBJPATH)%.o: $(NDLSRCPATH)%.c
	mkdir -p $(NDLOBJPATH)/M6502
	$(GCC) -c $(CFLAGS) $(NDLSRCPATH)$*.c -o $(NDLOBJPATH)$*.o

# NoDiceLib library
$(NDLLIB) : $(NDLOBJS)
	@echo Creating NoDiceLib library...
	$(AR) $(ARFLAGS) $(NDLLIB) $(NDLOBJS)

NoDiceLib: $(NDLLIB)


###############################################################
# NoDice (Level editor GUI)
###############################################################

# NoDice
GTKCFLAGS = $(shell pkg-config gtk+-2.0 --cflags)
GTKLIBS = $(shell pkg-config gtk+-2.0 --libs)
NDSRCPATH := src/NoDice/
NDOBJPATH := obj/NoDice/
NDSOURCES := $(shell find $(NDSRCPATH) -type f -name '*.c')
NDOBJS := $(patsubst $(NDSRCPATH)%, $(NDOBJPATH)%, $(patsubst %.c,%.o,$(NDSOURCES)))
NDBIN := bin/NoDice

# NoDice source and objects
$(NDOBJPATH)%.o: $(NDSRCPATH)%.c
	mkdir -p $(NDOBJPATH)
	$(GCC) -c $(CFLAGS) $(GTKCFLAGS) $(NDSRCPATH)$*.c -o $(NDOBJPATH)$*.o

# NoDice binary
$(NDBIN) : $(NDOBJS) $(NDLLIB)
	@echo Creating NoDice executable...
	$(GCC) $(NDOBJS) -o $(NDBIN) $(NDLLIB) $(GTKLIBS)

NoDice: $(NDBIN)
