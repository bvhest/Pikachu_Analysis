<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:assets="http://www.w3.org/1999/XSL/Transform/assets">
    
  <xsl:template match="node()|@*" mode="#all">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="node()|@*" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="group">
    <root>
      <!-- the cached entry, if it exists -->
      <cache>
        <xsl:apply-templates select="source/Users[@Source='Merged']"/>
      </cache>
      
      <!-- the newly aggregated cache entry -->
      <merged>
        <xsl:variable name="accountID" select="source[1]/Users/User/@accountID"/>
        <xsl:variable name="name">
          <xsl:choose>
            <xsl:when test="source/Users[@Source!='Merged']/User/Name">
              <xsl:for-each select="source/Users[@Source!='Merged']/User/Name">
                <xsl:if test="position() = last()">
                  <xsl:value-of select="current()"/>  
                </xsl:if>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise> 
              <xsl:value-of select="source/Users[@Source='Merged']/User/Name"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="status" select="if (source/Users[@Source != 'Merged']/User/@status = 'Active') then ('Active') else ('Deleted')"/>
        <xsl:variable name="sources">
          <xsl:for-each-group select="source/Users" group-by="@Source">
            <xsl:sort select="@Source" order="ascending"/>
            <xsl:value-of select="concat(current-group()/@Source, ' ')"/>
          </xsl:for-each-group>
        </xsl:variable>
        <xsl:variable name="docTimeStamp" select="source/Users[@Source != 'Merged']/@DocTimeStamp[1]"/>
        
        <xsl:variable name="source" select="source"/>
        
        <xsl:element name="Users">
          <xsl:attribute name="Source" select="'Merged'"/>
          <xsl:attribute name="DocTimeStamp" select="$docTimeStamp"/>
          
          <xsl:element name="User">
            <xsl:attribute name="accountID" select="$accountID"/>
            <xsl:attribute name="status" select="$status"/>
            
            <xsl:element name="Name">
              <xsl:value-of select="$name"/>
            </xsl:element>   
            
            <xsl:for-each select="tokenize($sources, ' ')"> 
              <xsl:if test="(. != 'Merged') and (. != '')">
                <xsl:element name="Authorizations">
                  <xsl:attribute name="source" select="."/>
                  <xsl:attribute name="status" select="$source/Users[@Source=current()]/User/@status"/>
                  
                  <xsl:variable name="authorization-source" select="."/>
                  
                  <xsl:for-each select="$source/Users[@Source=$authorization-source]/User/Authorizations/ContentTypes">
                    <xsl:if test="count($source/Users[@Source=$authorization-source]/User/Authorizations/ContentTypes) > 0">
                      <xsl:variable name="content-types" select="."/>  
                      
                      <xsl:apply-templates select="$content-types"/>
                    </xsl:if>
                  </xsl:for-each>
                  
                  <xsl:for-each select="$source/Users[@Source=$authorization-source]/User/Authorizations/GrantedMAGs">
                    <xsl:if test="count($source/Users[@Source=$authorization-source]/User/Authorizations/GrantedMAGs) > 0">
                      <xsl:variable name="granted-mags" select="."/>  
                      
                      <xsl:apply-templates select="$granted-mags"/>
                    </xsl:if>
                  </xsl:for-each>

                  <xsl:for-each select="$source/Users[@Source=$authorization-source]/User/Authorizations/GrantedOrganizations">
                    <xsl:if test="count($source/Users[@Source=$authorization-source]/User/Authorizations/GrantedOrganizations) > 0">
                      <xsl:variable name="granted-organizations" select="."/>  
                      
                      <xsl:apply-templates select="$granted-organizations"/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:element>
              </xsl:if>
            </xsl:for-each>     
            
            <!-- Now merge items from the cache that are not in the upload, and are not marked Deleted in the cache -->
            <xsl:for-each select="$source/Users[@Source='Merged']/User[@status='Active']/Authorizations">
              <xsl:if test="empty($source/Users[@Source=current()/@source])">
                <xsl:apply-templates select="current()"/>
              </xsl:if>
            </xsl:for-each>   
          </xsl:element>
        </xsl:element>
      </merged>
      
    </root>
  </xsl:template>
    
</xsl:stylesheet>