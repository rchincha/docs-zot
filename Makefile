SOURCES := $(wildcard *.adoc)
OBJECTS := $(patsubst %.adoc,%.html,${SOURCES})
MD_SOURCES := $(wildcard *.md)
MD_OBJECTS := $(patsubst %.md,%.adoc,${MD_SOURCES})

PROCESSOR ?= asciidoctor
MD2ADOC ?= pandoc --atx-headers --verbose  --wrap=none --toc --reference-links -f markdown+smart -t markdown-smart

.PHONY: all
all: md2adoc docs

.PHONY: docs
docs: ${OBJECTS}

%.html: %.adoc ${MD_OBJECTS}
	${PROCESSOR} $^

.PHONY: md2adoc
md2adoc: ${MD_OBJECTS}

%.adoc: %.md
	${MD2ADOC} -o $@ $<

.PHONY: clean
clean:
	rm -f *.html
