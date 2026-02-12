DECLARE @Period int = 1003
DECLARE @God int = 1016

SELECT
    ROW_NUMBER() OVER (ORDER BY t.Порядок_для_отчета) AS Номер,
    t.Name AS Регион,
    N'процент' AS Единица,
    t1.План,
    t1.Факт
FROM (
    SELECT
        Id,
        Name,
        HierarchicalLevel,
        iif(
            Id = 1136, 100,
            iif(
                Id = 1137, 101,
                iif(
                    Id = 1135, 102,
                    iif(Id = 1138, 103, Порядок_для_отчета)
                )
            )
        ) AS Порядок_для_отчета
    FROM _Регион
    WHERE HierarchicalLevel = 3
       OR (Id <= 1008 AND Id >= 1001) /*and Id<=1134*/
       OR (Id >= 1135 AND Id <= 1138)
) AS t
LEFT JOIN (
    SELECT Регион, Период, Календарный_год, [План], [Факт]
    FROM (
        SELECT
            Регион,
            Период,
            Календарный_год,
            Показатель,
            isnull(Значение, 0) AS Значение
        FROM (
            SELECT
                N'План' AS Показатель,
                Регион,
                Период,
                Календарный_год,
                Значение
            FROM _Справочник_Анкета2_Плановые_значения_показателя
            WHERE Период = @Period AND Календарный_год = @God
            UNION ALL
            /*Месяцы*/
            SELECT Показатель, Регион, Период, Календарный_год, Значение
            FROM (
                SELECT
                    N'Факт' AS Показатель,
                    t.region AS Регион,
                    t.Период,
                    t.Кален_год AS Календарный_год,
                    iif(t.kol = 0, 0, (cast(t1.kol AS float) / cast(t.kol AS float)) * 100) AS Значение
                FROM (
                    SELECT region, Период, Кален_год, count(*) AS kol
                    FROM _Анкета2
                    WHERE Кален_год = @God
                      AND Период = @Period
                      AND (NOT gen_sat IS NULL OR gen_sat <> 0) /*and region<=1134*/
                    GROUP BY region, Период, Кален_год
                ) AS t
                LEFT JOIN (
                    SELECT region, Период, Кален_год, count(*) AS kol
                    FROM _Анкета2
                    WHERE Кален_год = @God
                      AND Период = @Period
                      AND (gen_sat = 1004 OR gen_sat = 1005) /*and region<=1134*/
                    GROUP BY region, Период, Кален_год
                ) AS t1 ON t.region = t1.region AND t.Период = t1.Период
                UNION ALL
                SELECT N'Факт' AS Показатель, Регион, Период, Календарный_год, Значение
                FROM (
                    SELECT
                        t2.HierarchicalParent AS Регион,
                        t.Период,
                        t.Кален_год AS Календарный_год,
                        sum(
                            iif(
                                t.kol = 0,
                                0,
                                (cast(koef.Значение_для_федерального_округа AS float) * cast(t1.kol AS float) / cast(t.kol AS float)) * 100
                            )
                        ) AS Значение
                    FROM (
                        SELECT region, Период, Кален_год, count(*) AS kol
                        FROM _Анкета2
                        WHERE Кален_год = @God
                          AND Период = @Period
                          AND (NOT gen_sat IS NULL OR gen_sat <> 0) /*and region<=1134*/
                        GROUP BY region, Период, Кален_год
                    ) AS t
                    LEFT JOIN (
                        SELECT region, Период, count(*) AS kol
                        FROM _Анкета2
                        WHERE Кален_год = @God
                          AND Период = @Period
                          AND (gen_sat = 1004 OR gen_sat = 1005) /*and region<=1134*/
                        GROUP BY region, Период
                    ) AS t1 ON t.region = t1.region AND t.Период = t1.Период
                    LEFT JOIN _Справочник_Анкета2_весовая_константа_субъекта_ AS koef ON koef.id_региона = t.region
                    LEFT JOIN _Регион AS t2 ON t2.Id = t.region AND t2.HierarchicalLevel = 3
                    GROUP BY t2.HierarchicalParent, t.Период, t.Кален_год
                ) AS t
            ) AS t
            WHERE @Period <> 1001
            UNION ALL
            /*Год*/
            SELECT Показатель, Регион, 1001 AS Период, Календарный_год, avg(Значение) AS Значение
            FROM (
                SELECT
                    N'Факт' AS Показатель,
                    t.region AS Регион,
                    t.Период,
                    t.Кален_год AS Календарный_год,
                    iif(t.kol = 0, 0, (cast(t1.kol AS float) / cast(t.kol AS float)) * 100) AS Значение
                FROM (
                    SELECT region, Период, Кален_год, count(*) AS kol
                    FROM _Анкета2
                    WHERE Кален_год = @God
                      AND Период IN (1003, 1004, 1005, 1008, 1009, 1010, 1012, 1013, 1014, 1016, 1017, 1018)
                      AND (NOT gen_sat IS NULL OR gen_sat <> 0) /*and region<=1134*/
                    GROUP BY region, Период, Кален_год
                ) AS t
                LEFT JOIN (
                    SELECT region, Период, Кален_год, count(*) AS kol
                    FROM _Анкета2
                    WHERE Кален_год = @God
                      AND Период IN (1003, 1004, 1005, 1008, 1009, 1010, 1012, 1013, 1014, 1016, 1017, 1018)
                      AND (gen_sat = 1004 OR gen_sat = 1005) /*and region<=1134*/
                    GROUP BY region, Период, Кален_год
                ) AS t1 ON t.region = t1.region AND t.Период = t1.Период
                UNION ALL
                SELECT N'Факт' AS Показатель, Регион, Период, Календарный_год, Значение
                FROM (
                    SELECT
                        t2.HierarchicalParent AS Регион,
                        t.Период,
                        t.Кален_год AS Календарный_год,
                        sum(
                            iif(
                                t.kol = 0,
                                0,
                                (cast(koef.Значение_для_федерального_округа AS float) * cast(t1.kol AS float) / cast(t.kol AS float)) * 100
                            )
                        ) AS Значение
                    FROM (
                        SELECT region, Период, Кален_год, count(*) AS kol
                        FROM _Анкета2
                        WHERE Кален_год = @God
                          AND Период IN (1003, 1004, 1005, 1008, 1009, 1010, 1012, 1013, 1014, 1016, 1017, 1018)
                          AND (NOT gen_sat IS NULL OR gen_sat <> 0) /*and region<=1134*/
                        GROUP BY region, Период, Кален_год
                    ) AS t
                    LEFT JOIN (
                        SELECT region, Период, count(*) AS kol
                        FROM _Анкета2
                        WHERE Кален_год = @God
                          AND Период IN (1003, 1004, 1005, 1008, 1009, 1010, 1012, 1013, 1014, 1016, 1017, 1018)
                          AND (gen_sat = 1004 OR gen_sat = 1005) /*and region<=1134*/
                        GROUP BY region, Период
                    ) AS t1 ON t.region = t1.region AND t.Период = t1.Период
                    LEFT JOIN _Справочник_Анкета2_весовая_константа_субъекта_ AS koef ON koef.id_региона = t.region
                    LEFT JOIN _Регион AS t2 ON t2.Id = t.region AND t2.HierarchicalLevel = 3
                    GROUP BY t2.HierarchicalParent, t.Период, t.Кален_год
                ) AS t
            ) AS t
            WHERE @Period = 1001
            GROUP BY Показатель, Регион, Календарный_год
        ) AS t
    ) AS t
    PIVOT (
        sum(Значение)
        FOR Показатель IN ([План], [Факт])
    ) AS pvt
) AS t1 ON t1.Регион = t.Id AND t1.Период = @Period AND t1.Календарный_год = @God
--where t.HierarchicalLevel=3
ORDER BY t.Порядок_для_отчета
