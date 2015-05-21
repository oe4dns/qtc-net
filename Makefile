# This Makefile is for the qtc::net extension to perl.
#
PREFIX=/usr/local
DATADIR=/var/spool/qtc
CGIDIR=$(PREFIX)/share/qtc/cgi-bin
ETCDIR=/etc/qtc

# create perl makefile 
Makefile.PL.mk: Makefile.PL
	perl $<

all: Makefile.PL.mk
	make -f Makefile.PL.mk

install: Makefile.PL.mk
	make -f Makefile.PL.mk install
	if [ ! -d $(CGIDIR) ] ;\
	then \
		mkdir -p $(CGIDIR); \
	fi
	cp cgi-bin/*.cgi $(CGIDIR)
	if [ ! -d $(ETCDIR) ] ;\
	then \
		mkdir -p $(ETCDIR); \
	fi
	for etcfile in etc/qtc/* ; \
	do \
		if [ ! -f $etcfile ] ; \
		then \
			cp $etcfile $(ETCDIR) ; \
		fi ; \
	done

