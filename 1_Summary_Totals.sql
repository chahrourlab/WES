	DROP TABLE IF EXISTS Final_Summary_Totals;
	CREATE TABLE Final_Summary_Totals (
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
	# Note:  this statement will be differnt depending on how your data is organized.
	select GROUP_CONCAT(Individual_ID) into @samples FROM dfw_updated.Final_Pedigree where Seq_Notes not like '%Not sequenced%' and Seq_Notes not like '%Not Sequenced%';

	# limit the number of samples processed for debug purposes.  This should be commented out for final run.
	#set @samples = substring_index (@samples, ',', 2);

	REPEAT
	
		# pull the next sample to process.
   		set @sample = SUBSTRING_INDEX(@samples, ',', 1);

    	# variants
    	SET @sql = CONCAT('select count(*) into @variants from (select distinct Chr, Start, End, Ref from ', @sample, ' where Otherinfo1 != 0) tbl;');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		# hets
		SET @sql = CONCAT('select count(*) into @hets from (select distinct Chr, Start, End, Ref from ', @sample, ' where Otherinfo1 = 0.5) tbl;');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		# homoz 
		SET @sql = CONCAT('select count(*) into @homoz from (select distinct Chr, Start, End, Ref from ', @sample, ' where Otherinfo1 = 1) tbl;');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		# SNVs 
		SET @sql = CONCAT('select count(*) into @snv from (select distinct Chr, Start, End, Ref from ', @sample, ' where Otherinfo1 != 0 and (length(Ref) = 1 and Ref <> ''','-', ''') and (length(Alt) = 1 and Alt <> ''','-',''')) tbl;');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;

		# Indels
		SET @sql = CONCAT('select count(*) into @indel from (select distinct Chr, Start, End, Ref from ', @sample, ' where Otherinfo1 != 0 and ((Alt = ''', '-', ''' and Ref <> ''', '-', ''') or (Ref = ''', '-', ''' and Alt <> ''', '-', '''))) tbl;');
    	PREPARE stmt FROM @sql;
		EXECUTE stmt;
		DEALLOCATE PREPARE stmt;
	
		set @indel = @indel - ((@snv + @indel)-@variants);

		# insert values for this sample.
		INSERT INTO Final_Summary_Totals VALUES (@sample, @variants, @hets, @homoz, @snv, @indel);
	
		# prepare to pull the next sample.
		set @nxt = locate(',', @samples);
    	SET @samples= SUBSTRING(@samples, @nxt + 1);
    
	UNTIL @nxt = 0
	END REPEAT;