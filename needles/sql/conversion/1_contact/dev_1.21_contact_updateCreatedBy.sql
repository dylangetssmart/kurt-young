/*
update user created by and modified by now that users exist

*/

--select * from sma_MST_IndvContacts
--select * from sma_MST_Users smu

use KurtYoung_SA
go

update ind
set ind.cinnRecUserID = u.usrnUserID
from sma_MST_IndvContacts ind
join KurtYoung_Needles..names n
	on n.names_id = ind.saga
join sma_MST_Users u
	on ind.cinnContactID = u.usrnContactID;



-----------------------------------------------------------------------------------------------
-- update org

--;with cte_org_contacts
--as
--(
--	select
--		names_id as names_id,
--		'Court' as contact_type
--	from KurtYoung_Needles..user_case_data ucd
--	join KurtYoung_Needles..user_case_fields ucf
--		on ucf.field_title = 'Court'
--	join KurtYoung_Needles..user_case_name ucn
--		on ucn.ref_num = ucf.field_num
--		and ucd.casenum = ucn.casenum
--	join KurtYoung_Needles..names n
--		on n.names_id = ucn.user_name
--	where ISNULL(ucd.COURT, '') <> ''

--)

--update sma_MST_OrgContacts
--set connContactTypeID =
----case
----	when cte.contact_type = 'Court'
----		then (
----				select
----					octnOrigContactTypeID
----				from [dbo].[sma_MST_OriginalContactTypes]
----				where octsDscrptn = 'Court'
----					and octnContactCtgID = 1
----			)
----end
--from sma_MST_OrgContacts org
--join cte_org_contacts cte
--	on org.saga = cte.names_id
