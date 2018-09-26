<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:h="http://apache.org/cocoon/request/2.0">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <xsl:param name="param1"/>
  <xsl:param name="channel"/>
  <!-- -->
  <xsl:template match="/h:request/h:requestParameters">
    <root>
      <xsl:variable name="id" select="replace(h:parameter[@name='id']/h:value,'\*','%')"/>
      <xsl:variable name="v_sql" select='if($id != "") then concat(" and object_id like &apos;%",$id,"%&apos;") else ""'/>
      <xsl:variable name="v_radiofilesfilter"   select="h:parameter[@name='radiofilesfilter']/h:value"/>      
      <xsl:variable name="v_radiofilesfilter_sql" select='if($v_radiofilesfilter = "all") then "" 
                                                     else if($v_radiofilesfilter = "unreturned") then " and import_ts is null " 
                                                     else if($v_radiofilesfilter = "returned") then " and import_ts is not null "
                                                     else ""'/>
      <xsl:variable name="v_filename"           select="h:parameter[@name='filename']/h:value"/>
      <xsl:variable name="v_partialfilename"    select="replace(h:parameter[@name='partialfilename']/h:value,'\*','%')"/>
      <xsl:variable name="v_routingcode"        select="h:parameter[@name='routingcode']/h:value"/>
      <xsl:variable name="v_partialroutingcode" select="h:parameter[@name='partialroutingcode']/h:value"/>
      <xsl:variable name="v_category"           select="h:parameter[@name='category']/h:value"/>
      <xsl:variable name="v_partialcategory"    select="h:parameter[@name='partialcategory']/h:value"/>      
      <id><xsl:value-of select="$id"/></id>
      <ctl><xsl:value-of select="h:parameter[@name='ctl']/h:value"/></ctl>      
      <filename><xsl:value-of select="if($v_filename != '') then $v_filename else $v_partialfilename"/></filename>            
      <routingcode><xsl:value-of select="if($v_routingcode != '') then $v_routingcode else $v_partialroutingcode"/></routingcode>
      <category><xsl:value-of select="if($v_category != '') then $v_category else $v_partialcategory"/></category>            
      <radiofilesfilter><xsl:value-of select="$v_radiofilesfilter"/></radiofilesfilter>                  
      <x><xsl:copy-of select="."/></x>      
      <xsl:choose>
        <xsl:when test="h:parameter[@name='ctl']/h:value != ''">        
          <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
            <sql:query name="ctl">
              select * 
                from octl_translations 
               where content_type = '<xsl:value-of select="substring-before(h:parameter[@name='ctl']/h:value,',')"/>'
                 and localisation = '<xsl:value-of select="substring-after(h:parameter[@name='ctl']/h:value,',')"/>'
               <xsl:value-of select="$v_sql"/>
               <xsl:value-of select="$v_radiofilesfilter_sql"/>
               order by content_type, localisation, object_id, masterlastmodified_ts desc, lastmodified_ts desc
            </sql:query>
          </sql:execute-query>
        </xsl:when>
        <xsl:when test="h:parameter[@name='filename']/h:value != '' or h:parameter[@name='partialfilename']/h:value != '' ">
          <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
            <sql:query name="filename">
              select * from octl_translations where filename <xsl:value-of select='if($v_filename != "") then concat(  " = &apos;"
                                                                                                                     , $v_filename
                                                                                                                     ,"&apos;") 
                                                                                                         else concat(" like &apos;%"
                                                                                                                     , $v_partialfilename
                                                                                                                     , "%&apos;")'/>
               <xsl:value-of select="$v_radiofilesfilter_sql"/>                                                                                                                     
               order by content_type, localisation, object_id, masterlastmodified_ts desc, lastmodified_ts desc
            </sql:query>
          </sql:execute-query>
        </xsl:when>
        <xsl:when test="h:parameter[@name='routingcode']/h:value != '' or h:parameter[@name='partialroutingcode']/h:value != ''">
          <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
            <sql:query name="routingcode">
              select * from octl_translations where routing_code <xsl:value-of select='if($v_routingcode != "") then concat(  " = &apos;"
                                                                                                                     , $v_routingcode
                                                                                                                     ,"&apos;") 
                                                                                                         else concat(" like &apos;%"
                                                                                                                     , $v_partialroutingcode
                                                                                                                     , "%&apos;")'/>
               <xsl:value-of select="$v_radiofilesfilter_sql"/>
               order by content_type, localisation, object_id, masterlastmodified_ts desc, lastmodified_ts desc
            </sql:query>
          </sql:execute-query>
        </xsl:when>
        <xsl:when test="h:parameter[@name='category']/h:value != '' or h:parameter[@name='partialcategory']/h:value != ''">
          <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
            <sql:query name="category">
              select * from octl_translations where category <xsl:value-of select='if($v_category != "") then concat(  " = &apos;"
                                                                                                                     , $v_category
                                                                                                                     ,"&apos;") 
                                                                                                         else concat(" like &apos;%"
                                                                                                                     , $v_partialcategory
                                                                                                                     , "%&apos;")'/>
               <xsl:value-of select="$v_radiofilesfilter_sql"/>                                                                                                                     
               order by content_type, localisation, object_id, masterlastmodified_ts desc, lastmodified_ts desc
            </sql:query>
          </sql:execute-query>
        </xsl:when>
        <xsl:when test="$id != ''">
          <sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
            <sql:query name="id">
              select * from octl_translations where object_id like '%<xsl:value-of select="$id"/>%'
               <xsl:value-of select="$v_radiofilesfilter_sql"/>                             
               order by content_type, localisation, object_id, masterlastmodified_ts desc, lastmodified_ts desc
            </sql:query>
          </sql:execute-query>
        </xsl:when>
      </xsl:choose>
    </root>
  </xsl:template>
  <!-- -->
  <xsl:template match="h:node()">
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>