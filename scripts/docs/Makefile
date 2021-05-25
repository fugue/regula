
.PHONY: build
build: metadata.json
	python -m venv venv
	. venv/bin/activate && pip install -q -r requirements.txt
	. venv/bin/activate && python rules_tables.py > rules.md

metadata.json:
	opa eval --format=pretty \
		-d ../../rego/rules \
		-d ../../rego/lib \
		data.rules > metadata.json
