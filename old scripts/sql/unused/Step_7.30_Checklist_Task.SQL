
use [SANeedlesXXXXX]
GO

/*
alter table [sma_TRN_TaskNew] disable trigger all
delete from [sma_TRN_TaskNew]
DBCC CHECKIDENT ('[sma_TRN_TaskNew]', RESEED, 0);
alter table [sma_TRN_TaskNew] disable trigger all
*/

----(0)----
INSERT INTO [sma_MST_TaskCategory] (tskCtgDescription)
SELECT 'Checklist'
EXCEPT
SELECT tskCtgDescription FROM [sma_MST_TaskCategory] 

/*
select distinct (select top 1 replace(ltrim(DIR.[description]),'>','')) 
FROM [NeedlesXXXXX].[dbo].[checklist_dir] DIR 
inner join [NeedlesXXXXX].[dbo].[case_checklist] LST on DIR.code=LST.code
where isnull(DIR.[description],'')<>''
except
select tskCtgDescription from [SANeedlesXXXXX].[dbo].[sma_MST_TaskCategory] 
*/
GO
---(0)---
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'sma_TRN_TaskNew'))
begin
    ALTER TABLE [sma_TRN_TaskNew] ADD [saga] int NULL; 
end
GO

---(1)---
ALTER TABLE [sma_TRN_TaskNew] DISABLE TRIGGER ALL
GO

INSERT INTO [sma_TRN_TaskNew]
(
       [tskCaseID]
      ,[tskDueDate]
      ,[tskStartDate]
      ,[tskRequestorID]
      ,[tskAssigneeId]
      ,[tskReminderDays]
      ,[tskDescription]
      ,[tskCreatedDt]
      ,[tskCreatedUserID]
      ,[tskMasterID]
      ,[tskCtgID]
      ,[tskSummary]
      ,[tskPriority]
      ,[tskCompleted]
	 ,[saga]
)  
SELECT DISTINCT
    CAS.casnCaseID																			as [tskCaseID],
    case when CKL.due_date between '1900-01-01' and '2079-06-06' then CKL.due_date else '1900-01-01' end		as [tskDueDate],
    null																					as [tskStartDate],
    null																					as [tskRequestorID],
    (select usrnUserID from sma_MST_Users where saga=CKL.staff_assigned)				    as [tskAssigneeId],
    null																					as [tskReminderDays],
    --ltrim(CKL.[description])																as [tskDescription],
	null																					as [tskDescription],
    null																					as [tskCreatedDt],
    null																					as tskCreatedUserID,
    (select tskMasterID from sma_mst_Task_Template where tskMasterDetails = 'Custom Task')	as [tskMasterID], 
    --(select tskCtgID from sma_MST_TaskCategory where tskCtgDescription = (select top 1 replace(ltrim(D.[description]),'>','') FROM [NeedlesXXXXX].[dbo].[checklist_dir] D where D.code=CKL.code))					     
	(select tskCtgID from sma_MST_TaskCategory where tskCtgDescription = 'Checklist')		as [tskCtgID], 
    ltrim(CKL.[description])																as [tskSummary],  --task subject--
    (select uId from PriorityTypes where PriorityType = 'Normal')							as [tskPriority],
	case     
		when CKL.[status]='Done' or ckl.matcode = 'WC' then (select StatusID from TaskStatusTypes where StatusType = 'Completed' )		--ALL Worker's Comp cases will be marked completed.
		when CKL.[status]='Open' then (select StatusID from TaskStatusTypes where StatusType = 'In Progress')					
		when CKL.[status]='N/A' then (select StatusID from TaskStatusTypes where StatusType = 'Cancelled')					
		else (select StatusID from TaskStatusTypes where StatusType = 'Not Started')					
	end																						as [tskCompleted], 
    CKL.checklist_id																		as [saga]
FROM [NeedlesXXXXX].[dbo].[case_checklist] CKL
JOIN [sma_TRN_Cases] CAS on CAS.cassCaseNumber=CKL.case_id
WHERE isnull(CAS.casdClosingDate,'') = ''
and CKL.due_date between '1900-01-01' and '2079-06-06'

GO

ALTER TABLE [sma_TRN_TaskNew] ENABLE TRIGGER ALL
GO
