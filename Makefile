.PHONY: clean, all
ADA_BIB="/home/romain/bibada"
ADAX_PATH="$ADA_BIB/x11ada"
ADA_FORMS="$ADA_BIB/lib"
OPTIONS_COMPIL=-L${ADA_FORMS} -largs -lforms -largs ${ADAX_PATH}/var.o -largs -lX11

all: clean shell graphique

shell:
	bash compile
	gnatmake antivirus.adb $(OPTIONS_COMPIL)

graphique:
	gnatmake avgraphique.adb $(OPTIONS_COMPIL)

clean:
	rm -rf antivirus avgraphique *.o *.ali
