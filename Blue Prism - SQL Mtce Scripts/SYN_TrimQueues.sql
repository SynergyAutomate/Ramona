USE [BluePrismDB]
GO

/****** Object:  StoredProcedure [dbo].[SYN_TrimQueues]    Script Date: 29/03/2019 1:14:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rod Olsen
-- Create date: 29/03/2019
-- Description:	Trim work queue data leaving (n) days 
-- =============================================
CREATE PROCEDURE [dbo].[SYN_TrimQueues] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- * Queues - BPAWorkQueueItem
--   - using a threshold of when the item was completed 
--   - Note that all BPAWorkQueueItemTag entries for the affected item
--     records will be removed as part of this work.
--   - Effect: Queue items will no longer be accessible in the UI or a
--             process.

-- The days of queue items to keep
-- It will keep any items which were marked as finished after this number
-- of days ago, or have not been marked as finished yet.
declare @daystokeep int
set @daystokeep = 28

-- Set this to midnight on the day @daystokeep days ago
declare @threshold datetime
set @threshold = DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), -@daystokeep)

declare @items table (id uniqueidentifier not null);

-- gather all of the items that we want to delete
insert into @items
select i.id
from BPAWorkQueueItem i
  left join BPAWorkQueueItem inext
    on i.id = inext.id and inext.attempt = i.attempt + 1
where inext.id is null and i.finished < @threshold

-- And delete the ones that we've gathered
delete wi
from BPAWorkQueueItem wi
  join @items i on wi.id = i.id

-- * Tags - BPATag
--   - delete all tags that are not associated with a work item
--   - Effect: Should have no discernable effect to the user.
delete t
  from BPATag t
    left join BPAWorkQueueItemTag it on t.id = it.tagid
  where it.tagid is null;

-- delete everything from the work queue log.
truncate table BPAWorkQueueLog

END
GO

