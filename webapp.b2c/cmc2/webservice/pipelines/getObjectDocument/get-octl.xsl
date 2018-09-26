<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:sql="http://apache.org/cocoon/SQL/2.0"
                xmlns:svc="http://pww.cmc.philips.com/CMCService/functions/1.0"
                xmlns:tns="http://pww.cmc.philips.com/CMCService/types/1.0"
                >
  
  <xsl:import href="../service-base.xsl"/>
 
  <xsl:param name="objectID"/>
  <xsl:param name="contentType"/>
  <xsl:param name="locale"/>
  <xsl:param name="ifModifiedSince"/>
  
  <!-- If PMT/master_global is requested PMT_Master data is returned -->
  <xsl:variable name="l-ct" select="if ($locale = 'master_global' and $contentType = 'PMT') then 'PMT_Master' else $contentType"/>
  
  <xsl:template match="/root">
    <root>
      <xsl:variable name="object-cat" select="if ($__noauth) then () else document(concat('cocoon:/common/getObjectCategorization/CONSUMER/', $objectID))/object-categorization/object"/>
      
      <xsl:choose>
        <xsl:when test="not($__noauth) and fn:empty($object-cat)">
          <tns:Object objectID="{$objectID}" locale="{$locale}" documentType="{$contentType}" type="Error">
            <xsl:sequence select="svc:get-error(404)"/>
          </tns:Object>
        </xsl:when>
        <xsl:when test="not($__noauth) and not(svc:subcat-allowed($uap, $object-cat/categorizations/internal-categorization/SubCategoryCode/text())) and not(svc:final-published-in-pmt-raw($objectID))">
          <tns:Object objectID="{$objectID}" locale="{$locale}" documentType="{$contentType}" type="Error">
            <xsl:sequence select="svc:get-error(401)"/>
          </tns:Object>
        </xsl:when>
        <xsl:otherwise>
          <tns:Object objectID="{$objectID}" locale="{$locale}" documentType="{$contentType}" type="Product">
            <sql:execute-query>
              <sql:query>
                select object_id, to_char(lastmodified_ts,'YYYY-MM-DD"T"HH24:MI:SS') lastmodified, 
                <xsl:choose>
                  <xsl:when test="$ifModifiedSince != ''">
                    case
                      when lastmodified_ts > to_date('<xsl:value-of select="$ifModifiedSince"/>','YYYY-MM-DD"T"HH24:MI:SS') then data
                      else 'not modified'
                    end data
                  </xsl:when>
                  <xsl:otherwise>
                    data
                  </xsl:otherwise>
                </xsl:choose>
                from OCTL where content_type='<xsl:value-of select="$contentType"/>'
                and localisation='<xsl:value-of select="$locale"/>'
                and object_id='<xsl:value-of select="$objectID"/>'
                and status != 'PLACEHOLDER' and status != 'Deleted'
              </sql:query>
            </sql:execute-query>
          </tns:Object>
        </xsl:otherwise>
      </xsl:choose>
    </root>
  </xsl:template>
</xsl:stylesheet>
