USE [stack]
GO
/****** Object:  UserDefinedFunction [dbo].[select_orders_by_item_name]    Script Date: 20.05.2022 20:46:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER function [dbo].[select_orders_by_item_name](@name char(30))
returns table
as
return
(
SELECT t1.order_id, count(t1.order_id) as count , t3.name
FROM OrderItems t1
JOIN Orders t2 on  t2.row_id=t1.order_id
JOIN Customers t3 on  t2.customer_id=t3.row_id
WHERE t1.name = @name 
group by t1.order_id,  t1.name, t3.name
)