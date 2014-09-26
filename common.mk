.PHONY: fetch fetch-default fetch-extra
.PHONY: extract extract-default extract-extra
.PHONY: build build-default build-extra
.PHONY: install install-default install-extra
.PHONY: clean clean-default clean-extra

.PHONY: all

SRCDIR:="$(CURDIR)/../src"
BUILDDIR:="$(CURDIR)/../build"

RUN:="$(CURDIR)/../run-script.sh"
FETCH:="$(CURDIR)/../download"

all: INSTALLED

INSTALLED:
	$(MAKE) fetch build install
	touch $@

clean:
	rm -rf $(BUILDDIR)/$(DIRNAME)
	rm -f INSTALLED

clean-extra:

clean: clean-default clean-extra

fetch-default:
	@echo "================================================="
	@echo "Fetching $(PACKAGE)-$(VERSION)"
	@echo "================================================="
	@( mkdir -p $(SRCDIR) && cd $(SRCDIR) && $(FETCH) $(URL) $(MD5) $(ARCHIVE) )

fetch-extra:

fetch: fetch-default fetch-extra

extract-default: fetch
	@echo "================================================="
	@echo "Extracting $(PACKAGE)-$(VERSION)"
	@echo "================================================="
	@mkdir -p $(PREFIX)
	@mkdir -p $(BUILDDIR)
	@rm -rf $(BUILDDIR)/$(DIRNAME)
	@tar xvf $(SRCDIR)/$(ARCHIVE) -C $(BUILDDIR)

extract-extra:

extract: extract-default extract-extra

build-default: extract
	@echo "================================================="
	@echo "Building $(PACKAGE)-$(VERSION)"
	@echo "================================================="
	@cd $(BUILDDIR)/$(DIRNAME) && $(RUN) $(CURDIR)/compile.sh

build-extra:

build: build-default build-extra

install-default:
	@echo "================================================="
	@echo "Installing $(PACKAGE)-$(VERSION)"
	@echo "================================================="
	@cd $(BUILDDIR)/$(DIRNAME) && $(RUN) $(CURDIR)/install.sh

install-extra:

install: install-default install-extra
