DECLARE @region int
SET @region=1036
SELECT pvt.Врачи,
		pvt.номер_строки,
		[1008] as N'переменные_C_97',
		[1009] as N'переменные_D_97',
		[1023] as N'постоянные_J_87',
		[1024] as N'постоянные_C_250',
		[1025] as N'постоянные_D_250',
		[1026] as N'постоянные_E_250',
		[1027] as N'постоянные_F_250',
		[1028] as N'постоянные_G_250',
		[1029] as N'постоянные_H_250',
		[1030] as N'постоянные_I_250',
		[1031] as N'постоянные_J_250',
		[переменные_C_44], 
		[постоянные_K_44],
		[переменные_C_46],
		[постоянные_K_46],
		[переменные_C_63],
		[постоянные_K_63],
		[переменные_E_44],
		[переменные_F_44],
		[постоянные_D_35],
		[постоянные_C_35],
		[постоянные_J_35],
		[переменные_D_44],
		[переменные_E_46],
		[переменные_F_46],
		[постоянные_D_37],
		[постоянные_C_37],
		[постоянные_J_37],
		[переменные_D_46],
		[переменные_E_63],
		[переменные_F_63],
		[постоянные_D_54],
		[постоянные_C_54],
		[постоянные_J_54],
		[переменные_D_63],[1001],[1002],[1003]
FROM  
(
	SELECT [Расчёт_потребности_в_кадрах_Столбцы_2024]
			  ,_Расчёт_потребности_в_кадрах_Строки_2024.alias as Врачи
		  ,_Расчёт_потребности_в_кадрах_Строки_2024.номер_строки as номер_строки

		  ,[Value]

	FROM [ASMMS].[dbo].[__Расчет_потребности_в_кадрах_2024_год]
	INNER JOIN _Расчёт_потребности_в_кадрах_Строки_2024 ON
		_Расчёт_потребности_в_кадрах_Строки_2024.id = [Расчёт_потребности_в_кадрах_Строки_2024]
	WHERE [Субъект_РФ]=@region AND Расчёт_потребности_в_кадрах_Строки_2024 < 1174 AND Расчёт_потребности_в_кадрах_Строки_2024>1066

	UNION ALL

	SELECT 
			Расчёт_потребности_в_кадрах_Столбцы_2024,
			Врачи = N'Врачи, всего',
				0 as номер_строки,
				Value
		FROM __Расчет_потребности_в_кадрах_2024_год
		INNER JOIN _Расчёт_потребности_в_кадрах_Строки_2024 ON
			_Расчёт_потребности_в_кадрах_Строки_2024.id = __Расчет_потребности_в_кадрах_2024_год.Расчёт_потребности_в_кадрах_Строки_2024
		WHERE Расчёт_потребности_в_кадрах_Строки_2024 IN (1004,1005,1006,1007,1008,1009,1010,1011) AND Субъект_РФ=@Region
) t
PIVOT
(
	SUM(Value) FOR [Расчёт_потребности_в_кадрах_Столбцы_2024] IN ([1001],[1002],[1003],[1008],[1009],[1023],[1024],[1025],[1026],[1027],[1028],[1029],[1030],[1031])
) pvt
-------------------------------------	
LEFT JOIN
(
	SELECT pvt2.Врачи, 
			pvt2.[1004] as N'переменные_C_44', 
			pvt2.[1022] as N'постоянные_K_44',
			pvt3.[1004] as N'переменные_C_46',
			pvt3.[1022] as N'постоянные_K_46',
			pvt4.[1004] as N'переменные_C_63',
			pvt4.[1022] as N'постоянные_K_63',
			pvt2.[1006] as N'переменные_E_44',
			pvt2.[1007] as N'переменные_F_44',
			pvt2.[1017] as N'постоянные_D_35',
			pvt2.[1016] as N'постоянные_C_35',
			pvt2.[1021] as N'постоянные_J_35',
			pvt2.[1005] as N'переменные_D_44',
			pvt3.[1006] as N'переменные_E_46',
			pvt3.[1007] as N'переменные_F_46',
			pvt3.[1017] as N'постоянные_D_37',
			pvt3.[1016] as N'постоянные_C_37',
			pvt3.[1021] as N'постоянные_J_37',
			pvt3.[1005] as N'переменные_D_46',
			pvt4.[1006] as N'переменные_E_63',
			pvt4.[1007] as N'переменные_F_63',
			pvt4.[1017] as N'постоянные_D_54',
			pvt4.[1016] as N'постоянные_C_54',
			pvt4.[1021] as N'постоянные_J_54',
			pvt4.[1005] as N'переменные_D_63'
	FROM
	(	
		SELECT [Расчёт_потребности_в_кадрах_Столбцы_2024]
				,_Расчёт_потребности_в_кадрах_Строки_2024.врачебная_должность as Врачи
				,[Value]

		FROM [ASMMS].[dbo].[__Расчет_потребности_в_кадрах_2024_год]
		INNER JOIN _Расчёт_потребности_в_кадрах_Строки_2024 ON
			_Расчёт_потребности_в_кадрах_Строки_2024.id = [Расчёт_потребности_в_кадрах_Строки_2024]
		WHERE [Субъект_РФ]=@region AND Расчёт_потребности_в_кадрах_Строки_2024<=1066 AND Расчёт_потребности_в_кадрах_Строки_2024 NOT IN (1022,1039,1021,1040,1056,1061,1062,1052) 
	) t2
	PIVOT
	(
		SUM(Value) FOR [Расчёт_потребности_в_кадрах_Столбцы_2024] IN ([1004],[1022],[1006],[1007],[1017],[1016],[1021],[1005])
	) pvt2

	LEFT JOIN
	(	
		SELECT [Расчёт_потребности_в_кадрах_Столбцы_2024]
				,_Расчёт_потребности_в_кадрах_Строки_2024.врачебная_должность as Врачи
				,[Value]

		FROM [ASMMS].[dbo].[__Расчет_потребности_в_кадрах_2024_год]
		INNER JOIN _Расчёт_потребности_в_кадрах_Строки_2024 ON
			_Расчёт_потребности_в_кадрах_Строки_2024.id = [Расчёт_потребности_в_кадрах_Строки_2024]
		WHERE [Субъект_РФ]=@region AND Расчёт_потребности_в_кадрах_Строки_2024<=1066 AND Расчёт_потребности_в_кадрах_Строки_2024 IN (1022,1021,1040,1056,1061,1052)
	) t3
	PIVOT
	(
		SUM(Value) FOR [Расчёт_потребности_в_кадрах_Столбцы_2024] IN ([1004],[1022],[1006],[1007],[1017],[1016],[1021],[1005])
	) pvt3 ON
		pvt2.Врачи=pvt3.Врачи

	LEFT JOIN
	(	
		SELECT [Расчёт_потребности_в_кадрах_Столбцы_2024]
				,_Расчёт_потребности_в_кадрах_Строки_2024.врачебная_должность as Врачи
				,[Value]

		FROM [ASMMS].[dbo].[__Расчет_потребности_в_кадрах_2024_год]
		INNER JOIN _Расчёт_потребности_в_кадрах_Строки_2024 ON
			_Расчёт_потребности_в_кадрах_Строки_2024.id = [Расчёт_потребности_в_кадрах_Строки_2024]
		WHERE [Субъект_РФ]=@region AND Расчёт_потребности_в_кадрах_Строки_2024<=1066 AND Расчёт_потребности_в_кадрах_Строки_2024 IN (1039,1062)
	) t3
	PIVOT
	(
		SUM(Value) FOR [Расчёт_потребности_в_кадрах_Столбцы_2024] IN ([1004],[1022],[1006],[1007],[1017],[1016],[1021],[1005])
	) pvt4 ON
		pvt2.Врачи=pvt4.Врачи
) a ON
	a.Врачи = pvt.Врачи
