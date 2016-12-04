SELECT
  --
  -- CATEGORY AND AUTHOR:
  -- same format as we use everywhere else
  --
  (SUBSTR('00'||category_id,-2,2) ||'-'|| SUBSTR('00'||author_id,-2,2))
    AS author_id,
    author_name,
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
  (CASE WHEN LENGTH(text) >= 1
        THEN 
          (LENGTH(text) - LENGTH(REPLACE(text, ' ', '')) + 1)
        ELSE
          (LENGTH(text) - LENGTH(REPLACE(text, ' ', '')))
        END)
    AS words_spent,
  --
  -- CHARACTER COUNT FOR AUTHOR'S WHOLE BOOK:
  -- doesn't work without a subquery, correct *word* count would
  -- need condition inside of it again so leaving that be as it
  -- would really push the running time of the query
  --
  (SELECT SUM(LENGTH(text)) FROM cts_units GROUP BY category_id, author_id)
    AS author_charcount,
  --
  -- RATIO BETWEEN PREVIOUS TWO NUMBERS:
  -- getting the ratio would just be a simple matter of
  -- dividing the smaller of the two numbers (words spent
  -- on the aaya) by the larger one (characters spent on
  -- the whole Quran) - unfortunately we must repeat both
  -- calculations here...
  --
  (CAST((CASE WHEN LENGTH(text) >= 1
        THEN 
          (LENGTH(text) - LENGTH(REPLACE(text, ' ', '')) + 1)
        ELSE
          (LENGTH(text) - LENGTH(REPLACE(text, ' ', '')))
        END) AS FLOAT)
      -- Don't miss the division, it's hiding right here!
      /
  ((SELECT SUM(LENGTH(text)) 
    FROM cts_units 
    GROUP BY category_id, author_id)
    -- Dividing charcount by 6 so the ratio doesn't come
    -- out extremely small. For German my feeling for avg.
    -- word length in a big corpus would have been 10, for
    -- Arabic 6 sounds like a sensible number (3-4 root
    -- chars usually, lots of meem at the beginning, lots
    -- of alif or ya in the middle, lots of tamarbouta at
    -- the end.
    / 10))
    AS ratio
FROM cts_units 
ORDER BY ratio, words_spent, passage ASC;
