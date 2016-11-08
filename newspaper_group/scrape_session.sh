#!/bin/bash

start="2010/12/13"
#13.2.2013
#in anderen ordner

#    session=scraper_session

# hopefully it's not too slow
#for run in `seq 1 2`; do
#    echo $run

    session=scraper_session
    tmux new-session -d -s $session || exit    


    days=$(seq 0 30 | xargs -I {} date -d "$start {} day" +%Y/%-m/%-d)
	   



   i=0;
   for day in $days; do
       i=$((i+1))       
       tmux new-window -t $session:$i -n '' "Rscript ahramScraping.R --day=$day"
   done


 tmux attach-session -t $session
   



   start=$(date -d "$start + 60 day" '+%Y/%-m/%-d')
#done

echo $start

# zum schluss mal einen test machen, obs auch wirlich funktioniert hat.
