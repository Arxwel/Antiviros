#!/bin/bash
ADA_BIB="/opt/LibAda"
ADAX_PATH="$ADA_BIB/x11ada"
ADA_FORMS="$ADA_BIB/lib"
ADA_OBJECTS_PATH="$ADAX_PATH:$ADA_BIB"
ADA_INCLUDE_PATH="$ADAX_PATH:$ADA_BIB"
LD_LIBRARY_PATH="$ADA_FORMS"
export ADA_OBJECTS_PATH ADA_INCLUDE_PATH LD_LIBRARY_PATH
#LARGS="-L/usr/X11R6/lib -largs -lforms -largs ${ADAX_PATH}/var.o -largs -lX11 -largs -lXm -largs -lXt"
LARGS="-L$ADA_FORMS -largs -lforms -largs ${ADAX_PATH}/var.o -largs -lX11"
gnatmake -aIsrc -aOobj antivirus.adb avgraphique.adb $LARGS
rm -rf *.ali *.o
