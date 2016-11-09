#!/bin/bash

start="2013/12/1"
intervall=30

#13.2.2013 ##ahram
#in anderen ordner



session=scraper_session
tmux new-session -d -s $session || exit    


days=$(seq 0 $intervall | xargs -I {} date -d "$start {} day" +%Y/%-m/%-d)
	   

i=0;
for day in $days; do
       i=$((i+1))       
       #tmux new-window -t $session:$i -n '' "Rscript ahramScraping.R --day=$day"
       tmux new-window -t $session:$i -n ''"Rscript hespress.R -day=$day"
done


tmux attach-session -t $session
   

echo date -d "$start + $intervall day" '+%Y/%-m/%-d'

# zum schluss mal einen test machen, obs auch wirlich funktioniert hat.
