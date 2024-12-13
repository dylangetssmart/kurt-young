SELECT
	staff_code
   ,full_name
   ,active
   ,s.middle_name
   ,s.prefix
   ,s.suffix
FROM [JoelBieberNeedles].[dbo].[staff] s
ORDER BY active DESC