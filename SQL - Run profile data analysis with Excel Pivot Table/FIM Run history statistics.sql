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