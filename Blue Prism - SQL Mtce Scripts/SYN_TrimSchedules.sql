USE [BluePrismDB]
GO

/****** Object:  StoredProcedure [dbo].[SYN_TrimSchedules]    Script Date: 29/03/2019 1:14:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SYN_TrimSchedules] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
-- * Schedules - BPAScheduleLog
--   - using a threshold of when the schedule executed
--   - Effect: Schedule logs will not be available for the specified period
--             (does not affect session logs initiated by those schedules)

-- The days of logs to keep
-- It will keep any logs which started after this number of days
-- ago, or have not started or have not ended
declare @daystokeep int
set @daystokeep = 28

-- If we're keeping any logs, set a threshold date to midnight on the
-- day @daystokeep days ago.
if @daystokeep > 0 begin
  declare @threshold datetime
  set @threshold = DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), -@daystokeep)
  delete from BPAScheduleLog where instancetime < @threshold
end
-- If we're not keeping any logs just truncate the table and move on
else begin
    truncate table BPAScheduleLogEntry
    delete from BPAScheduleLog
end

-- * Schedules - BPAScheduleTrigger
--   - delete all 'Run Now' triggers
--   - Effect: Should have no discernable effect to the user

delete from BPAScheduleTrigger where usertrigger = 0
END
GO

