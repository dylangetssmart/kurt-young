use KurtYoung_SA
go

-- Create Employer Org Contacts from case_intake.Employer_Name_Case
-- saga = ROW_ID

-- Create saga_ref field for another way to find these contacts
if not exists (
		select
			*
		from sys.columns
		where Name = N'saga_ref'
			and Object_ID = OBJECT_ID(N'sma_MST_OrgContacts')
	)
begin
	alter table [sma_MST_OrgContacts] add [saga_ref] [VARCHAR](100) null;
end
go

insert into [sma_MST_OrgContacts]
	(
		[consName],
		[connContactCtg],
		[connContactTypeID],
		[connRecUserID],
		[condDtCreated],
		[saga],
		[source_id],
		[source_db],
		[source_ref]
	)
	select
		ci.Employer_Name_Case  as [consName],
		2					   as [connContactCtg],
		(
			select
				octnOrigContactTypeID
			from [sma_MST_OriginalContactTypes]
			where octnContactCtgID = 2
				and octsDscrptn = 'General'
		)					   as [connContactTypeID],
		368					   as [connRecUserID],
		GETDATE()			   as [condDtCreated],
		ci.ROW_ID			   as [saga],
		null				   as [source_id],
		null				   as [source_db],
		'case_intake.employer' as [source_ref]
	from KurtYoung_Needles..case_intake ci
	where
		ISNULL(ci.Employer_Name_Case, '') <> ''