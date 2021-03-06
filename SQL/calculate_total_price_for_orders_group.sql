USE [stack]
GO
/****** Object:  UserDefinedFunction [dbo].[calculate_total_price_for_orders_group]    Script Date: 20.05.2022 20:44:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[calculate_total_price_for_orders_group] (@Input INTEGER)
RETURNS INT
AS

BEGIN
  declare @count int
  declare @temp_table TABLE
  ( 
    temp_id  int	

  ); 
WITH Recursive (row_id, parent_id, group_name)
AS
(
    SELECT row_id, parent_id, group_name
    FROM Orders e
    WHERE e.row_id = @Input
    UNION ALL
    SELECT e.row_id, e. parent_id, e.group_name
    FROM Orders e
        JOIN Recursive r ON e.parent_id = r.row_id
)
	
    INSERT @temp_table
    SELECT row_id
    FROM Recursive;
 
     return (select sum(t1.price)from OrderItems t1
			 join @temp_table t2 on t2.temp_id=t1.order_id
			 where t2.temp_id=t1.order_id
	 )
END;
