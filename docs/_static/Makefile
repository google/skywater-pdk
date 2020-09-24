
FAVICON_INPUT=skywater-favicon.png
FAVICON_OUTDIR=favicon

favicon:
	rm -rf $(FAVICON_OUTDIR)
	mkdir $(FAVICON_OUTDIR)
	convert -resize x16 -gravity center -crop 16x16+0+0 -flatten -colors 256 -background transparent $(FAVICON_INPUT) $(FAVICON_OUTDIR)/favicon-16x16.ico
	convert -resize x32 -gravity center -crop 32x32+0+0 -flatten -colors 256 -background transparent $(FAVICON_INPUT) $(FAVICON_OUTDIR)/favicon-32x32.ico
	convert $(FAVICON_OUTDIR)/favicon-16x16.ico $(FAVICON_OUTDIR)/favicon-32x32.ico $(FAVICON_OUTDIR)/favicon.ico
	convert -resize x152 -background transparent $(FAVICON_INPUT) $(FAVICON_OUTDIR)/apple-touch-icon-152x152.png
	convert -resize x120 -background transparent $(FAVICON_INPUT) $(FAVICON_OUTDIR)/apple-touch-icon-120x120.png
	convert -resize x76  -background transparent $(FAVICON_INPUT) $(FAVICON_OUTDIR)/apple-touch-icon-76x76.png
	convert -resize x60  -background transparent $(FAVICON_INPUT) $(FAVICON_OUTDIR)/apple-touch-icon-60x60.png

.PHONY: favicon
