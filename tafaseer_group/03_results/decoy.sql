SELECT COUNT(text), text AS char_count
  FROM cts_units
  WHERE cts_urn LIKE '%alzmkhshry%' AND sura_id=112 AND aaya_id=4;
