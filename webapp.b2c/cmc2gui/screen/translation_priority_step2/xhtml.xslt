<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:me="http://apache.org/a">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="section"/>
  <xsl:param name="gui_url"/>
    <xsl:variable name="sectionurl">
    <xsl:if test="$section">
    <xsl:value-of select="concat('section/', $section, '/')"/>
    </xsl:if>
    </xsl:variable>    
  <xsl:variable name="schedule_id" select="//sql:rowset[@name='schedule_id']/sql:row"/>      
  <!-- -->
  <xsl:template match="/root">
  <xsl:variable name="country" select="substring-after(@language,'_')"/>
  <xsl:variable name="locale" select="@language"/>  
  <xsl:variable name="ctn" select="@ctn"/>    
    <html>
      <body contentID="content">
        <h2>New Translation Priority request - Step 2</h2><hr/>
          <xsl:choose>
            <xsl:when test="//sql:error">
              <xsl:for-each select="//sql:error">
                <p>
                  <xsl:value-of select="node()"/>
                </p>
              </xsl:for-each><br/>
            </xsl:when>
            <xsl:otherwise>            
              <xsl:choose>
                <xsl:when test="sql:rowset[@name = 'catalogs']/sql:row[sql:eoppass = '1'] and sql:rowset[@name = 'catalogs']/sql:row[sql:country=$country and sql:deleted = '0' and sql:subcatpass = '1' and sql:status = 'Final Published']">
                  <xsl:text>The next step is to schedule a translation export. Press the button below, and then on the following page press FIRE NOW</xsl:text><br/><br/><br/>
                  <button>
                    <xsl:variable name="pipe" select="concat('cmc2/content_type/PMT_Translated?locale=',@language,'&amp;ctn=',@ctn)"/>
                    <xsl:variable name="esc-pipe" select="encode-for-uri($pipe)"/>
                    <!-- encode again to encode % -->
                    <xsl:variable name="esc-esc-pipe" select="encode-for-uri($esc-pipe)"/>
                    <xsl:attribute name="onclick">javascript:window.location='<xsl:value-of select="concat('content_type_schedule/PMT_Translated/jobs/'
                                                                                                           ,$schedule_id
                                                                                                           ,'?job=TranslationExport&amp;pipe='
                                                                                                           ,$esc-esc-pipe)"/>'</xsl:attribute>
                    <xsl:text>Schedule priority job</xsl:text>
                  </button>                          
                  <br/><br/><br/>
                  <hr/>
                </xsl:when>
                <xsl:otherwise>
                  It looks like the data for <xsl:value-of select="$ctn"/> for locale <xsl:value-of select="$locale"/> does not support a translation request for the following reason(s):
                  <ul>
                  <xsl:if test="not(sql:rowset[@name = 'catalogs']/sql:row[sql:eoppass = '1'])">
                    <li> No catalog assignments found for <xsl:value-of select="$ctn"/> for any country for which EOP is in the future and deleted = false </li>  
                  </xsl:if>
                  <xsl:if test="not(sql:rowset[@name = 'catalogs']/sql:row[sql:country=$country and sql:deleted = '0'])">
                    <li> No catalog assignments found for <xsl:value-of select="$ctn"/> for country <xsl:value-of select="$country"/> for which deleted = false  </li>  
                  </xsl:if>
                  <xsl:if test="not(sql:rowset[@name = 'catalogs']/sql:row[sql:country=$country and sql:subcatpass = '1'])">
                    <li> No catalog assignments found for <xsl:value-of select="$ctn"/> for country <xsl:value-of select="$country"/> for which subcategorisation exists  </li>  
                  </xsl:if>
                  <xsl:if test="not(sql:rowset[@name = 'catalogs']/sql:row[sql:country=$country and sql:status = 'Final Published'])">
                    <xsl:choose>
                      <xsl:when test="sql:rowset[@name = 'catalogs']/sql:row[sql:country=$country]/sql:status[. != '']">
                        <li> The input OCTL (content type 'PMT_Localised') for <xsl:value-of select="$ctn"/> for country <xsl:value-of select="$country"/> has status '<xsl:value-of select="sql:rowset[@name = 'catalogs']/sql:row[sql:country=$country]/sql:status"/>'  </li>  
                      </xsl:when>
                      <xsl:otherwise>
                        <li> The input OCTL (content type 'PMT_Localised') for <xsl:value-of select="$ctn"/> for country <xsl:value-of select="$country"/> does not exist </li>  
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                  </ul>
                  <br />
                  If you still wish to schedule a priority translation for this ctn/locale, press the button below, or click <a href="javascript:history.go(-1)"> here </a> to go back and enter a different CTN/locale combination.
                  <br /><br /><br />
                  <button>
                    <xsl:attribute name="onclick">javascript:window.location='<xsl:value-of select="concat('content_type_schedule/PMT_Translated/jobs/'
                                                                                                                 ,$schedule_id
                                                                                                                 ,'?job=TranslationExport&amp;pipe=cmc2/content_type/PMT_Translated?locale='
                                                                                                                 ,@language
                                                                                                                 ,'&amp;ctn='
                                                                                                                 ,@ctn)"/>'</xsl:attribute>
                    <xsl:text>Schedule priority job</xsl:text>
                  </button>
                  <br/><br/><br/>                  
                  <hr />
                </xsl:otherwise>                         
              </xsl:choose>            
              <xsl:choose>
                <xsl:when test="/root/sql:rowset[@name = 'catalogs']/sql:row">                 
                  <xsl:apply-templates select="sql:rowset[@name = 'catalogs']">
                    <xsl:with-param name="ctn" select="@ctn"/>
                    <xsl:with-param name="locale" select="@language"/>
                  </xsl:apply-templates>                      
                  <hr/>
                </xsl:when>
                <xsl:otherwise/>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </body>
      </html>
    </xsl:template>
   
  <xsl:template match="/root/sql:rowset[@name = 'catalogs']">
  <xsl:param name="ctn"/>
  <xsl:param name="locale"/>
    <h3>Catalog assignments for <xsl:value-of select="$ctn"/> in country <xsl:value-of select="substring-after($locale,'_')"/> : </h3>
      <xsl:choose>
        <xsl:when test="sql:row[sql:country=substring-after($locale,'_')]">    
          <table border="0" cellspacing="5">
            <tr>
              <td>CTN</td>
              <td>Locale</td>
              <td>Catalog</td>
              <td>Subcategory</td>
              <td>SOP</td>
              <td>EOP</td>
              <td>LastModified</td>
              <td>Deleted</td>
              <td>LCB<br/>division</td>
            </tr>
            <xsl:apply-templates select="sql:row[sql:country=substring-after($locale,'_')]"/>          
          </table>
        </xsl:when>
        <xsl:otherwise>
          None found.
        </xsl:otherwise>
      </xsl:choose>
       <hr />
    <h3>Catalog assignments for <xsl:value-of select="$ctn"/> in other countries: </h3>
      <xsl:choose>
        <xsl:when test="sql:row[sql:country!=substring-after($locale,'_')]">    
          <table border="0" cellspacing="5">
            <tr>
              <td>CTN</td>
              <td>Locale</td>
              <td>Catalog</td>
              <td>Subcategory code</td>
              <td>SOP</td>
              <td>EOP</td>
              <td>LastModified</td>
              <td>Deleted</td>
              <td>LCB<br/>division</td>
            </tr>
            <xsl:apply-templates select="sql:row[sql:country!=substring-after($locale,'_')]"/>          
          </table>
        </xsl:when>
        <xsl:otherwise>
          None found.
        </xsl:otherwise>
      </xsl:choose>
    <p> </p>
  </xsl:template>

  <xsl:template match="/root/sql:rowset[@name = 'catalogs']/sql:row">
    <tr>
      <td>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="concat(   $gui_url
                                          , 'xmlraw/object_store/'
                                          , 'PMT_Localised'
                                          , '/'
                                          , sql:localisation
                                          , '/'
                                          , translate(sql:ctn,'/','_')
                                          , '.xml?id='
                                          , sql:ctn
                                          , '&amp;masterlastmodified_ts='
                                          , sql:masterlastmodified_ts
                                          , '&amp;lastmodified_ts='
                                          , sql:lastmodified_ts)
            "/>          
           </xsl:attribute>
         
          <xsl:value-of select="sql:ctn"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="sql:locale"/>
      </td>
      <td>
        <xsl:value-of select="sql:catalog_type"/>
      </td>
      <td>
        <xsl:attribute name="bgcolor" select="if(sql:subcategory != '') then '#00FF00' else '#FF0000'"/>
        <xsl:value-of select="sql:subcategory"/>
      </td>
      <td>
              <xsl:choose>
                <xsl:when test="me:compDate(fn:current-dateTime(), sql:sop) and me:compDate(sql:eop, fn:current-dateTime())">
                  <xsl:attribute name="bgcolor">#00FF00</xsl:attribute>
                </xsl:when>                
                <xsl:when test="me:compDate(sql:sop, fn:current-dateTime()) and me:compDate(sql:eop, fn:current-dateTime())">
                  <xsl:attribute name="bgcolor">#00FFFF</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="bgcolor">#FFFF00</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:value-of select="sql:sop"/>
            </td>
            
            <td>
              <xsl:choose>
                <xsl:when test="me:compDate(fn:current-dateTime(), sql:sop) and me:compDate(sql:eop, fn:current-dateTime())">
                  <xsl:attribute name="bgcolor">#00FF00</xsl:attribute>
                </xsl:when>
                <xsl:when test="me:compDate(sql:sop, fn:current-dateTime()) and me:compDate(sql:eop, fn:current-dateTime())">
                  <xsl:attribute name="bgcolor">#00FFFF</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="bgcolor">#FFFF00</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:value-of select="sql:eop"/>
            </td>


            <td><xsl:value-of select="substring(sql:lastmodified,1,16)"/></td>



      <td style="text-align:center">
        <xsl:attribute name="bgcolor" select="if(sql:deleted != '1') then '#00FF00' else '#FF0000'"/>
        <xsl:value-of select="sql:deleted"/>
      </td>
      <td>
        <xsl:value-of select="sql:ccdivision"/>
      </td>
    </tr>
  </xsl:template>  
  
  
  <xsl:function name="me:strip" as="xs:string">
    <xsl:param name="d"/>
    <xsl:value-of select="substring(translate(translate(translate(translate(substring($d,1,19),'-',''),'T',''),':',''),' ',''),1,15)"/>
  </xsl:function>
  
  <xsl:function name="me:compDate" as="xs:boolean">
    <xsl:param name="dt_a" as="xs:string"/>
    <xsl:param name="dt_b" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="me:strip($dt_a) gt me:strip($dt_b)">
        <xsl:copy-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>  
  
</xsl:stylesheet>
