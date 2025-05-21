use KurtYoung_SA
go

/* --------------------------------------------------------------------------------------------------------------
[user_case_data].[Employer_Name]
*/

--select
--	Employer_Name
--from KurtYoung_Needles..user_case_data ucd
--where
--	ISNULL(ucd.Employer_Name, '') <> ''

insert into [sma_MST_OrgContacts]
	(
		[consName],
		[consWorkPhone],
		[consComments],
		[connContactCtg],
		[connContactTypeID],
		[connRecUserID],
		[condDtCreated],
		[conbStatus],
		[saga],
		[source_id],
		[source_db],
		[source_ref]
	)
	select distinct
		ucd.Employer_Name			   as [consname],
		null						   as [consworkphone],
		null						   as [conscomments],
		2							   as [conncontactctg],
		(
			select
				octnOrigContactTypeID
			from [sma_MST_OriginalContactTypes]
			where octsDscrptn = 'General'
				and octnContactCtgID = 2
		)							   as [conncontacttypeid],

		368							   as [connrecuserid],
		GETDATE()					   as [conddtcreated],
		1							   as [conbstatus],
		null						   as [saga],
		ucd.Employer_Name			   as [source_id],
		'needles'					   as [source_db],
		'user_case_data.employer_name' as [source_ref]
	from [KurtYoung_Needles].[dbo].[user_case_data] ucd
	where
		ISNULL(ucd.Employer_Name, '') <> ''
go