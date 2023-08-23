	DROP TABLE IF EXISTS Final_Summary_Totals_QF;
	CREATE TABLE Final_Summary_Totals_QF (
		sampleID varchar (25) DEFAULT NULL,
		Variants int DEFAULT NULL,
		Heterozygous int DEFAULT NULL,
		Homozygous int DEFAULT NULL,
		SNVs int DEFAULT NULL,
		Indels int DEFAULT NULL,
		PRIMARY KEY (sampleID));
	
	# must set this system variable so that GROUP_CONCAT() will hold > 1000 chars) 
	SET SESSION group_concat_max_len = 1000000;

	# get all the samples to process.  Individual ID must match the table name containing the data.
	select GROUP_CONCAT(Individual_ID) into @samples
	FROM dfw_updated.Final_Pedigree where Seq_Notes not like '%Not sequenced%' and Seq_Notes not like '%Not Sequenced%' and batch=1; 
	 

	# limit the number of samples processed for debug purposes.
	#set @samples = substring_index (@samples, ',', 2);
	REPEAT
	
		# pull the next sample to process.
   		set @sample = SUBSTRING_INDEX(@samples, ',', 1);

    	# variants
    	SET @sql = CONCAT('select count(*) into @variants from ', @sample, ' where (Otherinfo3 >= 10 and GQ >=30 and Otherinfo1 != 0);');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		# hets
		SET @sql = CONCAT('select count(*) into @hets from ', @sample, ' where (Otherinfo3 >= 10 and GQ >=30 and Otherinfo1 = 0.5);');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		# homoz 
		SET @sql = CONCAT('select count(*) into @homoz from ', @sample, ' where (Otherinfo3 >= 10 and GQ>=30 and Otherinfo1 = 1);');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		# SNVs 
		SET @sql = CONCAT('select count(*) into @snv from ', @sample, ' where (Otherinfo3 >= 10 and GQ>=30 and Otherinfo1 != 0 and (length(Ref) = 1 and Ref <> ''', '-', ''') and (length(Alt) = 1 and Alt <> ''', '-', '''));');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		# Indels
		SET @sql = CONCAT('select count(*) into @indel from ', @sample, ' where (Otherinfo3 >= 10 and GQ>=30 and Otherinfo1 != 0 and ((Alt = ''', '-',''' and Ref <> ''','-', ''') or (Ref = ''','-',''' and Alt <> ''', '-', ''')));');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		# SNVs+Indels > Variants because some variants were being counted as both an SNV and Indel.
		# Adjust Indels so that the common variants count as SNV.
		set @indel = @indel - ((@snv + @indel)-@variants);

		# insert values for this sample.
		INSERT INTO Final_Summary_Totals_QF VALUES (@sample, @variants, @hets, @homoz, @snv, @indel);
	
		# prepare to pull the next sample.
		set @nxt = locate(',', @samples);
    	SET @samples= SUBSTRING(@samples, @nxt + 1);
    
	UNTIL @nxt = 0
	END REPEAT;

	select GROUP_CONCAT(Individual_ID) into @samples_1
	FROM dfw_updated.Final_Pedigree where Seq_Notes not like '%Not sequenced%' and Seq_Notes not like '%Not Sequenced%' and batch=2; 
	 

	# limit the number of samples processed for debug purposes.
	#set @samples = substring_index (@samples, ',', 2);
	REPEAT
	
		# pull the next sample to process.
   		set @sample_1 = SUBSTRING_INDEX(@samples_1, ',', 1);

    	# variants
    	SET @sql = CONCAT('select count(*) into @variants from ', @sample_1, ' where (Otherinfo3 >= 10 and GQ >=15 and Otherinfo1 != 0);');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		# hets
		SET @sql = CONCAT('select count(*) into @hets from ', @sample_1, ' where (Otherinfo3 >= 10 and GQ >=15 and Otherinfo1 = 0.5);');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		# homoz 
		SET @sql = CONCAT('select count(*) into @homoz from ', @sample_1, ' where (Otherinfo3 >= 10 and GQ>=15 and Otherinfo1 = 1);');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		# SNVs 
		SET @sql = CONCAT('select count(*) into @snv from ', @sample_1, ' where (Otherinfo3 >= 10 and GQ>=15 and Otherinfo1 != 0 and (length(Ref) = 1 and Ref <> ''', '-', ''') and (length(Alt) = 1 and Alt <> ''', '-', '''));');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		# Indels
		SET @sql = CONCAT('select count(*) into @indel from ', @sample_1, ' where (Otherinfo3 >= 10 and GQ>=15 and Otherinfo1 != 0 and ((Alt = ''', '-',''' and Ref <> ''','-', ''') or (Ref = ''','-',''' and Alt <> ''', '-', ''')));');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		# SNVs+Indels > Variants because some variants were being counted as both an SNV and Indel.
		# Adjust Indels so that the common variants count as SNV.
		set @indel = @indel - ((@snv + @indel)-@variants);

		# insert values for this sample.
		INSERT INTO Final_Summary_Totals_QF VALUES (@sample_1, @variants, @hets, @homoz, @snv, @indel);
	
		# prepare to pull the next sample.
		set @nxt = locate(',', @samples_1);
    	SET @samples_1= SUBSTRING(@samples_1, @nxt + 1);
    
	UNTIL @nxt = 0
	END REPEAT;
