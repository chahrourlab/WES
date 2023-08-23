	DROP TABLE IF EXISTS Final_Ultra_Rare_Variants;
	create table Final_Ultra_Rare_Variants as select * from Final_Rare_Variants 
		 where greatest(ExAC_ALL, ExAC_AFR, ExAC_AMR, ExAC_EAS, ExAC_FIN, ExAC_NFE, ExAC_OTH, ExAC_SAS, AF_exome, AF_afr_exome, AF_sas_exome,
			AF_amr_exome, AF_eas_exome, AF_nfe_exome, AF_fin_exome, AF_asj_exome, AF_oth_exome, AF_genome, AF_afr_genome, AF_sas_genome,
			AF_amr_genome, AF_eas_genome, AF_nfe_genome, AF_fin_genome, AF_asj_genome, AF_oth_genome, GME_AF, GME_NWA, GME_NEA, GME_AP,
			GME_Israel, GME_SD, GME_TP, GME_CA, `1000g2015aug_all`, `1000g2015aug_afr`, `1000g2015aug_amr`, `1000g2015aug_eas`, `1000g2015aug_eur`,
			`1000g2015aug_sas`) = 0;
	CREATE INDEX Final_Ultra_Rare_Variants_Chr_IDX USING BTREE ON dfw_updated.Final_Ultra_Rare_Variants (Chr,`Start`,`End`);