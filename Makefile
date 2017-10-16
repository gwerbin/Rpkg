## Config

#CRAN_DEFAULT = https://cloud.r-project.org
R_INSTALL_QUICK = R CMD INSTALL --no-docs --no-multiarch --no-demo

RPKG_LOCAL_LIB = cli/library

RPKG_INSTALL_PREFIX = /usr/local
RPKG_INSTALL_BIN = $(RPKG_INSTALL_PREFIX)/bin
RPKG_INSTALL_SHARE = $(RPKG_INSTALL_PREFIX)/share

SOURCES = package/Rpkg/R/rpkg.R
INSTALL_ARTIFACTS = $(RPKG_INSTALL_BIN)/Rpkg $(RPKG_INSTALL_SHARE)/Rpkg $(RPKG_INSTALL_SHARE)/Rpkg/library


## "Main"

# naked "make" is "make setup"

setup: $(RPKG_LOCAL_LIB)/Rpkg
install: $(INSTALL_ARTIFACTS)
uninstall:
	rm -rf $(INSTALL_ARTIFACTS)
clean:
	R CMD REMOVE Rpkg
	rm -rf $(R_LIB)
.PHONY: setup install uninstall clean


## Setup

$(RPKG_LOCAL_LIB):
	mkdir -p $@
# track individual files in SOURCES because Make doesn't reliably pick up on 
# whole-directory modifications
$(RPKG_LOCAL_LIB)/Rpkg: package/Rpkg $(SOURCES) | $(RPKG_LOCAL_LIB)
	$(R_INSTALL_QUICK) -l $| $<


## Install

$(RPKG_INSTALL_BIN)/Rpkg: cli/Rpkg $(RPKG_LOCAL_LIB)/Rpkg
	ln -s $(PWD)/$< $@
$(RPKG_INSTALL_SHARE)/Rpkg:
	mkdir -p $@
$(RPKG_INSTALL_SHARE)/Rpkg/library: $(RPKG_LOCAL_LIB)/Rpkg | $(RPKG_INSTALL_SHARE)/Rpkg
	ln -s $< $@


## Documentation

doc:
	mkdir -p $@
doc/index.html: README.md | doc
	pandoc --normalize --smart --standalone --from=markdown --to=html5 $< -o $@
