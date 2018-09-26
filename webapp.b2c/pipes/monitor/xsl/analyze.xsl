<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:sql="http://apache.org/cocoon/SQL/2.0" xmlns:include="http://apache.org/cocoon/include/1.0" xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:my="http://www.philips.com/pika">
	<!-- -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- -->
	<xsl:template match="/root">
		<xsl:choose>
			<xsl:when test="@id=''">
				<MonitorReport>
					<Evaluation>
						<xsl:text>ERROR: Channel does not exist.</xsl:text>
					</Evaluation>
				</MonitorReport>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="StartExec" as="xs:dateTime">
					<xsl:choose>
						<xsl:when test="string-length(@startexec) &gt; 0">
							<xsl:value-of select="xs:dateTime(@startexec)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="xs:dateTime('2000-01-01T00:00:00Z')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="EndExec" as="xs:dateTime">
					<xsl:choose>
						<xsl:when test="string-length(@endexec) &gt; 0">
							<xsl:value-of select="xs:dateTime(@endexec)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="xs:dateTime('1999-01-01T00:00:00Z')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="Now" as="xs:dateTime" select="xs:dateTime(@now)"/>
				<xsl:variable name="TimeLogFile" as="xs:dateTime">
					<xsl:choose>
						<xsl:when test="log">
							<xsl:value-of select="xs:dateTime(concat(substring(log/@date,1,10),'T',substring(log/@date,12,20),'.0Z'))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$StartExec"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="CheckAllowedLastRunTime" as="xs:dateTime" select="$Now -  xs:dayTimeDuration(concat('P0DT',@lastrun,'H'))"/>
				<xsl:variable name="LastRunTime" as="xs:double" select="my:minutesElapsed($EndExec - $StartExec)"/>
				<xsl:variable name="MaxRunTime" as="xs:double" select="xs:double(@maxtime)*60.0"/>
				<MonitorReport>
					<CurrentTime>
						<xsl:value-of select="$Now"/>
					</CurrentTime>
					<Name>
						<xsl:value-of select="@channel"/>
					</Name>
					<TimeLastRun>
						<xsl:value-of select="$StartExec"/>
					</TimeLastRun>
					<LastTimeFinished>
						<xsl:value-of select="$EndExec"/>
					</LastTimeFinished>
					<LastLogFile>
						<xsl:value-of select="log/@name"/>
					</LastLogFile>
					<TimeStampLogFile>
						<xsl:value-of select="$TimeLogFile"/>
					</TimeStampLogFile>
					<CheckHoursLastRun>
						<xsl:value-of select="@lastrun"/>
					</CheckHoursLastRun>
					<CheckMaxRunTime>
						<xsl:value-of select="$MaxRunTime"/>
					</CheckMaxRunTime>
					<CheckAllowedLastRunTime>
						<xsl:value-of select="$CheckAllowedLastRunTime"/>
					</CheckAllowedLastRunTime>
					<ActualLastRunTime>
						<xsl:value-of select="$LastRunTime"/>
					</ActualLastRunTime>
					<Evaluation>
						<xsl:choose>
							<xsl:when test="$CheckAllowedLastRunTime &gt; $StartExec">
								<xsl:text>ERROR: No execution within requested period.</xsl:text>
							</xsl:when>
							<xsl:when test="$LastRunTime &gt; $MaxRunTime">
								<xsl:text>ERROR: Last run exceeded requested time limit.</xsl:text>
							</xsl:when>
							<xsl:when test="($StartExec &gt; $EndExec) and (my:minutesElapsed($Now - $StartExec) &gt; $MaxRunTime)">
								<xsl:text>ERROR: Last run did not finish successfully in time.</xsl:text>
							</xsl:when>
							<xsl:when test="substring(log/@name,1,5) = 'error'">
								<xsl:text>ERROR: Last run generated an error file.</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>SUCCESS: Everything is within allowed parameters.</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</Evaluation>
				</MonitorReport>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--  -->
	<xsl:function as="xs:double" name="my:minutesElapsed">
		<xsl:param as="xdt:dateTimeDuration" name="v"/>
		<xsl:variable as="xs:double" name="days" select="fn:years-from-duration($v)*365.0+fn:days-from-duration($v)"/>
		<xsl:variable as="xs:double" name="hours" select="$days*24+fn:hours-from-duration($v)"/>
		<xsl:variable as="xs:double" name="minutes" select="$hours*60+fn:minutes-from-duration($v)"/>
		<xsl:variable as="xs:double" name="seconds" select="fn:seconds-from-duration($v) div 60.0"/>
		<xsl:value-of select="$minutes+$seconds"/>
	</xsl:function>
	<!--  -->
</xsl:stylesheet>
