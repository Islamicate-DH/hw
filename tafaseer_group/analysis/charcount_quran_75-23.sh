#!/bin/bash

SURA=75
AAYA=23

QUERY1="SELECT category_id, author_id, sum(length(text)) FROM cts_units WHERE sura_id = $SURA and aaya_id = $AAYA GROUP BY category_id, author_id;"
QUERY2="SELECT category_id, author_id, sum(length(text)) FROM cts_units GROUP BY category_id, author_id;"

DB_FILE="../../corpora/altafsir_com/processed/corpus.sqlite3"

echo "Character counts for $SURA:$AAYA..."
echo $QUERY1 | sqlite3 $DB_FILE
echo "Character counts for all the text..."
echo $QUERY2 | sqlite3 $DB_FILE
