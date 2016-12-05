BUILD_DIR=build
TITLE=Spécifications Xspec
DESTINATIONS=casa@sweetohm.org:/home/web/slides/specifications-xspec casa@sweetohm.net:/home/web/slides/specifications-xspec
OPTIONS={ratio: '4:3'}
SAXON_HOME=/opt/misc/saxon-he-9.7
XSPEC_HOME=/home/casa/doc/els/xspec

YELLOW=\033[1m\033[93m
CYAN=\033[1m\033[96m
CLEAR=\033[0m

all: clean slides xspec archive publish

help:
	@echo "$(YELLOW)This makefile has following targets:$(CLEAR)"
	@echo "$(CYAN)help$(CLEAR)    To print this help page"
	@echo "$(CYAN)slides$(CLEAR)  To generate slides in $(BUILD_DIR) directory"
	@echo "$(CYAN)xspec$(CLEAR)   To run Xspec test suite"
	@echo "$(CYAN)archive$(CLEAR) Building example archive"
	@echo "$(CYAN)publish$(CLEAR) To publish slides with rsync"
	@echo "$(CYAN)clean$(CLEAR)   To clean generated files in $(BUILD_DIR) directory"

slides:
	@echo "$(YELLOW)Generating slides$(CLEAR)"
	mkdir -p $(BUILD_DIR)
	mdpp README.md > $(BUILD_DIR)/README.md
	cp res/template.html $(BUILD_DIR)/index.html
	sed -i -e "s/<? TITLE ?>/$(TITLE)/g" $(BUILD_DIR)/index.html
	sed -i -e "/<? CONTENT ?>/{r $(BUILD_DIR)/README.md" -e "d}" $(BUILD_DIR)/index.html
	sed -i -e "s/<? OPTIONS ?>/$(OPTIONS)/g" $(BUILD_DIR)/index.html
	rm $(BUILD_DIR)/README.md
	cp -r res/ img/ $(BUILD_DIR)

xspec:
	@echo "$(YELLOW)Running Xspec test suite$(CLEAR)"
	mkdir -p $(BUILD_DIR)
	export SAXON_HOME=$(SAXON_HOME) && \
		export TEST_DIR=$(BUILD_DIR)/xspec && \
		$(XSPEC_HOME)/bin/xspec.sh src/xspec/main.xspec

archive:
	@echo "$(YELLOW)Building example archive$(CLEAR)"
	mkdir -p $(BUILD_DIR)/specifications-xspec
	cp -r src/* $(BUILD_DIR)/specifications-xspec/
	cd $(BUILD_DIR) && \
		zip specifications-xspec.zip -r specifications-xspec/ && \
		rm -rf specifications-xspec/

publish:
	@echo "$(YELLOW)Publishing slides$(CLEAR)"
	@for dest in $(DESTINATIONS); do \
		echo "Publishing to $${dest}..."; \
		rsync -av $(BUILD_DIR)/ $${dest}/ > /dev/null; \
	done

clean:
	@echo "$(YELLOW)Cleaning generated files$(CLEAR)"
	rm -rf $(BUILD_DIR)

