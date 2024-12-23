	DROP TABLE IF EXISTS Final_Summary_Totals_Rare_nonQF;	
	create table  Final_Summary_Totals_Rare_nonQF as
	(SELECT rv.sampleID as Sample,
 	   count(rv.sampleID) AS Variants,
 	   sum(case when Otherinfo1 = 0.5 then 1 else 0 end) AS Heterozygous,
 	   sum(case when Otherinfo1 = 1 then 1 else 0 end) AS Homozygous,
 	   sum(case when (length(Ref) = 1 and Ref <> '-') and (length(Alt) = 1 and Alt <> '-') then 1 else 0 end) as SNVs,
 	 	0 as Indels
 	   FROM Final_Rare_Variants_nonQF rv 
	group by rv.sampleID);

	update Final_Summary_Totals_Rare_nonQF set Indels = Variants - SNVs;