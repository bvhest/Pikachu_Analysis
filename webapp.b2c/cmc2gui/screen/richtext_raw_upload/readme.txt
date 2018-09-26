CMC2 Packaging GUI
==================

Description
-----------
The Packaging GUI in CMC2 allows uploading an Excel spreadsheet Packaging Brief created by PFS
to be imported into CMC2.
The import module is accessed via the Packaging main menu.

Steps
-----
1. Load upload screen: cmc2gui/packaging_home

2. Upload the file: cmc2gui/packaging_upload_post
	 a. After the upload the file is read by the HSSFGenerator which transforms the native Excel
	 	  format to XML.
	 b. The XML is transformed to the necessary format for processing in CMC2.
	    Both the package configuration and package texts are stored in one file in
	    	data/PP_Configuration/temp/upload/<project_code>.xml
	 c. The intermediate file is transformed into an HTML preview and shown to the user.

3. Import the file: cmc2gui/packaging_import_go
	 a. If the user click the import button the package code is sent to the server in this request.
	 b. The intermediate file is read and split up into two parts: one for the PP_Configuration import
	 		file and one for the PText_Raw import file.
	 c. Both parts are stored in the respective inboxes of both content types.
	 d. If one of both write-source operations fails, the other file is deleted if it was
	 		created succesfuly. 
	 e. The intermediate file is moved to the processed directory.
	 f. Result is shown to the user.
or
4. Cancel the import: cmc2gui/packaging_import_cancel
	 a. The intermediate file is deleted.
 
Packaging project code and creation time
----------------------------------------
The packaging project code and creation time are retrieved from the name of the Excel file.
The file name as created by PFS has the following form:
	 
	 		Packaging Brief <project_code> <date_time>.xls
	 
If the code or creation time cannot be determined from the file name (because the filename
doesn't have the required format, the current datetime is used.
	 
Language codes
--------------
The Packaging XML format uses language codes to specify the required translations.
The term language code is not to be confused with the language codes used in CMC2.
The packaging language codes are in fact locales that use a dash instead of an underscore
to separate the language and country.

Because the Excel file PFS creates contains language names rather than codes a mapping file is
used to determine the required language codes. The file is stored in
	
	screen/packaging_upload_post/language-map.xml

Known issues
------------

1. Sometimes the HSSFGenerator that reads the Excel input file will report an error:

	org.apache.poi.hssf.record.RecordFormatException: Unable to construct record instance,
	the following exception occured: null

There are two causes:
a. The currently selected cell is a pulldown menu, i.e. one of the language selection cells.
	 Changing the cell selection to a cell in another column will get rid of the error.
b. At least one sheet in the Excel file is protected with a password.
	 See the next point.

2. The HSSFGenerator cannot read Excel files with protected sheets. Since PFS protects all sheets
	 with password "PB" the files that PFS exports cannot be read directly.
	 All sheets have to be unprotected using Tools > Protect > Unprotect sheet on every sheet.

	Amending PFS to ommit the cell protection would be a better solution. 

3. No check is performed whether moving the intermediate file from temp/upload to
	 the processed directory fails.
	 It is safe to periodically clean the temp/upload directory.
	 
	 