SELECT ROW_NUMBER() OVER (ORDER BY t.Порядок_для_отчета) as Номер,t.Name as Регион,N'процент' as Единица,t1.План,t1.Факт
FROM (select Id,Name,HierarchicalLevel,iif(Id=1136,100,iif(Id=1137,101,iif(Id=1135,102,iif(Id=1138,103,Порядок_для_отчета)))) as Порядок_для_отчета from _Регион where HierarchicalLevel=3 or (Id<=1008 and Id>=1001) /*and Id<=1134*/ or (Id>=1135 and Id<=1138)) as t
left join (
select Регион,Период,Календарный_год,[План],[Факт]
from (
select Регион,Период,Календарный_год,Показатель,isnull(Значение,0) as Значение
from (
select N'План' as Показатель,Регион,Период,Календарный_год,Значение from _Справочник_Анкета2_Плановые_значения_показателя where Период=@Period and Календарный_год=@God
union all
/*Месяцы*/
select Показатель,Регион,Период,Календарный_год,Значение
from (
select N'Факт' as Показатель,t.region as Регион,t.Период,t.Кален_год as Календарный_год,iif(t.kol=0,0,(cast(t1.kol as float)/cast(t.kol as float))*100) as Значение
from (select region,Период,Кален_год,count(*) as kol from _Анкета2 where Кален_год=@God and Период=@Period and (not gen_sat is null or gen_sat<>0) /*and region<=1134*/ group by region,Период,Кален_год) as t
left join (select region,Период,Кален_год,count(*) as kol from _Анкета2 where Кален_год=@God and Период=@Period and (gen_sat=1004 or gen_sat=1005) /*and region<=1134*/ group by region,Период,Кален_год) as t1 on t.region=t1.region and t.Период=t1.Период
union all
select N'Факт' as Показатель,Регион,Период,Календарный_год,Значение
from (
select t2.HierarchicalParent as Регион,t.Период,t.Кален_год as Календарный_год,sum(iif(t.kol=0,0,(cast(koef.Значение_для_федерального_округа as float)*cast(t1.kol as float)/cast(t.kol as float))*100)) as Значение
from (select region,Период,Кален_год,count(*) as kol from _Анкета2 where Кален_год=@God and Период=@Period and (not gen_sat is null or gen_sat<>0) /*and region<=1134*/ group by region,Период,Кален_год) as t
left join (select region,Период,count(*) as kol from _Анкета2 where Кален_год=@God and Период=@Period and (gen_sat=1004 or gen_sat=1005) /*and region<=1134*/ group by region,Период) as t1 on t.region=t1.region and t.Период=t1.Период
left join _Справочник_Анкета2_весовая_константа_субъекта_ as koef ON koef.id_региона=t.region
left join _Регион as t2 on t2.Id=t.region and t2.HierarchicalLevel=3
group by t2.HierarchicalParent,t.Период,t.Кален_год
) as t
) as t where @Period<>1001
union all
/*Год*/
select Показатель,Регион,1001 as Период,Календарный_год,avg(Значение) as Значение
from (
select N'Факт' as Показатель,t.region as Регион,t.Период,t.Кален_год as Календарный_год,iif(t.kol=0,0,(cast(t1.kol as float)/cast(t.kol as float))*100) as Значение
from (select region,Период,Кален_год,count(*) as kol from _Анкета2 where Кален_год=@God and Период in (1003,1004,1005,1008,1009,1010,1012,1013,1014,1016,1017,1018) and (not gen_sat is null or gen_sat<>0) /*and region<=1134*/ group by region,Период,Кален_год) as t
left join (select region,Период,Кален_год,count(*) as kol from _Анкета2 where Кален_год=@God and Период in (1003,1004,1005,1008,1009,1010,1012,1013,1014,1016,1017,1018) and (gen_sat=1004 or gen_sat=1005) /*and region<=1134*/ group by region,Период,Кален_год) as t1 on t.region=t1.region and t.Период=t1.Период
union all
select N'Факт' as Показатель,Регион,Период,Календарный_год,Значение
from (
select t2.HierarchicalParent as Регион,t.Период,t.Кален_год as Календарный_год,sum(iif(t.kol=0,0,(cast(koef.Значение_для_федерального_округа as float)*cast(t1.kol as float)/cast(t.kol as float))*100)) as Значение
from (select region,Период,Кален_год,count(*) as kol from _Анкета2 where Кален_год=@God and Период in (1003,1004,1005,1008,1009,1010,1012,1013,1014,1016,1017,1018) and (not gen_sat is null or gen_sat<>0) /*and region<=1134*/ group by region,Период,Кален_год) as t
left join (select region,Период,count(*) as kol from _Анкета2 where Кален_год=@God and Период in (1003,1004,1005,1008,1009,1010,1012,1013,1014,1016,1017,1018) and (gen_sat=1004 or gen_sat=1005) /*and region<=1134*/ group by region,Период) as t1 on t.region=t1.region and t.Период=t1.Период
left join _Справочник_Анкета2_весовая_константа_субъекта_ as koef ON koef.id_региона=t.region
left join _Регион as t2 on t2.Id=t.region and t2.HierarchicalLevel=3
group by t2.HierarchicalParent,t.Период,t.Кален_год
) as t
) as t where @Period=1001
group by Показатель,Регион,Календарный_год
) as t
) as t
pivot (
sum(Значение)
for Показатель in ([План],[Факт])
) as pvt
) as t1 on t1.Регион=t.Id and t1.Период=@Period and t1.Календарный_год=@God
--where t.HierarchicalLevel=3
order by t.Порядок_для_отчета