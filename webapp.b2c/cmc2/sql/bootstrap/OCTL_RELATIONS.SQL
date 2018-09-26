SET DEFINE OFF;
Insert into OCTL_RELATIONS
   (OUTPUT_CONTENT_TYPE, OUTPUT_LOCALISATION, OUTPUT_OBJECT_ID, INPUT_CONTENT_TYPE, INPUT_LOCALISATION, INPUT_OBJECT_ID, ISSECONDARY, ISDERIVED)
 Values
   ('catalog_log', 'none', 'ProcoonCatalogs', 'catalog_configuration', 'none', 'ProcoonCatalogs', 0, 0);
Insert into OCTL_RELATIONS
   (OUTPUT_CONTENT_TYPE, OUTPUT_LOCALISATION, OUTPUT_OBJECT_ID, INPUT_CONTENT_TYPE, INPUT_LOCALISATION, INPUT_OBJECT_ID, ISSECONDARY, ISDERIVED)
 Values
   ('catalog_log', 'none', 'ProcoonCatalogs', 'catalog_definition', 'none', 'ProcoonCatalogs', 0, 0);
Insert into OCTL_RELATIONS
   (OUTPUT_CONTENT_TYPE, OUTPUT_LOCALISATION, OUTPUT_OBJECT_ID, INPUT_CONTENT_TYPE, INPUT_LOCALISATION, INPUT_OBJECT_ID, ISSECONDARY, ISDERIVED)
 Values
   ('catalog_log', 'none', 'BusinessCatalogs', 'catalog_configuration', 'none', 'BusinessCatalogs', 0, 0);
Insert into OCTL_RELATIONS
   (OUTPUT_CONTENT_TYPE, OUTPUT_LOCALISATION, OUTPUT_OBJECT_ID, INPUT_CONTENT_TYPE, INPUT_LOCALISATION, INPUT_OBJECT_ID, ISSECONDARY, ISDERIVED)
 Values
   ('catalog_log', 'none', 'BusinessCatalogs', 'catalog_definition', 'none', 'BusinessCatalogs', 0, 0);
Insert into OCTL_RELATIONS
   (OUTPUT_CONTENT_TYPE, OUTPUT_LOCALISATION, OUTPUT_OBJECT_ID, INPUT_CONTENT_TYPE, INPUT_LOCALISATION, INPUT_OBJECT_ID, ISSECONDARY, ISDERIVED)
 Values
   ('catalog_log', 'none', 'ContentTypesCatalog', 'catalog_configuration', 'none', 'ContentTypesCatalog', 0, 0);
Insert into OCTL_RELATIONS
   (OUTPUT_CONTENT_TYPE, OUTPUT_LOCALISATION, OUTPUT_OBJECT_ID, INPUT_CONTENT_TYPE, INPUT_LOCALISATION, INPUT_OBJECT_ID, ISSECONDARY, ISDERIVED)
 Values
   ('catalog_log', 'none', 'ContentTypesCatalog', 'catalog_definition', 'none', 'ContentTypesCatalog', 0, 0);
COMMIT;
