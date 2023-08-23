	DROP TABLE IF EXISTS Summary_Totals_Inherited_Homoz;
	create table  Summary_Totals_Inherited_Homoz as
	(SELECT sampleID,
	count(*) AS total,
	sum(case when `Func_refGene` not in ('exonic', 'ncRNA_exonic','splicing', 'exonic;splicing','ncRNA_splicing') then 1 else 0 end) AS Noncoding,
	sum(case when `Func_refGene` in ('exonic', 'ncRNA_exonic','splicing', 'exonic;splicing','ncRNA_splicing') then 1 else 0 end) AS Coding
	FROM S_Inherited_Homoz
	GROUP BY sampleID);