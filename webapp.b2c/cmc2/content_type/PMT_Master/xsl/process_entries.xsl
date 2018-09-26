<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    exclude-result-prefixes="sql">

  <xsl:param name="reload"/>     

  <xsl:variable name="currdatetime" select="substring(string(current-dateTime()),1,19)"/>  

  <xsl:template match="@*|node()">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- clean content -->
  <xsl:template match="octl|sql:rowset|sql:row|sql:data">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
  <xsl:template match="sql:*"/>
   
  <!-- Remove empty AssetList object -->
  <xsl:template match="sql:row[sql:content_type='AssetList']/sql:data/object[not(Asset)]"/>

  <!-- Remove Object-Relations of type 'Accessory' (moved to PMT) -->
  <xsl:template match="ProductReference[@ProductReferenceType='Accessory']
                      |ProductReferences[@ProductReferenceType='Accessory']" />

  <xsl:template match="currentmasterlastmodified_ts|currentlastmodified_ts">
    <xsl:copy copy-namespaces="no">
      <xsl:value-of select="sql:rowset/sql:row/sql:*"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- process octl attributes -->     
  <xsl:template match="octl-attributes[../@valid='true']">
    <xsl:choose>
      <xsl:when test="$reload='true'">  
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*|node()[not(local-name()='masterlastmodified_ts' or local-name()='lastmodified_ts' or local-name()='status' or local-name()='marketingversion')]"/>
          <lastmodified_ts><xsl:value-of select="../currentlastmodified_ts/sql:rowset/sql:row/sql:lastmodified_ts"/></lastmodified_ts>
          <masterlastmodified_ts><xsl:value-of select="../currentmasterlastmodified_ts/sql:rowset/sql:row/sql:masterlastmodified_ts"/></masterlastmodified_ts>
          <remark><xsl:value-of select="concat('RELOADED on ',$currdatetime)"/></remark> 
          <status><xsl:value-of select="../content/octl/sql:rowset/sql:row[sql:content_type='PMT_Enriched']/sql:status"/></status>
          <marketingversion><xsl:value-of select="../content/octl/sql:rowset/sql:row[sql:content_type='PMT_Enriched']/sql:marketingversion"/></marketingversion>   			
        </xsl:copy>      
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy copy-namespaces="no">
          <xsl:apply-templates select="@*|node()[not(local-name()='masterlastmodified_ts' or local-name()='status' or  local-name()='islocalized' or local-name()='marketingversion')]"/>
          <xsl:element name="masterlastmodified_ts">
                 <xsl:value-of select="../content/octl/sql:rowset/sql:row[sql:content_type='PMT_Enriched']/sql:masterlastmodified_ts"/>    
          </xsl:element>
          <xsl:element name="status">
            <xsl:value-of select="../content/octl/sql:rowset/sql:row[sql:content_type='PMT_Enriched']/sql:status"/>    
          </xsl:element>
          <xsl:element name="marketingversion">
            <xsl:value-of select="../content/octl/sql:rowset/sql:row[sql:content_type='PMT_Enriched']/sql:marketingversion"/>    
          </xsl:element>
          <xsl:element name="remark">
            <xsl:value-of select="' '"/>
          </xsl:element>          
          <xsl:element name="islocalized">
              <xsl:value-of select="if (upper-case(../content/octl/sql:rowset/sql:row/sql:data/Product/@IsLocalized)='TRUE') then 1 else 0"/>
          </xsl:element>
        </xsl:copy>
      </xsl:otherwise>             
    </xsl:choose>           
  </xsl:template>

</xsl:stylesheet>