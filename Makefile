CRAN_DEFAULT = https://cloud.r-project.org
R_INSTALL_QUICK = R CMD INSTALL --no-docs --no-multiarch --no-demo
R_LIB = cli/library

setup: $(R_LIB)/Rpkg

$(R_LIB):
	mkdir -p $@
$(R_LIB)/Rpkg: package/Rpkg | $(R_LIB)
	$(R_INSTALL_QUICK) -l $| $<

install: setup
	ln -s cli/bin/Rpkg /usr/local/bin/Rpkg
