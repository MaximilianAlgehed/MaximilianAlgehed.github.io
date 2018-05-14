echo '<html><body>' > papers.html
ls papers | sed 's/^\(.*\)\.pdf/<a href="papers\/\1.pdf">\1<\/a><br\/>/' >> papers.html
echo '</body></html>' >> papers.html
