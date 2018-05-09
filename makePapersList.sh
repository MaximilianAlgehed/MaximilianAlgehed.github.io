echo '<html><body>' > papers.html
ls papers | sed 's/^.*/<a href="papers\/&">&<\/a><br\/>/' >> papers.html
echo '</body></html>' >> papers.html
