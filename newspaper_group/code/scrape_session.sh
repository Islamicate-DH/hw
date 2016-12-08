
#!/bin/bash

# Bash script used to call scraping function in R.
# This was done only for ahram. The function is called in a
# tmux session, the given days are downloaded parallel. 
# If the number of days is too high computer might freeze.
# In this case approximitely one month has proven to be a good choice. 

start="2010/12/1"

session=scraper_session
tmux new-session -d -s $session || exit    


days=$(seq 0 31 | xargs -I {} date -d "$start {} day" +%Y/%-m/%-d)
	   
i=0;
for day in $days; do
       i=$((i+1))       
       tmux new-window -t $session:$i -n '' "Rscript ahram.R --day=$day"
done


tmux attach-session -t $session
   

# echo date -d "$start + $intervall day" '+%Y/%-m/%-d'


