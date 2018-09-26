<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1">catalog_log</xsl:param>
  <xsl:param name="param2">none</xsl:param>

  <xsl:template match="/">
  <root>
     <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
select  o.localisation, 
		o.object_id, 
		oc.needsprocessing_flag, 
		o.derivesecondary_flag, 
		oc.needsprocessing_ts, 
		o.intransaction_flag,
	    to_char(o.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts,
	    to_char(o.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts,
		to_char(o.startofprocessing, 'yyyy-mm-dd"T"hh24:mi:ss') startofprocessing,
		to_char(o.endofprocessing, 'yyyy-mm-dd"T"hh24:mi:ss') endofprocessing,
		o.active_flag, 
		o.status, 
		oc.batch_number, 
		o.remark, 
		o.islocalized, 
		case when o.data is null then 0 else 1 end as dataavailable
 from octl o
 left join octl_control oc
   on oc.modus        = 'BATCH'
  and oc.content_type = o.content_type
  and oc.localisation = o.localisation
  and oc.object_id    = o.object_id 
where o.content_type  = '<xsl:value-of select="$param1"/>'
  and o.localisation  = '<xsl:value-of select="$param2"/>'
order by o.object_id
      </sql:query>
    </sql:execute-query>
  </root>
  </xsl:template>
</xsl:stylesheet>