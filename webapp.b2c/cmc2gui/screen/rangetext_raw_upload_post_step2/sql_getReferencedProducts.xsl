<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:param name="ct"/>
  <!-- -->
  <xsl:template match="/">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>  
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>  
  <!-- -->
  <xsl:template match="ProductRefs">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <referencedproducts>
        <xsl:for-each select="ProductReference[@ProductReferenceType='assigned']/CTN
                            | ProductReference[@ProductReferenceType='assigned']/Product/@ctn">
          <object id="{.}">
            <sql:execute-query>
              <sql:query>      
                select o.DATA
                from octl o
                where o.CONTENT_TYPE = 'PMT_Raw' 
                  and o.LOCALISATION = 'none' 
                  and o.OBJECT_ID = '<xsl:value-of select="."/>'
              </sql:query>
            </sql:execute-query>
          </object>
        </xsl:for-each>
      </referencedproducts>
      <categorization>
        <object>
          <sql:execute-query>
            <sql:query>      
             select distinct C.groupcode || '/' || c.categorycode routingcode
               from object_categorization oc inner join categorization c
                 on oc.subcategory = c.subcategorycode
                 and oc.catalogcode = 'MASTER'
              where oc.OBJECT_ID = '<xsl:value-of select="Node/ProductRefs/ProductReference[@ProductReferenceType='assigned']/CTN[1]
                                                        | Node/ProductRefs/ProductReference[@ProductReferenceType='assigned']/Product[1]/@ctn"/>'
              <!-- Look at internal categories only -->
              and c.catalogcode in ('CONSUMER','NORELCO','PROFESSIONAL')                     
              and rownum = 1
            </sql:query>
          </sql:execute-query>
         </object>
      </categorization>            
    </xsl:copy>      
  </xsl:template>
</xsl:stylesheet>

