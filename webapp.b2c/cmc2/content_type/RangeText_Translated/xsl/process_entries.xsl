<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:sql="http://apache.org/cocoon/SQL/2.0">
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  <!-- Clean content returned from call to service 'get' routine -->
  <xsl:template match="octl|sql:rowset|sql:row|sql:data">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <!-- -->
  <xsl:template match="sql:*"/>
  <!-- -->
  <xsl:template match="octl-attributes[../@valid='true']">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()[not(local-name()='masterlastmodified_ts' or local-name()='status')]"/>
      <xsl:element name="masterlastmodified_ts"><xsl:value-of select="../content/octl/sql:rowset/sql:row[sql:content_type='RangeText_Localized']/sql:masterlastmodified_ts"/></xsl:element>
      <xsl:element name="status">
        <xsl:value-of select="../content/octl/sql:rowset/sql:row[sql:content_type='RangeText_Localized']/sql:status"/>
      </xsl:element>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="process">
    <sql:execute-query>
      <sql:query name="getcategorization">
        select c.*
          from categorization c
         inner join vw_object_categorization oc
            on oc.subcategory = c.subcategorycode
           and oc.catalogcode = c.catalogcode                   
         where oc.object_id   = '<xsl:value-of select="(../content/octl/sql:rowset/sql:row/sql:data/Node/ProductReferences/ProductReference/CTN
                                                      | ../content/octl/sql:rowset/sql:row/sql:data/Node/ProductRefs/ProductReference/CTN
                                                      | ../content/octl/sql:rowset/sql:row/sql:data/Node/ProductRefs/ProductReference/Product/@ctn)[1]"/>'
           and oc.catalogcode = 'MASTER'
       </sql:query>
    </sql:execute-query>
    <sql:execute-query>
      <sql:query name="getroutingname">
        select groupname || '/' || categoryname routingname
          from categorization
         where categorycode = '<xsl:value-of select="substring-after(../content/octl/sql:rowset/sql:row/sql:data/Node/@routingCode,'/')"/>'
           and catalogcode  = 'MASTER'                     
           and rownum       = 1
      </sql:query>
    </sql:execute-query>
  </xsl:template>
  <!-- -->
 </xsl:stylesheet>
