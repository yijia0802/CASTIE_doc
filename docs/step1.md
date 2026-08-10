---
layout: default
title: Step 1
parent: CASTIE
nav_order: 1
permalink: /docs/step1/
---

# Step 1: fit the null model

Step 1 fits the null Poisson mixed model for each gene across cells. The null
hypothesis contains neither a genetic main effect nor a genotype-by-context
interaction effect.

The tested simulated-data command is available in the **Step 1** tabs on the
[CASTIE home page]({{ '/' | relative_url }}) for both container and Pixi
installations.

Important inputs:

- `--phenoFile`: cell-level phenotype and covariate table
- `--phenoCol`: gene or phenotype being modeled
- `--sampleCovarColList`: donor-level covariates
- `--dynamicCovarColList`: cell-level contexts used to construct `eMat`
- `--plinkFile`: LD-pruned PLINK prefix used for the GRM and variance ratios
- `--outputPrefix`: prefix for the model and variance-ratio outputs

The tutorial uses `X1,X2` as donor-level covariates and `pf1,pf2` as dynamic
cell-level covariates.
