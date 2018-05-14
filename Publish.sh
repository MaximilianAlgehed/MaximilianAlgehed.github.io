pandoc -f markdown index.md -t html > index.html
pandoc -f markdown projects.md -t html > projects.html
./makePapersList.sh
./makeProjectsList.sh
git add papers/*.pdf
git add projects/*.md
git add projectsHTML/*.html
git commit -am "Publish"
git push
