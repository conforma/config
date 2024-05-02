
_default: all


DATA_JSON=src/data.json

POLICY_TEMPLATE=src/policy.yaml.tmpl
POLICY_KONFLUX_TEMPLATE=src/policy-konflux.yaml.tmpl
POLICY_KONFLUX_TASKS_TEMPLATE=src/policy-konflux-tasks.yaml.tmpl
POLICY_RHTAP_TEMPLATE=src/policy-rhtap.yaml.tmpl
POLICY_GITHUB_TEMPLATE=src/policy-github.yaml.tmpl

ifndef GOMPLATE
	GOMPLATE=gomplate
endif

%/policy.yaml: $(POLICY_TEMPLATE) $(DATA_JSON) $(POLICY_KONFLUX_TEMPLATE) $(POLICY_KONFLUX_TASKS_TEMPLATE) $(POLICY_RHTAP_TEMPLATE) $(POLICY_GITHUB_TEMPLATE) Makefile
	@mkdir -p $(*)
	@env NAME=$(*) $(GOMPLATE) -d data=$(DATA_JSON) --file $< \
		-t konflux=$(POLICY_KONFLUX_TEMPLATE) \
		-t konflux-tasks=$(POLICY_KONFLUX_TASKS_TEMPLATE) \
		-t rhtap=$(POLICY_RHTAP_TEMPLATE) \
		-t github=$(POLICY_GITHUB_TEMPLATE) \
		-o $@

POLICY_FILES=$(shell jq -r '"\(keys | .[])/policy.yaml"' src/data.json)

README_TEMPLATE=src/README.md.tmpl
README_KONFLUX_TEMPLATE=src/README-konflux.md.tmpl
README_KONFLUX_TASKS_TEMPLATE=src/README-konflux-tasks.md.tmpl
README_RHTAP_TEMPLATE=src/README-rhtap.md.tmpl
README_GITHUB_TEMPLATE=src/README-github.md.tmpl
README_FILE=README.md

$(README_FILE): $(README_TEMPLATE) $(DATA_JSON) $(README_KONFLUX_TEMPLATE) $(README_KONFLUX_TASKS_TEMPLATE) $(README_RHTAP_TEMPLATE) $(README_GITHUB_TEMPLATE) Makefile
	@$(GOMPLATE) -d data=$(DATA_JSON) --file $< \
		-t konflux=$(README_KONFLUX_TEMPLATE) \
		-t konflux-tasks=$(README_KONFLUX_TASKS_TEMPLATE) \
		-t rhtap=$(README_RHTAP_TEMPLATE) \
		-t github=$(README_GITHUB_TEMPLATE) \
		> $@

all: $(POLICY_FILES) $(README_FILE)

clean:
	@rm -rf $(POLICY_FILES) $(README_FILE)

refresh: clean all

# Should produce an error if any generated files are not in sync with their template
update-needed-check:
	@$(MAKE) --no-print-directory refresh
	@if [ -n "$$(git diff --name-only -- $(POLICY_FILES) $(README_FILE))" ]; then echo "Stale generated files found. Refresh needed."; exit 1; fi

# Should produce an error if there is any invalid yaml
yaml-parse-check:
	@git ls-files '*.yaml' | xargs -n1 yq > /dev/null

ci: update-needed-check yaml-parse-check

# See https://docs.gomplate.ca/installing/ for other installation methods
install-gomplate:
	go install github.com/hairyhenderson/gomplate/v3/cmd/gomplate@latest
