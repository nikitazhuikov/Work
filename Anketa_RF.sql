SELECT
    1 AS Номер,
    N'«Удовлетворенность населения медицинской помощью по результатам оценки общественного мнения»' AS Показатель,
    t1.План,
    t1.Факт
FROM _Регион AS t
LEFT JOIN (
    SELECT Регион, Период, Календарный_год, [План], [Факт]
    FROM (
        SELECT Регион, Период, Календарный_год, Показатель, Значение
        FROM (
            SELECT N'План' AS Показатель, Регион, Период, Календарный_год, Значение
            FROM _Справочник_Анкета2_Плановые_значения_показателя
            WHERE Регион = 1000 AND Период = @Period AND Календарный_год = @God
            UNION ALL
            SELECT Показатель, Регион, Период, Календарный_год, Значение
            FROM (
                SELECT N'Факт' AS Показатель, Регион, Период, Календарный_год, SUM(Значение) AS Значение
                FROM (
                    SELECT
                        1000 AS Регион,
                        t.Период,
                        t.Кален_год AS Календарный_год,
                        IIF(
                            (@God <= 1014 OR (@God = 1015 AND t.Период <= 1010)),
                            IIF(t.kol = 0, 0, (CAST(koef.Значение AS float) * CAST(t1.kol AS float) / CAST(t.kol AS float)) * 100),
                            IIF(t.kol = 0, 0, (CAST(koef1.Значение AS float) * CAST(t1.kol AS float) / CAST(t.kol AS float)) * 100)
                        ) AS Значение
                    FROM (
                        SELECT region, Период, Кален_год, COUNT(*) AS kol
                        FROM _Анкета2
                        WHERE Кален_год = @God
                          AND Период = @Period
                          AND (NOT gen_sat IS NULL OR gen_sat <> 0) /*and region<=1134*/
                        GROUP BY region, Период, Кален_год
                    ) AS t
                    LEFT JOIN (
                        SELECT region, Период, COUNT(*) AS kol
                        FROM _Анкета2
                        WHERE Кален_год = @God
                          AND Период = @Period
                          AND (gen_sat = 1004 OR gen_sat = 1005) /*and region<=1134*/
                        GROUP BY region, Период
                    ) AS t1 ON t.region = t1.region AND t.Период = t1.Период
                    LEFT JOIN _Справочник_Анкета2_весовая_константа_субъекта_ AS koef
                        ON koef.id_региона = t.region AND koef.Значения_до_18_июля_2025 = 1
                    LEFT JOIN _Справочник_Анкета2_весовая_константа_субъекта_ AS koef1
                        ON koef1.id_региона = t.region AND koef1.Значения_с_18_июля_2025 = 1
                ) AS t10
                GROUP BY Регион, Период, Календарный_год
            ) AS t
            WHERE @Period <> 1001
            UNION ALL
            SELECT Показатель, Регион, 1001 AS Период, Календарный_год, AVG(Значение) AS Значение
            FROM (
                SELECT N'Факт' AS Показатель, Регион, Период, Календарный_год, SUM(Значение) AS Значение
                FROM (
                    SELECT
                        1000 AS Регион,
                        t.Период,
                        t.Кален_год AS Календарный_год,
                        IIF(
                            (@God <= 1014 OR (@God = 1015 AND t.Период <= 1010)),
                            IIF(t.kol = 0, 0, (CAST(koef.Значение AS float) * CAST(t1.kol AS float) / CAST(t.kol AS float)) * 100),
                            IIF(t.kol = 0, 0, (CAST(koef1.Значение AS float) * CAST(t1.kol AS float) / CAST(t.kol AS float)) * 100)
                        ) AS Значение
                    FROM (
                        SELECT region, Период, Кален_год, COUNT(*) AS kol
                        FROM _Анкета2
                        WHERE Кален_год = @God
                          AND Период IN (1003, 1004, 1005, 1008, 1009, 1010, 1012, 1013, 1014, 1016, 1017, 1018)
                          AND (NOT gen_sat IS NULL OR gen_sat <> 0) /*and region<=1134*/
                        GROUP BY region, Период, Кален_год
                    ) AS t
                    LEFT JOIN (
                        SELECT region, Период, COUNT(*) AS kol
                        FROM _Анкета2
                        WHERE Кален_год = @God
                          AND Период IN (1003, 1004, 1005, 1008, 1009, 1010, 1012, 1013, 1014, 1016, 1017, 1018)
                          AND (gen_sat = 1004 OR gen_sat = 1005) /*and region<=1134*/
                        GROUP BY region, Период
                    ) AS t1 ON t.region = t1.region AND t.Период = t1.Период
                    LEFT JOIN _Справочник_Анкета2_весовая_константа_субъекта_ AS koef
                        ON koef.id_региона = t.region AND koef.Значения_до_18_июля_2025 = 1
                    LEFT JOIN _Справочник_Анкета2_весовая_константа_субъекта_ AS koef1
                        ON koef1.id_региона = t.region AND koef1.Значения_с_18_июля_2025 = 1
                ) AS t10
                GROUP BY Регион, Период, Календарный_год
            ) AS t
            WHERE @Period = 1001
            GROUP BY Показатель, Регион, Календарный_год
        ) AS t
    ) AS t
    PIVOT (
        SUM(Значение)
        FOR Показатель IN ([План], [Факт])
    ) AS pvt
) AS t1 ON t1.Регион = t.Id AND t1.Период = @Period AND t1.Календарный_год = @God
WHERE t.Id = 1000;