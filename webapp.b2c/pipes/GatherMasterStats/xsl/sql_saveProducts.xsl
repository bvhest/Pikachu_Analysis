<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0">
        <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

        <!-- -->
        <xsl:template match="/">
                <root>
                        <xsl:apply-templates/>
                </root>
        </xsl:template>
        <!-- -->
        <xsl:template match="//Product">
                <entry>
                        <xsl:attribute name="id"><xsl:value-of select="CTN"/></xsl:attribute>
                        <xsl:attribute name="locale"><xsl:text>Master</xsl:text></xsl:attribute>
                        <!--sql:execute-query>
                                <sql:query>

                                        update   master_products
                                        set      status = '<xsl:value-of select="MarketingStatus"/>'
                                                ,division = '<xsl:value-of select="@Division"/>'
                                                ,brand = '<xsl:value-of select="@Brand"/>'
                                                ,lastmodified = to_date('<xsl:value-of select="substring(@lastModified,1,19)"/>','yyyy-mm-dd"T"hh24:mi:ss')
                                        where    id = '<xsl:value-of select="CTN"/>'

                                </sql:query>
                        </sql:execute-query>


                        <sql:execute-query>
                                <sql:query>

                                        insert   into master_products (id, division, brand, status, lastmodified)
                                        select   '<xsl:value-of select="CTN"/>'
                                                ,'<xsl:value-of select="@Division"/>'
                                                ,'<xsl:value-of select="@Brand"/>'
                                                ,'<xsl:value-of select="MarketingStatus"/>'
                                                ,to_date('<xsl:value-of select="substring(@lastModified,1,19)"/>','yyyy-mm-dd"T"hh24:mi:ss')
                                        from     dual
                                        where not exists
                                                 (select 1
                                                  from master_products
                                                  where id  = '<xsl:value-of select="CTN"/>')

                                </sql:query>
                        </sql:execute-query>

                        <sql:execute-query>
                                <sql:in-xml-parameter nr="1">
                                        <xsl:copy-of copy-namespaces="no" select="."/>
                                </sql:in-xml-parameter>
                                <sql:query>
                                        update master_products mp
                                        set    mp.data = ?
                                        where (mp.id = '<xsl:value-of select="CTN"/>')
                                </sql:query>
                        </sql:execute-query-->
                </entry>
        </xsl:template>
</xsl:stylesheet>