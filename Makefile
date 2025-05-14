SHELL := bash

ROOT := $(shell pwd -P)

HELM-DOCS-REPO := https://github.com/helm/helm-www

PYTHON := $(shell command -v python3)
PYTHON ?= $(shell command -v python)
ifndef PYTHON
  $(error Python doesn't seem to be installed)
endif

PYTHON_VENV := $(ROOT)/.venv
VENV := source $(PYTHON_VENV)/bin/activate

DEPS := \
  $(PYTHON_VENV) \
  docs/index.md \

SITE-DOMAIN := docs.helmys.org
SITE-REMOTE := origin
SITE-BRANCH := site


default:

build: site

site: $(DIRS) $(DEPS)
	$(RM) -r $@
	git worktree add -f $@
	$(RM) -r $@/*
	$(VENV) && mkdocs build
	# echo $(SITE-DOMAIN) > $@/CNAME
	git -C $@ add -A

publish: site
	-git -C $< commit -m "Publish $$(date)"
	git -C $< push $(SITE-REMOTE) HEAD:$(SITE-BRANCH) --force

serve: $(DIRS) $(DEPS)
	$(VENV) && mkdocs $@

clean:
	$(RM) -r site

realclean: clean
	$(RM) -r helm-www docs

distclean: realclean
	$(RM) -r $(PYTHON_VENV)

$(PYTHON_VENV):
	$(PYTHON) -mvenv $@
	$(VENV) && pip install mkdocs-material

docs/index.md: helm-www
	cp -r $</content/en/docs docs
	for f in $$(find docs/ -name _index.md); \
	  do mv $$f $${f/_index/index}; \
	done

helm-www:
	git clone -q $(HELM-DOCS-REPO)
