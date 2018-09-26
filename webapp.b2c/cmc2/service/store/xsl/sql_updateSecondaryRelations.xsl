<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:template match="@*|node()">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="secondary">
		<xsl:copy copy-namespaces="no">
			<xsl:variable name="total" select="count(relation)"/>
      <sql:execute-query>
        <sql:query name="new-relations">
begin
            
	<xsl:for-each select="relation">
            <xsl:variable name="fields" select="tokenize(., ',')" />
            insert into octl_relations$ values(
               <xsl:value-of select="$fields[1]" />
              ,<xsl:value-of select="$fields[2]" />
              ,<xsl:value-of select="$fields[3]" />
              ,<xsl:value-of select="$fields[4]" />
              ,<xsl:value-of select="$fields[5]" />
              ,<xsl:value-of select="$fields[6]" />
              ,<xsl:value-of select="$fields[7]" />
              ,<xsl:value-of select="$fields[8]" />
            );
          </xsl:for-each>

          PCK_OCTL.update_secondary_relations();
      commit;
exception
   when others then 
     rollback; 
     raise_application_error (-20000, 'Error calling update_secondary_relations():'||sqlerrm);
end;
        </sql:query>
      </sql:execute-query>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
