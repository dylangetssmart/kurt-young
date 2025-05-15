use KurtYoung_SA
go

alter table [sma_TRN_CaseWitness] disable trigger all
go

SELECT * FROM SMA_MST_WitnessType smwt

select utd.case_id, utd.tab_id, utd.Witness_Name, utn.*, n.*
from KurtYoung_Needles..user_tab_data utd
join KurtYoung_Needles..user_tab_name utn
on utn.tab_id = utd.tab_id
join  KurtYoung_Needles..names n
on n.names_id = utn.user_name
where isnull(utd.Witness_Name,'')<>''


SELECT * FROM KurtYoung_Needles..user_tab_matter utm
SELECT * FROM KurtYoung_Needles..user_tab_name utn

/* --------------------------------------------------------------------------------------------------------------
Witness 1
*/
insert into [sma_TRN_CaseWitness]
	(
		[witnCaseID],
		[witnWitnesContactID],
		[witnWitnesAdID],
		[witnRoleID],
		[witnFavorable],
		[witnTestify],
		[witdStmtReqDate],
		[witdStmtDate],
		[witbHasRec],
		[witsDoc],
		[witsComment],
		[witnRecUserID],
		[witdDtCreated],
		[witnModifyUserID],
		[witdDtModified],
		[witnLevelNo]
	)
	select distinct
		c.casnCaseID as [witnCaseID],
		ioc.CID		 as [witnWitnesContactID],
		ioc.AID		 as [witnWitnesAdID],
		null		 as [witnRoleID],
		null		 as [witnFavorable],
		null		 as [witnTestify],
		null		 as [witdStmtReqDate],
		null		 as [witdStmtDate],
		null		 as [witbHasRec],
		null		 as [witsDoc],
		null		 as [witsComment],
		368			 as [witnRecUserID],
		GETDATE()	 as [witdDtCreated],
		null		 as [witnModifyUserID],
		null		 as [witdDtModified],
		null		 as [witnLevelNo]
	--select *
	from KurtYoung_Needles..user_tab_data utd
	join sma_TRN_Cases c
		on c.cassCaseNumber = CONVERT(VARCHAR, utd.case_id)
	join IndvOrgContacts_Indexed ioc
		on ioc.saga = utd.Witness_Name
	where
		ISNULL(utd.Witness_Name, '') <> ''
go

--select utd.case_id, utd.tab_id, utd.Witness_Name, utn.*, n.*
--from KurtYoung_Needles..user_tab_data utd
--join KurtYoung_Needles..user_tab_name utn
--on utn.tab_id = utd.tab_id
--join  KurtYoung_Needles..names n
--on n.names_id = utn.user_name
--where isnull(utd.Witness_Name,'')<>''

alter table [sma_TRN_CaseWitness] enable trigger all
go
