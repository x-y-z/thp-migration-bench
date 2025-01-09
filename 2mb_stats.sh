#!/bin/bash

for N in 1 2 4 8 16 32 64 128 256 512 768 1024; do for I in baseline mt_2 mt_4 mt_8 mt_16 mt_32; do grep THP ${N}_2mb_mthp/${I}.stats  | cut -d" " -f 6 | awk '{s+=$1}END{printf( "%.5f ",s/NR)}'; done; echo; done

