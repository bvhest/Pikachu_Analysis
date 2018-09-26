<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:my="http://www.philips.com/pika"
                xmlns:cmc2-f="http://www.philips.com/cmc2-f"
                extension-element-prefixes="cmc2-f"
                >
   <!-- -->
   <xsl:import href="../../../xsl/common/cmc2.function.xsl"/>
   <!-- -->
   <xsl:function name="my:ora" as="xs:string" >
      <xsl:param name="value"/>
      <xsl:variable name="q">'</xsl:variable>
      <xsl:variable name="o">'||chr(39)||'</xsl:variable>
      <xsl:sequence select="replace($value,$q,$o)"/>
   </xsl:function>
	<!-- -->
   <xsl:template match="/Product">
      <root>
         <sql:execute-query name="groups">
            <sql:query>
               DELETE FROM pms_config_alert_evaluations
            </sql:query>
         </sql:execute-query>
         <xsl:apply-templates select="Node"/>
      </root>
   </xsl:template>
	<!-- -->
  <xsl:template match="Node">
		<xsl:copy>
		<xsl:copy-of select="@*"/>
			<sql:execute-query name="aggregate">
				<sql:query>
				 INSERT INTO pms_config_alert_evaluations
                   ( COLUMNID
                   , CALCTYPE
                   , IN_AGGREGATION
                   , LABEL
                   , DESCRIPTION_ON_SUCCESS
                   , DESCRIPTION_ON_ERROR
                   , FK_COLUMNID
                   , MCI
                   , KEY
                   , OTHER
                   , ACCESSORY
                   , BASESEVERITY
                   , T0_BASETARGET
                   , T0_OFFSET
                   , T1_BASETARGET
                   , T1_OFFSET
                   , T2_BASETARGET
                   , T2_OFFSET
                   , T3_BASETARGET
                   , T3_OFFSET
                   , T4_BASETARGET
                   , T4_OFFSET
                   )
				 VALUES('<xsl:value-of select="@columnID"/>'
                   ,'<xsl:value-of select="@calcType"/>'
                   ,<xsl:value-of select="if (@inAggregation='true') then 1 else 0"/>
                   ,'<xsl:value-of select="@refName"/>'
                   ,'<xsl:value-of select="cmc2-f:escape-sql(./DescriptionOnSuccess, false())" />'
                   ,'<xsl:value-of select="cmc2-f:escape-sql(./DescriptionOnError, false())" />'
                   ,'<xsl:value-of select="parent::*/@columnID"/>'
                   ,'<xsl:value-of select="./Requirements/@MCI"/>'
                   ,'<xsl:value-of select="./Requirements/@Key"/>'
                   ,'<xsl:value-of select="./Requirements/@Other"/>'
                   ,'<xsl:value-of select="./Requirements/@Accessory"/>'
                   ,'<xsl:value-of select="./BaseUrgency"/>'
                   ,'<xsl:value-of select="./Date[@type='t0']/@milestone "/>'
                   ,'<xsl:value-of select="./Date[@type='t0']/@offset"/>'
                   ,'<xsl:value-of select="./Date[@type='t1']/@milestone "/>'
                   ,'<xsl:value-of select="./Date[@type='t1']/@offset"/>'
                   ,'<xsl:value-of select="./Date[@type='t2']/@milestone "/>'
                   ,'<xsl:value-of select="./Date[@type='t2']/@offset"/>'
                   ,'<xsl:value-of select="./Date[@type='t3']/@milestone "/>'
                   ,'<xsl:value-of select="./Date[@type='t3']/@offset"/>'
                   ,'<xsl:value-of select="./Date[@type='t4']/@milestone "/>'
                   ,'<xsl:value-of select="./Date[@type='t4']/@offset"/>'
                   )
            </sql:query>
			</sql:execute-query>
		</xsl:copy>
		<xsl:apply-templates select="Node"/>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
