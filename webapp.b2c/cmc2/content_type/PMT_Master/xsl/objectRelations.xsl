<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="ts"/>
  
  <xsl:variable name="apos">'</xsl:variable>
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="process[../@valid='true']">
    <xsl:variable name="accessory-ctns" select="../content/Product/ProductRefs/ProductReference[@ProductReferenceType='Accessory']/CTN
                                               |../content/Product/ProductReferences[@ProductReferenceType='Accessory']/CTN"/>
    <xsl:copy copy-namespaces="no">
      <query name="product-accessory-relations" isstoredprocedure="true">
        BEGIN
        
        -- Delete the accessory relations for this object that no longer exist
        update OBJECT_RELATIONS set deleted=1, lastmodified_ts=to_date('<xsl:value-of select="$ts"/>','yyyymmddhh24miss')
        where rel_type='PRD_ACC' and object_id_src = '<xsl:value-of select="../@o"/>'
        <xsl:if test="exists($accessory-ctns)">
        and object_id_tgt not in ('<xsl:value-of select="string-join($accessory-ctns,concat($apos, ',', $apos))"/>')
        </xsl:if>
        and deleted=0
        ;
        <xsl:if test="exists($accessory-ctns)">
        -- Merge the new accessory relations into the table
        merge into object_relations objrel
        using (
          <xsl:apply-templates select="$accessory-ctns" mode="object-relations"/>
        ) newrel
        on ( '<xsl:value-of select="../@o"/>'=objrel.object_id_src
        and newrel.tgt=objrel.object_id_tgt
        and 'PRD_ACC'=objrel.rel_type
        )
        when matched then
          update set objrel.deleted=0, lastmodified_ts=to_date('<xsl:value-of select="$ts"/>','yyyymmddhh24miss')
          where objrel.object_id_tgt=newrel.tgt
            and objrel.deleted=1
        when not matched then
          insert (objrel.object_id_src, objrel.object_id_tgt, objrel.rel_type, objrel.lastmodified_ts)
          values ('<xsl:value-of select="../@o"/>', newrel.tgt, 'PRD_ACC', to_date('<xsl:value-of select="$ts"/>','yyyymmddhh24miss'))
        ;
        </xsl:if>
        
        END;
      </query>
    </xsl:copy>    
  </xsl:template>
  
  <xsl:template match="CTN[position() = 1]" mode="object-relations">
    <xsl:text>select '</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>' tgt from dual</xsl:text>
  </xsl:template>

  <xsl:template match="CTN[position() gt 1]" mode="object-relations">
    <xsl:text>
    union select '</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>' tgt from dual</xsl:text>
  </xsl:template>
</xsl:stylesheet>