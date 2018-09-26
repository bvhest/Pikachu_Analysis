<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:source="http://apache.org/cocoon/source/1.0" exclude-result-prefixes="source sql">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="dir"/>   
  <!-- $runcatalogexport will have a value only in the case of a PMT_Translated catalog.xml request (i.e. to export only ctns in the catalog.xml file) -->
  <xsl:param name="runcatalogexport"/>
  <xsl:param name="workflow"/>  
  <xsl:param name="phase2"/>    
  <xsl:param name="runmode"/>
  <!-- -->
  <xsl:variable name="modus" select="if ($runmode != '') then $runmode else 'BATCH'"/>
  <xsl:variable name="ct" select="/entries/@ct"/>
 <!-- to accomodate for the different types of processing, the needsprocessing flag can have different values:
     |  0 : no processing (the default value).
     |  1 : triggered for processing by the previous proces step (normal Query run).
     |  2 : triggered for processing by a catalog-(translation)export.
     | -2 : triggered for processing by a catalog-(translation)export or packaging project with SEO translation requests.
     |  3 : triggered for processing by the previous proces step (Phase2 run).
     |  4 : triggered for processing by the previous proces step (Real translation request run).
     |--> 
  <xsl:variable name="v_needsprocessing" select="if ($runcatalogexport = 'yes') then '(-2,2)' 
                                            else if ($ct = 'PText_Translated') then '(-2,1)' 
                                            else if ($phase2 = 'yes') then '(3)' 
                                            else if ($workflow = 'CL_CMC' and $ct = 'PMT_Translated' and not($phase2 = 'yes')) then '(1,4)' 
                                            else '(-1,1)'" /> 

  <!-- -->
  <xsl:template match="/entries">
    <xsl:variable name="categoryname"><xsl:value-of select="replace(replace(replace(substring-after(@routingName,'/'),'[^A-Za-z0-9]','_'),'_+','_'),'_$','')"/></xsl:variable>
    <xsl:variable name="prefix">
      <xsl:choose>
        <xsl:when test="@ct='PMT_Translated'">Online_Products_<xsl:value-of select="$categoryname"/>_<xsl:value-of select="$workflow"/></xsl:when>
        <xsl:when test="@ct='Categorization_Translated'">Categorization_<xsl:value-of select="substring-after(@routingCode,'/')"/>_<xsl:value-of select="$workflow"/></xsl:when>
        <xsl:when test="@ct='PText_Translated'">Packaging_<xsl:value-of select="$categoryname"/>_<xsl:value-of select="$workflow"/></xsl:when>
        <xsl:when test="@ct='RangeText_Translated'">Online_Ranges_<xsl:value-of select="$categoryname"/>_<xsl:value-of select="$workflow"/></xsl:when>    
      </xsl:choose>     
    </xsl:variable>  
<xsl:variable name="lighting-categories" select="(
    'GR00302_GR/CA00320_CA',
                'GR00302_GR/CA00321_CA',
                'GR00302_GR/CA00324_CA',
                'GR00302_GR/CA00325_CA',
                'GR00302_GR/CA00326_CA',
                'GR00302_GR/CA00329_CA',
                'GR00302_GR/CA00330_CA',
                'GR00302_GR/CA00334_ENERGYSAVINGLAMPS',
                'GR00302_GR/CA00335_LEDENERGYSAVINGLAMPS',
                'GR00302_GR/CA00337_HLACCESSORIES',
                'GR00302_GR/CA00337_SMARTSPOT',
                'GR00302_GR/CA00338_LUMINAIRES',
                'GR00302_GR/CA00350_FLUORTUBE',
                'GR00302_GR/CA00352_LAMPS',
                'GR00302_GR/CA00364_HALOGENBULB',
                'GR00302_GR/CA00365_SWSOCKACC',
                'GR00302_GR/CA00369_WIRELESSLIGHT',
                'GR00302_GR/CA00370_LIGHTGALLERY',
                'GR00302_GR/CA00371_INCANLIGHT',
                'GR00302_GR/CA00379_THOMASLIGHTING',
                'GR00302_GR/CA00380_DISNEYLIGHTING',
                'GR00302_GR/DISNEY_AND_MARVEL_CA',
                'GR00302_GR/SWITCHES_CIRCUIT_BREAKERS_CA')"/>

      <xsl:variable name="archive_dir">
              <xsl:choose>
                     <!-- Export Consmer Lighting product to a different archive folder, except Automotive products-->
                     <xsl:when test="@routingCode=$lighting-categories">
                           <xsl:text>archive_li</xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                           <xsl:text>archive</xsl:text>
                     </xsl:otherwise>
              </xsl:choose>
       </xsl:variable>

    <xsl:variable name="filename" select="concat($prefix,'.',@ts,'.',@targetLocale,'.',@batchnumber,'.xml')"/>  
    <entries>
      <xsl:copy-of copy-namespaces="no" select="@*"/>
      <filedata>
        <source:write>
          <source:source>
            <xsl:value-of select="concat($dir,'/',@ct,'/', $archive_dir, '/',$filename)"/> 
          </source:source>
          <source:fragment>
            <xsl:choose>
            <xsl:when test="@ct='PMT_Translated'"> 
              <Products>
                <xsl:copy-of copy-namespaces="no" select="@*[not(local-name() = 'batchnumber')]"/>
                <xsl:copy-of copy-namespaces="no" select="entry[@valid='true']/content/node()"/>
              </Products>
            </xsl:when>
            <xsl:when test="@ct='RangeText_Translated'"> 
              <Nodes>
                <xsl:copy-of copy-namespaces="no" select="@*[not(local-name() = 'batchnumber')]"/>
                <xsl:copy-of copy-namespaces="no" select="entry[@valid='true']/content/node()"/>
              </Nodes>
            </xsl:when>        
            <xsl:otherwise>
              <xsl:apply-templates  select="entry[@valid='true']/content/*">
                <xsl:with-param name="filename" select="$filename"/>
                <xsl:with-param name="prefix" select="$prefix"/>
              </xsl:apply-templates>
            </xsl:otherwise>
            </xsl:choose>
          </source:fragment>
        </source:write>
      </filedata>
      <xsl:apply-templates>
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:with-param name="prefix" select="$prefix"/>
      </xsl:apply-templates>
      <xsl:copy-of copy-namespaces="no" select="store-outputs"/>
    </entries>
  </xsl:template>  
  <!-- -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>     
  </xsl:template>
  <!-- -->
  <xsl:template match="@batchnumber"/>
  <!-- -->  
  <xsl:template match="entry[@valid='true']">
    <xsl:param name="prefix"/>
    <xsl:param name="filename"/>
    <xsl:variable name="categoryname"><xsl:value-of select="replace(substring-after(@routingName,'/'),'[^A-Za-z0-9]','-')"/></xsl:variable>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      <sql:execute-query>
        <sql:query name="exportTranslationStore: update octl">
          update octl o
             set o.remark = '<xsl:value-of select="$filename"/>'
               , o.status = 'AwaitingTranslationImport'
           where o.content_type  = '<xsl:value-of select="@ct"/>'
             and o.object_id     = '<xsl:value-of select="@o"/>'
             and o.localisation in (<xsl:for-each select="tokenize(content/*/@StoreLocales,',')"><xsl:if test="position() != 1">,</xsl:if>'<xsl:value-of select="."/>'</xsl:for-each>)
             and exists (select 1 
                           from octl_control oc
                          where oc.modus        = '<xsl:value-of select="$modus"/>'
                            and oc.content_type = o.content_type
                            and oc.localisation = o.localisation
                            and oc.object_id    = o.object_id    
                            and oc.needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/>
                        )  
        </sql:query>
      </sql:execute-query>
      <sql:execute-query>
        <sql:query name="exportTranslationStore: update octl_control 1">
            update octl_control
               set needsprocessing_flag = '<xsl:value-of select="if($workflow = 'CL_QUERY' and ./@ct=('PMT_Translated','PText_Translated')) then 9 else 0"/>'
                 , intransaction_flag   = 0
                 , batch_number         = null
             where modus        = '<xsl:value-of select="$modus"/>'
               and content_type = '<xsl:value-of select="@ct"/>'
               and localisation in (<xsl:for-each select="tokenize(content/*/@StoreLocales,',')"><xsl:if test="position() != 1">,</xsl:if>'<xsl:value-of select="."/>'</xsl:for-each>)
               and object_id    = '<xsl:value-of select="@o"/>'
               and needsprocessing_flag in <xsl:value-of select="$v_needsprocessing"/>
        </sql:query>
      </sql:execute-query>
      <!-- Insert a row into OCTL_TRANSLATIONS for each OCTL in the the file -->
      <xsl:variable name="v_entries" select="../../entries"/>
      <xsl:variable name="v_entry" select="."/>
      <xsl:variable name="v_category">
        <xsl:choose>
          <xsl:when test="@ct='PMT_Translated'"><xsl:value-of select="$v_entries/@category"/></xsl:when>
          <xsl:when test="@ct='Categorization_Translated'">Default</xsl:when>
          <xsl:when test="@ct='PText_Translated'"><xsl:value-of select="$v_entries/@category"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$v_entries/@category"/></xsl:otherwise>          
        </xsl:choose>     
      </xsl:variable>        
      <xsl:variable name="v_routingCode">
        <xsl:choose>
          <xsl:when test="@ct='PMT_Translated'"><xsl:value-of select="$v_entries/@routingCode"/></xsl:when>
          <xsl:when test="@ct='Categorization_Translated'">Default</xsl:when>
          <xsl:when test="@ct='PText_Translated'"><xsl:value-of select="$v_entries/@routingCode"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$v_entries/@routingCode"/></xsl:otherwise>
        </xsl:choose>     
      </xsl:variable>      
      
      <xsl:for-each select="tokenize(content/*/@StoreLocales,',')">
        <sql:execute-query>
          <sql:query name="exportTranslationStore: insert octl_translations">
          declare
            l_msg    varchar2(4000);
            l_mlm    date := to_date('<xsl:value-of select="$v_entry/content/node()/@masterLastModified"/>','YYYY-MM-DD"T"HH24:MI:SS');
            l_lm     date := to_date('<xsl:value-of select="$v_entry/content/node()/@lastModified"/>','YYYY-MM-DD"T"HH24:MI:SS');
            l_dts    date := to_date('<xsl:value-of select="$v_entries/@docTimeStamp"/>','YYYYMMDD"T"HH24MISS');
          begin
            insert into octl_translations ( content_type
                                          , localisation
                                          , object_id
                                          , masterlastmodified_ts
                                          , lastmodified_ts
                                          , filename                                        
                                          , doctimestamp                                        
                                          , targetlocale
                                          , storelocales
                                          , category                                        
                                          , routing_code
                                          , workflow
                                          , priority
                                          , fileobjectcount
                                          , import_ts
                                          , marketingversion
                                          ) 
            values (  '<xsl:value-of select="$v_entries/@ct"/>'
                    , '<xsl:value-of select="."/>'
                    , '<xsl:value-of select="$v_entry/@o"/>'
                    , l_mlm
                    , l_lm
                    , '<xsl:value-of select="$filename"/>'
                    , l_dts
                    , '<xsl:value-of select="$v_entries/@targetLocale"/>'
                    , '<xsl:value-of select="$v_entry/content/node()/@StoreLocales"/>'
                    , '<xsl:value-of select="$v_category"/>'                                    
                    , '<xsl:value-of select="$v_routingCode"/>'                  
                    , '<xsl:value-of select="$v_entries/@workflow"/>'
                    , '<xsl:value-of select="$v_entries/@priority"/>'
                    , '<xsl:value-of select="count($v_entries/entry)"/>'
                    , null
                    ,'<xsl:value-of select="$v_entry/content/Product/MarketingVersion"/>')
            ;
          exception
             when dup_val_on_index then null; -- can occur for catalog exports.
             when others then raise;
          end;
          </sql:query>
        </sql:execute-query>      
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>
  <!-- -->
  <xsl:template match="entry[@valid='false'] ">
    <xsl:if test="not($reload='true')">
      <xsl:copy copy-namespaces="no">
        <xsl:apply-templates select="@*|node()"/>
        <sql:execute-query>
          <sql:query name="exportTranslationStore: update octl_control 2">
            update octl_control
               set needsprocessing_flag = 0
                 , intransaction_flag   = 0
                 , batch_number         = null
             where modus        = '<xsl:value-of select="$modus"/>'
               and content_type = '<xsl:value-of select="@ct"/>'
               and localisation = '<xsl:value-of select="@l"/>'
               and object_id    = '<xsl:value-of select="@o"/>'
               and needsprocessing_flag = 1
          </sql:query>
        </sql:execute-query>
      </xsl:copy>
    </xsl:if>
  </xsl:template>
  <!-- -->
  <xsl:template match="content"/>
  <!-- -->  
</xsl:stylesheet>
