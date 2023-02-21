Source: http://social.technet.microsoft.com/wiki/contents/articles/2150.how-to-use-powershell-to-import-schema-objects-from-a-csv-file.aspx.

This gallery items is recovered from the old MSDN archive and published again on Gallery to guarantee availability.

 
Summary
This script may be used to create Attributes and Bindings in the FIM Portal Schema based on information in a CSV file.

The script comes in two parts:

Import-SchemaCSV.ps1 is used to generate a changes.xml file, and
CommitChanges.ps1 is used to import the changes into the FIM Portal.
If you are creating new attributes with bindings then you must run the process twice. The first time the attributes will be created, and the second time the bindings will be created, using the GUIDs of the new attributes.

The script does not currently create Resource objects. Any Resource types specified in the CSV file must already exist.