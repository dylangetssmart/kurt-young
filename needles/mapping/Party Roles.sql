SELECT
	[role]
   ,COUNT(*) AS Count
<<<<<<< HEAD
FROM [KurtYoung_Needles]..party_Indexed
=======
FROM [Needles]..party_Indexed
>>>>>>> d7f79dc97274c70cc19edf75cc36bfad72783475
WHERE ISNULL([role], '') <> ''
GROUP BY [role]