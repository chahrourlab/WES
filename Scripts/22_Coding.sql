	DROP TABLE IF EXISTS Final_Coding;
	create table Final_Coding as (select * from
	(SELECT "Denovo" as "Inheritance", dv.*, "neither" as "Parent" from dfw_updated.Final_Denovo_Variants dv
	 	where `Func_refGene` in ('exonic', 'ncRNA_exonic','splicing','ncRNA_splicing','exonic;splicing','ncRNA_exonic;splicing')
	union ALL 
	SELECT "Inherited Homozygous", ih.*, "both" from
		dfw_updated.Final_Inherited_Homoz ih where `Func_refGene` in ('exonic', 'ncRNA_exonic','splicing','ncRNA_splicing','exonic;splicing','ncRNA_exonic;splicing')
	union ALL 
	SELECT "X-Linked", xl.*, "mother" from dfw_updated.Final_X_Linked xl
		where `Func_refGene` in ('exonic', 'ncRNA_exonic','splicing','ncRNA_splicing','exonic;splicing','ncRNA_exonic;splicing') 
	union ALL 
	SELECT "Compound Heterozygous", ch1.* from dfw_updated.Final_Compound_Heterozygous_Filtered ch1
		where `Func_refGene` in ('exonic', 'ncRNA_exonic','splicing','ncRNA_splicing','exonic;splicing','ncRNA_exonic;splicing') and exists (select * from dfw_updated.Final_Compound_Heterozygous_Filtered ch2 
			where ch2.`Func_refGene` in ('exonic', 'ncRNA_exonic','splicing','ncRNA_splicing','exonic;splicing','ncRNA_exonic;splicing') and ch1.sampleID = ch2.sampleID and ch1.`Gene_refGene` = ch2.`Gene_refGene` and ch1.Parent <> ch2.Parent)) tble );
	CREATE INDEX Final_Coding_Chr_IDX USING BTREE ON dfw_updated.Final_Coding (Chr,`Start`,`End`);