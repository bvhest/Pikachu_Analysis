<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
	<xsl:param name="external_only"/>
	<!-- -->
	<!--

merge into ph_feature_list d
 using ph_feature_list_E s 
 on (s.PRODUCT_ID = d.PRODUCT_ID and s.SEQUENCE_NUM = d.SEQUENCE_NUM)
		
	when matched then
				update set
			d.FEATURE_ID =  s.FEATURE_ID
    when not matched then
insert (PRODUCT_ID,SEQUENCE_NUM,FEATURE_ID)
 values (s.PRODUCT_ID,s.SEQUENCE_NUM,s.FEATURE_ID);

delete from ph_feature_list where (PRODUCT_ID,FEATURE_ID) in (
select d.PRODUCT_ID,d.FEATURE_ID 
from ph_feature_list d
left outer join ph_feature_list_e s on s.PRODUCT_ID = d.PRODUCT_ID and s.FEATURE_ID = d.FEATURE_ID
where s.PRODUCT_ID is null
and exists (select 1 from ph_feature_list_e where PRODUCT_ID = d.PRODUCT_ID ));

-->
	<xsl:template name="merge">
		<xsl:variable name="apos">'</xsl:variable>
		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="df">'yyyy-mm-dd"T"hh24:mi:ss'</xsl:variable>
		<xsl:variable name="atgNull">'__NULL__'</xsl:variable>

BEGIN
 merge into <xsl:value-of select="@name"/> d
 using <xsl:value-of select="concat(@name,'_E') "/> s 
 on (<xsl:for-each select="column[@primary-key='P']">
			<xsl:if test="position() != 1"> and </xsl:if>
			<xsl:value-of select="concat('s.',@name,' = d.',@name)"/>
		</xsl:for-each>)
		<xsl:if test="column[not(@primary-key='P')] ">
	when matched then
				update set
			<xsl:for-each select="column[not(@primary-key='P')]">
					<xsl:if test="position() != 1">,</xsl:if>
					<xsl:value-of select="concat('d.',@name, ' =  s.',@name )"/>
				</xsl:for-each>
		</xsl:if>
    when not matched then
insert (<xsl:for-each select="column">
			<xsl:if test="position() != 1">,</xsl:if>
			<xsl:value-of select="@name"/>
		</xsl:for-each>)
 values (<xsl:for-each select="column">
				<xsl:if test="position() != 1">,</xsl:if>
				<xsl:value-of select="concat('s.',@name )"/>
		</xsl:for-each>);
dbms_output.put_line('Merge <xsl:value-of select="@name"/> '||SQL%ROWCOUNT );
commit;
EXCEPTION
	WHEN OTHERS THEN
		 BEGIN
			 rollback;
			dbms_output.put_line('<xsl:value-of select="@name"/> *** ERROR'||SQLERRM );
		END;
END;		
	</xsl:template>


	<xsl:template name="load">
		<xsl:variable name="apos">'</xsl:variable>
		<xsl:variable name="columnList">
			<xsl:for-each select="column">
				<xsl:if test="position() != 1">,</xsl:if>
				<xsl:value-of select="@name"/>
			</xsl:for-each>
		</xsl:variable>
BEGIN
	 insert into <xsl:value-of select="@name"/>(<xsl:value-of select="$columnList"/>)
	 select <xsl:value-of select="$columnList"/> from <xsl:value-of select="concat(@name,'_E') "/> 
	 minus
	 select <xsl:value-of select="$columnList"/> from <xsl:value-of select="@name"/>;
dbms_output.put_line('Load <xsl:value-of select="@name"/> '||SQL%ROWCOUNT );
commit;
EXCEPTION
	WHEN OTHERS THEN
		 BEGIN
			 rollback;
			dbms_output.put_line('<xsl:value-of select="@name"/> *** ERROR'||SQLCODE );
		END;
END;		
	</xsl:template>	

<!-- -->
	<xsl:template name="remove">
		<xsl:variable name="pkColumn" select="column[@primary-key='P'][@position='1']/@name "/>
		<xsl:variable name="listColumn" select="column[@primary-key='P'][@position='2']/@name "/>
		<xsl:variable name="colList" select="concat($pkColumn,',',$listColumn)"/>
		<xsl:variable name="colListd" select="concat('d.',$pkColumn,',d.',$listColumn)"/>
BEGIN
delete from <xsl:value-of select="@name"/>
where (<xsl:value-of select="$colList"/>) in (
select <xsl:value-of select="$colListd"/>
from <xsl:value-of select="@name"/> d
left outer join <xsl:value-of select="concat(@name,'_E')"/> s on s.<xsl:value-of select="$pkColumn"/> = d.<xsl:value-of select="$pkColumn"/> and s.<xsl:value-of select="$listColumn"/> = d.<xsl:value-of select="$listColumn"/>
where s.<xsl:value-of select="$pkColumn"/> is null
and exists (select 1 from <xsl:value-of select="concat(@name,'_E')"/> where <xsl:value-of select="$pkColumn"/> = d.<xsl:value-of select="$pkColumn"/> ));
dbms_output.put_line('Remove <xsl:value-of select="@name"/> '||SQL%ROWCOUNT );
commit;
EXCEPTION
	WHEN OTHERS THEN
		 BEGIN
			 rollback;
			dbms_output.put_line('<xsl:value-of select="@name"/> *** ERROR'||SQLCODE );
		END;
END;		
</xsl:template>

	
	<!--  ********************************************************                  PROCESS          *********************************************-->
	
	<xsl:template match="/root">
		<root>
			<sql:execute-query xmlns:sql="http://apache.org/cocoon/SQL/2.0">
				<sql:query>
			CREATE OR REPLACE procedure loadData is
			BEGIN
				<xsl:apply-templates select="table[@type='primary']"/>
				<xsl:apply-templates select="table[@type='auxiliary']"/>
				<xsl:apply-templates select="table[@type='multi'][@data-type='list']"/>
				<xsl:apply-templates select="table[@type='multi'][@data-type='set']"/>
				<xsl:apply-templates select="table[@type='multi'][@data-type='map']"/>
			END;
			</sql:query>
			</sql:execute-query>
		</root>	
	</xsl:template>
	
	<xsl:template match="node()|@*">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="sql:rowset"/>
	<xsl:template match="table[@type='primary'] | table[@type='auxiliary'] | table[@type='multi'][@data-type='map'][@append='true']">
		<xsl:choose>
			<xsl:when test="column/@primary-key='P' "><xsl:call-template name="merge"/></xsl:when>
			<xsl:otherwise><xsl:call-template name="load"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- -->
	<xsl:template match="table[@type='multi'][@data-type='list'] ">
			<xsl:call-template name="remove"/>
			<xsl:call-template name="merge"/>
	</xsl:template>
	<!-- -->
	<xsl:template match=" table[@type='multi'][@data-type='map'][not(@append='true')] ">
			<xsl:call-template name="remove"/>
			<xsl:call-template name="merge"/>
	</xsl:template>
	<xsl:template match=" table[@type='multi'][@data-type='set'] ">
			<xsl:call-template name="remove"/>
			<xsl:call-template name="merge"/>
	</xsl:template>
	<!-- -->
</xsl:stylesheet>
