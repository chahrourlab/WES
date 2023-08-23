	DROP TABLE IF EXISTS Final_Summary_Totals_Denovo;
	create table  Final_Summary_Totals_Denovo as
	(SELECT sampleID,
 	   count(*) AS total,
 	   sum(case when length(Ref)=1 and Ref <> '-' and length(Alt)=1 and Alt <> '-' then 1 else 0 end) as SNVs,
 	   sum(case when (Alt='-' and Ref <> '-') or (Ref='-' and Alt <> '-') then 1 else 0 end) as Indels,
 	   sum(case when `Func_refGene` not in ('exonic', 'ncRNA_exonic','splicing') then 1 else 0 end) AS Noncoding,
 	   sum(case when `Func_refGene` in ('exonic', 'ncRNA_exonic','splicing') then 1 else 0 end) AS Coding
	FROM Final_Denovo_Variants
	GROUP BY sampleID);