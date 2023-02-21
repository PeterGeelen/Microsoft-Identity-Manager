Part 1: 

This article provides you a quick solution to get a statistical overview of your FIM / MIM run profile performance.

Prerequisites:

- sufficient run history data in the FIM/MIM appllication

- Access to SQL data base of FIM Sync to run a (read-only) query on the Run history tables

 

SQL Script

Run the script below on the FIM Sync database and copy/paste or import the results into the Excel Sheet.

#########################

use FIMSynchronizationService
SELECT
--mms_run_history.run_history_id,
mms_management_agent.ma_name,
--mms_run_history.run_profile_id,
mms_run_profile.run_profile_name,
mms_run_history.run_number,
mms_run_history.username,
mms_run_history.is_run_complete,
mms_run_history.run_result,
mms_run_history.current_step_number,
mms_run_history.total_steps,
mms_run_history.start_date,
mms_run_history.end_date,
mms_run_history.mms_timestamp,
mms_run_history.operation_bitmask
FROM
mms_run_history WITH (nolock)

INNER JOIN
mms_run_profile
ON
mms_run_history.run_profile_id = mms_run_profile.run_profile_id

INNER JOIN
mms_management_agent
ON
mms_run_history.ma_id = mms_management_agent.ma_id

ORDER BY
mms_run_history.mms_timestamp DESC

#########################

 

Known issues

- currently the pivot table is referencing a fixed length column, which you need to fix when you import more data than currently configured.

Part 2
This article provides you a quick solution to get a statistical overview of your FIM / MIM run profile performance using an Export by SQL Query

Prerequisites:

- sufficient run history data in the FIM/MIM appllication

- Access to SQL data base of FIM Sync to run a (read-only) query on the Run history tables

 

Use this XLS sheet to copy the SQL query output from part 1 : https://gallery.technet.microsoft.com/FIM-2010-MIM-2016-Run-84ed34fb