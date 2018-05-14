ls projects |
  sed 's/^\(.*\)\.md/\1/' |
  xargs -n 1 -I file pandoc -f markdown projects/file.md -o projectsHTML/file.html

echo '<html><body>' > projects.html
ls projectsHTML | sed 's/^\(.*\)\.html/<a href="projectsHTML\/\1.html">\1<\/a><br\/>/' >> projects.html
echo '</body></html>' >> projects.html
