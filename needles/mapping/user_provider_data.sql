select
	cfu.[tablename],
	cfu.[column_name],
	[field_title],
	[field_type],
	[field_len],
	[caseid]		 as case_link,
	[ValueCount]	 as count,
	CFSD.field_value as [Sample Data]
from CustomFieldUsage CFU
left join CustomFieldSampleData CFSD
	on CFU.column_name = CFSD.column_name
		and CFU.tablename = CFSD.tablename
where
	CFU.tablename = 'user_provider_data'
	and ValueCount > 0
order by CFU.tablename, CFU.field_num


SELECT *
FROM KurtYoung_Needles..provider p
--join KurtYoung_Needles..user_pro


SELECT * FROM KurtYoung_Needles..user_provider up
SELECT * FROM KurtYoung_Needles..provider p where p.name_id in (149,155,4160)
SELECT * FROM KurtYoung_Needles..user_provider_data upd where upd.provider_id in (149,155,4160)
--SELECT * FROM KurtYoung_Needles..user_provider_fields upf
SELECT * FROM KurtYoung_Needles..user_provider_name upn
SELECT * FROM KurtYoung_Needles..names where names_id in (149,155, 4160)

SELECT * FROM KurtYoung_Needles..user_case_fields ucf where ucf.field_type = 'minidir'
SELECT * FROM KurtYoung_Needles..user_case_data ucd


SELECT * FROM KurtYoung_Needles..provider p where p.name_id in (149,155,4160)
SELECT * FROM KurtYoung_Needles..names where names_id in (149,155, 4160)
SELECT * FROM KurtYoung_Needles..user_provider up
SELECT * FROM KurtYoung_Needles..user_provider_data upd where upd.provider_id in (149,155,4160)
SELECT * FROM KurtYoung_Needles..user_provider_name upn where upn.provider_id in (149,155)

select * from KurtYoung_Needles..mini_dir_list mdl
select * from KurtYoung_Needles..mini_general_dir mgd

select dl.dir_name, gd.*
from mini_general_dir gd
JOIN mini_dir_list dl on gd.num_assigned = dl.dir_key where dl.dir_name = 'employertype' order by gd.num_assigned

SELECT * FROM KurtYoung_Needles..user_provider_data upd where isnull(upd.Employer_Type,'')<>''