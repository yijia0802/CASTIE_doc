---
layout: default
title: Step 3
parent: CASTIE
nav_order: 3
permalink: /docs/step3/
---

# SAIGE-QTL Dynamic Step 3

 Step 3 combines p-values using cauchy combination/ACAT test to obtain gene-level p-values.

## Preprocessing for step 3

1. Run the following script [`001_concatenate.sh`]({{ '/assets/codes/001_concatenate.sh' | relative_url }}) to concatenate all genes' P values from step 2.  

2. Run the following script [`002_split.sh`]({{ '/assets/codes/002_split.sh' | relative_url }}) to split the vectors into separated columns for each interaction term.

3. Run the following script [`003_filter_maf.sh`]({{ '/assets/codes/003_filter_maf.sh' | relative_url }}) to filter to common variants.


## Running step 3

For Step 3, no specific environment is required, so it can be run outside of the container. We provide the R script [`step3_0.2.5.1_cl.R`]({{ '/assets/codes/step3_0.2.5.1_cl.R' | relative_url }}) and example commands in a shell script. After running Step 3, please run qvalue() in R on the main-effect P-values and on each interaction term, then filter by FDR to obtain the eGenes.

## Example script: [`step3_0.2.5.1.sh`]({{ '/assets/codes/step3_0.2.5.1.sh' | relative_url }})
```bash
Rscript step3_0.2.5.1_cl.R \
  --input "/.../filtered_maf_split_file.txt" \
  --outdir "/.../step3_output/"
```
