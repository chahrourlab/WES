	DROP TABLE IF EXISTS Final_Denovo_Variants;
	create table Final_Denovo_Variants as (select * from Final_Private_Variants spv where 1=2);
	CREATE INDEX Final_Denovo_Variants_Chr_IDX USING BTREE ON dfw_updated.Final_Denovo_Variants (Chr,`Start`,`End`);
	insert into Final_Denovo_Variants 
		select * from Final_Private_Variants pv
		WHERE exists (select * from dfw_updated.Final_Pedigree mc
					where Family_member in ('Proband', 'Proband (twin)', 'Sibling', 'Sibling (twin)', 'Sibling (half)') 
					and batch=1 and pv.sampleID = mc.Individual_ID) AND 
	 				GT like '0%' AND 
	 				GQ >=99 AND
					length(Ref) <= 50 AND 
	 				length(Alt) <= 50 and 
	 				(AC like '%,%' OR 
	 					(AQ>=999
	 					and SUBSTRING_INDEX(AD, ',', -1) >= 10
						and SUBSTRING_INDEX(AD, ',', 1) >= 10
						and SUBSTRING_INDEX(AD, ',', -1)/DP >= 0.3
						and SUBSTRING_INDEX(AD, ',', -1)/DP <= 0.7));
	insert into Final_Denovo_Variants 
		select * from Final_Private_Variants pv
		WHERE exists (select * from dfw_updated.Final_Pedigree mc
					where Family_member in ('Proband', 'Proband (twin)', 'Sibling', 'Sibling (twin)', 'Sibling (half)') 
					and batch=2 and pv.sampleID = mc.Individual_ID) AND 
	 				GT like '0%' AND 
	 				GQ >=20 AND
					length(Ref) <= 50 AND 
	 				length(Alt) <= 50 and 
	 				(AC like '%,%' OR 
	 					(AQ>=30
	 					and SUBSTRING_INDEX(AD, ',', -1) >= 10
						and SUBSTRING_INDEX(AD, ',', 1) >= 10
						and SUBSTRING_INDEX(AD, ',', -1)/DP >= 0.3
						and SUBSTRING_INDEX(AD, ',', -1)/DP <= 0.7));
	