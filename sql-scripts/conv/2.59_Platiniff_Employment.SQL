USE SANeedlesSLF
GO
/*
alter table [dbo].[sma_TRN_Employment] disable trigger all
delete from [dbo].[sma_TRN_Employment] 
DBCC CHECKIDENT ('[dbo].[sma_TRN_Employment]', RESEED, 0);
alter table [dbo].[sma_TRN_Employment] enable trigger all
*/

--sp_help [sma_TRN_Employment]

ALTER TABLE sma_TRN_Employment
	ALTER COLUMN [empsJobTitle] varchar(500)
GO


/* ####################################
1.0 -- From user_tab_data
*/

INSERT INTO [dbo].[sma_TRN_Employment]
           ([empnPlaintiffID]
           ,[empnEmprAddressID]
           ,[empnEmployerID]
           ,[empnContactPersonID]
           ,[empnCPAddressId]
           ,[empsJobTitle]
           ,[empnSalaryFreqID]
           ,[empnSalaryAmt]
           ,[empnCommissionFreqID]
           ,[empnCommissionAmt]
           ,[empnBonusFreqID]
           ,[empnBonusAmt]
           ,[empnOverTimeFreqID]
           ,[empnOverTimeAmt]
           ,[empnOtherFreqID]
           ,[empnOtherCompensationAmt]
           ,[empsComments]
           ,[empbWorksOffBooks]
           ,[empsCompensationComments]
           ,[empbWorksPartiallyOffBooks]
           ,[empbOnTheJob]
           ,[empbWCClaim]
           ,[empbContinuing]
           ,[empdDateHired]
           ,[empnUDF1]
           ,[empnUDF2]
           ,[empnRecUserID]
           ,[empdDtCreated]
           ,[empnModifyUserID]
           ,[empdDtModified]
           ,[empnLevelNo]
           ,[empnauthtodefcoun]
           ,[empnauthtodefcounDt]
           ,[empnTotalDisability]
           ,[empnAverageWeeklyWage]
           ,[empnEmpUnion]
           ,[NotEmploymentReasonID]
           ,[empdDateTo]
           ,[empsDepartment]
           ,[empdSent]
           ,[empdReceived]
           ,[empnStatusId]
           ,[empnWorkSiteId])
SELECT
	(
		select plnnPlaintiffID
		from sma_trn_plaintiff
		where plnnCaseID = cas.casncaseid and plnbIsPrimary = 1
	)										as [empnPlaintiffID]		--Plaintiff ID
	,A.addnAddressID						as [empnEmprAddressID]		--employer org AID
	,org.connContactID						as [empnEmployerID]			--employer org CID
	,null									as [empnContactPersonID]	--indv CID
	,null									as [empnCPAddressId]		--indv AID
    ,null									as [empsJobTitle]			--ds 6/6/2024 - Job Title
    ,(
		select fqmnFrequencyID
		from sma_MST_Frequencies
		where fqmsCode = 'AN'
	)										as [empnSalaryFreqID]		--ds 6/6/2024 - Salary Frequency -> sma_mst_frequencies.fqmnFrequencyID
    ,ud.Annual_Income_Plaintiff				as [empnSalaryAmt]			--ds 6/6/2024 - Salary Amount
    ,null									as [empnCommissionFreqID]	--Commission: (frequency)  sma_mst_frequencies.fqmnFrequencyID
    ,null									as [empnCommissionAmt]		--Commission Amount
	,null									as [empnBonusFreqID]		--Bonus: (frequency)  sma_mst_frequencies.fqmnFrequencyID
	,null									as [empnBonusAmt]			--Bonus Amount
	,null									as [empnOverTimeFreqID]	--Overtime (frequency)  sma_mst_frequencies.fqmnFrequencyID
	,null									as [empnOverTimeAmt]		--Overtime Amoun
	,null									as [empnOtherFreqID]		--Other Compensation (frequency)  sma_mst_frequencies.fqmnFrequencyID
    ,null									as [empnOtherCompensationAmt]	--Other Compensation Amount
	,null									as empsCompensationComments			-- Compensation Comments
	,null									as [empbWorksPartiallyOffBooks]	--bit
	,null									as [empbOnTheJob]				--On the job injury? bit
	,null									as [empbWCClaim]				--W/C Claim?  bit
	,null									as [empbContinuing]			--continuing?  bit
	,null									as [empdDateHired]				-- ds 6/6/2024 - Date From
	,null									as [empnUDF1]
	,null									as [empnUDF2]
	,368									as [empnRecUserID]
	,getdate()								as [empdDtCreated]
	,null									as [empnModifyUserID]
	,null									as [empdDtModified]
	,null									as [empnLevelNo]
	,null									as [empnauthtodefcoun]		--Auth. to defense cousel:  bit
	,null									as [empnauthtodefcounDt]	--Auth. to defense cousel:  date
	,null									as [empnTotalDisability]	--Temporary Total Disability (TTD)
	,null									as [empnAverageWeeklyWage]		--Average weekly wage (AWW)
	,null									as [empnEmpUnion]			--Unique Contact ID of Union
	,null									as [NotEmploymentReasonID]		--1=Minor; 2=Retired; 3=Unemployed; (MST?)
	,null									as [empdDateTo]			--ds 6/6/2024 - Date To
	,null									as [empsDepartment]		--Department
	,null									as [empdSent]			--emp verification request sent
	,null									as [empdReceived]		--emp verification request received
	,null									as [empnStatusId]		--status  sma_MST_EmploymentStatuses.ID
	,null									as [empnWorkSiteId]

FROM NeedlesSLF..user_party_data ud

	inner join SANeedlesSLF..Employer_Address_Helper help
		on help.case_id = ud.case_id
		and help.party_id = ud.party_id

	join sma_MST_OrgContacts org
		on org.saga = ud.case_id
		and org.saga_ref = 'upd_employer'

	-- join Employer_Address_Helper help
	-- 	on help.case_id = upd.case_id
	-- 	and help.party_id = upd.party_id

	JOIN sma_trn_Cases cas
		on cas.cassCaseNumber = convert(varchar,ud.case_id)
	
	-- Link to SA Contact Card via:
	-- user_tab_data -> user_tab_name -> names -> IndvOrgContacts_Indexed
	-- join NeedlesSLF.dbo.user_tab_name utn
	-- 	on ud.tab_id = utn.tab_id
	-- join NeedlesSLF.dbo.names n
	-- 	on utn.user_name = n.names_id
	

	join SANeedlesSLF..sma_MST_Address A
		on A.addnContactID = org.connContactID
		and a.addnContactCtgID = org.connContactCtg


	-- from NeedlesSLF..user_party_data upd
	-- join sma_MST_OrgContacts org
	-- 	on org.saga = upd.case_id
	-- 	and org.saga_ref = 'upd_employer'

	-- -- Indv
	-- left join SANeedlesSLF.dbo.IndvOrgContacts_Indexed ioci
	-- 	on n.names_id = ioci.saga
	-- 	and ioci.CTG = 1

	-- -- Org
	-- left join SANeedlesSLF.dbo.IndvOrgContacts_Indexed ioco
	-- 	on n.names_id = ioco.saga
	-- 	and ioco.CTG = 2

--WHERE isnull(ud.Annual_Income_Plaintiff,'')<>''
GO