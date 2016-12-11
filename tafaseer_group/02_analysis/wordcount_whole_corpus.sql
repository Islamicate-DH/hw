---
--- Helper table needed for second query
--- Get rid of it first if it already existed
---
DROP TABLE IF EXISTS wordcounts_by_author;
CREATE TABLE wordcounts_by_author(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, author_name CHAR(255) UNIQUE NOT NULL, words INTEGER NOT NULL);

---
--- Determine wordcounts for everything the author wrote
--- Note this doesn't take into consideration duplicate pages!
---
INSERT INTO wordcounts_by_author (author_name, words)
SELECT
  author_name,
  SUM((CASE WHEN LENGTH(text) >= 1
        THEN
          (LENGTH(text) - LENGTH(REPLACE(text, ' ', '')) + 1)
        ELSE
          (LENGTH(text) - LENGTH(REPLACE(text, ' ', '')))
        END)) AS words
FROM cts_units
GROUP BY author_name
ORDER BY words ASC;

---
--- Now determine wordcounts per page, if it's distinct from any other page
--- 
SELECT
  text_hash,
  --
  -- CATEGORY AND AUTHOR:
  -- same format as we use everywhere else
  --
  (SUBSTR('00'||category_id,-2,2) ||'-'|| SUBSTR('00'||author_id,-2,2))
    AS author_id,
    U.author_name,
  --
  -- QUR'AN PASSAGE:
  -- the way its usually given in literature
  --
  (SUBSTR('000'||sura_id,-3,3) ||':'|| SUBSTR('000'||aaya_id,-3,3))
    AS passage,
  --
  -- AMOUNT OF WORDS SPENT ON EACH AAYA:
  -- we have to use a condition here to get a good value
  -- http://stackoverflow.com/questions/3293790/query-to-count-words-sqlite-3
  --
  (CASE WHEN LENGTH(`text`) >= 1
        THEN
          (LENGTH(`text`) - LENGTH(REPLACE(`text`, ' ', '')) + 1)
        ELSE
          (LENGTH(`text`) - LENGTH(REPLACE(`text`, ' ', '')))
        END)
    AS words_spent,
  --
  -- CHARACTER COUNT FOR AUTHOR'S WHOLE BOOK:
  -- doesn't work without a subquery, correct *word* count would
  -- need condition inside of it again so leaving that be as it
  -- would really push the running time of the query
  --
  (W.words)
    AS author_wordcount,
  --
  -- PERCENTAGE OF AAYA WORDCOUNT WRT AUTHOR WORDCOUNT:
  -- getting the ratio is just a simple matter of
  -- dividing the smaller of the two numbers (words spent
  -- on the aaya) by the larger one (words spent on the
  -- whole of the Quran) - unfortunately we must repeat
  -- the words_spent calculation here
  --
  ROUND(100 * ((CASE WHEN LENGTH(`text`) >= 1
        THEN
          (LENGTH(`text`) - LENGTH(REPLACE(`text`, ' ', '')) + 1)
        ELSE
          (LENGTH(`text`) - LENGTH(REPLACE(`text`, ' ', '')))
        END) * 1.0 / W.words * 1.0), 5)
    AS percentage
FROM cts_units AS U
JOIN wordcounts_by_author AS W
  ON U.author_name=W.author_name
ORDER BY U.author_name ASC, percentage DESC, words_spent DESC, passage ASC;
