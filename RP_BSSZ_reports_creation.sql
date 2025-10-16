INSERT INTO [ASMMS].[dbo].[_Мониторинг_РП_СД_история]
(
    [__CreatedOn],
    [id_main_object],
    [Регион],
    [Отчётная_дата],
    [Статус]
)
SELECT 
    GETDATE() AS [__CreatedOn],
    main.[Id] AS [id_main_object],
    main.[Регион],
    main.[Отчетная_дата] AS [Отчётная_дата],
    5167 AS [Статус]
FROM [ASMMS].[dbo].[_Мониторинг_РП_основная_сущность_СД] main
WHERE main.[Регион] IS NOT NULL 
  AND main.[Отчетная_дата] IS NOT NULL;

/****** Проверка количества вставленных записей ******/
SELECT 
    COUNT(*) AS [Количество_вставленных_записей]
FROM [ASMMS].[dbo].[_Мониторинг_РП_СД_история] 
