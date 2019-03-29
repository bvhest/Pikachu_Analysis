## IPL (mag='F02') related products


```{r}
# /* 
# Select all F02 (IPL) related products
# */
qry <- 
  "select m.pm_name 
from m_product_model m
, m_article_group ag
where m.ag_cd = ag.ag_cd
and ag.mag_cd = 'F02'
order by m.pm_name"

DBI::dbGetQuery(conn = pr.jdbcConnection, 
                statement = qry ) %>%
  kableExtra::kable(caption="IPL (F02) related products") %>%
  kableExtra::kable_styling()
``` 


```
# /*
# select all symcure id relation related to an IPL products
# */
qry <- 
  "select count(*) 
from m_symptom_cure_relation scr,
(select pm_name 
from m_product_model m
, m_article_group ag
where m.ag_cd = ag.ag_cd
and ag.mag_cd = 'F02') pm
where scr.pm_name = pm.pm_name"

DBI::dbGetQuery(conn = pr.jdbcConnection, 
                statement = qry ) %>%
  kableExtra::kable(caption="Count of Symptom-cure relations for IPL products") %>%
  kableExtra::kable_styling()
```




```
# /*
# select all symcure id related to IPL products
# */
qry <- 
  "select count(pm.pm_name) 
from m_symptom_cure_relation scr, 
(select pm_name 
from m_product_model m
, m_article_group ag
where m.ag_cd = ag.ag_cd
and ag.mag_cd = 'F02') pm,
m_symptom_cure SC
where scr.pm_name = pm.pm_name
and scr.sycu_id = sc.sycu_id"

DBI::dbGetQuery(conn = pr.jdbcConnection, 
                statement = qry ) %>%
  kableExtra::kable(caption="Count of Symptom-cure records for IPL products") %>%
  kableExtra::kable_styling()
```

```{r}
# /*
# Select the count per document type for ALL secured FAQs
# */
qry <- 
  "select sc.dt_cd as doc_type, count(pm.pm_name) as product_count
from m_symptom_cure SC,
     m_symptom_cure_relation scr,
     m_document_type dt, 
     (select pm_name 
      from m_product_model m
         , m_article_group ag
      where m.ag_cd = ag.ag_cd
      and ag.mag_cd = 'F02') pm
where scr.pm_name = pm.pm_name
  and scr.sycu_id = sc.sycu_id
  and dt.dt_cd    = sc.dt_cd
  and dt.dt_restricted_ind = 'Y'
group by sc.dt_cd
order by product_count desc" 

DBI::dbGetQuery(conn = pr.jdbcConnection, 
                statement = qry ) %>%
  kableExtra::kable(caption="Product-count per secured doc-type for Symptom-cure records for IPL products") %>%
  kableExtra::kable_styling()
```
