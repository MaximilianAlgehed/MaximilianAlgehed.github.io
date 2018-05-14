
PAPERS_PDFS=$(wildcard papers/*.pdf)
TOPLEVEL_HTML=$(patsubst %.md,%.html,$(wildcard *.md))
PROJECTS_HTML=$(patsubst projects/%.md,projectsHTML/%.html,$(wildcard projects/*.md))

all: $(TOPLEVEL_HTML) $(PROJECTS_HTML) papers.html

./%.html: ./%.md
	pandoc -f markdown $< -o $@

projectsHTML/%.html: projects/%.md
	pandoc -f markdown $< -o $@

papers.html: $(PAPERS_PDFS)
	./makePapersList.sh
