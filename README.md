# WES
Whole exome sequencing variant analysis pipeline used to analyze the data pblished in the following manuscript- 
Gogate A, Kaur K, Goodspeed K, Evans P, Morris MA, Chahrour MH. The genetic landscape of autism spectrum disorder in an ancestrally diverse cohort. npj Genomic Medicine (2024) (Accepted- In press)



##
This process begins with fully processed sample variant files stored in an SQL database that can be parsed and analyzed.  All SQL scripts contain code to create a SQL procedure with the code in the script.  Having the procedures in the database helps with documentation and creates easy repeatability. Please contact us for the raw files. 

### Pipeline
1. **Load the sample data** into a SQL database.
2. Create a **summary table** for the original data (Script 1- 1_Summary_Totals.sql).
3. **Quality-filter** the data and create a summary table (Script 2).
4. Identify both quality-filtered and non-quality-filtered **rare variants** for every sample and create  corresponding summary tables (Script 3-6). Typically the frequencies of rare variants should be < 0.01.
5. Identify both quality-filtered and non-quality-filtered **ultra rare variants** for every sample and create corresponding summary tables (Script 7-10).  Ultra rare variants are those where all frequencies are zero.
6. Identify **private variants** for every sample and create a summary table (Script 11-12). Private variants in a sample are those variants that do not exist in any other sample and do not exist in the nonQF table.
7. Identify **denovo variants** for all offspring and create a summary table (Script 13-14). All offspring typically includes probands, twin probands, and siblings, sibling twins, and half-siblings. Verify the terminology used in the cohort and update the query appropriately. Numbers are pulled from the private variants table. Criteria for denovo will vary by cohort based on what information is available.
8. Identify **X-Linked variants** and create a summary table (Script 15-16).  These variants are pulled from Rare variants of affected males, where the variant is ChrX and homozygous in the child, ChrX and heterozygous in the mother, and does not exist in the father as either homozygous or heterozygous. Furthermore, the variant cannot exist in an unaffected sister in homozygous form, and it cannot exist in an unaffected brother in either homozygous or heterozygous form.  
9. Identify **Inherited Homozygous variants** and create a summary table (Script 17-18). These variants are pulled from rare variants, where the variant is homozygous in the child and heterozygous in all parent samples available. Furthermore, the variant cannot exist in any unaffected sibling in homozygous form.
10. Identify **Compound Heterozygous variants** and create a summary table (Script 19-21).  These variants are pulled from Rare variants of affected children where we have samples for both parents. Coding variants with genes that occur more than once are pulled for each affected child. At least one of these variants must come from the mother AND another variant (different) must come from the father (both heterozygous). Furthermore, the variant set (one from the mother and one from the father) must not exist in any unaffected sibling.
11. Identify **Coding variants** (Script 22).  These variants are pulled from the following tables: Denovo, Inherited Homozygous, X Linked, and Compound Heterozygous. Coding variants are those that are “exonic” or “splicing”.
12. Identify variants that are **Possibly Pathogenic** (Script 23). The following variants are defined as “possibly pathogenic”: (1) splice site variants, (2) exonic variants with a predicted protein effect of “frameshift insertion”, “frameshift deletion”, “nonframeshift insertion”, “nonframeshift deletion”, “stopgain”, “stoploss”, or “unknown”, (3) exonic “nonsynonymous SNV” variants that were predicted to be damaging by at least 1 of the 9 algorithms  used: SIFT, PolyPhen-2 HumVar, LRT, MutationTaster, MutationAssessor, FATHMM, PROVEAN, MetaSVM, and MetaLR.
13. Create a table for **Burden analysis** (Script 24) to determine whether there is an excess of potentially pathogenic variants in affected versus unaffected individuals. 
