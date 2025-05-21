use Skolrood_SA
go

select
	upd.case_id,
	upd.party_id,
	upd.Employer
from Skolrood_Needles..user_party_data upd
where
	ISNULL(upd.Employer, '') <> ''

select
	*
from IndvOrgContacts_Indexed ioci
where
	ioci.source_ref like '%employer%'

/* ------------------------------------------------------------------------------
Create employment records from user_party_data
*/
insert into [dbo].[sma_TRN_Employment]
	(
		[empnPlaintiffID],
		[empnEmprAddressID],
		[empnEmployerID],
		[empnContactPersonID],
		[empnCPAddressId],
		[empsJobTitle],
		[empnSalaryFreqID],
		[empnSalaryAmt],
		[empnCommissionFreqID],
		[empnCommissionAmt],
		[empnBonusFreqID],
		[empnBonusAmt],
		[empnOverTimeFreqID],
		[empnOverTimeAmt],
		[empnOtherFreqID],
		[empnOtherCompensationAmt],
		[empsComments],
		[empbWorksOffBooks],
		[empsCompensationComments],
		[empbWorksPartiallyOffBooks],
		[empbOnTheJob],
		[empbWCClaim],
		[empbContinuing],
		[empdDateHired],
		[empnUDF1],
		[empnUDF2],
		[empnRecUserID],
		[empdDtCreated],
		[empnModifyUserID],
		[empdDtModified],
		[empnLevelNo],
		[empnauthtodefcoun],
		[empnauthtodefcounDt],
		[empnTotalDisability],
		[empnAverageWeeklyWage],
		[empnEmpUnion],
		[NotEmploymentReasonID],
		[empdDateTo],
		[empsDepartment],
		[empdSent],
		[empdReceived],
		[empnStatusId],
		[empnWorkSiteId],
		[saga],
		[source_id],
		[source_db],
		[source_ref]
	)
	select distinct
		(
			select
				plnnPlaintiffID
			from sma_trn_plaintiff
			where plnnCaseID = cas.casnCaseID
				and plnbIsPrimary = 1
		)							as [empnPlaintiffID],--Plaintiff ID
		ioci.AID					as [empnEmprAddressID],	--employer org AID
		ioci.CID					as [empnEmployerID],	--employer org CID
		null						as [empnContactPersonID],--indv CID
		null						as [empnCPAddressId],	--indv AID
		null						as [empsJobTitle],	--ds 6/6/2024 - Job Title
		(
			select
				fqmnFrequencyID
			from sma_MST_Frequencies
			where fqmsCode = 'AN'
		)							as [empnSalaryFreqID],	--ds 6/6/2024 - Salary Frequency -> sma_mst_frequencies.fqmnFrequencyID
		upd.Annual_Income_Plaintiff as [empnSalaryAmt],		--ds 6/6/2024 - Salary Amount
		null						as [empnCommissionFreqID],	--Commission: (frequency)  sma_mst_frequencies.fqmnFrequencyID
		null						as [empnCommissionAmt],	--Commission Amount
		null						as [empnBonusFreqID],	--Bonus: (frequency)  sma_mst_frequencies.fqmnFrequencyID
		null						as [empnBonusAmt],		--Bonus Amount
		null						as [empnOverTimeFreqID],	--Overtime (frequency)  sma_mst_frequencies.fqmnFrequencyID
		null						as [empnOverTimeAmt],	--Overtime Amoun
		null						as [empnOtherFreqID],	--Other Compensation (frequency)  sma_mst_frequencies.fqmnFrequencyID
		null						as [empnOtherCompensationAmt],	--Other Compensation Amount
		null						as [empsComments],
		null						as [empbWorksOffBooks],
		null						as empsCompensationComments,	-- Compensation Comments
		null						as [empbWorksPartiallyOffBooks],	--bit
		null						as [empbOnTheJob],			--On the job injury? bit
		null						as [empbWCClaim],			--W/C Claim?  bit
		null						as [empbContinuing],		--continuing?  bit
		null						as [empdDateHired],			-- ds 6/6/2024 - Date From
		null						as [empnUDF1],
		null						as [empnUDF2],
		368							as [empnRecUserID],
		GETDATE()					as [empdDtCreated],
		null						as [empnModifyUserID],
		null						as [empdDtModified],
		null						as [empnLevelNo],
		null						as [empnauthtodefcoun],		--Auth. to defense cousel:  bit
		null						as [empnauthtodefcounDt],	--Auth. to defense cousel:  date
		null						as [empnTotalDisability],	--Temporary Total Disability (TTD)
		null						as [empnAverageWeeklyWage],		--Average weekly wage (AWW)
		null						as [empnEmpUnion],	--Unique Contact ID of Union
		null						as [NotEmploymentReasonID],		--1=Minor; 2=Retired; 3=Unemployed; (MST?)
		null						as [empdDateTo],		--ds 6/6/2024 - Date To
		null						as [empsDepartment],	--Department
		null						as [empdSent],		--emp verification request sent
		null						as [empdReceived],		--emp verification request received
		null						as [empnStatusId],		--status  sma_MST_EmploymentStatuses.ID
		null						as [empnWorkSiteId],
		null						as [saga],
		upd.Employer				as [source_id],
		'needles'					as [source_db],
		'user_party_data.employer'  as [source_ref]
	--	select distinct upd.*
	from Skolrood_Needles..user_party_data upd
	join sma_TRN_Cases cas
		on cas.cassCaseNumber = CONVERT(VARCHAR, upd.case_id)
	join IndvOrgContacts_Indexed ioci
		on ioci.Name = upd.Employer
			and ioci.source_ref = 'user_party_data.employer'
	--join sma_trn_plaintiff p
	--	on p.plnnCaseID = cas.casnCaseID
	--		and p.plnbIsPrimary = 1
	where
		ISNULL(upd.Employer, '') <> ''
	order by upd.Employer

--inner join Skolrood_SA..Employer_Address_Helper help
--	on help.case_id = ud.case_id
--		and help.party_id = ud.party_id

--join sma_MST_OrgContacts org
--	on org.saga = ud.case_id
--		and org.source_ref = 'upd_employer'

---- join Employer_Address_Helper help
---- 	on help.case_id = upd.case_id
---- 	and help.party_id = upd.party_id

--join sma_trn_Cases cas
--	on cas.cassCaseNumber = CONVERT(VARCHAR, ud.case_id)

---- Link to SA Contact Card via:
---- user_tab_data -> user_tab_name -> names -> IndvOrgContacts_Indexed
---- join Skolrood_Needles.dbo.user_tab_name utn
---- 	on ud.tab_id = utn.tab_id
---- join Skolrood_Needles.dbo.names n
---- 	on utn.user_name = n.names_id


--join Skolrood_SA..sma_MST_Address A
--	on A.addnContactID = org.connContactID
--		and a.addnContactCtgID = org.connContactCtg


-- from Skolrood_Needles..user_party_data upd
-- join sma_MST_OrgContacts org
-- 	on org.saga = upd.case_id
-- 	and org.saga_ref = 'upd_employer'

-- -- Indv
-- left join Skolrood_SA.dbo.IndvOrgContacts_Indexed ioci
-- 	on n.names_id = ioci.saga
-- 	and ioci.CTG = 1

-- -- Org
-- left join Skolrood_SA.dbo.IndvOrgContacts_Indexed ioco
-- 	on n.names_id = ioco.saga
-- 	and ioco.CTG = 2

--WHERE isnull(ud.Annual_Income_Plaintiff,'')<>''
go



-- /* ####################################
-- Insert Lost Wages
-- */
-- INSERT INTO [sma_TRN_LostWages]
-- 	(
-- 	[ltwnEmploymentID], [ltwsType], [ltwdFrmDt], [ltwdToDt], [ltwnAmount], [ltwnAmtPaid], [ltwnLoss], [Comments], [ltwdMDConfReqDt], [ltwdMDConfDt], [ltwdEmpVerfReqDt], [ltwdEmpVerfRcvdDt], [ltwnRecUserID], [ltwdDtCreated], [ltwnModifyUserID], [ltwdDtModified], [ltwnLevelNo]
-- 	)
-- 	SELECT DISTINCT
-- 		e.empnEmploymentID AS [ltwnEmploymentID]		--sma_trn_employment ID
-- 	   ,(
-- 			SELECT
-- 				wgtnWagesTypeID
-- 			FROM [sma_MST_WagesTypes]
-- 			WHERE wgtsDscrptn = 'Salary'
-- 		)				   
-- 		AS [ltwsType]   			--[sma_MST_WagesTypes].wgtnWagesTypeID
-- 		-- ,case
-- 		-- 	when ud.Last_Date_Worked between '1/1/1900' and '6/6/2079'
-- 		-- 		then ud.Last_Date_Worked
-- 		-- 	else null 
-- 		-- 	end					as [ltwdFrmDt]
-- 		-- ,case
-- 		-- 	when ud.Returned_to_Work between '1/1/1900' and '6/6/2079'
-- 		-- 		then ud.Returned_to_Work 
-- 		-- 	when isdate(ud.returntowork) = 1 and ud.returntowork between '1/1/1900' and '6/6/2079'
-- 		-- 		then ud.returntowork 
-- 		-- 	else null
-- 		-- 	end					as [ltwdToDt]
-- 	   ,NULL			   AS [ltwdFrmDt]
-- 	   ,NULL			   AS [ltwdToDt]
-- 	   ,NULL			   AS [ltwnAmount]
-- 	   ,NULL			   AS [ltwnAmtPaid]
-- 	   ,v.total_value	   AS [ltwnLoss]
-- 		-- ,isnull('Return to work: ' + nullif(convert(Varchar,ud.returntowork),'') + char(13),'') +
-- 		-- ''						as [comments]
-- 	   ,NULL			   AS [comments]
-- 	   ,NULL			   AS [ltwdMDConfReqDt]
-- 	   ,NULL			   AS [ltwdMDConfDt]
-- 	   ,NULL			   AS [ltwdEmpVerfReqDt]
-- 	   ,NULL			   AS [ltwdEmpVerfRcvdDt]
-- 	   ,368				   AS [ltwnRecUserID]
-- 	   ,GETDATE()		   AS [ltwdDtCreated]
-- 	   ,NULL			   AS [ltwnModifyUserID]
-- 	   ,NULL			   AS [ltwdDtModified]
-- 	   ,NULL			   AS [ltwnLevelNo]
-- 	-- employment record id: case > plaintiff > employment (value has caseid)
-- 	FROM Skolrood_Needles..value_indexed v
-- 	JOIN sma_trn_Cases cas
-- 		ON cas.cassCaseNumber = v.case_id
-- 	JOIN sma_trn_plaintiff p
-- 		ON p.plnnCaseID = cas.casnCaseID
-- 			AND p.plnbIsPrimary = 1
-- 	INNER JOIN sma_TRN_Employment e
-- 		ON e.empnPlaintiffID = p.plnnPlaintiffID
-- 	WHERE v.code = 'LWG'

-- -- FROM Skolrood_Needles..user_tab4_data ud
-- -- JOIN EmployerTemp et on et.employer = ud.employer and et.employer_address = ud.Employer_Address
-- -- JOIN IndvOrgContacts_Indexed ioc on ioc.SAGA = et.empID and ioc.[Name] = et.employer
-- -- JOIN [sma_TRN_Employment] e on  e.empnPlaintiffID = p.plnnPlaintiffID and empnEmployerID = ioc.CID


-- ---------------------------------------
-- -- Update Special Damages
-- ---------------------------------------
-- ALTER TABLE [sma_TRN_SpDamages] DISABLE TRIGGER ALL
-- GO

-- INSERT INTO [sma_TRN_SpDamages]
-- 	(
-- 	[spdsRefTable], [spdnRecordID], [spdnRecUserID], [spddDtCreated], [spdnLevelNo], spdnBillAmt, spddDateFrom, spddDateTo
-- 	)
-- 	SELECT DISTINCT
-- 		'LostWages'		   AS spdsRefTable
-- 	   ,lw.ltwnLostWagesID AS spdnRecordID
-- 	   ,lw.ltwnRecUserID   AS [spdnRecUserID]
-- 	   ,lw.ltwdDtCreated   AS spddDtCreated
-- 	   ,NULL			   AS [spdnLevelNo]
-- 	   ,lw.[ltwnLoss]	   AS spdnBillAmt
-- 	   ,lw.ltwdFrmDt	   AS spddDateFrom
-- 	   ,lw.ltwdToDt		   AS spddDateTo
-- 	FROM sma_TRN_LostWages LW


-- ALTER TABLE [sma_TRN_SpDamages] ENABLE TRIGGER ALL
-- GO
