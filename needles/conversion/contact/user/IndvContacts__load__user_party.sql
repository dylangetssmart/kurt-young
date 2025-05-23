use [SA]
go

alter table [sma_MST_IndvContacts] disable trigger all
go

/* --------------------------------------------------------------------------------------------------------------
Insert Individual Contacts from [user_party_data].[witness_1]
*/
insert into [sma_MST_IndvContacts]
	(
		[cinbPrimary],
		[cinnContactTypeID],
		[cinnContactSubCtgID],
		[cinsPrefix],
		[cinsFirstName],
		[cinsMiddleName],
		[cinsLastName],
		[cinsSuffix],
		[cinsNickName],
		[cinbStatus],
		[cinsSSNNo],
		[cindBirthDate],
		[cinsComments],
		[cinnContactCtg],
		[cinnRefByCtgID],
		[cinnReferredBy],
		[cindDateOfDeath],
		[cinsCVLink],
		[cinnMaritalStatusID],
		[cinnGender],
		[cinsBirthPlace],
		[cinnCountyID],
		[cinsCountyOfResidence],
		[cinbFlagForPhoto],
		[cinsPrimaryContactNo],
		[cinsHomePhone],
		[cinsWorkPhone],
		[cinsMobile],
		[cinbPreventMailing],
		[cinnRecUserID],
		[cindDtCreated],
		[cinnModifyUserID],
		[cindDtModified],
		[cinnLevelNo],
		[cinsPrimaryLanguage],
		[cinsOtherLanguage],
		[cinbDeathFlag],
		[cinsCitizenship],
		[cinsHeight],
		[cinnWeight],
		[cinsReligion],
		[cindMarriageDate],
		[cinsMarriageLoc],
		[cinsDeathPlace],
		[cinsMaidenName],
		[cinsOccupation],
		[cinsSpouse],
		[cinsGrade],
		[saga],
		[source_id],
		[source_db],
		[source_ref]
	)
	select distinct
		1								 as [cinbPrimary],
		10								 as [cinnContactTypeID],
		null							 as [cinnContactSubCtgID],
		''								 as [cinsPrefix],
		dbo.get_firstword(upd.Witness_1) as [cinsFirstName],
		''								 as [cinsMiddleName],
		dbo.get_lastword(upd.Witness_1)	 as [cinsLastName],
		null							 as [cinsSuffix],
		null							 as [cinsNickName],
		1								 as [cinbStatus],
		null							 as [cinsSSNNo],
		null							 as [cindBirthDate],
		null							 as [cinsComments],
		1								 as [cinnContactCtg],
		''								 as [cinnRefByCtgID],
		''								 as [cinnReferredBy],
		null							 as [cindDateOfDeath],
		''								 as [cinsCVLink],
		''								 as [cinnMaritalStatusID],
		1								 as [cinnGender],
		''								 as [cinsBirthPlace],
		1								 as [cinnCountyID],
		1								 as [cinsCountyOfResidence],
		null							 as [cinbFlagForPhoto],
		null							 as [cinsPrimaryContactNo],
		''								 as [cinsHomePhone],
		''								 as [cinsWorkPhone],
		null							 as [cinsMobile],
		0								 as [cinbPreventMailing],
		368								 as [cinnRecUserID],
		GETDATE()						 as [cindDtCreated],
		''								 as [cinnModifyUserID],
		null							 as [cindDtModified],
		0								 as [cinnLevelNo],
		''								 as [cinsPrimaryLanguage],
		''								 as [cinsOtherLanguage],
		''								 as [cinbDeathFlag],
		''								 as [cinsCitizenship],
		null + null						 as [cinsHeight],
		null							 as [cinnWeight],
		''								 as [cinsReligion],
		null							 as [cindMarriageDate],
		null							 as [cinsMarriageLoc],
		null							 as [cinsDeathPlace],
		''								 as [cinsMaidenName],
		''								 as [cinsOccupation],
		''								 as [cinsSpouse],
		-1								 as [cinsGrade],
		''								 as [saga],
		upd.witness_1					 as [source_id],
		'needles'						 as [source_db],
		'user_party_data.witness_1'		 as [source_ref]
	from [Needles].[dbo].[user_party_data] upd
	where
		ISNULL(upd.Witness_1, '') <> ''
go

/* --------------------------------------------------------------------------------------------------------------
Insert Individual Contacts from [user_party_data].[witness_2]
*/
insert into [sma_MST_IndvContacts]
	(
		[cinbPrimary],
		[cinnContactTypeID],
		[cinnContactSubCtgID],
		[cinsPrefix],
		[cinsFirstName],
		[cinsMiddleName],
		[cinsLastName],
		[cinsSuffix],
		[cinsNickName],
		[cinbStatus],
		[cinsSSNNo],
		[cindBirthDate],
		[cinsComments],
		[cinnContactCtg],
		[cinnRefByCtgID],
		[cinnReferredBy],
		[cindDateOfDeath],
		[cinsCVLink],
		[cinnMaritalStatusID],
		[cinnGender],
		[cinsBirthPlace],
		[cinnCountyID],
		[cinsCountyOfResidence],
		[cinbFlagForPhoto],
		[cinsPrimaryContactNo],
		[cinsHomePhone],
		[cinsWorkPhone],
		[cinsMobile],
		[cinbPreventMailing],
		[cinnRecUserID],
		[cindDtCreated],
		[cinnModifyUserID],
		[cindDtModified],
		[cinnLevelNo],
		[cinsPrimaryLanguage],
		[cinsOtherLanguage],
		[cinbDeathFlag],
		[cinsCitizenship],
		[cinsHeight],
		[cinnWeight],
		[cinsReligion],
		[cindMarriageDate],
		[cinsMarriageLoc],
		[cinsDeathPlace],
		[cinsMaidenName],
		[cinsOccupation],
		[cinsSpouse],
		[cinsGrade],
		[saga],
		[source_id],
		[source_db],
		[source_ref]
	)
	select distinct
		1								 as [cinbPrimary],
		10								 as [cinnContactTypeID],
		null							 as [cinnContactSubCtgID],
		''								 as [cinsPrefix],
		dbo.get_firstword(upd.Witness_2) as [cinsFirstName],
		''								 as [cinsMiddleName],
		dbo.get_lastword(upd.Witness_2)	 as [cinsLastName],
		null							 as [cinsSuffix],
		null							 as [cinsNickName],
		1								 as [cinbStatus],
		null							 as [cinsSSNNo],
		null							 as [cindBirthDate],
		null							 as [cinsComments],
		1								 as [cinnContactCtg],
		''								 as [cinnRefByCtgID],
		''								 as [cinnReferredBy],
		null							 as [cindDateOfDeath],
		''								 as [cinsCVLink],
		''								 as [cinnMaritalStatusID],
		1								 as [cinnGender],
		''								 as [cinsBirthPlace],
		1								 as [cinnCountyID],
		1								 as [cinsCountyOfResidence],
		null							 as [cinbFlagForPhoto],
		null							 as [cinsPrimaryContactNo],
		''								 as [cinsHomePhone],
		''								 as [cinsWorkPhone],
		null							 as [cinsMobile],
		0								 as [cinbPreventMailing],
		368								 as [cinnRecUserID],
		GETDATE()						 as [cindDtCreated],
		''								 as [cinnModifyUserID],
		null							 as [cindDtModified],
		0								 as [cinnLevelNo],
		''								 as [cinsPrimaryLanguage],
		''								 as [cinsOtherLanguage],
		''								 as [cinbDeathFlag],
		''								 as [cinsCitizenship],
		null + null						 as [cinsHeight],
		null							 as [cinnWeight],
		''								 as [cinsReligion],
		null							 as [cindMarriageDate],
		null							 as [cinsMarriageLoc],
		null							 as [cinsDeathPlace],
		''								 as [cinsMaidenName],
		''								 as [cinsOccupation],
		''								 as [cinsSpouse],
		-1								 as [cinsGrade],
		''								 as [saga],
		upd.witness_2					 as [source_id],
		'needles'						 as [source_db],
		'user_party_data.witness_2'		 as [source_ref]
	from [Needles].[dbo].[user_party_data] upd
	where
		ISNULL(upd.Witness_2, '') <> ''
go

/* --------------------------------------------------------------------------------------------------------------
Insert Individual Contacts from [user_party_data].[witness_3]
*/
insert into [sma_MST_IndvContacts]
	(
		[cinbPrimary],
		[cinnContactTypeID],
		[cinnContactSubCtgID],
		[cinsPrefix],
		[cinsFirstName],
		[cinsMiddleName],
		[cinsLastName],
		[cinsSuffix],
		[cinsNickName],
		[cinbStatus],
		[cinsSSNNo],
		[cindBirthDate],
		[cinsComments],
		[cinnContactCtg],
		[cinnRefByCtgID],
		[cinnReferredBy],
		[cindDateOfDeath],
		[cinsCVLink],
		[cinnMaritalStatusID],
		[cinnGender],
		[cinsBirthPlace],
		[cinnCountyID],
		[cinsCountyOfResidence],
		[cinbFlagForPhoto],
		[cinsPrimaryContactNo],
		[cinsHomePhone],
		[cinsWorkPhone],
		[cinsMobile],
		[cinbPreventMailing],
		[cinnRecUserID],
		[cindDtCreated],
		[cinnModifyUserID],
		[cindDtModified],
		[cinnLevelNo],
		[cinsPrimaryLanguage],
		[cinsOtherLanguage],
		[cinbDeathFlag],
		[cinsCitizenship],
		[cinsHeight],
		[cinnWeight],
		[cinsReligion],
		[cindMarriageDate],
		[cinsMarriageLoc],
		[cinsDeathPlace],
		[cinsMaidenName],
		[cinsOccupation],
		[cinsSpouse],
		[cinsGrade],
		[saga],
		[source_id],
		[source_db],
		[source_ref]
	)
	select distinct
		1								 as [cinbPrimary],
		10								 as [cinnContactTypeID],
		null							 as [cinnContactSubCtgID],
		''								 as [cinsPrefix],
		dbo.get_firstword(upd.Witness_3) as [cinsFirstName],
		''								 as [cinsMiddleName],
		dbo.get_lastword(upd.Witness_3)	 as [cinsLastName],
		null							 as [cinsSuffix],
		null							 as [cinsNickName],
		1								 as [cinbStatus],
		null							 as [cinsSSNNo],
		null							 as [cindBirthDate],
		null							 as [cinsComments],
		1								 as [cinnContactCtg],
		''								 as [cinnRefByCtgID],
		''								 as [cinnReferredBy],
		null							 as [cindDateOfDeath],
		''								 as [cinsCVLink],
		''								 as [cinnMaritalStatusID],
		1								 as [cinnGender],
		''								 as [cinsBirthPlace],
		1								 as [cinnCountyID],
		1								 as [cinsCountyOfResidence],
		null							 as [cinbFlagForPhoto],
		null							 as [cinsPrimaryContactNo],
		''								 as [cinsHomePhone],
		''								 as [cinsWorkPhone],
		null							 as [cinsMobile],
		0								 as [cinbPreventMailing],
		368								 as [cinnRecUserID],
		GETDATE()						 as [cindDtCreated],
		''								 as [cinnModifyUserID],
		null							 as [cindDtModified],
		0								 as [cinnLevelNo],
		''								 as [cinsPrimaryLanguage],
		''								 as [cinsOtherLanguage],
		''								 as [cinbDeathFlag],
		''								 as [cinsCitizenship],
		null + null						 as [cinsHeight],
		null							 as [cinnWeight],
		''								 as [cinsReligion],
		null							 as [cindMarriageDate],
		null							 as [cinsMarriageLoc],
		null							 as [cinsDeathPlace],
		''								 as [cinsMaidenName],
		''								 as [cinsOccupation],
		''								 as [cinsSpouse],
		-1								 as [cinsGrade],
		''								 as [saga],
		upd.witness_3					 as [source_id],
		'needles'						 as [source_db],
		'user_party_data.witness_3'		 as [source_ref]
	from [Needles].[dbo].[user_party_data] upd
	where
		ISNULL(upd.Witness_3, '') <> ''
go

/* --------------------------------------------------------------------------------------------------------------
Insert Individual Contacts from [user_party_data].[contact_person]
*/
insert into [sma_MST_IndvContacts]
	(
		[cinbPrimary],
		[cinnContactTypeID],
		[cinnContactSubCtgID],
		[cinsPrefix],
		[cinsFirstName],
		[cinsMiddleName],
		[cinsLastName],
		[cinsSuffix],
		[cinsNickName],
		[cinbStatus],
		[cinsSSNNo],
		[cindBirthDate],
		[cinsComments],
		[cinnContactCtg],
		[cinnRefByCtgID],
		[cinnReferredBy],
		[cindDateOfDeath],
		[cinsCVLink],
		[cinnMaritalStatusID],
		[cinnGender],
		[cinsBirthPlace],
		[cinnCountyID],
		[cinsCountyOfResidence],
		[cinbFlagForPhoto],
		[cinsPrimaryContactNo],
		[cinsHomePhone],
		[cinsWorkPhone],
		[cinsMobile],
		[cinbPreventMailing],
		[cinnRecUserID],
		[cindDtCreated],
		[cinnModifyUserID],
		[cindDtModified],
		[cinnLevelNo],
		[cinsPrimaryLanguage],
		[cinsOtherLanguage],
		[cinbDeathFlag],
		[cinsCitizenship],
		[cinsHeight],
		[cinnWeight],
		[cinsReligion],
		[cindMarriageDate],
		[cinsMarriageLoc],
		[cinsDeathPlace],
		[cinsMaidenName],
		[cinsOccupation],
		[cinsSpouse],
		[cinsGrade],
		[saga],
		[source_id],
		[source_db],
		[source_ref]
	)
	select distinct
		1									 as [cinbPrimary],
		(
			select
				octnOrigContactTypeID
			from [dbo].[sma_MST_OriginalContactTypes]
			where octsDscrptn = 'General'
				and octnContactCtgID = 1
		)									 as [cinnContactTypeID],
		null								 as [cinnContactSubCtgID],
		''									 as [cinsPrefix],
		dbo.get_firstword(up.Contact_Person) as [cinsFirstName],
		''									 as [cinsMiddleName],
		dbo.get_lastword(up.Contact_Person)	 as [cinsLastName],
		null								 as [cinsSuffix],
		null								 as [cinsNickName],
		1									 as [cinbStatus],
		null								 as [cinsSSNNo],
		null								 as [cindBirthDate],
		null								 as [cinsComments],
		1									 as [cinnContactCtg],
		''									 as [cinnRefByCtgID],
		''									 as [cinnReferredBy],
		null								 as [cindDateOfDeath],
		''									 as [cinsCVLink],
		''									 as [cinnMaritalStatusID],
		1									 as [cinnGender],
		''									 as [cinsBirthPlace],
		1									 as [cinnCountyID],
		1									 as [cinsCountyOfResidence],
		null								 as [cinbFlagForPhoto],
		null								 as [cinsPrimaryContactNo],
		up.Contacts_Phone_Number			 as [cinsHomePhone],
		''									 as [cinsWorkPhone],
		null								 as [cinsMobile],
		0									 as [cinbPreventMailing],
		368									 as [cinnRecUserID],
		GETDATE()							 as [cindDtCreated],
		''									 as [cinnModifyUserID],
		null								 as [cindDtModified],
		0									 as [cinnLevelNo],
		''									 as [cinsPrimaryLanguage],
		''									 as [cinsOtherLanguage],
		''									 as [cinbDeathFlag],
		''									 as [cinsCitizenship],
		null + null							 as [cinsHeight],
		null								 as [cinnWeight],
		''									 as [cinsReligion],
		null								 as [cindMarriageDate],
		null								 as [cinsMarriageLoc],
		null								 as [cinsDeathPlace],
		''									 as [cinsMaidenName],
		''									 as [cinsOccupation],
		''									 as [cinsSpouse],
		-1									 as [cinsGrade],
		''									 as [saga],
		up.Contact_Person					 as [source_id],
		'needles'							 as [source_db],
		'user_party_data.Contact_Person'	 as [source_ref]
	from Needles.[dbo].[user_party_data] up
	where
		ISNULL(Contact_Person, '') <> ''
go

/* --------------------------------------------------------------------------------------------------------------
Insert Individual Contacts from [user_party_data].[spouse]
*/
insert into [sma_MST_IndvContacts]
	(
		[cinbPrimary],
		[cinnContactTypeID],
		[cinnContactSubCtgID],
		[cinsPrefix],
		[cinsFirstName],
		[cinsMiddleName],
		[cinsLastName],
		[cinsSuffix],
		[cinsNickName],
		[cinbStatus],
		[cinsSSNNo],
		[cindBirthDate],
		[cinsComments],
		[cinnContactCtg],
		[cinnRefByCtgID],
		[cinnReferredBy],
		[cindDateOfDeath],
		[cinsCVLink],
		[cinnMaritalStatusID],
		[cinnGender],
		[cinsBirthPlace],
		[cinnCountyID],
		[cinsCountyOfResidence],
		[cinbFlagForPhoto],
		[cinsPrimaryContactNo],
		[cinsHomePhone],
		[cinsWorkPhone],
		[cinsMobile],
		[cinbPreventMailing],
		[cinnRecUserID],
		[cindDtCreated],
		[cinnModifyUserID],
		[cindDtModified],
		[cinnLevelNo],
		[cinsPrimaryLanguage],
		[cinsOtherLanguage],
		[cinbDeathFlag],
		[cinsCitizenship],
		[cinsHeight],
		[cinnWeight],
		[cinsReligion],
		[cindMarriageDate],
		[cinsMarriageLoc],
		[cinsDeathPlace],
		[cinsMaidenName],
		[cinsOccupation],
		[cinsSpouse],
		[cinsGrade],
		[saga],
		[source_id],
		[source_db],
		[source_ref]
	)
	select distinct
		1							  as [cinbPrimary],
		(
			select
				octnOrigContactTypeID
			from [dbo].[sma_MST_OriginalContactTypes]
			where octsDscrptn = 'General'
				and octnContactCtgID = 1
		),
		null						  as [cinnContactSubCtgID],
		''							  as [cinsPrefix],
		dbo.get_firstword(upd.Spouse) as [cinsFirstName],
		''							  as [cinsMiddleName],
		dbo.get_lastword(upd.Spouse)  as [cinsLastName],
		null						  as [cinsSuffix],
		null						  as [cinsNickName],
		1							  as [cinbStatus],
		upd.Spouses_SS_Number		  as [cinsSSNNo],
		case
			when (upd.Spouses_DOB between '1900-01-01' and '2079-06-06')
				then upd.Spouses_DOB
			else null
		end							  as [cindBirthDate],
		null						  as [cinsComments],
		1							  as [cinnContactCtg],
		''							  as [cinnRefByCtgID],
		''							  as [cinnReferredBy],
		null						  as [cindDateOfDeath],
		''							  as [cinsCVLink],
		''							  as [cinnMaritalStatusID],
		1							  as [cinnGender],
		''							  as [cinsBirthPlace],
		1							  as [cinnCountyID],
		1							  as [cinsCountyOfResidence],
		null						  as [cinbFlagForPhoto],
		null						  as [cinsPrimaryContactNo],
		''							  as [cinsHomePhone],
		''							  as [cinsWorkPhone],
		null						  as [cinsMobile],
		0							  as [cinbPreventMailing],
		368							  as [cinnRecUserID],
		GETDATE()					  as [cindDtCreated],
		''							  as [cinnModifyUserID],
		null						  as [cindDtModified],
		0							  as [cinnLevelNo],
		''							  as [cinsPrimaryLanguage],
		''							  as [cinsOtherLanguage],
		''							  as [cinbDeathFlag],
		''							  as [cinsCitizenship],
		null + null					  as [cinsHeight],
		null						  as [cinnWeight],
		''							  as [cinsReligion],
		null						  as [cindMarriageDate],
		null						  as [cinsMarriageLoc],
		null						  as [cinsDeathPlace],
		''							  as [cinsMaidenName],
		''							  as [cinsOccupation],
		''							  as [cinsSpouse],
		-1							  as [cinsGrade],
		''							  as [saga],
		upd.Spouse					  as [source_id],
		'needles'					  as [source_db],
		'user_party_data.spouse'	  as [source_ref]
	from [Needles].[dbo].[user_party_data] upd
	where
		ISNULL(upd.Spouse, '') <> ''

go
--
alter table [sma_MST_IndvContacts] enable trigger all
go
