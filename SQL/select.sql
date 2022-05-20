SELECT t3.name
FROM OrderItems t1
JOIN Orders t2 on  t2.row_id=t1.order_id
JOIN Customers t3 on  t2.customer_id=t3.row_id
where year(t2.registered_at)=2020
and t3.name not in (
	--очистка фамилий, где нет заказа
	SELECT t3.name
	FROM OrderItems t1
	JOIN Orders t2 on  t2.row_id=t1.order_id
	JOIN Customers t3 on  t2.customer_id=t3.row_id
	where year(t2.registered_at)=2020
	and t2.row_id  not in (
	--выборка заказов, где нет кассы--
		SELECT  t2.order_id
		FROM OrderItems t2
		where t2.name='кассовый аппарат'
)
)
group by t3.name
