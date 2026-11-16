BLOCKDIAG ?= python3 -c "import PIL.Image, PIL.ImageDraw, PIL.ImageFont; PIL.Image.ANTIALIAS = getattr(PIL.Image, 'Resampling', PIL.Image).LANCZOS; PIL.ImageDraw.ImageDraw.textsize = lambda self, text, font=None, *args, **kwargs: (font.getbbox(text)[2] - font.getbbox(text)[0], font.getbbox(text)[3] - font.getbbox(text)[1]) if font else (len(text)*8, 16); PIL.ImageFont.FreeTypeFont.getsize = lambda self, text, *args, **kwargs: (self.getbbox(text)[2] - self.getbbox(text)[0], self.getbbox(text)[3] - self.getbbox(text)[1]); from blockdiag.command import main; import sys; sys.argv[0] = 'blockdiag'; main()"

DIAG_FILES = $(wildcard *.diag)
PNG_FILES = $(DIAG_FILES:.diag=.png)

%.png: %.diag
	$(BLOCKDIAG) $< -o $@

INPUT_FILES = $(shell cat spec_files.txt)

all: docs

.PHONY: all build html pdf clean

docs: html pdf

html: $(PNG_FILES)
	pandoc -s \
		-f markdown-implicit_figures+mark \
		--toc \
		--toc-depth=6 \
		--number-sections \
		--variable toc-title:"Table of Contents" \
		--highlight-style code.theme \
		-o pkcs-spec-v3.3.html \
		$(INPUT_FILES)

pdf: $(PNG_FILES)
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

latex: $(PNG_FILES)
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
	-rm -rf *.html *.pdf *.latex $(PNG_FILES)
