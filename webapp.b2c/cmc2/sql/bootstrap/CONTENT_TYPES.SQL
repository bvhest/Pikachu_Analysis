SET DEFINE OFF;
Insert into CONTENT_TYPES
   (CONTENT_TYPE, REFERENCE_NAME, DISPLAY_NAME, SECONDARY_DERIVATION, DESCRIPTION)
 Values
   ('catalog_configuration', 'catalog_configuration', 'Catalog configuration', 0, 'bootstrap');
Insert into CONTENT_TYPES
   (CONTENT_TYPE, REFERENCE_NAME, DISPLAY_NAME, SECONDARY_DERIVATION, DESCRIPTION)
 Values
   ('catalog_definition', 'catalog_definition', 'catalog definition', 0, 'bootstrap');
Insert into CONTENT_TYPES
   (CONTENT_TYPE, REFERENCE_NAME, DISPLAY_NAME, SECONDARY_DERIVATION, DESCRIPTION)
 Values
   ('catalog_log', 'catalog_log', 'catalog log', 0, 'bootstrap');
Insert into CONTENT_TYPES
   (CONTENT_TYPE, REFERENCE_NAME, DISPLAY_NAME, SECONDARY_DERIVATION, DESCRIPTION)
 Values
   ('content_type_definition', 'content_type_definition', 'content type definition', 0, 'bootstrap');
Insert into CONTENT_TYPES
   (CONTENT_TYPE, REFERENCE_NAME, DISPLAY_NAME, SECONDARY_DERIVATION, DESCRIPTION)
 Values
   ('content_type_log', 'content_type_log', 'content type log', 0, 'bootstrap');
COMMIT;
