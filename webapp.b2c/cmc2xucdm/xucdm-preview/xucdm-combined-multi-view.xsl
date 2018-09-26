<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml CategorizationTree_test_file.xml?>
<!-- version 1.3	nly90671	12.04.2007		added length overflow block	-->
<!-- version 1.3	nly90671	12.04.2007		made it possible to combine both previews in one XSLT	-->
<!-- version 1.4	nly92174	07.06.2007		make a parameter of image link	-->
<!-- version 1.5	nly90671	26.06.2007		corrected productname display	-->
<!-- version 1.5	nly90671	26.06.2007		corrected popup	-->
<!-- version 1.6	nly90671	19.11.2007		added brandstuff	-->
<!-- version 1.7	nly90671	28.02.2007		added support for images, added support for xUCDM 1.,1, added support for packaging -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.0">
  <!-- -->
  <!-- switched order of imports and added output function -->
  <xsl:import href="xucdm-multi-view.xsl"/>
  <xsl:import href="xucdm-category-multi-view.xsl"/>
  <xsl:import href="xucdm-packagingtext-multi-view.xsl"/>
  <xsl:import href="xucdm-range-multi-view.xsl"/>
  <xsl:output method="html" encoding="UTF-8"/>
  <xsl:param name="img_link" select="'http://philips.sdlproducts.com/PhilipsImages/GetImage.aspx'"/>
  <!-- -->
</xsl:stylesheet>
