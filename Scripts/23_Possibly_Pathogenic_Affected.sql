	DROP TABLE IF EXISTS Final_Possibly_Pathogenic;
	create table Final_Possibly_Pathogenic as
		(select * from Final_Coding cod1 
		where ((Inheritance <> 'Compound Heterozygous' and (
			`Func_refGene` in ('splicing') or 
			`ExonicFunc_refGene` in ('frameshift insertion', 'frameshift deletion', 'stopgain', 'stoploss','unknown') or 
			(`ExonicFunc_refGene` in ('nonsynonymous SNV') and (
			SIFT_pred in ('D') or Polyphen2_HVAR_pred in ('P', 'D')))))  
		or (Inheritance in ('Compound Heterozygous') and (
			`Func_refGene` in ('splicing') or 
			`ExonicFunc_refGene` in ('frameshift insertion', 'frameshift deletion', 'stopgain', 'stoploss','unknown') or 
			(`ExonicFunc_refGene` in ('nonsynonymous SNV') and (
			SIFT_pred in ('D') or Polyphen2_HVAR_pred in ('P', 'D'))))
				and exists (select * from Final_Coding cod2 where 
			cod1.`Gene_refGene` = cod2.`Gene_refGene` and cod1.Parent <> cod2.Parent and (`Func_refGene` in ('splicing') or `ExonicFunc_refGene` in ('frameshift insertion', 'frameshift deletion', 'stopgain', 'stoploss','unknown') or (`ExonicFunc_refGene` in ('nonsynonymous SNV')
	and (SIFT_pred in ('D') or Polyphen2_HVAR_pred in ('P', 'D')))))))) ;

	CREATE INDEX Final_Possibly_Pathogenic_Chr_IDX USING BTREE ON dfw_updated.Final_Possibly_Pathogenic (Chr,`Start`,`End`);

	create table Final_Possibly_Pathogenic_Affected as select * from Final_Possibly_Pathogenic spp left join Final_Pedigree dp on spp.sampleID = dp.Individual_ID where dp.Affection =2
