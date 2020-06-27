update:
	for i in ../../../libraries/*; do \
		if [ ! -d $$i ]; then continue; fi; \
		ln -sf -T $$i/latest $$(basename $$i); \
	done
	git add *
