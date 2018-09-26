<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">

	<xsl:param name="o"/>
	<xsl:param name="ct"/>
	<xsl:param name="l"/>
  
  	<xsl:template match="@*|node()">
	    <xsl:copy copy-namespaces="no">
	      <xsl:apply-templates select="@*|node()"/>
	    </xsl:copy>
  	</xsl:template> 
		
	  <xsl:template match="content[../@valid='true']">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<sql:execute-query>
			  <sql:query name="secondarycontent">  
             SELECT  OS.*
               FROM OCTL_STORE OS
         INNER JOIN octl_relations R
                 ON OS.CONTENT_TYPE = R.INPUT_CONTENT_TYPE
                AND OS.LOCALISATION = R.INPUT_LOCALISATION
                AND OS.OBJECT_ID = R.INPUT_OBJECT_ID
         INNER JOIN OCTL O
                 ON O.CONTENT_TYPE = OS.CONTENT_TYPE
                AND O.LOCALISATION = OS.LOCALISATION
                AND O.OBJECT_ID = OS.OBJECT_ID
                AND O.LASTMODIFIED_TS = OS.LASTMODIFIED_TS
                AND O.MASTERLASTMODIFIED_ts = OS.MASTERLASTMODIFIED_TS
				      WHERE R.OUTPUT_CONTENT_TYPE = '<xsl:value-of select="$ct"/>'
					      AND R.OUTPUT_LOCALISATION = '<xsl:value-of select="$l"/>'
					      AND R.OUTPUT_OBJECT_ID = '<xsl:value-of select="$o"/>'
					      AND R.ISSECONDARY = 1
					      AND R.ISDERIVED = 1
                     AND o.status != 'Deleted'
		        </sql:query>
		      </sql:execute-query>
			<sql:execute-query>
			  <sql:query name="subcat">  
             SELECT OC.SUBCATEGORY
               FROM VW_OBJECT_CATEGORIZATION OC
				      WHERE OC.OBJECT_ID = '<xsl:value-of select="$o"/>'
					      AND OC.SOURCE != 'ProductTree'
                and oc.catalogcode = 'MASTER'
		    </sql:query>
		  </sql:execute-query>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>