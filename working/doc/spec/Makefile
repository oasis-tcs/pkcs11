INPUT_FILES = $(shell cat spec_files.txt)

all: docs

.PHONY: all build html pdf

docs: html pdf

html:
	pandoc -s \
		-f markdown-implicit_figures+mark \
		--toc \
		--toc-depth=6 \
		--number-sections \
		--variable toc-title:"Table of Contents" \
		--highlight-style code.theme \
		-o pkcs-spec-v3.3.html \
		$(INPUT_FILES)

pdf:
	pandoc -s \
		-H header.tex \
		-f markdown+mark \
		--toc \
		--toc-depth=6 \
		--number-sections \
		--variable toc-title:"Table of Contents" \
		--variable linkcolor:blue \
		--variable fontsize=10pt \
		--variable geometry:margin=1in \
		--variable mainfont="DejaVu Sans" \
		--variable monofont="DejaVu Sans Mono" \
		--pdf-engine=lualatex \
		--highlight-style code.theme \
		-o pkcs-spec-v3.3.pdf \
		$(INPUT_FILES)

latex:
	pandoc -s \
		-H header.tex \
		-f markdown-implicit_figures+mark \
		--toc \
		--toc-depth=6 \
		--number-sections \
		--variable toc-title:"Table of Contents" \
		--variable linkcolor:blue \
		--variable fontsize=10pt \
		--variable geometry:margin=1in \
		--variable mainfont="DejaVu Sans" \
		--variable monofont="DejaVu Sans Mono" \
		--pdf-engine=lualatex \
		--highlight-style code.theme \
		-o pkcs-spec-v3.3.latex \
		$(INPUT_FILES)
clean:
	-rm -rf *.html *.pdf *.latex
