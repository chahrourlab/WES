	DROP TABLE IF EXISTS Final_Summary_Totals_X_Linked;
	create table  Final_Summary_Totals_X_Linked as
	(SELECT sampleID,
 	   count(*) AS total,
 	   sum(case when `Func_refGene` not in ('exonic', 'ncRNA_exonic','splicing', 'exonic;splicing') then 1 else 0 end) AS Noncoding,
 	   sum(case when `Func_refGene` in ('exonic', 'ncRNA_exonic','splicing', 'exonic;splicing') then 1 else 0 end) AS Coding
	FROM Final_X_Linked
	group by sampleID);