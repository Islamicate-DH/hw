-- CREATE TABLE wordcounts_by_author(
--   id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
--   author_name CHAR(255) UNIQUE NOT NULL, 
--   words INTEGER NOT NULL);
-- INSERT INTO wordcounts_by_author (author_name, words)
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
