
_default: all


DATA_JSON=src/data.json

POLICY_TEMPLATE=src/policy.yaml.tmpl
POLICY_RHTAP_TEMPLATE='src/policy-rhtap.yaml.tmpl'
POLICY_GITHUB_TEMPLATE='src/policy-github.yaml.tmpl'

ifndef GOMPLATE
	GOMPLATE=gomplate
endif

%/policy.yaml: $(POLICY_TEMPLATE) $(DATA_JSON) Makefile
	@mkdir -p $(*)
	@env NAME=$(*) $(GOMPLATE) -d data=$(DATA_JSON) --file $< \
		-t rhtap=$(POLICY_RHTAP_TEMPLATE) -t github=$(POLICY_GITHUB_TEMPLATE) \
		> $@

POLICY_FILES=$(shell jq -r '"\(.[].name)/policy.yaml"' src/data.json)

README_TEMPLATE=src/README.md.tmpl
README_RHTAP_TEMPLATE=src/README-rhtap.md.tmpl
README_GITHUB_TEMPLATE=src/README-github.md.tmpl
README_FILE=README.md

$(README_FILE): $(README_TEMPLATE) $(DATA_JSON) Makefile
	@$(GOMPLATE) -d data=$(DATA_JSON) --file $< \
		-t rhtap=$(README_RHTAP_TEMPLATE) -t github=$(README_GITHUB_TEMPLATE) \
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
	go install github.com/hairyhenderson/gomplate/v4/cmd/gomplate@latest
