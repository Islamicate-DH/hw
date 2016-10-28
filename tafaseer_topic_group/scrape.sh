#!/bin/bash

session=scraper_session
madahib=10
tafaseer=(8 20 10 2 7 7 4 3 5 2)
last_sura=114
last_aaya=6

tmux new-session -d -s $session || exit

i=0; for madhab in `seq 1 $madahib`; do
  for tafsir in `seq 1 ${tafaseer[$((madhab-1))]}`; do
    i=$((i+1))
    tmux new-window -t $session:$i -n '' "Rscript altafsir_com_scraper.R --start=$madhab,$tafsir,1,1 --stop=$madhab,$tafsir,$last_sura,$last_aaya"
  done
done
