#!/bin/bash

start="2015/1/1"



session=scraper_session
tmux new-session -d -s $session || exit    


days=$(seq 0 30 | xargs -I {} date -d "$start {} day" +%Y/%-m/%-d)
	   
# achtung leerzeichen!
i=0;
for day in $days; do
       i=$((i+1))       
#       tmux new-window -t $session:$i -n '' "Rscript ahramScraping.R --day=$day"
       tmux new-window -t $session:$i -n '' "Rscript hespress.R --day=$day"
done


tmux attach-session -t $session
   

echo date -d "$start + $intervall day" '+%Y/%-m/%-d'

# zum schluss mal einen test machen, obs auch wirlich funktioniert hat.
