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
  <xsl:variable name="id" select="/root/id"/>
  <xsl:variable name="ctl" select="/root/ctl"/>
  <xsl:variable name="category" select="/root/category"/>
  <xsl:variable name="routingcode" select="/root/routingcode"/>
  <xsl:variable name="filename" select="/root/filename"/>   
  <xsl:variable name="radiofilesfilter" select="/root/radiofilesfilter"/>     
  <xsl:variable name="schedule_id" select="//sql:rowset[@name='schedule_id']/sql:row"/>      
  
  <!-- -->
  <xsl:template match="/root">

  
    <html>
      <body contentID="content">
      <script language="javascript">
        function togglecolumn(id)
        {
          var collapsedcol = document.getElementById(id + '_collapsed');
          var expandedcol = document.getElementById(id + '_expanded');
          if(collapsedcol.style.display != 'none')
          {
            collapsedcol.style.display = 'none';
            expandedcol.style.display = 'block';
          }
          else
          {
            collapsedcol.style.display = 'block';
            expandedcol.style.display = 'none';
          }          
        }
      </script>      
        <h2>Translation history request - results</h2><hr/>
          <xsl:choose>
            <xsl:when test="//sql:error">
              <xsl:for-each select="//sql:error">
                <p>
                  <xsl:value-of select="node()"/>
                </p>
              </xsl:for-each><br/>
            </xsl:when>
            <xsl:otherwise>            
              <xsl:apply-templates select="sql:rowset"/>
            </xsl:otherwise>
          </xsl:choose>
        </body>
      </html>
    </xsl:template>
   
  <xsl:template match="/root/sql:rowset">  
    <br/><h3>&#160;</h3>
    <h3>OCTL translation export and import details for <xsl:value-of select="if($id != '') then concat('object id &quot;',$id,'&quot;') else ''"/><xsl:value-of select="if($id != '' and ($ctl != '' or $category != '' or $routingcode != '' or $filename != '')) then ', ' else ''"/> <xsl:value-of select="if($ctl != '') then concat('content type &quot;', substring-before($ctl,','), '&quot;, localisation &quot;', substring-after($ctl,','),'&quot;') 
                                                                                        else if($category != '')    then concat('category &quot;',$category,'&quot;')
                                                                                        else if($routingcode != '') then concat('routing code &quot;',$routingcode,'&quot;')
                                                                                        else if($filename != '')    then concat('filename &quot;',$filename,'&quot;')
                                                                                        else ''
                                                                                        "/> (filter: <xsl:value-of select="if($radiofilesfilter='all')then ' show all files' 
                                                                                                                      else if($radiofilesfilter='returned')then ' show only returned files'
                                                                                                                      else if($radiofilesfilter='unreturned')then ' show only unreturned files'
                                                                                                                      else ''"/>): </h3>
                                                                                                                      
    <br/><h3>&#160;</h3>
    <xsl:choose>
      <xsl:when test="sql:row">    
        <table class="main">
          <colgroup>
            <col id="core" span="6" style="background-color:#FFFF99"/>
            <col id="main_collapsed" span="1" style="background-color:#FFFF99"/>                   
            <col id="main_expanded" span="9" style="background-color:#FFFF99; display:none"/>
            <col id="import" span="4" style="background-color:#FFFF99"/>    
          </colgroup>
          <tr>
            <td>Content&#160;type<a href="javascript:return false" title="This is the content type (CT in OCTL)">?</a></td>
            <td>Localisation<a href="javascript:return false" title="This is the localisation (L in OCTL)">?</a></td>
            <td>Object&#160;id<a href="javascript:return false" title="This is the object id (O in OCTL). For a product it is equivalent to the CTN">?</a></td>
            <td>MasterLastModified<a href="javascript:return false" title="This is the last modified date of the input OCTL to this OCTL. This date will be in the translation file.">?</a></td>
            <td>LastModified<a href="javascript:return false" title="This is the last modified date of this OCTL. This date will be in the translation file.">?</a></td>
            <td>Filename<a href="javascript:return false" title="This is the name of the translation file.">?</a></td>
            <td>DocTimestamp<a href="javascript:return false" title="This is the timestamp of the translation file.">?&#160;&#160;</a><a href="javascript:togglecolumn('main')" title="Expand view"><span style="font-family: Arial">&#x25ba;</span></a></td>                
            <td>DocTimestamp<a href="javascript:return false" title="This is the timestamp of the translation file.">?&#160;&#160;</a><a href="javascript:togglecolumn('main')" title="Collapse view"><span style="font-family: Arial">&#x25c4;</span></a></td>            
            <td>File&#160;Content<a href="javascript:return false" title="Click to see the translation file content. 'Out(xml)' is the outgoing file content - xml. 'Out(zip)' is the outgoing file content - zipped (if older than 90 days). 'In' (where applicable) is the content in the incoming file">?</a></td>
            <td>TargetLocale<a href="javascript:return false" title="This is the requested locale of the translation request.">?</a></td>
            <td>StoreLocales<a href="javascript:return false" title="This is the set of locales that the translated content will be 'exploded' to when it is imported into Pika Chu">?</a></td>
            <td>Category<a href="javascript:return false" title="This is the routing category in the file">?</a></td>        
            <td>RoutingCode<a href="javascript:return false" title="This is the routing code in the file">?</a></td>        
            <td>Workflow<a href="javascript:return false" title="This is the workflow in the file">?</a></td>        
            <td>Priority<a href="javascript:return false" title="This is the priority of the request">?</a></td>        
            <td>FileObjectCount<a href="javascript:return false" title="This is the number of objects in the file.  For PMT_Translated, it will be the number of products">?</a></td>        
            <td>Import&#160;date<a href="javascript:return false" title="This is the date when the returned file was imported">?</a></td>        
            <td>Import:Valid<a href="javascript:return false" title="This is the validity of the import">?</a></td>        
            <td>Import:Result<a href="javascript:return false" title="This is the result of the import">?</a></td>
            <td>Import:Content<a href="javascript:return false" title="Click (where applicable) to see the OCTL content (i.e. the result of the translation import)">?</a></td>            
          </tr>
          <xsl:apply-templates select="sql:row"/>
        </table>
      </xsl:when>
      <xsl:otherwise>
          None found.
      </xsl:otherwise>
    </xsl:choose>
    <hr />
    <p> </p>
  </xsl:template>

  <xsl:template match="/root/sql:rowset/sql:row">
    <tr>
      <td><xsl:value-of select="sql:content_type"/></td>
      <td><xsl:value-of select="sql:localisation"/></td>
      <td><xsl:value-of select="sql:object_id"/></td>
      <td><xsl:value-of select="substring(sql:masterlastmodified_ts,1,19)"/></td>
      <td><xsl:value-of select="substring(sql:lastmodified_ts,1,19)"/></td>
      <td><xsl:value-of select="sql:filename"/></td>
      <td><xsl:value-of select="substring(sql:doctimestamp,1,19)"/></td>
      <td><xsl:value-of select="substring(sql:doctimestamp,1,19)"/></td>      
      <td><a target="_blank"><xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'get_file/',sql:filename,'?file=',sql:content_type,'/archive_ftp/',sql:filename)"/></xsl:attribute>Out(xml)|</a><a target="_blank"><xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'get_file/',sql:filename,'.zip','?file=',sql:content_type,'/archive_ftp/',sql:filename,'.zip')"/></xsl:attribute>Out(zip)|</a>
        <xsl:choose>
          <xsl:when test="sql:import_ts != ''">
            <a target="_blank"><xsl:attribute name="href"><xsl:value-of select="concat($gui_url, 'get_file/',sql:filename,'.zip','?file=',sql:content_type,'/processed/',sql:filename,'.zip')"/></xsl:attribute>In(zip)</a>      
          </xsl:when>
        </xsl:choose>      
      </td>
      <td><xsl:value-of select="sql:targetlocale"/></td>
      <td><xsl:value-of select="sql:storelocales"/></td>
      <td><xsl:value-of select="sql:category"/></td>        
      <td><xsl:value-of select="sql:routing_code"/></td>        
      <td><xsl:value-of select="sql:workflow"/></td>        
      <td><xsl:value-of select="sql:priority"/></td>        
      <td><xsl:value-of select="sql:fileobjectcount"/></td>        
      <td><xsl:value-of select="if(sql:import_ts='1900-01-01 00:00:00.0') then 'Unknown' else substring(sql:import_ts,1,19)"/></td>        
      <td><xsl:value-of select="sql:valid"/></td>        
      <td><xsl:value-of select="if(sql:result='InitialTableLoad') then 'OK' else sql:result"/></td>        
          <td>
            <xsl:choose>
              <xsl:when test="sql:valid='true'">
                <a target="_blank">
                  <xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          , 'xmlraw/object_store/'
                                                                          , sql:content_type
                                                                          , '/'
                                                                          , sql:localisation
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.xml?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:masterlastmodified_ts,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:lastmodified_ts,1,19),' ','T'))"/></xsl:attribute>
                  <xsl:text>Raw&#160;XML&#160;</xsl:text>
                </a>
                <a target="_blank">
                  <xsl:attribute name="href"><xsl:value-of select="concat( $gui_url
                                                                          ,'icp/object_preview/'
                                                                          , sql:content_type
                                                                          , '/'
                                                                          , sql:localisation
                                                                          , '/'
                                                                          , translate(sql:object_id,'/','_')
                                                                          , '.html?id='
                                                                          , sql:object_id
                                                                          , '&amp;masterlastmodified_ts='
                                                                          , replace(substring(sql:masterlastmodified_ts,1,19),' ','T')
                                                                          , '&amp;lastmodified_ts='
                                                                          , replace(substring(sql:lastmodified_ts,1,19),' ','T'))"/></xsl:attribute>
                  <xsl:text>|&#160;Preview</xsl:text>
                </a>
              </xsl:when>
              <xsl:otherwise/>
            </xsl:choose>
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
