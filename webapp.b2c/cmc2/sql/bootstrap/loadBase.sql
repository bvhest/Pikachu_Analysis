delete from octl_store;

delete from octl_relations;

delete from octl;

delete from ctl_relations;

delete from ctl;

delete from content_types;

delete from object_categorization;
delete from categorization;
delete from object_master_data;
delete from localized_subcat;

delete from locale_language;
delete from language_translations;

delete from catalog_objects;
delete from catalog_ctl;

commit;
@CONTENT_TYPES.SQL
@CTL.SQL
@CTL_RELATIONS.SQL
@OCTL.SQL
@OCTL_RELATIONS.SQL
@LOCALE_LANGUAGE.SQL
@LANGUAGE_TRANSLATIONS.SQL
