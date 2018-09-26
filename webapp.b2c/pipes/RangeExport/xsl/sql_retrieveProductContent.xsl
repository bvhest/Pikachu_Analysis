<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:sql="http://apache.org/cocoon/SQL/2.0"
	exclude-result-prefixes="sql xsl">

  <xsl:param name="channel"/>
  <xsl:param name="locale"/>
  <xsl:param name="masterlocale"/>
  <xsl:param name="master"/>
  
  <xsl:variable name="apos">'</xsl:variable>
  
  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="ProductRefs|ProductReferences">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
    
    <xsl:variable name="assigned-ctns" select="ProductReference[@ProductReferenceType='assigned']/CTN
                                             | ProductReference[@ProductReferenceType='assigned']/Product/@ctn"/>
    
    <ProductReferencesContent>
      <sql:execute-query>
        <sql:query name="ProductReferencesContent">
          <xsl:choose>
            <xsl:when test="$masterlocale = 'yes' or $locale = 'MASTER'">
            <!-- Retrieve master content or master content for locale -->
              SELECT O.OBJECT_ID ID
                        ,O.STATUS STATUS
                        ,O.LASTMODIFIED_TS LASTMODIFIED
                        ,O.DATA DATA
                        ,OBJ.DIVISION DIVISION
                        ,OBJ.BRAND BRAND
              FROM OCTL O
                  ,OBJECT_MASTER_DATA OBJ
              WHERE o.CONTENT_TYPE='PMT_Master'
                and o.LOCALISATION='master_global'
                and o.OBJECT_ID = obj.OBJECT_ID
                and o.OBJECT_ID in ('<xsl:value-of select="string-join($assigned-ctns, concat($apos,',',$apos))"/>')
            </xsl:when>
            <xsl:otherwise>
              <!-- Retrieve localized content -->
              SELECT  o.object_id id,
                      o.status status,
                      o.localisation locale,
                      o.lastmodified_ts lastmodified,
                      o.data data,
                      NULL country,
                      obj.division division,
                      obj.brand brand,
                      o.MASTERLASTMODIFIED_TS masterlastmodified
              from octl o
                 , object_master_data obj
              WHERE o.CONTENT_TYPE='PMT'
                and o.localisation = '<xsl:value-of select="$locale"/>'  
                and o.OBJECT_ID = obj.OBJECT_ID
                and o.object_id in ('<xsl:value-of select="string-join($assigned-ctns, concat($apos,',',$apos))"/>')
            </xsl:otherwise>
          </xsl:choose>
        </sql:query>
      </sql:execute-query>
    </ProductReferencesContent>
  </xsl:template>
  
</xsl:stylesheet>