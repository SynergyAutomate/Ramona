USE [BluePrismDB]
GO

/****** Object:  StoredProcedure [dbo].[SYN_CountRows]    Script Date: 29/03/2019 1:13:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rod Olsen
-- Create date: 29/03/2019
-- Description:	Display a row count of 
--              each table in the BP database
-- =============================================
CREATE PROCEDURE [dbo].[SYN_CountRows] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT      SCHEMA_NAME(A.schema_id) + '.' +
        A.Name AS 'Table Name', SUM(B.rows) AS 'Row Count'
FROM        sys.objects A
INNER JOIN sys.partitions B ON A.object_id = B.object_id
WHERE       A.type = 'U'
GROUP BY    A.schema_id, A.Name, B.rows
ORDER BY	B.rows DESC

END
GO

