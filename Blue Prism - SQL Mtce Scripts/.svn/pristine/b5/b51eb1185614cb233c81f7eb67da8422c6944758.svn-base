USE [BluePrismDB]
GO

/****** Object:  StoredProcedure [dbo].[SYN_TrimProcessHistory]    Script Date: 29/03/2019 1:14:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rod Olsen
-- Create date: 29/03/2019
-- Description:	Trim Audit History keeping (n) days
-- =============================================
CREATE PROCEDURE [dbo].[SYN_TrimProcessHistory] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   -- * Process History BPAAuditEvents
--   - using a threshold of when the audit record was created
--   - Effect: User will not be able to compare / view old processes in the
--             process history. Audit events will remain

-- The days of audit records to keep the data for
-- It will keep any processes on audit records created after this number of days ago
declare @daystokeep int;
set @daystokeep = 28;

-- Set this to midnight on the day @daystokeep days ago
declare @threshold datetime;
set @threshold = DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), -@daystokeep);

-- * Process History BPAAuditEvents
--   - no threshold
--   - Effect: User will not be able to compare / view old processes in the
--             process history. Audit events will remain
select @threshold;

update BPAAuditEvents set
    oldXML = null,
    newXml = null
  where eventdatetime < @threshold;
END
GO

