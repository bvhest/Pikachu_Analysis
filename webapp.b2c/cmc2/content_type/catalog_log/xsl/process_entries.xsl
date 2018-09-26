<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sql="http://apache.org/cocoon/SQL/2.0">

    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="content[../@valid='true']">
        <xsl:copy>
            <sql:execute-query>
                <sql:query isstoredprocedure="true">
                    BEGIN
                        PCK_CATALOG.create_catalog_placeholders('<xsl:value-of select="../@o"/>',1);
                    END;
                </sql:query>
            </sql:execute-query>
            <sql:execute-query>
                <sql:query name="selectProcessedRows">
                  select to_char(o.masterlastmodified_ts,'YYYY-MM-DD"T"HH24:MI:SS') masterlastmodified_ts
                       , co.object_id object
                       , co.customer_id
                       , co.country
                       , co.division
                       , co.gtin
                       , to_char(co.sop, 'YYYY-MM-DD"T"HH24:MI:SS') sop
                       , to_char(co.eop, 'YYYY-MM-DD"T"HH24:MI:SS') eop
                       , to_char(co.sos, 'YYYY-MM-DD"T"HH24:MI:SS') sos
                       , to_char(co.eos, 'YYYY-MM-DD"T"HH24:MI:SS') eos
                       , co.buy_online
                       , co.local_going_price
                       , co.deleted
                       , to_char(co.delete_after_date, 'YYYY-MM-DD"T"HH24:MI:SS') delete_after_date
                       , co.priority
                       , to_char(co.lastmodified,'YYYY-MM-DD"T"HH24:MI:SS') lastmodified
                    from catalog_objects co 
                   inner join octl o 
                      on o.object_id             = co.catalog_id
                   where co.needsprocessing_flag = -1
                     and o.content_type          = 'catalog_definition'
                     and o.object_id             = '<xsl:value-of select="../@o"/>'
                </sql:query>
            </sql:execute-query>
            <sql:execute-query>
                <sql:query name="resetProcessedRows">
                  update catalog_objects
                     set needsprocessing_flag = 0
                   where catalog_id = '<xsl:value-of select="../@o"/>'
                     and needsprocessing_flag = -1
                </sql:query>
            </sql:execute-query>            
        </xsl:copy>
    </xsl:template>

      <!-- process octl attributes -->
    <xsl:template match="octl-attributes[../@valid='true']">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()[not(local-name()='masterlastmodified_ts' or local-name()='status')]"/>
          <xsl:element name="masterlastmodified_ts">
          		 <xsl:value-of select="lastmodified_ts"/>
           </xsl:element>
          <xsl:element name="status">
            <xsl:value-of select="'Loaded'"/>
          </xsl:element>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>