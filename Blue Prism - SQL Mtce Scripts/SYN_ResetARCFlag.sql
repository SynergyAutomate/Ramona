USE [BluePrismDB]
GO

/****** Object:  StoredProcedure [dbo].[SYN_ResetARCFlag]    Script Date: 29/03/2019 1:17:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rod Olsen
-- Create date: 29/03/2019
-- Description:	Reset erroneous archive flag
-- =============================================
CREATE PROCEDURE [dbo].[SYN_ResetARCFlag] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- This command will reset the flag governing the archiving process
-- if that process did not complete for any reason.

-- It should be run if you are seeing this error message:
-- 'The machine is already performing an archiving process', or
-- 'Archiving failed - The parameterized query '(@name nvarchar(4000)) update BPASysConfig set
--  ArchiveInProgre' expects the parameter '@name', which was not supplied.'

 update BPASysConfig set ArchiveInProgress = NULL
END
GO

