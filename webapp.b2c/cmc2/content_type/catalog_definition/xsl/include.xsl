<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cinclude="http://apache.org/cocoon/include/1.0"
    xmlns:dir="http://apache.org/cocoon/directory/2.0">
  <!-- -->
  <xsl:param name="sourcefiles" />
  <xsl:param name="runmode" select="''" />

  <xsl:template match="/">
    <root>
      <xsl:choose>
        <xsl:when test="$sourcefiles='LCB'">
          <xsl:for-each select="dir:directory/dir:file[starts-with(@name,'lcb_full_0200')]">
            <!-- using @name rather than @lastModified because it's possible that 2 files could have the same @lastModified 
              if downloaded/generated/copied at the same time -->
            <xsl:sort select="@name" order="descending" />
            <cinclude:include>
              <xsl:attribute name="src" select="if(position() = 1) then concat('cocoon:/readFile/',@name) else concat('cocoon:/archiveFile/',@name)" />
            </cinclude:include>
          </xsl:for-each>
          <xsl:for-each select="dir:directory/dir:file[starts-with(@name,'lcb_full_0100')]">
            <xsl:sort select="@name" order="descending" />
            <cinclude:include>
              <xsl:attribute name="src" select="if(position() = 1) then concat('cocoon:/readFile/',@name) else concat('cocoon:/archiveFile/',@name)" />
            </cinclude:include>
          </xsl:for-each>
          <xsl:for-each select="dir:directory/dir:file[starts-with(@name,'lcb_full_marketing_0200')]">
            <xsl:sort select="@name" order="descending" />
            <cinclude:include>
              <xsl:attribute name="src" select="if(position() = 1) then concat('cocoon:/readFile/',@name) else concat('cocoon:/archiveFile/',@name)" />
            </cinclude:include>
          </xsl:for-each>
          <xsl:for-each select="dir:directory/dir:file[starts-with(@name,'lcb_full_care_0200')]">
            <xsl:sort select="@name" order="descending" />
            <cinclude:include>
              <xsl:attribute name="src" select="if(position() = 1) then concat('cocoon:/readFile/',@name) else concat('cocoon:/archiveFile/',@name)" />
            </cinclude:include>
          </xsl:for-each>
          <xsl:for-each select="dir:directory/dir:file[not(starts-with(@name,'lcb_full_0200') or starts-with(@name,'lcb_full_marketing_0200') or starts-with(@name,'lcb_full_care_0200') or starts-with(@name,'lcb_full_0100'))]">
            <!-- do not process -->
            <cinclude:include src="cocoon:/archiveFile/{@name}" />
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$sourcefiles='CCB'">
          <xsl:for-each select="dir:directory/dir:file[matches(@name,'^pikachu_full_\d{14}')]">
            <!-- using @name rather than @lastModified because it's possible that 2 files could have the same @lastModified 
              if downloaded/generated/copied at the same time -->
            <xsl:sort select="@name" order="descending" />
            <cinclude:include>
              <xsl:attribute name="src" select="if(position() = 1) then concat('cocoon:/readFile/',@name) else concat('cocoon:/archiveFile/',@name)" />
            </cinclude:include>
          </xsl:for-each>
          <xsl:for-each select="dir:directory/dir:file[matches(@name,'^pikachu_full_FSS_\d{14}')]">
            <!-- using @name rather than @lastModified because it's possible that 2 files could have the same @lastModified 
              if downloaded/generated/copied at the same time -->
            <xsl:sort select="@name" order="descending" />
            <cinclude:include>
              <xsl:attribute name="src" select="if(position() = 1) then concat('cocoon:/readFile/',@name) else concat('cocoon:/archiveFile/',@name)" />
            </cinclude:include>
          </xsl:for-each>
          <xsl:for-each select="dir:directory/dir:file[matches(@name,'^pikachu_full_SHOP_\d{14}')]">
            <!-- using @name rather than @lastModified because it's possible that 2 files could have the same @lastModified 
              if downloaded/generated/copied at the same time -->
            <xsl:sort select="@name" order="descending" />
            <cinclude:include>
              <xsl:attribute name="src" select="if(position() = 1) then concat('cocoon:/readFile/',@name) else concat('cocoon:/archiveFile/',@name)" />
            </cinclude:include>
          </xsl:for-each>
          <xsl:for-each select="dir:directory/dir:file[not(starts-with(@name,'pikachu_full'))]">
            <!-- do not process -->
            <cinclude:include src="cocoon:/archiveFile/{@name}" />
          </xsl:for-each>
        </xsl:when>
        <xsl:when test="$sourcefiles='ProductMasterDataCatalog'">
          <xsl:choose>
            <xsl:when test="$runmode='FASTLANE'">
              <!-- Process all available files, since they are partial catalogs -->
              <xsl:for-each select="dir:directory/dir:file[starts-with(@name,'ProductMasterDataCatalog')]">
                <cinclude:include>
                  <xsl:attribute name="src" select="concat('cocoon:/processProductMasterDataFile_sub/', @name)" />
                </cinclude:include>
              </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <!-- Process the latest file, since it is based on a full feed -->
              <xsl:for-each select="dir:directory/dir:file[starts-with(@name,'ProductMasterDataCatalog')]">
                <!-- using @name rather than @lastModified because it's possible that 2 files could have the same @lastModified 
                  if downloaded/generated/copied at the same time -->
                <xsl:sort select="@name" order="descending" />
                <cinclude:include>
                  <xsl:attribute name="src" select="if(position() = 1) then
                                                      concat('cocoon:/processProductMasterDataFile_sub/',@name)
                                                    else
                                                      concat('cocoon:/archiveFile/',@name)" />
                </cinclude:include>
              </xsl:for-each>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:for-each select="dir:directory/dir:file[not(starts-with(@name,'ProductMasterDataCatalog'))]">
            <!-- do not process -->
            <cinclude:include src="cocoon:/archiveFile/{@name}" />
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </root>
  </xsl:template>
</xsl:stylesheet>