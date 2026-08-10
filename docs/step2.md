---
layout: default
title: Step 2
parent: CASTIE
nav_order: 2
permalink: /docs/step2/
---

# Step 2: test genetic variants

Step 2 uses the Step 1 null model and variance ratios to test variants in a
specified genomic region.

The tested simulated-data command is available in the **Step 2** tabs on the
[CASTIE home page]({{ '/' | relative_url }}) for both container and Pixi
installations.

Important inputs:

- `--bedFile`, `--bimFile`, and `--famFile`: association-test PLINK files
- `--GMMATmodelFile`: Step 1 `.rda` model
- `--varianceRatioFile`: Step 1 variance-ratio file
- `--rangestoIncludeFile`: chromosome, start, and end interval
- `--SAIGEOutputFile`: output path for variant-level results

Main-effect results use `BETA`, `SE`, and `p.value`. Dynamic interaction
results follow the order of `--dynamicCovarColList` supplied in Step 1.
