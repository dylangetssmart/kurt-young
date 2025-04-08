use KurtYoung_SA
go

-------------------------------------------------------------------------------
-- [sma_TRN_LienDetails]
-------------------------------------------------------------------------------
alter table [sma_TRN_LienDetails] disable trigger all
go

insert into [sma_TRN_LienDetails]
	(
		lndnLienorID,
		lndnLienTypeID,
		lndnCnfrmdLienAmount,
		lndsRefTable,
		lndnRecUserID,
		lnddDtCreated
	)
	select
		lnrnLienorID		 as lndnLienorID, --> same as lndnRecordID
		lnrnLienorTypeID	 as lndnLienTypeID,
		lnrnCnfrmdLienAmount as lndnCnfrmdLienAmount,
		'sma_TRN_Lienors'	 as lndsRefTable,
		368					 as lndnRecUserID,
		GETDATE()			 as lnddDtCreated
	from [sma_TRN_Lienors]

alter table [SAKurtYoung_Needles].[dbo].[sma_TRN_LienDetails] enable trigger all
go