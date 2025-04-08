use [KurtYoung_SA]
go


/* ####################################
1.0 -- user_case_data.Attending_Physician
*/

alter table [sma_TRN_Hospitals] disable trigger all
go

insert into [sma_TRN_Hospitals]
	(
		[hosnCaseID],
		[hosnContactID],
		[hosnContactCtg],
		[hosnAddressID],
		[hossMedProType],
		[hosdStartDt],
		[hosdEndDt],
		[hosnPlaintiffID],
		[hosnComments],
		[hosnHospitalChart],
		[hosnRecUserID],
		[hosdDtCreated],
		[hosnModifyUserID],
		[hosdDtModified],
		[saga],
		[source_id],
		[source_db],
		[source_ref]
	)
	select
		cas.casnCaseID	  as [hosnCaseID],
		ioc.CID			  as [hosnContactID],
		ioc.CTG			  as [hosnContactCtg],
		ioc.AID			  as [hosnAddressID],
		'M'				  as [hossMedProType],
		null			  as [hosdStartDt],
		null			  as [hosdEndDt],
		p.plnnPlaintiffID as hosnPlaintiffID,
		null			  as [hosnComments],
		null			  as [hosnHospitalChart],
		368				  as [hosnRecUserID],
		GETDATE()		  as [hosdDtCreated],
		null			  as [hosnModifyUserID],
		null			  as [hosdDtModified],
		n.names_id		  as [saga],
		null			  as [source_id],
		null			  as [source_db],
		'value'			  as [source_ref]
	--select *
	from KurtYoung_Needles..user_case_data ud
	-- case
	join KurtYoung_Needles..cases c
		on c.casenum = CONVERT(VARCHAR, ud.casenum)
	join sma_TRN_Cases cas
		on cas.NeedlesCasenum = CONVERT(VARCHAR, ud.casenum)
	-- on cas.cassCaseNumber = convert(varchar, ud.casenum)
	-- Doctor contact card
	join KurtYoung_Needles..user_case_name un
		on un.casenum = ud.casenum
	join KurtYoung_Needles..user_case_matter um
		on um.ref_num = un.ref_num
			and um.mattercode = c.matcode
			and um.field_title = 'Attending Physician'
	join KurtYoung_Needles..names n
		on n.names_id = un.user_name
	join IndvOrgContacts_Indexed ioc
		on ioc.SAGA = n.names_id
	-- get Plaintiff
	join sma_TRN_Plaintiff p
		on p.plnnCaseID = cas.casnCaseID
			and p.plnbIsPrimary = 1
	where
		ISNULL(ud.Attending_Physician, '') <> ''

--SELECT * FROM KurtYoung_Needles..user_case_data ucd
--SELECT * FROM KurtYoung_Needles..user_case_name ucn
--SELECT * FROM KurtYoung_Needles..user_case_matter ucm

--FROM KurtYoung_Needles..user_case_data ucd
--	JOIN sma_trn_Cases cas
--		on cas.cassCaseNumber = convert(varchar,ucd.casenum)
--	-- Link to SA Contact Card via:
--	-- user_tab_data -> user_tab_name -> names -> IndvOrgContacts_Indexed
--	join KurtYoung_Needles.dbo.user_case_name ucn
--		on ucd.casenum = ucn.casenum
--	join KurtYoung_Needles.dbo.names n
--		on ucn.user_name = n.names_id
--	left join IndvOrgContacts_Indexed ioci
--		on n.names_id = ioci.saga
--		and ioci.CTG = 1
--	join [sma_TRN_Plaintiff] pln
--		on pln.plnnCaseID = cas.casnCaseID
--WHERE isnull(ucd.Attending_Physician,'')<>''



alter table [sma_TRN_Hospitals] enable trigger all