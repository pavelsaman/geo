INSTALL_DIR=~/.local/bin
URL=https://locationiq.com/

define remove
@echo ""
@echo "Removing geo..."
/bin/rm -f ${INSTALL_DIR}/geo.bash ${INSTALL_DIR}/geo-completion.bash
@echo "Done"
@echo ""
endef


all:
	@echo ""
	@echo "Please run 'make install'"
	@echo ""

install:
	@echo ""
	@echo "Installing Bashrepos..."
	mkdir -p ${INSTALL_DIR}
	cp geo.bash geo-completion.bash ${INSTALL_DIR}
	@echo "Done"
	@echo ""
	@echo "Please go to $(URL) to get an API key necessary for accessing the resource."
	@echo ""

uninstall:
	$(remove)

clean:
	$(remove)

.PHONY: all install uninstall clean
