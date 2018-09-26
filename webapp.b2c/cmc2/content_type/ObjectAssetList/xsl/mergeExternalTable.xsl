<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="cmc2-f" >
  <xsl:param name="ts"/>
  
  <xsl:template match="/">
    <xsl:copy>
      <!-- Deletes -->
      <sql:execute-query>
        <sql:query name="mark-assets-deletions">
          update asset_lists a
            set deleted = 1, lastmodified = to_date('<xsl:value-of select="$ts"/>','yyyymmddhh24miss')
          
          where (a.object_id, a.doctype, a.locale) in (
            select al.object_id, al.doctype, al.locale 
            from asset_lists al
            
            inner join (
                select distinct OBJECT_ID, LOCALE 
                from asset_lists_ext al_ext
              ) object_locales 
              on object_locales.object_id = al.object_id 
              and object_locales.locale = al.locale
          
            left outer join asset_lists_ext al_ext 
               on al_ext.object_id = al.object_id
              and al_ext.doctype = al.doctype 
              and al_ext.locale = al.locale
           
            where al_ext.object_id is null
          )
        </sql:query>
      </sql:execute-query>
  
      <!-- Merge updated/new assets -->
      <sql:execute-query>
        <sql:query name="merge-asset-changes">
         merge into asset_lists al
         using ( select  object_id,
                   doctype,
                  locale,
                   asset_resource_ref, 
                  product_asset,
                  deleted, 
                  md5, 
                  lang, 
                  license, 
                  access_rights, 
                  modified, 
                  publisher, 
                  internalresourceidentifier, 
                  secureresourceidentifier, 
                  publicresourceidentifier, 
                  creator, 
                  format, 
                  ext, 
                  short_description,
                  lastmodified,
                  object_id||'|'||doctype as asset_id
                  from asset_lists_ext) al_ext
          on (    al.object_id=al_ext.object_id
                and al.doctype=al_ext.doctype
                and al.locale = al_ext.locale)
          when not matched then
                      insert (  object_id,
                                  doctype,
                                  locale,
                                  asset_resource_ref, 
                                  product_asset,
                                  deleted, 
                                  md5, 
                                  lang, 
                                  license, 
                                  access_rights, 
                                  modified, 
                                  publisher, 
                                  internalresourceidentifier, 
                                  secureresourceidentifier, 
                                  publicresourceidentifier, 
                                  creator, 
                                  format, 
                                  ext, 
                                  short_description,
                                  lastmodified,
                                  asset_id)
                      values ( al_ext.object_id,
                                  al_ext.doctype,
                                  al_ext.locale,
                                  al_ext.asset_resource_ref, 
                                  al_ext.product_asset,
                                  al_ext.deleted, 
                                  al_ext.md5, 
                                  al_ext.lang, 
                                  al_ext.license, 
                                  al_ext.access_rights, 
                                  al_ext.modified, 
                                  al_ext.publisher, 
                                  al_ext.internalresourceidentifier, 
                                  al_ext.secureresourceidentifier, 
                                  al_ext.publicresourceidentifier, 
                                  al_ext.creator, 
                                  al_ext.format, 
                                  al_ext.ext,  
                                  al_ext.short_description,
                                  al_ext.lastmodified,
                                  al_ext.asset_id)
          when matched then
              update set 
                                  al.asset_resource_ref = al_ext.asset_resource_ref, 
                                  al.product_asset = al_ext.product_asset,
                                  al.deleted = al_ext.deleted, 
                                  al.md5 = al_ext.md5, 
                                  al.lang = al_ext.lang, 
                                  al.license = al_ext.license, 
                                  al.access_rights = al_ext.access_rights, 
                                  al.modified = al_ext.modified, 
                                  al.publisher = al_ext.publisher, 
                                  al.internalresourceidentifier = al_ext.internalresourceidentifier, 
                                  al.secureresourceidentifier = al_ext.secureresourceidentifier, 
                                  al.publicresourceidentifier = al_ext.publicresourceidentifier, 
                                  al.creator = al_ext.creator, 
                                  al.format = al_ext.format, 
                                  al.ext = al_ext.ext, 
                                  al.short_description = al_ext.short_description, 
                                  al.lastmodified = al_ext.lastmodified,
                                  al.asset_id =  al_ext.asset_id
                  where al.modified &lt; al_ext.modified
					OR	al.internalresourceidentifier != al_ext.internalresourceidentifier
					OR	al.secureresourceidentifier != al_ext.secureresourceidentifier
					OR	al.publicresourceidentifier != al_ext.publicresourceidentifier
				  
        </sql:query>
      </sql:execute-query>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>
</xsl:stylesheet>
