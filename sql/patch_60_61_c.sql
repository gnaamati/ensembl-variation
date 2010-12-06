# make allele fields char(1) instead of varchar(255)
ALTER TABLE `tmp_individual_genotype_single_bp` CHANGE `allele_1` `allele_1` char(1) NULL DEFAULT NULL;
ALTER TABLE `tmp_individual_genotype_single_bp` CHANGE `allele_2` `allele_2` char(1) NULL DEFAULT NULL;


# patch identifier
INSERT INTO meta (species_id, meta_key, meta_value) VALUES (NULL,'patch', 'patch_60_61_c.sql|change allele columns in tmp_individual_genotype_single_bp to char(1)');
