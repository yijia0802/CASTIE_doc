---
layout: default
title: Step 3 + 4
parent: CASTIE
nav_order: 3
permalink: /docs/step3/
---

# Steps 3 and 4: gene-level analysis

Step 3 combines variant-level p-values with ACAT to obtain gene-level
p-values. Step 4 calculates q-values separately within each p-value context
and calls eGenes at the requested FDR.

The tested commands are available together in the **Step 3 + 4** tabs on the
[CASTIE home page]({{ '/' | relative_url }}) for both container and Pixi
installations.

For a real multi-gene dynamic analysis, use `step3_0.2.5.7.R` to create
`step3_longformat.txt`, then run:

```bash
step4_get_egenes.R \
  --input=/path/to/step3_longformat.txt \
  --outdir=/path/to/step4 \
  --fdr=0.05
```

Step 4 expects `Gene`, `pval_column`, and `ACAT_p`. It writes per-context eGene
tables and gene lists, plus context-union, context-only, and shared-context
summaries.
