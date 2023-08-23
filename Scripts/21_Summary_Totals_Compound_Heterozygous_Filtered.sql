	DROP TABLE IF EXISTS Summary_Totals_Comp_Hetero;
	create table  Summary_Totals_Comp_Hetero as
	(SELECT mc.Individual_ID,
 	   count(ch1.sampleID) AS VariantCount,
	   count(distinct `Gene_refGene`) AS GeneCount
	FROM S_Comp_Hetero_Filtered ch1 right join DFW_pedigree mc 
	on (ch1.sampleID = mc.Individual_ID)
	where mc.Family_member in ('Proband', 'Proband (twin)', 'Sibling', 'Sibling (twin)', 'Half sibling') and
		exists (select distinct Chr, Start, End, Alt, Ref from S_Comp_Hetero_Filtered ch2 
				where ch1.sampleID = ch2.sampleID and ch1.`Gene_refGene` = ch2.`Gene_refGene` 
					and ch1.Parent <> ch2.Parent)
	group by mc.Individual_ID);