
-- Add asset_id column to ASSET_LISTS to store the combined ID
alter table ASSET_LISTS add (asset_id varchar2(150));
-- Shrink the doctype column
alter table ASSET_LISTS modify (doctype varchar2(5));
-- Populate the asset_id column
update ASSET_LISTS set asset_id=object_id || '|' || doctype;
-- Add unique index to the asset_id column
create index IDX_AL_ASSET_ID ON ASSET_LISTS (asset_id asc);



declare
  
  v_channel   customer_locale_export.customer_id%TYPE := 'Scene7';
  v_doctypes  varchar2(3000)                          := q'|'_FP','A1P','A2P','A3P','A4P','A5P','ABP','APP','AWL','AWP','AWR','AWT','BPP','BRP'
                                                          ,'CLL','CLP','CO_','COP','D1P','D2P','D3P','D4P','D5P','DPP','E1P','E2P','E3P','E4P'
                                                          ,'EL1','ENL','FDB','FIL','FLP','FMB','FTP','GAP','L1P','L2P','L3P','L4P','MCP','MI1'
                                                          ,'P3D','P3F','PA1','PAH','PBP','PDB','PID','PLP','PMB','PP2','PS2','PVP','PWL','R1P'
                                                          ,'RCP','RTP','SLP','TLP','TRP','TSL','U1P','U2P','U3P','U4P','U5P','UPL','UWL','VIM'|';
  --v_channel   customer_locale_export.customer_id%TYPE := 'AtgAssets';
  --v_doctypes  varchar2(3000)                          := q'|'FML'|';
  --v_channel   customer_locale_export.customer_id%TYPE := 'FlixMediaAssets';
  --v_doctypes  varchar2(3000)                          := q'|'FML','PRD','PRM','PM2','PM3','PM4','PM5','PRV'|';
  --v_channel   customer_locale_export.customer_id%TYPE := 'WebcollageAssets';
  --v_doctypes  varchar2(3000)                          := q'|'FML','PRD','PRM','PM2','PM3','PM4','PM5','PRV'|';
  
  cursor c_assets(
      p_channel in customer_locale_export.customer_id%TYPE
    , p_doctypes in varchar2
  ) is
    select cle.ctn as object_id, cle.locale, cle.lasttransmit, al.doctype, al.md5
    from customer_locale_export cle
    inner join asset_lists al
       on al.object_id=cle.ctn
      and al.locale=cle.locale
    where cle.customer_id=p_channel
      and cle.lasttransmit is not null
      --and nvl(cle.remark,'null') != 'Migration'
      and al.doctype in (p_doctypes)
    --  and rownum <= 50
    ;
    
begin
  for r_asset in c_assets(v_channel, v_doctypes) loop
    insert into customer_locale_export (customer_id, ctn, locale, lasttransmit, flag, remark)
    values (v_channel, r_asset.object_id||'|'||r_asset.doctype, r_asset.locale, r_asset.lasttransmit, 0, r_asset.md5);
  end loop;
end;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--select * from channels where pipeline ='pipes/AssetsExport.Scene7' and id=1000;
update channels set pipeline='pipes/Scene7' where pipeline ='pipes/AssetsExport.Scene7' and id=1000;