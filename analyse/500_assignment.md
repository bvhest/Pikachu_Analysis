/* Result:
  
  select sc.dt_cd, count(*) 
from 
m_symptom_cure_relation SCR, 
m_symptom_cure SC,
m_document_type DT
where SCR.SYCU_ID=SC.SYCU_ID
and dt.dt_cd = SC.DT_CD
and dt.dt_restricted_ind='Y'
group by sc.dt_cd
MAG02
GSM	108
SUE	3690
CCS	2441
SCE	7893
RSN	1977
SUH	10
GDA	18057
SCC	9482
CCT	514468
GSC	18654
RSL	1
SCH	2
SCP	39
RSE	1
RSA	22
STI	3693
SUC	6182
SUM	4353
GSP	50
SCO	29204
GSE	8106
SDA	68846
*/
  
  
/*
  Select all products that have a restricted asset linked to it
*/
  select scr.pm_name, count(*) 
from 
m_symptom_cure_relation SCR, 
m_symptom_cure SC,
m_document_type DT
where SCR.SYCU_ID=SC.SYCU_ID
and dt.dt_cd = SC.DT_CD
and dt.dt_restricted_ind='Y'
group by scr.pm_name


# welke zijn restricted of publiek?


2) GTIN info voor IPL/Wakeuplights uploaden in step (
  meerdere GTIN's per product. Wat is de packaging info. Welke data betreft de Pieces.
)
personal care - 9044*
material number varieerd minder dan GTIN. Wat zijn de Piece, Each, Stuck, etc? Liefst alle typen, maar in ieder geval de PCE!

hoe lager de GTIN-code, hoe lager in de packaging hierarchy. 
--> wat zijn de PCE (Pieces)?

zoek in CCR naar logistic password. Wat staat geregistreerd als Piece?

liefst een repeatable process !

story = IPL SRC: B2C GTIN data

