<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
-- remark contains the import/export filename that contains the export date
select
    case when (sub1.tdate is not null) then
        to_date(sub1.tdate,'yyyy-mm-dd hh24:mi:ss')
    else
        to_date(sub2.tdate,'yyyy-mm-dd hh24:mi:ss')
    end as display_exportdate,
    case when (sub1.tdate is not null) then
        sub1.tdate
    else
        sub2.tdate
    end as exportdate,    
    sub1.tcount waiting_import_count,
    sub2.tcount import_count,
    nvl(sub1.tcount,0) + nvl(sub2.tcount,0) as total_count,
    round(nvl(sub2.tcount,0)/(nvl(sub1.tcount,0) + nvl(sub2.tcount,0))*100, 1) as pct_received
from
(
select substr(o1.remark,8,14) tdate, status, count(o1.object_id) tcount
from octl o1
where o1.content_type='PMT_Translated'
and o1.remark is not null
and not (o1.remark like '%PIKACHU%')
and o1.status='AwaitingTranslationImport'
group by substr(o1.remark,8,14), status
) sub1
full outer join
(
select substr(o1.remark,8,14) tdate, status, count(o1.object_id) tcount
from octl o1
where o1.content_type='PMT_Translated'
and o1.remark is not null
and not (o1.remark like '%PIKACHU%')
and o1.status!='AwaitingTranslationImport'
group by substr(o1.remark,8,14), status
) sub2
    on sub1.tdate=sub2.tdate
where rownum &lt;= 60
order by exportdate desc
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>