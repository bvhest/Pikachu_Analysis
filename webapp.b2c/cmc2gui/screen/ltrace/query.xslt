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
								prior input_content_type = output_content_type and 
								prior input_localisation = output_localisation
							start with 
								output_content_type = '<xsl:value-of select="$param1"/>' and 
								output_localisation = '<xsl:value-of select="$param2"/>'
              order by nvl(cts.id,0)                  
								</sql:query>
					</sql:execute-query>
				</xsl:when>
				<xsl:otherwise>
					<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
						<sql:query>
						select level, octl.content_type, octl.localisation, octl.object_id, oc.needsprocessing_flag,
						  input_content_type, input_localisation, output_content_type, output_localisation, 
								  TO_CHAR(octl.masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts,
								  TO_CHAR(octl.lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts,issecondary,
						  case when octl.data is null then 0 else 1 end as dataavailable, nvl(cts.id,0) schedule_id
 						from octl_relations
                     , octl
                   left join octl_control oc
                     on oc.modus        = 'BATCH'
                    and oc.content_type = octl.content_type
                    and oc.localisation = octl.localisation
                    and oc.object_id    = octl.object_id  
            left outer join (select content_type, max(id) id from content_type_schedule group by content_type) cts 
              on cts.content_type = octl.content_type              
						where
						  input_content_type = octl.content_type and
						  input_localisation = octl.localisation and
						  input_object_id = octl.object_id
						  and issecondary = 0
						connect by 
						  prior input_content_type = output_content_type and 
						  prior input_localisation = output_localisation and 
						  prior input_object_id = output_object_id 
						start with 
							output_content_type = '<xsl:value-of select="$param1"/>' and 
							output_localisation = '<xsl:value-of select="$param2"/>' and 
							output_object_id='<xsl:value-of select="$id"/>'
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
