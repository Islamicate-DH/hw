# Copyright John Mathena & Tobias Wenzel
# In Course: Islamicate World 2.0
# University of Maryland, University Leipzig
#
# File description:
#     This script is used to create histograms
#     for each topic found during the TM.


library(ggplot2)
filename <- "~/Dokumente/hw/islamicate2.0/MFWs_by_newspaper_TM_Egyptian revolution_general.csv"
mfw <- read.csv(file = filename, sep = ",", fileEncoding = "UTF-8", header = T)

wf <- data.frame(word=mfw[,1],freq=mfw[,2])
wf <- wf[order(wf$freq, decreasing = F),]

wf$word <- factor(wf$word, levels = wf$word[order(wf$freq,decreasing = T)])


png("~/Dokumente/islamicate2.0/hw/newspaper_group/pics/MFWs_by_newspaper_TM_Egyptian revolution_general.png",
    width=1080,height=800)
p <- ggplot(wf[1:25,], aes(word, freq))+ labs(y="fequency")
p <- p + geom_bar(stat="identity")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1, size = 22),
               axis.title.x=element_blank(),
               axis.title.y = element_text(size=22, angle = 90)) 
p
dev.off()
