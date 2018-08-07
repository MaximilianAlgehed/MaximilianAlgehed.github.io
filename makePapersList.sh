echo '---\ntitle: My Papers\n---\n' > papers.md
ls papers | sed 's/^\(.*\)\.pdf/* [\1](papers\/\1.pdf)/' >> papers.md
