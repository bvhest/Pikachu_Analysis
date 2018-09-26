<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cinclude="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:osm="http://osmosis.gr/osml/1.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:param name="param1"></xsl:param>
	<xsl:param name="param2"></xsl:param>
	<xsl:param name="id"></xsl:param>
	<xsl:template match="/">
		<root>
			<xsl:choose>
				<xsl:when test="(not ($id)) or ($id ='')">
					<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
						<sql:query>
							select cr.level, cr,output_content_type, cr.output_localisation, cr.input_content_type, cr.input_localisation, nvl(cts.id,0) schedule_id
							from ctl_relations cr
              left outer join (select content_type, max(id) id from content_type_schedule group by content_type) cts 
                on cts.content_type = cr.input_content_type
							connect by 
								prior output_content_type = input_content_type and 
								prior output_localisation = input_localisation
							start with 
								input_content_type = '<xsl:value-of select="$param1"/>' and 
								input_localisation = '<xsl:value-of select="$param2"/>'
              order by nvl(cts.id,0)                
						</sql:query>
					</sql:execute-query>
				</xsl:when>
				<xsl:otherwise>
					<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
						<sql:query>
                  select level, o.content_type, o.localisation, o.object_id
                       , oc.needsprocessing_flag
                       , ore.input_content_type, ore.input_localisation, ore.output_content_type, ore.output_localisation
                       , TO_CHAR(o.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
                       , TO_CHAR(o.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
                       , ore.issecondary
                       , case when o.data is null then 0 else 1 end as dataavailable
                       , nvl(cts.id,0) schedule_id
                  from octl_relations ore
                     , octl o
                  left join octl_control oc
                     on oc.content_type = o.content_type
                    and oc.localisation = o.localisation
                    and oc.object_id    = o.object_id
                    and oc.modus        = 'BATCH'
                  left outer join (select content_type, max(id) id from content_type_schedule group by content_type) cts 
                    on cts.content_type = o.content_type
              where ore.output_content_type = o.content_type
                and ore.output_localisation = o.localisation
                and ore.output_object_id    = o.object_id
                and ore.issecondary         = 0
            connect by prior ore.output_content_type = ore.input_content_type
                   and prior ore.output_localisation = ore.input_localisation
                   and prior ore.output_object_id    = ore.input_object_id 
            start with ore.input_content_type = '<xsl:value-of select="$param1"/>'
                   and ore.input_localisation = '<xsl:value-of select="$param2"/>'
                   and ore.input_object_id    = '<xsl:value-of select="$id"/>'
            order by nvl(cts.id,0)        
						</sql:query>						
				        <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
							<sql:query name="secondaries">
								select 
								  ocr.input_object_id,
								  ocr.input_localisation,
								  ocr.input_content_type,
								  TO_CHAR(os.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts,
								  TO_CHAR(os.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts
								from octl_relations ocr
						left join octl os on
						  os.content_type = ocr.input_content_type
						  and os.object_id = ocr.input_object_id
						  and os.localisation = ocr.input_localisation
								where 
								  ocr.output_object_id = '<sql:ancestor-value name="object_id" level="1"/>' 
								  and ocr.output_localisation = '<sql:ancestor-value name="localisation" level="1"/>' 
								  and ocr.output_content_type = '<sql:ancestor-value name="content_type" level="1"/>' 
								  and ocr.issecondary = 1
							</sql:query>
				        </sql:execute-query>
					</sql:execute-query>
				</xsl:otherwise>
			</xsl:choose>
		</root>
	</xsl:template>
</xsl:stylesheet>
