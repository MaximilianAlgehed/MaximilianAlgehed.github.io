
PAPERS_PDF=$(wildcard papers/*.pdf)
TOPLEVEL_HTML=$(patsubst %.md,%.html,$(wildcard *.md))
PROJECTS_HTML=$(patsubst projects/%.md,projectsHTML/%.html,$(wildcard projects/*.md))

all: $(TOPLEVEL_HTML) $(PROJECTS_HTML) papers.html

./%.html: ./%.md
	pandoc -s -f markdown $< -o $@

projectsHTML/%.html: projects/%.md
	pandoc -s -f markdown $< -o $@

papers.md: $(PAPERS_PDF) makePapersList.sh
	./makePapersList.sh
