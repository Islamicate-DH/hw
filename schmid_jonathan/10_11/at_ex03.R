#!/usr/bin/env Rscript
#
# Obacht! Interaktiver Modus und Skripte funktionieren in R teils verschieden
# voneinander. Interaktiv scan() = geskriptet readLines()! Oder man löst es wie
# unten zu sehen...

cat("\nBitte geben Sie eine positive ganze Zahl ein: ")
benutzereingabe = scan(file('stdin'), what = integer(), n = 1)
gausssche_summe = sum(1:benutzereingabe) # Wenn man Vektoren benutzen möchte.
                                         # Viel cooler ist Mathe:
                                         # gausssche_summe = x * (x - 1) / 2
cat(paste('Die Gaußsche Summe von', benutzereingabe, 'ist', gausssche_summe, "\n\n"))
