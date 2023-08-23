	DROP TABLE IF EXISTS Final_Summary_Totals_Burden; 
	create table Final_Summary_Totals_Burden as
	(SELECT pd.Individual_ID as sampleID,
 	   count(rare.sampleID) AS total,
 	   sum(case when Func_refGene in ('exonic', 'splicing', 'exonic;splicing') then 1 else 0 end) AS TotalCoding,
 	   sum(case when Func_refGene='exonic' and ExonicFunc_refGene in ('nonframeshift insertion', 'nonframeshift deletion', 'synonymous SNV') then 1 else 0 end) AS Nondisrupting,
	   sum(case when Func_refGene in ('exonic', 'splicing', 'exonic;splicing') and ExonicFunc_refGene in ('frameshift insertion', 'frameshift deletion', 'stopgain', 'stoploss') then 1 else 0 end) AS LoF,
	   sum(case when Func_refGene in ('exonic', 'splicing', 'exonic;splicing') and ExonicFunc_refGene ='nonsynonymous SNV' and (select 
			(case when SIFT_pred = 'D' then 1 else 0 end)	+
			(case when Polyphen2_HVAR_pred in ('P', 'D') then 1 else 0 end) +
			(case when LRT_pred = 'D' then 1 else 0 end) +
			(case when MutationAssessor_Pred in ('A', 'D') then 1 else 0 end) +
			(case when MutationTaster_Pred in ('H', 'M') then 1 else 0 end) +
			(case when FATHMM_pred = 'D' then 1 else 0 end) +
			(case when PROVEAN_pred = 'D' then 1 else 0 end) +
			(case when MetaSVM_pred = 'D' then 1 else 0 end) +
			(case when MetaLR_pred = 'D' then 1 else 0 end) >= 5) then 1 else 0 end) as MissenseDamaging
	  FROM Final_Rare_Variants rare right join Final_Pedigree pd 
			on (rare.sampleID = pd.Individual_ID)
	  where pd.Family_member in ('Proband', 'Proband (twin)', 'Sibling', 'Sibling (twin)', 'Half sibling')
	  group by pd.Individual_ID);
	 CREATE INDEX `sID` on Final_Summary_Totals_Burden (`sampleID`);