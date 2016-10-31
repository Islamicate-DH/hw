#!/bin/bash

session=scraper_session # meaning
tmux new-session -d -s $session || exit

# First we set a starting-point and create a sequence of dates,
# we are interested in. That's the 2nd number after seq.
start="2005/01/01"
week=$(seq 1 30 | xargs -I {} date -d "$start {} day" +%Y/%-m/%-d)


# Now we start a session for each day, meaning we parallize the process
# making it way faster.
i=0;
for day in $week; do
    i=$((i+1))
    tmux new-window -t $session:$i -n '' "Rscript ahramScraping.R --day=$day"

done


tmux attach-session -t $session

