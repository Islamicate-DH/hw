SELECT 
  (SUBSTR('00'||category_id,-2,2) || '-' || SUBSTR('00'||author_id,-2,2))
    AS author_id,
  (SUBSTR('000'||sura_id,-3,3) || ':' || SUBSTR('000'||aaya_id,-3,3))
    AS passage, 
  LENGTH(label)
    AS aaya_length,
  LENGTH(text)
    AS chars_spent 
FROM cts_units 
ORDER BY chars_spent, aaya_length, author_id, passage;
