#!/bin/bash

session=scraper_session
madahib=10
tafaseer=(8 20 10 2 7 7 4 3 5 2)
last_sura=114
last_aaya=6

# Opens a new tmux session, preferably ran from outside tmux!
# I used this for a first run.
#
one_process_per_tafsir()
{
  tmux new-session -d -s $session || exit
  i=0; for madhab in `seq 1 $madahib`; do
    for tafsir in `seq 1 ${tafaseer[$((madhab-1))]}`; do
      i=$((i+1))
      tmux new-window -t $session:$i "Rscript altafsir_com_scraper.R --start=$madhab,$tafsir,1,1 --stop=$madhab,$tafsir,$last_sura,$last_aaya"
    done
  done
  tmux attach-session -t $session
}

# Runs from within tmux, must be in a session first!
# I used this for running a second time, to grab anything
# that wasn't downloaded during the first try, because of
# connection timeouts or whatever. 68 processes was a bit
# much for running on just 8 cores in hindsight, 10 should
# be a better fit, especially since the smaller madhahib
# (with 2 tafaseer each) will finish rather quickly, at
# which point it will become one process per core.
#
one_process_per_madhab()
{
  for madhab in `seq 1 $madahib`; do
    tmux new-window "Rscript altafsir_com_scraper.R --start=$madhab,1,1,1 --stop=$madhab,${tafaseer[$((madhab-1))]},$last_sura,$last_aaya"
  done
}

# As per Maxim's wish, downloading by tafsir again,
# two per core only this time.
one_tafsir_per_core()
{
  touch /tmp/scraped.dat
  while true; do
    cores=6
    starting_madhab=1
    starting_tafsir=1
    instances=$(ps ax | grep 'altafsir_com_scraper.R' | grep -E '([[s]tart|[s]top)' | wc -l)
    newest_instance=$(ps ax | grep 'altafsir_com_scraper.R' | grep -E '([[s]tart|[s]top)' | tail -1)
    newest_instance_start_pos=$(echo $newest_instance | cut -d '=' -f 3 | cut -d ' ' -f 1)
    
    if [ "$instances" == "" ]; then instances=0; fi
    if [ "$newest_instance" == "$madahib,$tafaseer[$((madahib-1))],1,1" ]; then
      echo "All through. Stop."
      break
    fi

    for madhab in `seq $starting_madhab $madahib`; do
      for tafsir in `seq 1 ${tafaseer[$((madhab-1))]}`; do
        start_pos="$madhab,$tafsir,1,1"
        stop_pos="$madhab,$tafsir,$last_sura,$last_aaya"
        range="$start_pos-$stop_pos"
        if [ "$instances" -le "$cores" ] && \
           [ "$range" != "$(grep $range /tmp/scraped.dat)" ]; then
          echo "Starting process to run from $start_pos to $stop_pos"
          echo "$range" >> /tmp/scraped.dat
          tmux new-window "rscript altafsir_com_scraper.r --start=$start_pos --stop=$stop_pos"
          instances=$((instances+1))
        fi
      done
    done

    gracetime=10
    echo "Sleeping for $gracetime seconds before trying to start new instances."
    sleep $gracetime
  done
}

$1 # First argument should be the function to run.
