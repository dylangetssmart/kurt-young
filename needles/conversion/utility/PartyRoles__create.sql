use KurtYoung_SA
go


set ansi_nulls on
go

set quoted_identifier on
go

if exists (
		select
			*
		from sys.tables
		where name = 'PartyRoles'
			and type = 'U'
	)
begin
	drop table PartyRoles
end

create table [dbo].[PartyRoles] (
	[Needles Roles] [NVARCHAR](255) null,
	[SA Roles]		[NVARCHAR](255) null,
	[SA Party]		[NVARCHAR](255) null
) on [PRIMARY]

go

insert into [dbo].[PartyRoles]
	(
		[Needles Roles],
		[SA Roles],
		[SA Party]
	)
	SELECT 'Petitioner', '(P)-Petitioner', 'Plaintiff' UNION
	SELECT 'Testator', '(P)-Testator', 'Plaintiff' UNION
	SELECT 'Personal Representative', 'Personal Representative', 'Plaintiff' UNION
	SELECT 'Seller', '(D)-Seller', 'Defendant' UNION
	SELECT 'Guardian', '(P)-Guardian', 'Plaintiff' UNION
	SELECT 'Testatrix', '(P)-Testatrix', 'Plaintiff' UNION
	SELECT 'Employer', '(D)-Defendant', 'Defendant' UNION
	SELECT 'Beneficiary', '(P)-Beneficiary', 'Plaintiff' UNION
	SELECT 'Beneficiary/Child', '(P)-Beneficiary/Child', 'Plaintiff' UNION
	SELECT 'Spouse', '(P)-Spouse', 'Plaintiff' UNION
	SELECT 'Plaintiff Compan', '(P)-Plaintiff Compan', 'Plaintiff' UNION
	SELECT 'Decedent', '(P)-Decedent', 'Plaintiff' UNION
	SELECT 'Executor', '(P)-Executor', 'Plaintiff' UNION
	SELECT 'Voter', '(P)-Voter', 'Plaintiff' UNION
	SELECT 'Defendant', '(D)-Defendant', 'Defendant' UNION
	SELECT 'Respondent', '(D)-Defendant', 'Defendant' UNION
	SELECT 'Payee', '(D)-Payee', 'Defendant' UNION
	SELECT 'Family Member', '(P)-Family Member', 'Plaintiff' UNION
	SELECT 'Plaintiff', '(P)-Plaintiff', 'Plaintiff' UNION
	SELECT 'Claimant', '(P)-Claimant', 'Plaintiff' UNION
	SELECT 'Buyer', '(P)-Buyer', 'Plaintiff'

go

-- add non-typical roles to Other Contacts (sma_MST_OtherCasesContact)
-- Drop the sma_MST_OtherCasesContact table if it exists
--IF EXISTS (SELECT * FROM sys.tables WHERE name = 'sma_MST_OtherCasesContact' AND type = 'U')
--BEGIN 
--    DROP TABLE [dbo].[sma_MST_OtherCasesContact]
--END
--GO

---- Create the sma_MST_OtherCasesContact table
--CREATE TABLE [dbo].[sma_MST_OtherCasesContact](
--    [OtherCasesContactPKID] [int] IDENTITY(1,1) NOT NULL,
--    [OtherCasesID] [int] NULL,
--    [OtherCasesContactID] [int] NULL,
--    [OtherCasesContactCtgID] [int] NULL,
--    [OtherCaseContactAddressID] [int] NULL,
--    [OtherCasesContactRole] [varchar](500) NULL,
--    [OtherCasesCreatedUserID] [int] NULL,
--    [OtherCasesContactCreatedDt] [smalldatetime] NULL,
--    [OtherCasesModifyUserID] [int] NULL,
--    [OtherCasesContactModifieddt] [smalldatetime] NULL,
-- CONSTRAINT [PK_sma_MST_OtherCasesContact] PRIMARY KEY CLUSTERED 
--(
--    [OtherCasesContactPKID] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
--) ON [PRIMARY]

---- Create
----INSERT [SAKurtYoung_Needles].[dbo].[sma_MST_OtherCasesContact](
----	[OtherCasesContactRole]
----)
----SELECT 'Personal Representative' UNION
----SELECT 'Seller' UNION
----SELECT 'Voter' UNION
----SELECT 'Payee' UNION
----SELECT 'Family Member' UNION
----SELECT 'Buyer'
