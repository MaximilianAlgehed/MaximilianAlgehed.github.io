echo '<html><body><h1> My Papers </h1><ul>' > papers.html
ls papers | sed 's/^\(.*\)\.pdf/<li><a href="papers\/\1.pdf">\1<\/a><\/li>/' >> papers.html
echo '</ul></body></html>' >> papers.html
