
CC=gcc

thp_move_pages: move_thp.c 
	$(CC) -O3 -o $@ $^ -lnuma -lm
	sudo setcap "all=ep" $@

non_thp_move_pages: move_base_page.c 
	$(CC) -O3 -o $@ $^ -lnuma -lm
	sudo setcap "all=ep" $@

bench: thp_move_pages non_thp_move_pages
	@echo -n "THP Migration: "
	@./thp_move_pages 1 2>/dev/null | grep -A 1 "Total\|Test"
	@sleep 3
	@echo "-------------------"
	@echo -n "BasePage Migration: "
	@./non_thp_move_pages 32 2>/dev/null | grep -A 1 "Total\|Test"

bench2: thp_move_pages
	@echo -n "${NUM_PAGES} THP Migration: "
	@./thp_move_pages ${NUM_PAGES} 2>/dev/null | grep "Total\|Test\|num_copy_pages\|total_copy_pages_usec"

bench3: non_thp_move_pages
	@echo -n "${NUM_PAGES} BasePage Migration: "
	@./non_thp_move_pages ${NUM_PAGES} 2>/dev/null | grep "Total\|Test\|num_copy_pages\|total_copy_pages_usec"
