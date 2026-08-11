---
layout: default
title: Step 3 + 4
parent: CASTIE
nav_order: 3
permalink: /docs/step3/
---

# Steps 3 and 4: gene-level analysis

The Polars concatenation command first combines the per-gene Step 2 files,
splits `pval_ge` into named dynamic-covariate columns, and applies the MAF
filter. Step 3 then combines variant-level p-values with ACAT to obtain
gene-level p-values. Step 4 calculates q-values separately within each
p-value context and calls eGenes at the requested FDR.

The tested commands are available together in the **Step 3 + 4** tabs on the
[CASTIE home page]({{ '/' | relative_url }}) for both container and Pixi
installations.

For a real multi-gene dynamic analysis, use `step3_gene_pvalue.R` to create
`step3_longformat.txt`, then run:

```bash
concat_step2_results.py \
  --input-dir=/path/to/step2 \
  --output=/path/to/step3_input.txt \
  --contexts=age,sex,pf1,pf2 \
  --file-pattern='*.txt' \
  --gene-regex='^(?P<gene>.+)_count_cis_window_1000000_0[.]2[.]5[.]7[.]txt$' \
  --maf-min=0.05 \
  --maf-max=0.95

step3_gene_pvalue.R \
  --input=/path/to/step3_input.txt \
  --outdir=/path/to/step3

step4_get_egenes.R \
  --input=/path/to/step3/step3_longformat.txt \
  --outdir=/path/to/step4 \
  --fdr=0.05
```

Both tab-delimited text and Parquet Step 2 outputs are supported and detected
automatically. Select them with `--file-pattern='*.txt'` or
`--file-pattern='*.parquet'`, respectively, and use the same extension in
`--gene-regex`. You can override detection with `--input-format=txt` or
`--input-format=parquet`.

Step 4 expects `Gene`, `pval_column`, and `ACAT_p`. It writes per-context eGene
tables and gene lists, plus context-union, context-only, and shared-context
summaries.
