<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:my="http://www.philips.com/pika">
	<xsl:param name="begintime" as="xs:dateTime"/>
	<xsl:param name="endtime" as="xs:dateTime"/>
	<xsl:param name="count" as="xs:integer"/>
	<xsl:variable name="systime" as="xs:dateTime" select="current-dateTime()"/>
	<!-- -->
	<xsl:template match="/">
		<root>
			<begintime value="{$begintime}"/>
			<endtime1 value="{$endtime}"/>
			<endtime value="{$systime}"/>
			<count value="{$count}"/>
			<timediff-for-all-calls value="{$systime - $begintime}"/>
			<time-for-all-calls value="{my:secondsElapsed($begintime - current-dateTime())}"/>
			<time-call-seconds value="{(my:secondsElapsed($begintime - current-dateTime())) div $count}"/>
		</root>
	</xsl:template>
	<!-- -->
	<xsl:function as="xs:double" name="my:secondsElapsed">
		<xsl:param as="xdt:dateTimeDuration" name="v"/>
		<xsl:variable as="xs:double" name="days" select="fn:years-from-duration($v)*365.0+fn:days-from-duration($v)"/>
		<xsl:variable as="xs:double" name="hours" select="$days*24+fn:hours-from-duration($v)"/>
		<xsl:variable as="xs:double" name="minutes" select="$hours*60+fn:minutes-from-duration($v)"/>
		<xsl:variable as="xs:double" name="seconds" select="$minutes*60+fn:seconds-from-duration($v)"/>
		<xsl:value-of select="$seconds"/>
	</xsl:function>
	<!--  -->
</xsl:stylesheet>
