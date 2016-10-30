#!/bin/bash

session=scraper_session # meaning

 tmux new-session -d -s $session || exit

# do loop stuff
# since we have years/months/days it's a little bit different...

start="2005/01/31"

week=$(seq 1 10 | xargs -I {} date -d "$start {} day" +%Y/%-m/%-d)



# outer loop...
i=0;
for day in $week; do

    i=$((i+1))
    tmux new-window -t $session:$i -n '' "Rscript ahramScraping.R --day=$day"

done


tmux attach-session -t $session
