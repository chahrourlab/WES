	DROP TABLE IF EXISTS S_Comp_Hetero_Filtered;
	CREATE TABLE S_Comp_Hetero_Filtered as SELECT * FROM S_Compound_Heterozygous sch where (AC not like '%,%' and 
												SUBSTRING_INDEX(AD, ',', -1)>=10 and 
												SUBSTRING_INDEX(AD, ',', 1)>=10 and 
												SUBSTRING_INDEX(AD, ',', -1)/DP>=0.3 and 
												SUBSTRING_INDEX(AD, ',', -1)/DP<=0.7 and 
												SUBSTRING_INDEX(sampleID, '_', 2)=SUBSTRING_INDEX(Parent, '_', 2));
	CREATE INDEX S_Comp_Hetero_Filtered_Chr_IDX USING BTREE ON dfw_updated.S_Comp_Hetero_Filtered (Chr,`Start`,`End`);

