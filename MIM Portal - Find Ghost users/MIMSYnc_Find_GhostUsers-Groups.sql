select rdn, object_type
from [FIMSynchronizationService].[dbo].[mms_connectorspace] with(nolock)
where (object_type in ('Person','Group')) and (ma_id ='<FIM MA GUID>') AND object_id in
 (
 select csmv2.cs_object_id
 FROM [FIMSynchronizationService].[dbo].[mms_csmv_link] csmv2 with(nolock) 
 where csmv2.mv_object_id in
  (
  SELECT [mv_object_id]
  FROM [FIMSynchronizationService].[dbo].[mms_csmv_link] csmv1 with(nolock)
  group by csmv1.mv_object_id
  having count(csmv1.cs_object_id) = 1
  )
 )
order by object_type
