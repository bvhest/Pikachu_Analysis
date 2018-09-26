<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="entries">
		<entries>
			<xsl:copy-of copy-namespaces="no" select="@*"/>
			<xsl:apply-templates/>
		</entries>
	</xsl:template>

	<xsl:template match="entry">
		<entry>
			<xsl:copy-of copy-namespaces="no" select="@*"/>
			<content>
				<xsl:apply-templates select="content/octl/sql:rowset/sql:row/sql:data/content-type-definition"/>
			</content>
			<xsl:apply-templates/>
		</entry>
	</xsl:template>


	<xsl:template match="store-outputs|result">
		<xsl:copy-of copy-namespaces="no" select="."/>
	</xsl:template>
	<!-- -->
	<xsl:template match="octl-attributes[../@valid='true']">
        <xsl:copy>
          <xsl:copy-of select="@*|node()[not(local-name()='masterlastmodified_ts' or local-name()='status')]"/>
          <xsl:element name="masterlastmodified_ts">
                 <xsl:value-of select="lastmodified_ts"/>    
          </xsl:element>
          <xsl:element name="status">
            <xsl:value-of select="'Loaded'"/>    
          </xsl:element>
        </xsl:copy>        
  </xsl:template>
	
	<xsl:template match="content/octl/sql:rowset/sql:row/sql:data/content-type-definition">
		<xsl:copy>
		<xsl:copy-of select="@*"/>
		<!-- create ct entry -->
		<ct ct="{content-type}">
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>				
            merge into content_types ct 
            using ( select '<xsl:value-of select="content-type"/>'         as content_type
                          ,'<xsl:value-of select="description"/>'          as description
                          ,'<xsl:value-of select="reference-name"/>'       as reference_name
                          ,'<xsl:value-of select="display-name"/>'         as display_name
                          ,'<xsl:value-of select="secondary-derivation"/>' as secondary_derivation 
                    from dual
                   ) s 
               on (ct.content_type=s.content_type)
            when matched then
              update set ct.description         = s.description
                       , ct.reference_name      = s.reference_name
                       , ct.display_name        = s.display_name
                       , ct.secondary_derivation= s.secondary_derivation
            when not matched then
              insert (
                CONTENT_TYPE,
                DESCRIPTION,
                REFERENCE_NAME,
                DISPLAY_NAME,
                SECONDARY_DERIVATION)
              values (
                s.content_type, 
                s.description,
                s.reference_name, 
                s.display_name,
                s.secondary_derivation)
			</sql:query>
		</sql:execute-query>
		</ct>

		<!-- create ctl entry -->
		<ctl ct="{content-type}" l="{localisation}">
		<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
			<sql:query>
            merge into ctl 
            using ( select '<xsl:value-of select="content-type" />' as content_type
                         , '<xsl:value-of select="localisation" />' as localisation
                         , '<xsl:value-of select="offset-days" />' as offset_days
                    from dual
                  ) s 
               on (s.content_type=ctl.content_type
               and s.localisation=ctl.localisation)
            when matched then
              update set ctl.offset_days = s.offset_days
            when not matched then
              insert (CONTENT_TYPE, LOCALISATION, OFFSET_DAYS) 
              values (s.content_type, s.localisation, s.offset_days)
			</sql:query>
		</sql:execute-query>
    <!-- Mark catalog_ctl object for processing by catalog_log -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
         UPDATE catalog_ctl 
            SET needsprocessing_flag=1
          WHERE content_type = '<xsl:value-of select="content-type" />'
            AND localisation = '<xsl:value-of select="localisation" />' 
      </sql:query>
    </sql:execute-query>

    <!-- Mark catalog_ctl objects that follow this ctl for processing by catalog_log -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
         update catalog_ctl 
            set needsprocessing_flag=1
         where exists (
             select distinct output_content_type
             from ctl_relations
             where output_content_type = catalog_ctl.content_type
               and output_localisation = catalog_ctl.localisation
             connect by 
                 prior output_content_type = input_content_type and 
                 prior output_localisation = input_localisation
             start with 
                 input_content_type = '<xsl:value-of select="content-type" />' 
                 and input_localisation = '<xsl:value-of select="localisation" />'
         )
      </sql:query>
    </sql:execute-query>

    <!-- Mark catalog_log objects for processing -->
    <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
      <sql:query>
         update octl_control
            set needsprocessing_flag = 1
          where content_type = 'catalog_log'
            and object_id in (select distinct catalog_id
                              from catalog_ctl
                              where needsprocessing_flag = 1
                              )
      </sql:query>
    </sql:execute-query>
		</ctl>
		
		<!-- create or update ctl relation -->
		<xsl:if test="input-content-type and input-localisation">
			<ctl-relation ct-in="{input-content-type}" l-in="{input-localisation}" ct-out="{content-type}" l-out="{localisation}">
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query>
					INSERT INTO ctl_relations cr (OUTPUT_CONTENT_TYPE, OUTPUT_LOCALISATION, INPUT_CONTENT_TYPE, INPUT_LOCALISATION, ISSECONDARY, GLOBAL_ID )
					SELECT '<xsl:value-of select="content-type"/>',  '<xsl:value-of select="localisation"/>' ,  '<xsl:value-of select="input-content-type"/>',  '<xsl:value-of select="input-localisation"/>', 0 , null
					FROM DUAL
					WHERE NOT EXISTS (SELECT 1 FROM ctl_relations cr1
												WHERE cr1.OUTPUT_CONTENT_TYPE = '<xsl:value-of select="content-type"/>'
												AND cr1.OUTPUT_LOCALISATION =  '<xsl:value-of select="localisation"/>'
												AND cr1. INPUT_CONTENT_TYPE = '<xsl:value-of select="input-content-type"/>'
												AND cr1. INPUT_LOCALISATION =  '<xsl:value-of select="input-localisation"/>')	
				</sql:query>
			</sql:execute-query>
			</ctl-relation>
		
			<xsl:for-each select="secondary">
				<ctl-secondary-relation ct-in="{input-content-type}" l-in="{input-localisation}" ct-out="{content-type}" l-out="{localisation}">
					<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
						<sql:query>
					INSERT INTO ctl_relations cr (OUTPUT_CONTENT_TYPE, OUTPUT_LOCALISATION, INPUT_CONTENT_TYPE, INPUT_LOCALISATION, ISSECONDARY, GLOBAL_ID )
					SELECT '<xsl:value-of select="../content-type"/>',  '<xsl:value-of select="../localisation"/>' ,  '<xsl:value-of select="input-content-type"/>',  '<xsl:value-of select="input-localisation"/>',
								 1 , '<xsl:value-of select="global-id"/>'
					FROM DUAL
					WHERE NOT EXISTS (SELECT 1 FROM ctl_relations cr1
												WHERE cr1.OUTPUT_CONTENT_TYPE = '<xsl:value-of select="../content-type"/>'
												AND cr1.OUTPUT_LOCALISATION =  '<xsl:value-of select="../localisation"/>'
												AND cr1. INPUT_CONTENT_TYPE = '<xsl:value-of select="input-content-type"/>'
												AND cr1. INPUT_LOCALISATION =  '<xsl:value-of select="input-localisation"/>')
						</sql:query>
				</sql:execute-query>
			</ctl-secondary-relation>
			</xsl:for-each>
		</xsl:if>
		<!-- retain original -->
		<xsl:copy-of select="child::*"/>
		</xsl:copy>	
	</xsl:template>
	
	<xsl:template match="@*|node()"/>

</xsl:stylesheet>
