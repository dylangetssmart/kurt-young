/* ######################################################################################
description: Adds identity column ROW_ID to case_intake

steps:
	-

usage_instructions:
	-

dependencies:
	- 

notes:
	-
#########################################################################################
*/

<<<<<<< HEAD
use KurtYoung_Needles
go
=======
USE [Needles]
GO
>>>>>>> d7f79dc97274c70cc19edf75cc36bfad72783475

ALTER TABLE case_intake
ADD ROW_ID INT IDENTITY(1,1)