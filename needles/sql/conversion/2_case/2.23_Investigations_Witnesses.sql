use KurtYoung_SA
go

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
	select
		cas.casnCaseID as [witnCaseID],
		ioci.UNQCID	   as [witnWitnesContactID],
		ioci.AID	   as [witnWitnesAdID],
		null		   as [witnRoleID],
		null		   as [witnFavorable],
		null		   as [witnTestify],
		null		   as [witdStmtReqDate],
		null		   as [witdStmtDate],
		null		   as [witbHasRec],
		null		   as [witsDoc],
		null		   as [witsComment],
		368			   as [witnRecUserID],
		GETDATE()	   as [witdDtCreated],
		null		   as [witnModifyUserID],
		null		   as [witdDtModified],
		null		   as [witnLevelNo]
	from KurtYoung_Needles..user_tab_data utd
	join sma_trn_Cases cas
		on cas.NeedlesCasenum = CONVERT(VARCHAR, utd.case_id)
	-- on cas.cassCaseNumber = convert(varchar,utd.case_id)
	-- Link to SA Contact Card via:
	-- user_tab_data -> user_tab_name -> names -> IndvOrgContacts_Indexed
	join KurtYoung_Needles.dbo.user_tab_name utn
		on utd.tab_id = utn.tab_id
	join KurtYoung_Needles.dbo.names n
		on utn.user_name = n.names_id
	left join IndvOrgContacts_Indexed ioci
		on n.names_id = ioci.saga
			and ioci.CTG = 1
	where
		ISNULL(utd.witness_name, '') <> ''