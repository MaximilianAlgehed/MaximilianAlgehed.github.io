pandoc -f markdown index.md -t html -o index.html
pandoc -f markdown projects.md -t html -o projects.html
./makePapersList.sh
./makeProjectsList.sh
git add papers/*.pdf
git add projects/*.md
git add projectsHTML/*.html
git commit -am "Publish"
git push
