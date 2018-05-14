echo '<html><body><h> My Papers </h><ul>' > papers.html
ls papers | sed 's/^\(.*\)\.pdf/<li><a href="papers\/\1.pdf">\1<\/a><\/li>/' >> papers.html
echo '</ul></body></html>' >> papers.html
