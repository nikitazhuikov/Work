WITH CTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY [ЕКВ_специальности], [ЕКВ_показатели], [Календарный_год], [Период], [Субъект_РФ]
            ORDER BY [Id]
        ) AS RowNum
    FROM [ASMMS].[dbo].[__Единовременные_компенсационные_выплаты_приложение_2]
    WHERE [Календарный_год]=1015
        and [Период]=1017 
        and [Субъект_РФ]=1059 

)
DELETE FROM CTE WHERE RowNum > 1