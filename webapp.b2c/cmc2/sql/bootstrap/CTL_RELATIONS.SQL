SET DEFINE OFF;
Insert into CTL_RELATIONS
   (OUTPUT_CONTENT_TYPE, OUTPUT_LOCALISATION, INPUT_CONTENT_TYPE, INPUT_LOCALISATION, ISSECONDARY)
 Values
   ('catalog_log', 'none', 'catalog_definition', 'none', 0);
Insert into CTL_RELATIONS
   (OUTPUT_CONTENT_TYPE, OUTPUT_LOCALISATION, INPUT_CONTENT_TYPE, INPUT_LOCALISATION, ISSECONDARY)
 Values
   ('content_type_log', 'none', 'content_type_definition', 'none', 0);
Insert into CTL_RELATIONS
   (OUTPUT_CONTENT_TYPE, OUTPUT_LOCALISATION, INPUT_CONTENT_TYPE, INPUT_LOCALISATION, ISSECONDARY)
 Values
   ('catalog_log', 'none', 'catalog_configuration', 'none', 1);
COMMIT;
