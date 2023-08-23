	DROP TABLE IF EXISTS Final_Rare_Variants;
	create table Final_Rare_Variants as (select `Chr`,`Start`,`End`,`Ref`,`Alt`,`Func_refGene`,`Gene_refGene`,`GeneDetail_refGene`,`ExonicFunc_refGene`,`AAChange_refGene`,`xref_refGene`,`avsnp147`,
	`SIFT_score`,`SIFT_pred`,`Polyphen2_HDIV_score`,`Polyphen2_HDIV_pred`,`Polyphen2_HVAR_score`,`Polyphen2_HVAR_pred`,`LRT_score`,`LRT_pred`,`MutationTaster_score`,`MutationTaster_pred`,
`MutationAssessor_score`,`MutationAssessor_pred`,`FATHMM_score`,`FATHMM_pred`,`PROVEAN_score`,`PROVEAN_pred`,`VEST3_score`,`CADD_raw`,`CADD_phred`,`DANN_score`,`fathmm-MKL_coding_score`,
`fathmm-MKL_coding_pred`,`MetaSVM_score`,`MetaSVM_pred`,`MetaLR_score`,`MetaLR_pred`,`integrated_fitCons_score`,`integrated_confidence_value`,`GERP++_RS`,`phyloP7way_vertebrate`,
`phyloP20way_mammalian`,`phastCons7way_vertebrate`,`phastCons20way_mammalian`,`SiPhy_29way_logOdds`,`dbscSNV_ADA_SCORE`,`dbscSNV_RF_SCORE`,`MCAP`,`REVEL`,`DN ID`,`Patient ID`,`Phenotype`,`Platform`,
`Study`,`Pubmed ID`,`ExAC_ALL`,`ExAC_AFR`,`ExAC_AMR`,`ExAC_EAS`,`ExAC_FIN`,`ExAC_NFE`,`ExAC_OTH`,`ExAC_SAS`,`AF_exome`,`AF_popmax_exome`,`AF_male_exome`,`AF_female_exome`,`AF_raw_exome`,`AF_afr_exome`,
`AF_sas_exome`,`AF_amr_exome`,`AF_eas_exome`,`AF_nfe_exome`,`AF_fin_exome`,`AF_asj_exome`,`AF_oth_exome`,`non_topmed_AF_popmax_exome`,`non_neuro_AF_popmax_exome`,`non_cancer_AF_popmax_exome`,`controls_AF_popmax_exome`,
`AF_genome`,`AF_popmax_genome`,`AF_male_genome`,`AF_female_genome`,`AF_raw_genome`,`AF_afr_genome`,`AF_sas_genome`,`AF_amr_genome`,`AF_eas_genome`,`AF_nfe_genome`,`AF_fin_genome`,`AF_asj_genome`,
`AF_oth_genome`,`non_topmed_AF_popmax_genome`,`non_neuro_AF_popmax_genome`,`non_cancer_AF_popmax_genome`,`controls_AF_popmax_genome`,`GME_AF`,`GME_NWA`,`GME_NEA`,`GME_AP`,`GME_Israel`,
`GME_SD`,`GME_TP`,`GME_CA`,`1000g2015aug_all`,`1000g2015aug_afr`,`1000g2015aug_amr`,`1000g2015aug_eas`,`1000g2015aug_eur`,`1000g2015aug_sas`,`CLNALLELEID`,`CLNDN`,`CLNDISDB`,`CLNREVSTAT`,
`CLNSIG`,`Otherinfo1`,`Otherinfo2`,`Otherinfo3`,`Otherinfo4`,`Otherinfo5`,`Otherinfo6`,`Otherinfo7`,`Otherinfo8`,`Otherinfo9`,`Otherinfo10`,`AF`,`AQ`,`AC`,`AN`,`Otherinfo12`,`GT`,
`DP`,`AD`,`GQ`,`PL`,`RNC`,`sampleID` from MC_001_1 spv where 1=2);
	CREATE INDEX Final_Rare_Variants_Chr_IDX USING BTREE ON dfw_updated.Final_Rare_Variants (Chr,`Start`,`End`);
	
	# must set this system variable so that GROUP_CONCAT() will hold > 1000 chars) 
	SET SESSION group_concat_max_len = 1000000;

	# get all the samples to process.  
	select GROUP_CONCAT(Individual_ID) into @samples
	FROM dfw_updated.Final_Pedigree where Seq_Notes not like '%Not sequenced%' and Seq_Notes not like '%Not Sequenced%' and batch=1;
 
	

	# limit the number of samples processed for debug purposes.
	#set @samples = substring_index (@samples, ',', 5);

	REPEAT
	
		# pull the next sample to process.
   		set @sample = SUBSTRING_INDEX(@samples, ',', 1);

    	# variants
    	SET @sql = CONCAT('insert into Final_Rare_Variants select `Chr`,`Start`,`End`,`Ref`,`Alt`,`Func_refGene`,`Gene_refGene`,`GeneDetail_refGene`,`ExonicFunc_refGene`,`AAChange_refGene`,`xref_refGene`,`avsnp147`,
	`SIFT_score`,`SIFT_pred`,`Polyphen2_HDIV_score`,`Polyphen2_HDIV_pred`,`Polyphen2_HVAR_score`,`Polyphen2_HVAR_pred`,`LRT_score`,`LRT_pred`,`MutationTaster_score`,`MutationTaster_pred`,
`MutationAssessor_score`,`MutationAssessor_pred`,`FATHMM_score`,`FATHMM_pred`,`PROVEAN_score`,`PROVEAN_pred`,`VEST3_score`,`CADD_raw`,`CADD_phred`,`DANN_score`,`fathmm-MKL_coding_score`,
`fathmm-MKL_coding_pred`,`MetaSVM_score`,`MetaSVM_pred`,`MetaLR_score`,`MetaLR_pred`,`integrated_fitCons_score`,`integrated_confidence_value`,`GERP++_RS`,`phyloP7way_vertebrate`,
`phyloP20way_mammalian`,`phastCons7way_vertebrate`,`phastCons20way_mammalian`,`SiPhy_29way_logOdds`,`dbscSNV_ADA_SCORE`,`dbscSNV_RF_SCORE`,`MCAP`,`REVEL`,`DN ID`,`Patient ID`,`Phenotype`,`Platform`,
`Study`,`Pubmed ID`,`ExAC_ALL`,`ExAC_AFR`,`ExAC_AMR`,`ExAC_EAS`,`ExAC_FIN`,`ExAC_NFE`,`ExAC_OTH`,`ExAC_SAS`,`AF_exome`,`AF_popmax_exome`,`AF_male_exome`,`AF_female_exome`,`AF_raw_exome`,`AF_afr_exome`,
`AF_sas_exome`,`AF_amr_exome`,`AF_eas_exome`,`AF_nfe_exome`,`AF_fin_exome`,`AF_asj_exome`,`AF_oth_exome`,`non_topmed_AF_popmax_exome`,`non_neuro_AF_popmax_exome`,`non_cancer_AF_popmax_exome`,`controls_AF_popmax_exome`,
`AF_genome`,`AF_popmax_genome`,`AF_male_genome`,`AF_female_genome`,`AF_raw_genome`,`AF_afr_genome`,`AF_sas_genome`,`AF_amr_genome`,`AF_eas_genome`,`AF_nfe_genome`,`AF_fin_genome`,`AF_asj_genome`,
`AF_oth_genome`,`non_topmed_AF_popmax_genome`,`non_neuro_AF_popmax_genome`,`non_cancer_AF_popmax_genome`,`controls_AF_popmax_genome`,`GME_AF`,`GME_NWA`,`GME_NEA`,`GME_AP`,`GME_Israel`,
`GME_SD`,`GME_TP`,`GME_CA`,`1000g2015aug_all`,`1000g2015aug_afr`,`1000g2015aug_amr`,`1000g2015aug_eas`,`1000g2015aug_eur`,`1000g2015aug_sas`,`CLNALLELEID`,`CLNDN`,`CLNDISDB`,`CLNREVSTAT`,
`CLNSIG`,`Otherinfo1`,`Otherinfo2`,`Otherinfo3`,`Otherinfo4`,`Otherinfo5`,`Otherinfo6`,`Otherinfo7`,`Otherinfo8`,`Otherinfo9`,`Otherinfo10`,`AF`,`AQ`,`AC`,`AN`,`Otherinfo12`,`GT`,
`DP`,`AD`,`GQ`,`PL`,`RNC`,`sampleID` from ', @sample, 
    		' where Otherinfo1 != 0 and Otherinfo3 >= 10 and (GQ <> ''', '.', ''' and GQ >= 30) and greatest(ExAC_ALL, ExAC_AFR, ExAC_AMR, ExAC_EAS, ExAC_FIN, ExAC_NFE, ExAC_OTH, ExAC_SAS, AF_exome, AF_afr_exome, AF_sas_exome,
			AF_amr_exome, AF_eas_exome, AF_nfe_exome, AF_fin_exome, AF_asj_exome, AF_oth_exome, AF_genome, AF_afr_genome, AF_sas_genome,
			AF_amr_genome, AF_eas_genome, AF_nfe_genome, AF_fin_genome, AF_asj_genome, AF_oth_genome, GME_AF, GME_NWA, GME_NEA, GME_AP,
			GME_Israel, GME_SD, GME_TP, GME_CA, 1000g2015aug_all, 1000g2015aug_afr, 1000g2015aug_amr, 1000g2015aug_eas, 1000g2015aug_eur,
			1000g2015aug_sas) < .01');
		PREPARE stmt FROM @sql;
    	EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		# prepare to pull the next sample.
		set @nxt = locate(',', @samples);
    	SET @samples= SUBSTRING(@samples, @nxt + 1);
    
	UNTIL @nxt = 0
	END REPEAT;

	select GROUP_CONCAT(Individual_ID) into @samples_1
	FROM dfw_updated.Final_Pedigree where Seq_Notes not like '%Not sequenced%' and Seq_Notes not like '%Not Sequenced%' and batch=2;
 
	

	# limit the number of samples processed for debug purposes.
	#set @samples = substring_index (@samples, ',', 5);

	REPEAT
	
		# pull the next sample to process.
   		set @sample_1 = SUBSTRING_INDEX(@samples_1, ',', 1);

    	# variants
    	SET @sql_1 = CONCAT('insert into Final_Rare_Variants select `Chr`,`Start`,`End`,`Ref`,`Alt`,`Func_refGene`,`Gene_refGene`,`GeneDetail_refGene`,`ExonicFunc_refGene`,`AAChange_refGene`,`xref_refGene`,`avsnp147`,
	`SIFT_score`,`SIFT_pred`,`Polyphen2_HDIV_score`,`Polyphen2_HDIV_pred`,`Polyphen2_HVAR_score`,`Polyphen2_HVAR_pred`,`LRT_score`,`LRT_pred`,`MutationTaster_score`,`MutationTaster_pred`,
`MutationAssessor_score`,`MutationAssessor_pred`,`FATHMM_score`,`FATHMM_pred`,`PROVEAN_score`,`PROVEAN_pred`,`VEST3_score`,`CADD_raw`,`CADD_phred`,`DANN_score`,`fathmm-MKL_coding_score`,
`fathmm-MKL_coding_pred`,`MetaSVM_score`,`MetaSVM_pred`,`MetaLR_score`,`MetaLR_pred`,`integrated_fitCons_score`,`integrated_confidence_value`,`GERP++_RS`,`phyloP7way_vertebrate`,
`phyloP20way_mammalian`,`phastCons7way_vertebrate`,`phastCons20way_mammalian`,`SiPhy_29way_logOdds`,`dbscSNV_ADA_SCORE`,`dbscSNV_RF_SCORE`,`MCAP`,`REVEL`,`DN ID`,`Patient ID`,`Phenotype`,`Platform`,
`Study`,`Pubmed ID`,`ExAC_ALL`,`ExAC_AFR`,`ExAC_AMR`,`ExAC_EAS`,`ExAC_FIN`,`ExAC_NFE`,`ExAC_OTH`,`ExAC_SAS`,`AF_exome`,`AF_popmax_exome`,`AF_male_exome`,`AF_female_exome`,`AF_raw_exome`,`AF_afr_exome`,
`AF_sas_exome`,`AF_amr_exome`,`AF_eas_exome`,`AF_nfe_exome`,`AF_fin_exome`,`AF_asj_exome`,`AF_oth_exome`,`non_topmed_AF_popmax_exome`,`non_neuro_AF_popmax_exome`,`non_cancer_AF_popmax_exome`,`controls_AF_popmax_exome`,
`AF_genome`,`AF_popmax_genome`,`AF_male_genome`,`AF_female_genome`,`AF_raw_genome`,`AF_afr_genome`,`AF_sas_genome`,`AF_amr_genome`,`AF_eas_genome`,`AF_nfe_genome`,`AF_fin_genome`,`AF_asj_genome`,
`AF_oth_genome`,`non_topmed_AF_popmax_genome`,`non_neuro_AF_popmax_genome`,`non_cancer_AF_popmax_genome`,`controls_AF_popmax_genome`,`GME_AF`,`GME_NWA`,`GME_NEA`,`GME_AP`,`GME_Israel`,
`GME_SD`,`GME_TP`,`GME_CA`,`1000g2015aug_all`,`1000g2015aug_afr`,`1000g2015aug_amr`,`1000g2015aug_eas`,`1000g2015aug_eur`,`1000g2015aug_sas`,`CLNALLELEID`,`CLNDN`,`CLNDISDB`,`CLNREVSTAT`,
`CLNSIG`,`Otherinfo1`,`Otherinfo2`,`Otherinfo3`,`Otherinfo4`,`Otherinfo5`,`Otherinfo6`,`Otherinfo7`,`Otherinfo8`,`Otherinfo9`,`Otherinfo10`,`AF`,`AQ`,`AC`,`AN`,`Otherinfo12`,`GT`,
`DP`,`AD`,`GQ`,`PL`,`RNC`,`sampleID` from ', @sample_1, 
    		' where Otherinfo1 != 0 and Otherinfo3 >= 10 and (GQ <> ''', '.', ''' and GQ >= 15) and greatest(ExAC_ALL, ExAC_AFR, ExAC_AMR, ExAC_EAS, ExAC_FIN, ExAC_NFE, ExAC_OTH, ExAC_SAS, AF_exome, AF_afr_exome, AF_sas_exome,
			AF_amr_exome, AF_eas_exome, AF_nfe_exome, AF_fin_exome, AF_asj_exome, AF_oth_exome, AF_genome, AF_afr_genome, AF_sas_genome,
			AF_amr_genome, AF_eas_genome, AF_nfe_genome, AF_fin_genome, AF_asj_genome, AF_oth_genome, GME_AF, GME_NWA, GME_NEA, GME_AP,
			GME_Israel, GME_SD, GME_TP, GME_CA, 1000g2015aug_all, 1000g2015aug_afr, 1000g2015aug_amr, 1000g2015aug_eas, 1000g2015aug_eur,
			1000g2015aug_sas) < .01');
		PREPARE stmt_1 FROM @sql_1;
    	EXECUTE stmt_1;
		DEALLOCATE PREPARE stmt_1;

		# prepare to pull the next sample.
		set @nxt_1 = locate(',', @samples_1);
    	SET @samples_1= SUBSTRING(@samples_1, @nxt_1 + 1);
    
	UNTIL @nxt_1 = 0
	END REPEAT;
