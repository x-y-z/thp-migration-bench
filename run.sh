#!/bin/bash

# NUM_PAGES_SEQ="1 256 512 768 1024"
# NUM_PAGES_SEQ="32 256 512 768"
# NUM_PAGES_SEQ="1024"
NUM_PAGES_SEQ="1 2 4 8 16 32 64 128 256 512 768 1024"
# NUM_PAGES_SEQ="256 512 768 1024"
# NUM_PAGES_SEQ="2 4 8 16 32"
# NUM_PAGES_SEQ="1 2 4 8 16 32"
MT_SEQ="2 4 8 16 32"

#2MB
for NUM_PAGES in ${NUM_PAGES_SEQ};
do
export NUM_PAGES

# FOLDER_NAME="${NUM_PAGES}_64kb_base"
FOLDER_NAME="${NUM_PAGES}_2mb_mthp"
# FOLDER_NAME="${NUM_PAGES}_512mb_thp"
BENCH=bench2

mkdir ${FOLDER_NAME}

echo ${FOLDER_NAME}

sudo sysctl vm/use_mt_copy=0 && for I in $(seq 1 10); do make ${BENCH} >> ${FOLDER_NAME}/baseline.stats; sleep 5; done

for MT in ${MT_SEQ};
do
sudo sysctl vm/use_mt_copy=1 && sudo sysctl vm/limit_mt_num=${MT} && for I in $(seq 1 10); do make ${BENCH} >> ${FOLDER_NAME}/mt_${MT}.stats; sleep 5; done
done

done

NUM_PAGES_SEQ="32 256 512 768 1024"
BASE_PAGE_SIZE_KB=$(echo "$(getconf PAGESIZE)/1024" | bc)
#64KB on arm64
for NUM_PAGES in ${NUM_PAGES_SEQ};
do
export NUM_PAGES

FOLDER_NAME="${NUM_PAGES}_${BASE_PAGE_SIZE_KB}kb_base"
BENCH=bench3

mkdir ${FOLDER_NAME}

echo ${FOLDER_NAME}

sudo sysctl vm/use_mt_copy=0 && for I in $(seq 1 10); do make ${BENCH} >> ${FOLDER_NAME}/baseline.stats; sleep 5; done

for MT in ${MT_SEQ};
do
sudo sysctl vm/use_mt_copy=1 && sudo sysctl vm/limit_mt_num=${MT} && for I in $(seq 1 10); do make ${BENCH} >> ${FOLDER_NAME}/mt_${MT}.stats; sleep 5; done
done

done
