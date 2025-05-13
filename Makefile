SHELL := bash

ROOT := $(shell pwd -P)

HELM-DOCS-REPO := https://github.com/helm/helm-www

PYTHON := $(shell command -v python3)
PYTHON ?= $(shell command -v python)

PYTHON_VENV := $(ROOT)/.venv
VENV := source $(PYTHON_VENV)/bin/activate

DEPS := \
  $(PYTHON_VENV) \
  mkdocs.yml \
  docs/index.md \


default:

build: $(DIRS) $(DEPS)
	$(VENV) && mkdocs build

serve: $(DIRS) $(DEPS)
	$(VENV) && mkdocs serve
	mkdocs build

clean:
	$(RM) mkdocs.yml

realclean: clean
	$(RM) -r helm-www docs

distclean:
	$(RM) -r $(PYTHON_VENV)

$(PYTHON_VENV):
	$(PYTHON) -mvenv $@
	$(VENV) && pip install mkdocs-material

mkdocs.yml:
	$(RM) -r /tmp/foo
	$(VENV) && mkdocs new /tmp/foo
	mv /tmp/foo/$@ $@
	$(RM) -r /tmp/foo

docs/index.md: helm-www
	cp -r $</content/en/docs docs
	mv docs/_index.md $@

helm-www:
	git clone -q $(HELM-DOCS-REPO)
