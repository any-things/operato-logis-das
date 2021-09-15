select 
	a.sub_equip_cd, a.class_cd, a.pick_qty, a.picked_qty, case when a.picked_qty = 0 then 'W' else 'P' end as status
from
	(select
		j.sub_equip_cd, j.class_cd, sum(j.pick_qty) as pick_qty, sum(j.picked_qty) as picked_qty
	from
		job_instances j inner join cells c on j.domain_id = c.domain_id and j.equip_cd = c.equip_cd and j.sub_equip_cd = c.cell_cd
	where
		j.domain_id = :domainId
		and j.batch_id = :batchId
		and c.active_flag = true
		#if($cellCd)
		and j.sub_equip_cd = :cellCd
		#end
		#if($stationCd)
		and c.station_cd = :stationCd
		#end
	group by
		j.sub_equip_cd, j.class_cd
	) a
order by
	a.sub_equip_cd