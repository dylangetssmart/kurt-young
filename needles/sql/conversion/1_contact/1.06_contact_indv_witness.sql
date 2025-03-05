use KurtYoung_SA
go

alter table [sma_MST_IndvContacts] disable trigger all
go

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
	select
		1									as [cinbprimary],
		(
			select
				octnOrigContactTypeID
			from [dbo].[sma_MST_OriginalContactTypes]
			where octsDscrptn = 'General'
				and octnContactCtgID = 1
		)									as [cinncontacttypeid],
		null								as [cinncontactsubctgid],
		''									as [cinsprefix],
		dbo.get_firstword(utd.Witness_Name) as [cinsfirstname],
		''									as [cinsmiddlename],
		dbo.get_lastword(utd.Witness_Name)  as [cinslastname],
		null								as [cinssuffix],
		null								as [cinsnickname],
		1									as [cinbstatus],
		null								as [cinsssnno],
		null								as [cindbirthdate],
		null								as [cinscomments],
		1									as [cinncontactctg],
		''									as [cinnrefbyctgid],
		''									as [cinnreferredby],
		null								as [cinddateofdeath],
		''									as [cinscvlink],
		''									as [cinnmaritalstatusid],
		1									as [cinngender],
		''									as [cinsbirthplace],
		1									as [cinncountyid],
		1									as [cinscountyofresidence],
		null								as [cinbflagforphoto],
		null								as [cinsprimarycontactno],
		null								as [cinshomephone],
		''									as [cinsworkphone],
		null								as [cinsmobile],
		0									as [cinbpreventmailing],
		368									as [cinnrecuserid],
		GETDATE()							as [cinddtcreated],
		''									as [cinnmodifyuserid],
		null								as [cinddtmodified],
		0									as [cinnlevelno],
		''									as [cinsprimarylanguage],
		''									as [cinsotherlanguage],
		''									as [cinbdeathflag],
		''									as [cinscitizenship],
		null								as [cinsheight],
		null								as [cinnweight],
		''									as [cinsreligion],
		null								as [cindmarriagedate],
		null								as [cinsmarriageloc],
		null								as [cinsdeathplace],
		''									as [cinsmaidenname],
		''									as [cinsoccupation],
		''									as [cinsspouse],
		null								as [cinsgrade],
		null								as [saga],
		utd.Witness_Name					as [source_id],
		'needles'							as [source_db],
		'user_tab_data.Witness_Name'		as [source_ref]
	from [KurtYoung_Needles].[dbo].user_tab_data utd
	where
		ISNULL(utd.Witness_Name, '') <> ''
go

alter table [sma_MST_IndvContacts] enable trigger all
go