This powershell pulls the FIM2010/MIM 2016 run history statistics from the Sync server and loads them into an Excel sheet with Pivot tables to have a nice reporting overview of the run profiles.

Prerequisites:

http://github.com/dfinke/ImportExcel
Credits

original Powershell basics posted by Alex Weinert
Source: http://iheartpowershell.blogspot.be/2012/01/fim-run-history-statistics.html

This Excel sheet uses a macro to transform the PivotTables in the source XLSX sheet with conditional formatting

 

To use the macro, enable the Developer Menu

Add macro to FIM Menu and Quick Access Ribbon bar

Create a custom FIM menu -> add macro

 

The macro checks for a XLSX file in the same folder as XLSM file.
THen the PivotTables are formatted with hh:mm:ss formats and the Conditional formatting.