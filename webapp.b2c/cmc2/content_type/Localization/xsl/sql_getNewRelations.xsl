<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:param name="ct"/>
  <xsl:variable name="doctimestamp" select="'1900-01-01T00:00:00'"/>
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="currentrelations/sql:rowset">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="currentrelations/sql:rowset/sql:row">
    <relation>
      <xsl:apply-templates select="@*|node()"/>
    </relation>
  </xsl:template>
  <!-- -->
  <xsl:template match="currentrelations/sql:rowset/sql:row/sql:*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  <!-- -->
  <xsl:template match="currentcontent">
    <xsl:copy>
      <xsl:apply-templates select="sql:rowset/sql:row/sql:data/Localization"/>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry">
   <xsl:copy>
      <xsl:apply-templates select="@*[not(local-name()='valid')] "/>
      <!-- work out which products are affected by the new content -->
      <xsl:variable name="currentcontent" select="currentcontent/sql:rowset/sql:row/sql:data/Localization"/>
      <xsl:variable name="newcontent"     select="content/Localization"/>
      <xsl:choose>
        <xsl:when test="deep-equal($currentcontent/*,$newcontent/*)">
          <xsl:attribute name="valid">false</xsl:attribute>
          <xsl:element name="result">Identical octl exists</xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@valid|result"/>
          <xsl:apply-templates select="node()[not(local-name()='result')]"/>
        </xsl:otherwise>        
      </xsl:choose>
          <newrelations>
            <!-- Only determine new relations if the incoming content is active -->
            <xsl:if test="$newcontent/Active = 'YES'">
              <sql:execute-query>
                <sql:query name="PMT_Localised">
                    select o.content_type, o.localisation, o.object_id, o.masterlastmodified_ts, o.lastmodified_ts, o.status
                      from octl o
                inner join vw_object_categorization oc
                        on oc.object_id   = o.object_id
                     where o.content_type = 'PMT_Localised'
                       and o.localisation = '<xsl:value-of select="concat('master_',content/Localization/Country)"/>'
                       and o.status      != 'PLACEHOLDER'
                       and oc.catalogcode = 'MASTER'
                       and oc.subcategory IN (<xsl:for-each select="tokenize(content/Localization/SubCategory,',')"><xsl:if test="position() != 1">,</xsl:if>'<xsl:value-of select="."/>'</xsl:for-each>)
                  <xsl:if test="content/Localization/CTNMask != ''">
                       and o.object_id like '<xsl:value-of select="translate(normalize-space(content/Localization/CTNMask),'*?','%_')"/>'
                  </xsl:if>
                </sql:query>
              </sql:execute-query>
              <sql:execute-query>
                <sql:query name="RangeText_Localized">
                 select rtl.content_type, rtl.localisation, rtl.object_id, rtl.masterlastmodified_ts, rtl.lastmodified_ts, rtl.status
                   from octl rtl
                  inner join octl_relations r
                     on r.input_object_id     = rtl.object_id
                  inner join vw_object_categorization oc
                     on oc.object_id          = r.output_object_id
                  where r.output_content_type = 'PMT_Master'
                    and r.input_content_type  = 'RangeText_Raw'
                    and r.input_localisation  = 'none'
                    and rtl.content_type      = 'RangeText_Localized'
                    and rtl.localisation      = '<xsl:value-of select="concat('master_',content/Localization/Country)"/>'
                    and oc.catalogcode        = 'MASTER'
                    and oc.subcategory IN (<xsl:for-each select="tokenize(content/Localization/SubCategory,',')"><xsl:if test="position() != 1">,</xsl:if>'<xsl:value-of select="."/>'</xsl:for-each>)
                  <xsl:if test="content/Localization/CTNMask != ''">
                    and r.output_object_id like '<xsl:value-of select="translate(normalize-space(content/Localization/CTNMask),'*?','%_')"/>'
                  </xsl:if>
                </sql:query>
              </sql:execute-query>
            </xsl:if>
          </newrelations>      
    </xsl:copy>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>

