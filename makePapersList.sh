echo '# My Papers' > papers.md
ls papers | sed 's/^\(.*\)\.pdf/* [\1](papers\/\1.pdf)/' >> papers.md
