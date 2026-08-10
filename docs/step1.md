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

## Example phenotype file

| Barcode  | Individual | Gene1 | Gene2 | ... | GeneX | Age | Sex | PC1   | PC2   | Cell_covariate_1 | Cell_covariate_2 | Log(total_read_counts) |
|----------|------------|-------|-------|-----|-------|-----|-----|-------|-------|------------------|------------------|------------------------|
| AAACGTTT | Ind1       |  12   |  45   | ... |   3   | 34  |  1  |  0.01 | -0.03 | 0.5              | 1                | 14.2                   |
| AAACGTTG | Ind1       |   3   |  18   | ... |   0   | 34  |  1  |  0.01 | -0.03 | 0.7              | 0                | 13.7                   |
| AAACGTTA | Ind2       |  27   |   9   | ... |   4   | 51  |  0  | -0.02 |  0.06 | 0.3              | 1                | 15.0                   |
| AAACGTTT | Ind2       |   8   |  22   | ... |  64   | 51  |  0  | -0.02 |  0.06 | 0.6              | 0                | 14.5                   |
| AAACGTTG | Ind2       |   0   |  11   | ... |  40   | 51  |  0  | -0.02 |  0.06 | 0.4              | 1                | 13.9                   |
| AAACGTTA | Ind3       |  19   |  33   | ... |  89   | 29  |  1  |  0.05 | -0.01 | 0.2              | 0                | 14.8                   |

The phenotype file contains one row per cell. Donor-level values repeat for
cells belonging to the same individual, while cell-level context values can
vary between cells.

## Example gene location file

| gene_name   | gene_id         | seqid | start  | end    | strand |
|-------------|-----------------|-------|--------|--------|--------|
| AL627309.1  | ENSG00000237683 | 1     | 134901 | 139379 | -      |
| AL669831.1  | ENSG00000269831 | 1     | 738532 | 739137 | -      |
| AL645608.2  | ENSG00000269308 | 1     | 818043 | 819983 | +      |
| AL645608.1  | ENSG00000268179 | 1     | 861264 | 866445 | -      |
| AL590822.1  | ENSG00000240361 | 1     | 892941 | 901095 | +      |
| AL354822.1  | ENSG00000233750 | 1     | 925941 | 933567 | -      |

The chromosome, start, and end columns can be used to construct the cis-region
file supplied to Step 2.
