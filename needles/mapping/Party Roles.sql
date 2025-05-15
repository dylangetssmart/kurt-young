SELECT
	[role]
   ,COUNT(*) AS Count
FROM [KurtYoung_Needles]..party_Indexed
WHERE ISNULL([role], '') <> ''
GROUP BY [role]