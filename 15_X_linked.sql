	DROP TABLE IF EXISTS dfw_updated.Final_X_Linked;
	CREATE TABLE dfw_updated.Final_X_Linked as
		(select * from dfw_updated.Final_Rare_Variants where 1=2);
	CREATE INDEX Final_X_Linked_Chr_IDX USING BTREE ON dfw_updated.Final_X_Linked (Chr,`Start`,`End`);

	INSERT INTO dfw_updated.Final_X_Linked WITH 
		Children AS (SELECT Individual_ID, Mother_ID, Father_ID 
			FROM dfw_updated.Final_Pedigree dp 
			WHERE Sex=1 AND Affection=2 AND Mother_ID <> '0'),
			
		Unaffected_Siblings AS (SELECT Individual_ID, Sex, Mother_ID, Father_ID
			FROM dfw_updated.Final_Pedigree dp2 
			WHERE Affection=1 AND Family_member in ('Sibling', 'Sibling (twin)', 'Sibling (half)')),
		
		Child_Homoz AS (SELECT rare.*
			FROM dfw_updated.Final_Rare_Variants rare left join Children ch on (rare.sampleID=ch.Individual_ID) 
			WHERE rare.Chr='X' and rare.Otherinfo1=1),
			
		Child_Mother_Hetero AS (SELECT chomoz.* 
			FROM Child_Homoz chomoz left join Children ch on (chomoz.sampleID=ch.Individual_ID) 
			WHERE EXISTS (select * from dfw_updated.Final_Rare_Variants srv WHERE srv.sampleID=ch.Mother_ID
				and chomoz.Chr=srv.Chr and chomoz.`Start`=srv.`Start` and chomoz.`End`=srv.`End` and chomoz.`Ref`=srv.`Ref`
				and chomoz.`Alt`=srv.`Alt` and srv.Otherinfo1=0.5) AND
			   (ch.Father_ID='0' or NOT EXISTS (select * from dfw_updated.Final_Rare_Variants srv1 WHERE srv1.sampleID=ch.Father_ID
				and chomoz.Chr=srv1.Chr and chomoz.`Start`=srv1.`Start` and chomoz.`End`=srv1.`End` and chomoz.`Ref`=srv1.`Ref`
				and chomoz.`Alt`=srv1.`Alt`))),
		
		Sibling_Check AS (SELECT cmh.* 
			FROM Child_Mother_Hetero cmh left join Children ch1 on (cmh.sampleID=ch1.Individual_ID) 
			WHERE NOT EXISTS (SELECT * from dfw_updated.Final_Rare_Variants srv2 left join Unaffected_Siblings uas on (srv2.sampleID=uas.Individual_ID)
						WHERE uas.Mother_ID=ch1.Mother_ID and uas.Sex=2 and cmh.Chr=srv2.Chr and cmh.`Start`=srv2.`Start` 
						and cmh.`End`=srv2.`End` and cmh.`Ref`=srv2.`Ref` and cmh.`Alt`=srv2.`Alt` and srv2.Otherinfo1=1) AND 
			   	  NOT EXISTS (SELECT * from dfw_updated.Final_Rare_Variants srv3 left join Unaffected_Siblings uas1 on (srv3.sampleID=uas1.Individual_ID)
						WHERE uas1.Mother_ID=ch1.Mother_ID and uas1.Sex=1 and cmh.Chr=srv3.Chr and cmh.`Start`=srv3.`Start` 
						and cmh.`End`=srv3.`End` and cmh.`Ref`=srv3.`Ref` and cmh.`Alt`=srv3.`Alt`))
	
	SELECT * FROM Sibling_Check;