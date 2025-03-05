/*
1. Create WorkPlans from #ChecklistMatCodes,
	- created manually as client provided info
2. Create WorkPlanItemTemplate
3. Create sma_MST_WorkPlanItem
*/

--USE SANeedlesKMY
--GO

---(0)---
if not exists (SELECT * FROM sys.columns WHERE Name = N'saga' AND Object_ID = Object_ID(N'[sma_MST_WorkPlanItemTemplates]'))
begin
    ALTER TABLE [sma_MST_WorkPlanItemTemplates] ADD [saga] int NULL; 
end
GO

IF OBJECT_ID('tempdb..#ChecklistMatCodes') IS NOT NULL
    DROP TABLE #ChecklistMatCodes;


CREATE TABLE #ChecklistMatCodes (
    description VARCHAR(100),
    matcode VARCHAR(10)
);

INSERT INTO #ChecklistMatCodes
(
	description
	,matcode
)
VALUES
    ('WC Ext Disability Checklist.docx', '017-1'),
    ('512 Checklist', '012-1'),
    ('WC C9 OSIF', '015-1'),
    ('WC C9 SI', '016-1'),
    ('WC C86 Checklst', '003-1'),
    ('WC Cont Wage Loss Checklist', '006-1'),
    ('WC NWWL Checklist', '005-1'),
    ('WC PPD Checklist', '004-1'),
    ('WC Primary Checklist Word version', 'WC'),
    ('WC PTD Checklist', '014-1'),
    ('WC WWL Checklist', '013-1');
-- ('017-1'), ('012-1'), ('015-1'), ('016-1'), ('003-1'), ('006-1'),
-- ('WC'), ('005-1'), ('014-1'), ('004-1'), ('013-1')



---(1)---
INSERT INTO [dbo].[sma_MST_WorkPlans]
(
    [Name]
    ,[Description]
    ,[CreatorId]
    ,[CreationDate]
    ,[ModifierId]
    ,[ModifyDate]
    ,[SpecialNotes]
    ,[IsDeleted]
)
SELECT 
    matcode					as [Name]
    -- matcode                     as [Name]
    ,description				as [Description]
    ,368                        as [CreatorId]
    ,GETDATE()                  as [CreationDate]
    ,null                       as [ModifierId]
    ,NULL                       as [ModifyDate]
    ,null                       as [SpecialNotes]
    ,0							as [IsDeleted]
from #ChecklistMatCodes
GO

INSERT INTO [dbo].[sma_MST_WorkPlanItemTemplates]
(
	[Name]
	,[Description]
	,[ItemTypeId]
	,[CategoryId]
	,[CreatorUserId]
	,[CreationDate]
	,[ModifyUserId]
	,[ModifyDate]
	,[PriorityId]
	,[SpecialInstructions]
	,[Due]
	,[Reminder]
	,[SecReminder]
	,[TetReminder]
	,[IsAutomatic]
	,[RepeatFrequency]
	,[RepeatCount]
	,[DateFrom]
	,[DateTo]
	,[IsDueAfterHolidays]
	,[DueType]
	,[DueDays]
	,[DueMonths]
	,[DueYears]
	,[EquationType]
	,[ToPromptUser]
	,[saga]
)
SELECT
    ISNULL(description, '')
		+ ' (' + ISNULL(code, '') + ')' 		as [Name]
    ,description					    		as [Description]
    ,(
		select uId
		FROM [SANeedlesKMY].[dbo].[sma_MST_WorkPlanItemTypes]
		where [Name] = 'Task'
	)											as [ItemTypeId]
    ,(
		select tskCtgID
		FROM [SANeedlesKMY].[dbo].[sma_MST_TaskCategory]
		where tskCtgDescription = 'Discovery'
	)											as [CategoryId]
    ,368							    		as [CreatorUserId]
    ,GETDATE()						    		as [CreationDate]
    ,NULL							    		as [ModifyUserId]
    ,NULL							    		as [ModifyDate]
    ,(
		select uId
		from [SANeedlesKMY].[dbo].[PriorityTypes]
		where PriorityType = 'Normal'
	)											as [PriorityId]
    ,''							 				as [SpecialInstructions]
    ,repeat_days					    		as [Due]
    ,NULL							    		as [Reminder]
    ,NULL							    		as [SecReminder]
    ,NULL							    		as [TetReminder]
    ,0							    			as [IsAutomatic]
    ,repeat_days					    		as [RepeatFrequency]
    ,NULL							    		as [RepeatCount]
    ,null							    		as [DateFrom]
    ,null							    		as [DateTo]
    ,1							    			as [IsDueAfterHolidays]
    ,case 
	   when ref ='DOI'
			then (
					select uId
					from [SANeedlesKMY].[dbo].[sma_MST_WorkPlanDueTypes]
					where [Name] = 'Incident Date (DOI)'
				)
	   when ref = 'COD'
			then (
					select uId
					from [SANeedlesKMY].[dbo].[sma_MST_WorkPlanDueTypes]
					where [Name] = 'Case Created Date'
				)
	   else (
				select uId
				from [SANeedlesKMY].[dbo].[sma_MST_WorkPlanDueTypes]
				where [Name] = 'Item Entered Date'
			) 
    	end							    		as [DueType]	   
    ,repeat_days					    		as [DueDays]
    ,repeat_days/30					    		as [DueMonths]
    ,repeat_days/368					    	as [DueYears]
    ,1							    			as [EquationType]
    ,1							    			as [ToPromptUser]
	,[UID]										as [saga]
FROM [NeedlesKMY].[dbo].[checklist_Dir_Indexed] chk
where chk.matcode in (select matcode from #ChecklistMatCodes)
GO

--select * from [sma_MST_WorkPlanItemTemplates]

---(3)---
--SET IDENTITY_INSERT [dbo].[sma_MST_WorkPlanItem] ON;
--GO

INSERT INTO [dbo].[sma_MST_WorkPlanItem]
(
	[Name]
	,[WorkPlanID]
	,[Description]
	,[SpecialInstructions]
	,[ParentID]
	,[TypeID]
	,[CategoryID]
	,[Reminder]
	,[SecReminder]
	,[TetReminder]
	,[IsAutomatic]
	,[CreatorUserID]
	,[CreateDate]
	,[ModifyUserID]
	,[ModifyDate]
	,[PriorityID]
	,[RepeatFrequency]
	,[RepeatCount]
	,[DateFrom]
	,[DateTo]
	,[IsDueAfterHolidays]
	,[DueType]
	,[DueTargetId]
	,[DueTargetEventId]
	,[DueDays]
	,[DueMonths]
	,[DueYears]
	,[EquationType]
	,[ToPromptUser]
	,[VisualIndex]
)
SELECT 
	ISNULL(CHKL.[description], '')
		+ ' (' + ISNULL(code, '') + ')'			as [Name]
	,ISNULL(WP.uId,1)							as [WorkPlanID]
	,CHKL.[description]							as [Description]
	,''											as [SpecialInstructions]
	,isnull(
			(
				select w.uId
				from [NeedlesKMY].[dbo].[checklist_dir_indexed] cd
					LEFT JOIN [dbo].[sma_MST_WorkPlanItemTemplates] W
						ON W.SAGA = cd.[UID]
				where code = CHKL.ref 
				and matcode = CHkl.matcode
			)
		,1) 									as ParentID
	,isnull(WPT.ItemTypeId,1)					as TypeID
	,WPT.CategoryId								as [CategoryID]
	,NULL										as [Reminder]
	,NULL										as [SecReminder]
	,NULL										as [TetReminder]
	,0											as [IsAutomatic]
	,368										as [CreatorUserID]
	,GETDATE()									as [CreateDate]
	,NULL										as [ModifyUserID]
	,NULL										as [ModifyDate]
	,(
		select uId
		from [SANeedlesKMY].[dbo].[PriorityTypes]
		where PriorityType = 'Normal'
	)											as [PriorityID]
	,NULL										as [RepeatFrequency]
	,NULL										as [RepeatCount]
	,NULL										as [DateFrom]
	,NULL							    		as [DateTo]
	,1							    			as [IsDueAfterHolidays]
	,WPT.DueType					    		as [DueType]
	,NULL							    		as [DueTargetId]
	,NULL							    		as [DueTargetEventId]
	,WPT.DueDays					    		as [DueDays]
	,WPT.DueMonths					    		as [DueMonths]
	,WPT.DueYears 					    		as [DueYears]
	,WPT.EquationType				    		as [EquationType]
	,1							    			as [ToPromptUser]
	,1							    			as [VisualIndex]
FROM [NeedlesKMY].[dbo].[checklist_dir_indexed] CHKL
	LEFT JOIN [dbo].[sma_MST_WorkPlans] WP
		ON WP.Name = CHKL.matcode
	LEFT JOIN [dbo].[sma_MST_WorkPlanItemTemplates] WPT
		ON WPT.SAGA = CHKL.[UID]
	--join #ChecklistMatCodes chkt
	--	on 
GO



update WPI
set ParentID = isnull(parent.UID, 1)
--select wp.[Name], wpi.uid WorkPlaceItemID , wpi.[name] WPItemName, wpi.ParentID , CHKL.[description], chkl.ref, parent.code, parent.description, isnull(parent.UID,1) ParentID
from [sma_MST_WorkPlanItem] WPI
join [sma_MST_WorkPlans] WP
	on WP.UID = WPI.WorkPlanID
join [NeedlesKMY].[dbo].[checklist_dir_Indexed] CHKL
	on CHKL.matcode = wp.[Name]
		and wpi.[name] = ISNULL(chkl.[description], '') + ' (' + ISNULL(chkl.[code], '') + ')'
left join (
	select WPI.UID
		,wp.name
		,chkl.Matcode
		,chkl.code
		,chkl.description
	from [sma_MST_WorkPlanItem] WPI
	join [sma_MST_WorkPlans] WP
		on WP.UID = WPI.WorkPlanID
	join [NeedlesKMY].[dbo].[checklist_dir_Indexed] CHKL
		on CHKL.matcode = wp.[Name]
			and wpi.[name] = ISNULL(chkl.[description], '') + ' (' + ISNULL(chkl.[code], '') + ')'
	) Parent
	on Parent.matcode = chkl.matcode
		and parent.code = chkl.ref
where WPI.ParentID <> isnull(parent.UID, 1)