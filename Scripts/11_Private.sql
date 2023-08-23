	DROP TABLE IF EXISTS Final_Private_Variants;
	create table Final_Private_Variants as
		(select * from Final_Ultra_Rare_Variants_nonQF where 1=2);
	CREATE INDEX Final_Private_Variants_Chr_IDX USING BTREE ON dfw_updated.Final_Private_Variants (`Chr`,`Start`,`End`);
	insert into Final_Private_Variants
		select * from Final_Ultra_Rare_Variants urv1
			where not EXISTS 
			(select * from Final_Ultra_Rare_Variants_nonQF urv2
			where urv1.`Chr` = urv2.`Chr` and urv1.`Start` = urv2.`Start` and urv1.`End` = urv2.`End` 
			and urv1.`Ref` = urv2.`Ref` and urv1.`Alt` = urv2.`Alt`	and urv1.`sampleID` <> urv2.`sampleID` );	