CRAN_DEFAULT = https://cloud.r-project.org
R_INSTALL_QUICK = R CMD INSTALL --no-docs --no-multiarch --no-demo
R_LIB = cli/library
RPKG_INSTALL_PREFIX = /usr/local/bin

setup: $(R_LIB)/Rpkg

$(R_LIB):
	mkdir -p $@
$(R_LIB)/Rpkg: package/Rpkg | $(R_LIB)
	$(R_INSTALL_QUICK) -l $| $<

install: setup
	ln -s $(PWD)/cli/bin/Rpkg $(RPKG_INSTALL_PREFIX)/Rpkg
