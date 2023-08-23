	DROP TABLE IF EXISTS dfw_updated.S_Compound_Heterozygous;
	create table  dfw_updated.S_Compound_Heterozygous as
		(select pv.* from  dfw_updated.S_Rare_Variants pv where 1=2);
	ALTER TABLE  dfw_updated.S_Compound_Heterozygous ADD Parent varchar(25);
	CREATE INDEX S_Compound_Heterozygous_Chr_IDX USING BTREE ON dfw_updated.S_Compound_Heterozygous (Chr,`Start`,`End`);

	INSERT INTO  dfw_updated.S_Compound_Heterozygous
	WITH 
		Children AS (SELECT Individual_ID, Mother_ID, Father_ID 
			FROM  dfw_updated.DFW_pedigree dp 
			WHERE Affection = 2 AND Mother_ID <> '0' AND Father_ID <> '0'),
		Unaffected_Siblings AS (SELECT Individual_ID, Mother_ID, Father_ID
			FROM  dfw_updated.DFW_pedigree dp2 
			WHERE Affection=1 AND Family_member in ('Sibling', 'Sibling (twin)', 'Sibling (half)')),
		Multiples AS (SELECT sample, gene FROM (SELECT sampleID as sample, `Gene_refGene` as gene, count(*) as c
			FROM  dfw_updated.S_Rare_Variants rare_var 
			GROUP BY sampleID, `Gene_refGene`
			HAVING c > 1 ) genes),
		Child_Hetero AS (SELECT rare.*
			FROM  dfw_updated.S_Rare_Variants rare left join Children ch on (rare.sampleID=ch.Individual_ID) 
			WHERE rare.`Func_refGene` in ('exonic', 'ncRNA_exonic', 'splicing','ncRNA_splicing','ncRNA_exonic;splicing','exonic;splicing') and rare.Otherinfo1=0.5
				and rare.`Gene_refGene` in (select gene from Multiples m where m.sample=ch.Individual_ID)),
		Child_Genes AS (select distinct `Gene_refGene` from Child_Hetero),
		Both_Parents AS (select * from dfw_updated.S_Rare_Variants srv right join Children ch on (srv.sampleID=ch.Mother_ID)  
			WHERE srv.`Gene_refGene` in (select * from Child_Genes) and srv.Otherinfo1=.5
			UNION ALL
			select * from dfw_updated.S_Rare_Variants srv1 right join Children ch on (srv1.sampleID=ch.Father_ID)  
			WHERE srv1.`Gene_refGene` in (select * from Child_Genes) and srv1.Otherinfo1=.5),
		Distinct_Genes AS (select * from Both_Parents bp1 
						where EXISTS (SELECT `Gene_refGene`, Chr, Start, End, Ref, Alt 
								FROM Both_Parents bp2
								WHERE bp1.`Gene_refGene`=bp2.`Gene_refGene` and (bp1.Chr <> bp2.Chr OR bp1.`Start` <> bp2.`Start` OR 
								bp1.`End` <> bp2.`End` OR bp1.`Ref` <> bp2.`Ref` OR bp1.`Alt` <> bp2.`Alt`))),
		Sibling_Hetero AS (select * from dfw_updated.S_Rare_Variants srv2 left join Unaffected_Siblings uas on (srv2.sampleID=uas.Individual_ID)
			WHERE srv2.`Func_refGene` in ('exonic', 'ncRNA_exonic', 'splicing','ncRNA_splicing','ncRNA_exonic;splicing','exonic;splicing') and srv2.Otherinfo1=0.5
				and srv2.`Gene_refGene` in (select gene from Multiples m where m.sample=uas.Individual_ID)),
		Distinct_not_Sibling AS (select dg1.* from Distinct_Genes dg1 
			WHERE NOT EXISTS (SELECT * from Sibling_Hetero shet where dg1.Chr=shet.Chr 
			and dg1.`Start`=shet.`Start` and dg1.`End`=shet.`End` and dg1.`Ref`=shet.`Ref` and dg1.`Alt`=shet.`Alt`))
	SELECT chet.*, dns.sampleID as Parent FROM Child_Hetero chet right join Distinct_not_Sibling dns 
		on (chet.`Gene_refGene`=dns.`Gene_refGene` and chet.Chr=dns.Chr and chet.`Start`=dns.`Start` and 
		chet.`End`=dns.`End` and chet.`Ref`=dns.`Ref` and chet.`Alt`=dns.`Alt`) 
		WHERE chet.Chr IS NOT NULL;