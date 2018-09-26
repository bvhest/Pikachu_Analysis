<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:sql="http://apache.org/cocoon/SQL/2.0" 
                xmlns:cinclude="http://apache.org/cocoon/include/1.0" 
                xmlns:data="http://www.philips.com/cmc2-data"
                exclude-result-prefixes="sql xsl cinclude data" 
            >
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--  base the transformation on the default xUCDM transformation -->
  <xsl:import href="../xUCDM.1.2.convertProducts.xsl" />
  <!--  -->
  <xsl:param name="doctypesfilepath"/>
  <xsl:param name="type"/>
  <xsl:param name="channel"/>
  <!--  no selection needed: the assetchannel is for ATG -->
  <xsl:variable name="assetschannel">ATG</xsl:variable>
  <!--  -->
  <xsl:variable name="doctypesfile" select="document($doctypesfilepath)"/>
  <xsl:variable name="imagepath" select="'http://images.philips.com/is/image/PhilipsConsumer/'"/>
  <xsl:variable name="nonimagepath" select="'http://www.p4c.philips.com/cgi-bin/dcbint/get?id='"/>

</xsl:stylesheet>