USE [BluePrismDB]
GO

/****** Object:  StoredProcedure [dbo].[SYN_RemoveLogs]    Script Date: 29/03/2019 1:13:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rod Olsen
-- Create date: 29/03/2019
-- Description:	Remove Logs
-- =============================================
CREATE PROCEDURE [dbo].[SYN_RemoveLogs]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  
begin tran;

-- The days of logs to keep
-- It will keep any logs which started after this number of days
-- ago, or have not started or have not ended
declare @daystokeep int;
set @daystokeep = 28;

-- Set this to midnight on the day @daystokeep days ago
declare @threshold datetime;
set @threshold = DATEADD(DAY, DATEDIFF(DAY, 0, GETDATE()), -@daystokeep);

-- very temp table to hold sessions that we are saving
declare @sessions table (sessno int not null);

-- Get all the unstarted or unfinished sessions as well as those
-- which have finished, but were started before the threshold date
insert into @sessions (sessno)
select sessionnumber
  from BPASession
  where startdatetime is null or enddatetime is null or startdatetime >= @threshold
;

-- Get all of the entries corresponding to those logs
-- then get rid of all the data in the session log tables
if object_id(N'BPASessionLog_Unicode', N'U') is not null begin
    select l.*
      into tempbplog_wide
      from BPASessionLog_Unicode l
        join @sessions s on l.sessionnumber = s.sessno
    ;

    select l.*
      into tempbplog_byte
      from BPASessionLog_NonUnicode l
        join @sessions s on l.sessionnumber = s.sessno
    ;

    truncate table BPASessionLog_Unicode;
    truncate table BPASessionLog_NonUnicode;
    
end
else begin
    select l.*
      into tempbplog_orig
      from BPASessionLog l
        join @sessions s on l.sessionnumber = s.sessno
    ;

    truncate table BPASessionLog;

end;

-- and delete all of the sessions which we have not marked as
-- being saved (ie. those which are not in the @sessions table)
delete s
  from BPASession s
    left join @sessions ts on s.sessionnumber = ts.sessno
  where ts.sessno is null;

-- now restore all the data from the #tempbplog table back into
-- the now empty BPASessionLog(_XXX) table(s)
if object_id(N'BPASessionLog_Unicode', N'U') is not null begin

    insert into BPASessionLog_Unicode
      select * from tempbplog_wide;
    insert into BPASessionLog_NonUnicode
      select * from tempbplog_byte;

end
else begin
    insert into BPASessionLog
      select * from tempbplog_orig;

end;

-- job done.
commit
-- rollback
END
GO

