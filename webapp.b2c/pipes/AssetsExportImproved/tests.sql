-- Add asset_id column to ASSET_LISTS to store the combined ID
alter table ASSET_LISTS add (asset_id varchar2(125));
-- Shrink the doctype column
alter table ASSET_LISTS modify (doctype varchar2(5));
-- Populate the asset_id column
update ASSET_LISTS set asset_id=object_id || '|' || doctype;
-- Add unique index to the asset_id column
create index IDX_AL_ASSET_ID ON ASSET_LISTS (asset_id asc);

-- Test record for 192E1SB/27
insert into customer_locale_export (customer_id, locale, ctn) values ('Scene7','fr_CA','192E1SB/27|PSS');

-- Flag the test product
update customer_locale_export set flag=1 where customer_id='Scene7' and locale in ('master_global','fr_CA') and ctn='192E1SB/27|PSS';

-- Put the MD5 in the CLE remark field for all flagged records and one locale
merge into customer_locale_export cle
using (
  select al.asset_id
       , al.locale
       , al.md5
  from asset_lists al
  
  where al.locale='fr_CA'
    -- Only for records that were not modified after this run was started
    and al.lastmodified < to_date('20111229162700','yyyymmddhh24miss') -- runtimestamp
) al
on (
      al.asset_id=cle.ctn
  and al.locale=cle.locale
  and cle.customer_id='Scene7'
  and cle.flag=1
)
when matched then
  update set remark=al.md5
;

select * from customer_locale_export where customer_id='Scene7' and ctn like '192E1SB/27%';

