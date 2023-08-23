	DROP TABLE IF EXISTS dfw_updated.Final_Inherited_Homoz;
	create table dfw_updated.Final_Inherited_Homoz as (select * from dfw_updated.Final_Rare_Variants where 1=2);
	CREATE INDEX Final_Inherited_Homoz_Chr_IDX USING BTREE ON dfw_updated.Final_Inherited_Homoz (Chr,`Start`,`End`);
	INSERT INTO dfw_updated.Final_Inherited_Homoz   
	WITH 
		Children AS (SELECT Individual_ID, Mother_ID, Father_ID 
			FROM dfw_updated.Final_Pedigree dp 
			WHERE Father_ID <> '0' or Mother_ID <> '0'),
		Unaffected_Siblings AS (SELECT Individual_ID, Mother_ID
			FROM dfw_updated.Final_Pedigree dp2 
			WHERE Affection=1 AND Family_member in ('Sibling', 'Sibling (twin)', 'Sibling (half)')),
		Child_Homoz AS (SELECT rare.* 
			FROM dfw_updated.Final_Rare_Variants rare left join Children ch on (rare.sampleID=ch.Individual_ID) 
			WHERE rare.Otherinfo1=1),
		Child_Parent_Hetero AS (SELECT chomoz.* 
			FROM Child_Homoz chomoz left join Children ch on (chomoz.sampleID=ch.Individual_ID) 
			WHERE (ch.Mother_ID = '0' or 
				EXISTS (select * from dfw_updated.Final_Rare_Variants srv WHERE srv.sampleID=ch.Mother_ID
				and chomoz.Chr=srv.Chr and chomoz.`Start`=srv.`Start` and chomoz.`End`=srv.`End` and chomoz.`Ref`=srv.`Ref`
				and chomoz.`Alt`=srv.`Alt` and srv.Otherinfo1=0.5)) AND 
			   (ch.Father_ID = '0' or 
				EXISTS (select * from dfw_updated.Final_Rare_Variants srv1 WHERE srv1.sampleID=ch.Father_ID
				and chomoz.Chr=srv1.Chr and chomoz.`Start`=srv1.`Start` and chomoz.`End`=srv1.`End` and chomoz.`Ref`=srv1.`Ref`
				and chomoz.`Alt`=srv1.`Alt`and srv1.Otherinfo1=0.5))),
		Child_Sibling AS (SELECT cph.* FROM Child_Parent_Hetero cph left join Children ch on (cph.sampleID=ch.Individual_ID)		
			WHERE NOT EXISTS (SELECT * from dfw_updated.Final_Rare_Variants srv2 left join Unaffected_Siblings uas on (srv2.sampleID=uas.Individual_ID) 
						WHERE ch.Mother_ID = uas.Mother_ID and cph.Chr=srv2.Chr and cph.`Start`=srv2.`Start` and cph.`End`=srv2.`End` 
						and cph.`Ref`=srv2.`Ref` and cph.`Alt`=srv2.`Alt` and srv2.Otherinfo1=1))
	SELECT * from Child_Sibling;