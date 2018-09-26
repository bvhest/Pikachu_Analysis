<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:sql="http://apache.org/cocoon/SQL/2.0"
    xmlns:cmc2-f="http://www.philips.com/cmc2-f"
    extension-element-prefixes="cmc2-f"
    exclude-result-prefixes="sql">

  <xsl:import href="../../../xsl/common/cmc2.function.xsl"/>
  <xsl:include href="pmsBase.xsl"/>
    
  <xsl:template match="sql:rowset" />
  
  <xsl:template match="content/Product/Categorization">
    <xsl:variable name="catg" select="ancestor::entry/content/sql:rowset[@name='Categorization']" />
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="$catg/sql:row[sql:catalogcode='MASTER']" mode="pms-categorization"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="sql:row" mode="pms-categorization">
    <SubCategory code="{sql:subcatcode}">
      <xsl:value-of select="sql:subcatname" />
    </SubCategory>
  </xsl:template>

  <xsl:template match="entry[@valid='true'][content/Product/@is-deleted='false']/process">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()"/>
      
      <xsl:variable name="catg" select="ancestor::entry/content/sql:rowset[@name='Categorization']/sql:row[sql:catalogcode='MASTER']"/>
      <xsl:variable name="status" select="ancestor::entry/content/Product/MasterData/ProductStatus"/>
      <query name="Categorization">
            merge into PMS_CATEGORIES tgt
            using (
              select '<xsl:value-of select="../@o"/>' ctn
                   , 'GR' gcs_level
                   , '<xsl:value-of select="$catg/sql:groupcode"/>' code
                   , '<xsl:value-of select="cmc2-f:escape-sql($catg/sql:groupname, false())"/>' name
                   , to_date('<xsl:value-of select="../octl-attributes/lastmodified_ts"/>','YYYY-MM-DD"T"HH24:MI:SS') lastmodified_ts
                from dual
              union
              select '<xsl:value-of select="../@o"/>' ctn
                   , 'CA' gcs_level
                   , '<xsl:value-of select="$catg/sql:catcode"/>' code
                   , '<xsl:value-of select="cmc2-f:escape-sql($catg/sql:catname, false())"/>' name
                   , to_date('<xsl:value-of select="../octl-attributes/lastmodified_ts"/>','YYYY-MM-DD"T"HH24:MI:SS') lastmodified_ts
                from dual
              union
              select '<xsl:value-of select="../@o"/>' ctn
                   , 'SU' gcs_level
                   , '<xsl:value-of select="$catg/sql:subcatcode"/>' code
                   , '<xsl:value-of select="cmc2-f:escape-sql($catg/sql:subcatname, false())"/>' name
                   , to_date('<xsl:value-of select="../octl-attributes/lastmodified_ts"/>','YYYY-MM-DD"T"HH24:MI:SS') lastmodified_ts
                from dual                
            ) src
            on (    src.ctn = tgt.ctn
                and src.gcs_level = tgt.gcs_level)
            when matched then
              -- CTN exists: update if records are older
              update 
                 set tgt.gcs_category_code = src.code
                   , tgt.gcs_category_name = src.name
                   , tgt.lastmodified_ts = src.lastmodified_ts
               where nvl(tgt.lastmodified_ts, to_date('1900-01-01','yyyy-mm-dd')) &lt; src.lastmodified_ts
                 and (tgt.gcs_category_code != src.code or tgt.gcs_category_name != src.name)
            
            when not matched then
              -- CTN is new: insert new records
              insert (ctn, gcs_level, gcs_category_code, gcs_category_name, lastmodified_ts)
                values (  src.ctn
                        , src.gcs_level
                        , src.code
                        , src.name
                        , src.lastmodified_ts
                       )
      </query>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
