	DROP TABLE IF EXISTS Final_Summary_Totals_Private;
	create table  Final_Summary_Totals_Private as
	(SELECT pv.sampleID AS Sample,
 	   count(pv.sampleID) AS Variants,
 	   sum(case when Otherinfo1 = 0.5 then 1 else 0 end) AS Heterozygous,
 	   sum(case when Otherinfo1 = 1 then 1 else 0 end) AS Homozygous, 
 	   sum(case when (length(Ref) = 1 and Ref <> '-') and (length(Alt) = 1 and Alt <> '-') then 1 else 0 end) as SNVs,
 	 	0 as Indels
	FROM Final_Private_Variants pv
	GROUP BY pv.sampleID);

	update Final_Summary_Totals_Private set Indels = Variants - SNVs;