$(shell [ -d .make ] || \
  (git clone -q https://github.com/makeplus/makes .make))
include .make/init.mk
include .make/python.mk

HELM-DOCS-REPO := https://github.com/helm/helm-www

DEPS := \
  $(PYTHON-VENV) \
  docs/index.md \

SITE-DOMAIN := docs.helmys.org
SITE-REMOTE := origin
SITE-BRANCH := site


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

clean::
	$(RM) -r site

realclean::
	$(RM) -r helm-www docs

distclean::
	$(RM) -r .make

docs/index.md: helm-www
	mkdir -p docs
	cp -r $</content/en/docs/* docs/
	for f in $$(find docs/ -name _index.md); \
	  do mv $$f $${f/_index/index}; \
	done


helm-www:
	git clone -q $(HELM-DOCS-REPO)
