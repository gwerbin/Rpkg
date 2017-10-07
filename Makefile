#CRAN_DEFAULT = https://cloud.r-project.org
R_INSTALL_QUICK = R CMD INSTALL --no-docs --no-multiarch --no-demo

RPKG_LOCAL_LIB = cli/library

RPKG_INSTALL_PREFIX = /usr/local
RPKG_INSTALL_BIN = $(RPKG_INSTALL_PREFIX)/bin
RPKG_INSTALL_SHARE = $(RPKG_INSTALL_PREFIX)/share/Rpkg
INSTALL_ARTIFACTS = $(RPKG_INSTALL_BIN)/Rpkg $(RPKG_INSTALL_SHARE)/library

$(RPKG_LOCAL_LIB):
	mkdir -p $@
$(RPKG_LOCAL_LIB)/Rpkg: package/Rpkg | $(RPKG_LOCAL_LIB)
	$(R_INSTALL_QUICK) -l $| $<

$(RPKG_INSTALL_BIN)/Rpkg: cli/Rpkg $(RPKG_LOCAL_LIB)/Rpkg
	cp -a $< $@
$(RPKG_INSTALL_SHARE)/library: $(RPKG_LOCAL_LIB)/Rpkg
	cp -a $< $@

.PHONY: setup install uninstall clean
setup: $(RPKG_LOCAL_LIB)/Rpkg
install: $(INSTALL_ARTIFACTS)
uninstall:
	rm -rf $(INSTALL_ARTIFACTS)
clean:
	R CMD REMOVE Rpkg
	rm -rf $(R_LIB)
