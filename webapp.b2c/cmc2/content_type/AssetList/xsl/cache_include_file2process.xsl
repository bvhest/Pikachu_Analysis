<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:cinclude="http://apache.org/cocoon/include/1.0"  xmlns:dir="http://apache.org/cocoon/directory/2.0"
	 >
  <!-- -->	
	<xsl:param name="sourceDir"/>
	<xsl:param name="directoryName"/>
	
  <xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	 <!-- -->
	<xsl:template match="//dir:directory/dir:directory">
		 <directory> 
		 <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute> 	
		 <cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/0')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/5')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/6')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/7')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/8')}" />		
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/B')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/E')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/I')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/J')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/K')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/L')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/M')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/N')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/O')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/Q')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/T')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/U')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/V')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/W')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/X')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/Y')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/Z')}" />		
		
		<!--Below Starts with 1 -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/10')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/11')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/12')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/13')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/14')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/15')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/16')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/17')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/18')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/19')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1A')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1B')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1C')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1D')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1E')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1F')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1G')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1H')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1I')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1J')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1K')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1L')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1M')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1N')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1O')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1P')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1Q')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1R')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1S')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1T')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1U')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1V')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1W')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1X')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1Y')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/1Z')}" />
		
		<!--Below Starts with 2 -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/20')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/21')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/22')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/23')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/24')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/25')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/26')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/27')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/28')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/29')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2A')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2B')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2C')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2D')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2E')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2F')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2G')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2H')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2I')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2J')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2K')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2L')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2M')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2N')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2O')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2P')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2Q')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2R')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2S')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2T')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2U')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2V')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2W')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2X')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2Y')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/2Z')}" />
		
		<!--Below Starts with 3 -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/30')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/31')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/32')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/33')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/34')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/35')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/36')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/37')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/38')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/39')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3A')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3B')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3C')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3D')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3E')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3F')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3G')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3H')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3I')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3J')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3K')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3L')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3M')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3N')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3O')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3P')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3Q')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3R')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3S')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3T')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3U')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3V')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3W')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3X')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3Y')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/3Z')}" />
		
		<!--Below Starts with 4 -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/40')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/41')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/42')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/43')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/44')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/45')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/46')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/47')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/48')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/49')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4A')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4B')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4C')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4D')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4E')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4F')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4G')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4H')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4I')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4J')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4K')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4L')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4M')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4N')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4O')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4P')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4Q')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4R')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4S')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4T')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4U')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4V')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4W')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4X')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4Y')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/4Z')}" />
		
		<!--Below Starts with 9 -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/90')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/91')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/92')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/93')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/94')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/95')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/96')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/97')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/98')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/99')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9A')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9B')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9C')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9D')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9E')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9F')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9G')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9H')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9I')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9J')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9K')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9L')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9M')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9N')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9O')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9P')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9Q')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9R')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9S')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9T')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9U')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9V')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9W')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9X')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9Y')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/9Z')}" />
		
		<!--Below Starts with A -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/A0')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/A1')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/A2')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/A3')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/A4')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/A5')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/A6')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/A7')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/A8')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/A9')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AA')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AB')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AC')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AD')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AE')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AF')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AG')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AH')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AI')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AJ')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AK')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AL')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AM')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AN')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AO')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AP')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AQ')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AR')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AS')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AT')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AU')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AV')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AW')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AX')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AY')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/AZ')}" />
		
		<!--Below Starts with C -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/C0')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/C1')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/C2')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/C3')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/C4')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/C5')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/C6')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/C7')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/C8')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/C9')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CA')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CB')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CC')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CD')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CE')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CF')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CG')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CH')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CI')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CJ')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CK')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CL')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CM')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CN')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CO')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CP')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CQ')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CR')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CS')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CT')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CU')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CV')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CW')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CX')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CY')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/CZ')}" />
		
		<!--Below Starts with D -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/D0')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/D1')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/D2')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/D3')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/D4')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/D5')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/D6')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/D7')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/D8')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/D9')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DA')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DB')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DC')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DD')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DE')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DF')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DG')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DH')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DI')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DJ')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DK')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DL')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DM')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DN')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DO')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DP')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DQ')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DR')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DS')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DT')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DU')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DV')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DW')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DX')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DY')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/DZ')}" />
		
		<!--Below Starts with F -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/F0')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/F1')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/F2')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/F3')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/F4')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/F5')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/F6')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/F7')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/F8')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/F9')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FA')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FB')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FC')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FD')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FE')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FF')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FG')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FH')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FI')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FJ')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FK')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FL')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FM')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FN')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FO')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FP')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FQ')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FR')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FS')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FT')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FU')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FV')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FW')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FX')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FY')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/FZ')}" />
		
		<!--Below Starts with G -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/G0')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/G1')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/G2')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/G3')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/G4')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/G5')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/G6')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/G7')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/G8')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/G9')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GA')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GB')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GC')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GD')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GE')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GF')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GG')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GH')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GI')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GJ')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GK')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GL')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GM')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GN')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GO')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GP')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GQ')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GR')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GS')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GT')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GU')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GV')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GW')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GX')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GY')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/GZ')}" />
		
		<!--Below Starts with H -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/H0')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/H1')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/H2')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/H3')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/H4')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/H5')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/H6')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/H7')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/H8')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/H9')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HA')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HB')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HC')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HD')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HE')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HF')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HG')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HH')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HI')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HJ')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HK')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HL')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HM')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HN')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HO')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HP')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HQ')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HR')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HS')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HT')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HU')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HV')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HW')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HX')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HY')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/HZ')}" />
		
		<!--Below Starts with P -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/P0')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/P1')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/P2')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/P3')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/P4')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/P5')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/P6')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/P7')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/P8')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/P9')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PA')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PB')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PC')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PD')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PE')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PF')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PG')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PH')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PI')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PJ')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PK')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PL')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PM')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PN')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PO')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PP')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PQ')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PR')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PS')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PT')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PU')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PV')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PW')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PX')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PY')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/PZ')}" />
		
		<!--Below Starts with R -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/R0')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/R1')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/R2')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/R3')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/R4')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/R5')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/R6')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/R7')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/R8')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/R9')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RA')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RB')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RC')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RD')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RE')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RF')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RG')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RH')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RI')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RJ')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RK')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RL')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RM')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RN')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RO')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RP')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RQ')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RR')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RS')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RT')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RU')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RV')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RW')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RX')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RY')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/RZ')}" />
		
		
		<!--Below Starts with S -->
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/S0')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/S1')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/S2')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/S3')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/S4')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/S5')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/S6')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/S7')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/S8')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/S9')}" />
		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SA')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SB')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SC')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SD')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SE')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SF')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SG')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SH')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SI')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SJ')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SK')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SL')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SM')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SN')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SO')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SP')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SQ')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SR')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SS')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/ST')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SU')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SV')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SW')}" />		
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SX')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SY')}" />
		<cinclude:include src="{concat('cocoon:/mergePerCacheLocale/',@name,'/SZ')}" />
		
		 </directory> 
	</xsl:template>
 
  
</xsl:stylesheet>