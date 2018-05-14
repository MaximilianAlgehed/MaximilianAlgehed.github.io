pandox index.md > index.html
./makePapersList.sh
./makeProjectsList.sh
git add papers/*.pdf
git add projects/*.md
git add projectsHTML/*.html
git commit -am "Publish"
git push
