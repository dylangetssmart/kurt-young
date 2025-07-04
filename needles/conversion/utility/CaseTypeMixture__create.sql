use KurtYoung_SA
go

if exists (
		select
			*
		from sys.objects
		where name = 'CaseTypeMixture'
	)
begin
	drop table [dbo].[CaseTypeMixture]
end

go

set ansi_nulls on
go

set quoted_identifier on
go

create table [dbo].[CaseTypeMixture] (
	[matcode]					  [NVARCHAR](255) null,
	[header]					  [NVARCHAR](255) null,
	[description]				  [NVARCHAR](255) null,
	[SmartAdvocate Case Type]	  [NVARCHAR](255) null,
	[SmartAdvocate Case Sub Type] [NVARCHAR](255) null
) on [PRIMARY]

/*
Create matcode "AT"
*/
--if not exists (
--		select
--			1
--		from KurtYoung_Needles..matter
--		where matcode = 'AT'
--	)
--begin
--	insert into KurtYoung_Needles..matter
--		(
--			matcode,
--			header,
--			description
--		)
--		values
--		('AT', 'AUTO', 'Auto Accidents');
--end


insert into [dbo].[CaseTypeMixture]
	(
		[matcode],
		[header],
		[description],
		[SmartAdvocate Case Type],
		[SmartAdvocate Case Sub Type]
	)

	select
		[matcode],
		[header],
		[description],
		case
			when [description] is null
				then [matcode]
			else [description]
		end,
		'Unknown'
	from KurtYoung_Needles.[dbo].[matter] M
	order by description

/* ------------------------------------------------------------------------------
Add case types that are not defined in matter (somehow)
*/ ------------------------------------------------------------------------------

insert into [dbo].[CaseTypeMixture]
	(
		[matcode],
		[header],
		[description],
		[SmartAdvocate Case Type],
		[SmartAdvocate Case Sub Type]
	)
	select
		c.matcode,
		null	  as header,
		null	  as description,
		c.matcode as [SmartAdvocate Case Type],
		'Unknown' as [SmartAdvocate Case Sub Type]
	from (
		select distinct
			matcode
		from KurtYoung_Needles..cases
	) c
	where
		not exists (
			select
				1
			from [dbo].[CaseTypeMixture] m
			where m.matcode = c.matcode
		);

SELECT * FROM CaseTypeMixture ctm
	-- matcode, header, description, SA case type, SA case sub type
	--select
	--	'BR',
	--	'BANKRUPT',
	--	'Bankruptcy',
	--	'Bankruptcy',
	--	''
	--union
	--select
	--	'DS',
	--	'DSBLITY',
	--	'Disability - Social Security',
	--	'Disability - Social Security',
	--	''
	--union
	--select
	--	'MC',
	--	'MTRCYCLE',
	--	' Motorcycle Accident',
	--	' Motorcycle Accident',
	--	''
	--union
	--select
	--	'MM',
	--	'MED MAL',
	--	'Medical Malpractice',
	--	'Medical Malpractice',
	--	''
	--union
	--select
	--	'PL',
	--	'PREMISES',
	--	'Premises Liability',
	--	'Premises Liability',
	--	''
	--union
	--select
	--	'PR',
	--	'PROD LIA',
	--	'Product Liability',
	--	'Product Liability',
	--	''
	--union
	--select
	--	'TOX',
	--	'CAMP LEJ',
	--	'Camp Lejeune',
	--	'Camp Lejeune',
	--	''
	--union
	--select
	--	'WC',
	--	'WORKCOMP',
	--	'Worker''s Compensation',
	--	'Worker''s Compensation',
	--	''
	--union
	--select
	--	'ZIN',
	--	'INTAKE',
	--	'Intake - Prospective Client',
	--	'Intake - Prospective Client',
	--	''
	--union
	--select
	--	'ZLN',
	--	'LIEN',
	--	'P W/D S&S HAS LIEN ON CASE',
	--	'P W/D S&S HAS LIEN ON CASE',
	--	''
	--union
	--select
	--	'AT',
	--	'AUTO',
	--	'Auto Accidents',
	--	'Auto Accidents',
	--	''