echo '<html><body>' > projects.html
ls projectsHTML | sed 's/^\(.*\)\.html/<a href="projectsHTML\/\1.html">\1<\/a><br\/>/' >> projects.html
echo '</body></html>' >> projects.html
