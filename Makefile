
CC=gcc

thp_move_pages: move_thp.c 
	$(CC) -o $@ $^ -lnuma -lm
	sudo setcap "all=ep" $@

non_thp_move_pages: move_base_page.c 
	$(CC) -o $@ $^ -lnuma -lm
	sudo setcap "all=ep" $@

bench: thp_move_pages non_thp_move_pages
	@echo -n "THP Migration: "
	@./thp_move_pages 1 2>/dev/null | grep -A 1 "Total\|Test"
	@sleep 3
	@echo "-------------------"
	@echo -n "BasePage Migration: "
	@./non_thp_move_pages 32 2>/dev/null | grep -A 1 "Total\|Test"
