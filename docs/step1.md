---
layout: default
title: Step 1
parent: CASTIE
nav_order: 1
permalink: /docs/step1/
---

# SAIGE-QTL Dynamic Step 1

Step 1 fits the null Poisson mixed model for each gene across cells.

H0: βG = 0; βGxC = 0

## Example script: [`step1_0.2.5.1.sh`]({{ '/assets/codes/step1_0.2.5.1.sh' | relative_url }})

```bash
genename=$1
cellType=$2
traitType=count
windowsize=1000000

phenofile=/.../b_all_celltype_cellcycle_pseudotime_mofa500_readcounts_0422.tsv
geneLocationFile=/.../GeneLocations.tsv

i=$(awk -v gene=$genename '$1 == gene {print $3}' $geneLocationFile)
echo "$i"

step1output=/.../step1_output/
step1prefix=${step1output}${genename}_${cellType}_${traitType}_0.2.5.1

step1_fitNULLGLMM_qtl.R \
    --useSparseGRMtoFitNULL=FALSE \
    --useGRMtoFitNULL=FALSE \
    --phenoFile=${phenofile} \
    --phenoCol=${genename} \
    --sampleCovarColList=age,sex,pc1,pc2,pc3,pc4,pc5,pc6 \
    --sampleIDColinphenoFile=individual \
    --traitType=${traitType} \
    --outputPrefix=${step1prefix} \
    --skipVarianceRatioEstimation=FALSE \
    --isRemoveZerosinPheno=FALSE \
    --isCovariateOffset=FALSE \
    --isCovariateTransform=TRUE \
    --skipModelFitting=FALSE \
    --tol=0.00001 \
    --plinkFile=/.../OneK1K_AllChr_pruned_10k_randomMarkers_forVR_fullsamples \
    --IsOverwriteVarianceRatioFile=TRUE	\
    --maxiterPCG=10000 \
    --isStoreSigma=TRUE \
    --tauInit=1,0.1,0 \
    --maxiter=10000	\
    --nThreads=8 \
    --covarColList=age,sex,pc1,pc2,pc3,pc4,pc5,pc6,pf1,pf2,pseudotime,S.Score,G2M.Score \
    --dynamicCovarColList=age,sex,pseudotime,S.Score,G2M.Score \
    --offsetCol=log_cell_read_counts
```

- `--dynamicCovarColList` specifies dynamic (cell-level) covariates to include in the model.
- `--offsetCol` specifies offset covariates, for example the log of total read counts at the cell level.
- We recommend LD-pruning and randomly selecting ~3,000 SNPs for the genotype file in step 1 for computational efficiency.


## Example phenotype file

| Barcode  | Individual | Gene1 | Gene2 | ... | GeneX | Age | Sex | PC1   | PC2   | Cell_covariate_1 | Cell_covariate_2 | Log(total_read_counts) |
|----------|------------|-------|-------|-----|-------|-----|-----|-------|-------|------------------|------------------|------------------------|
| AAACGTTT | Ind1       |  12   |  45   | ... |   3   | 34  |  1  |  0.01 | -0.03 | 0.5              | 1                | 14.2                   |
| AAACGTTG | Ind1       |   3   |  18   | ... |   0   | 34  |  1  |  0.01 | -0.03 | 0.7              | 0                | 13.7                   |
| AAACGTTA | Ind2       |  27   |   9   | ... |   4   | 51  |  0  | -0.02 |  0.06 | 0.3              | 1                | 15.0                   |
| AAACGTTT | Ind2       |   8   |  22   | ... |   64  | 51  |  0  | -0.02 |  0.06 | 0.6              | 0                | 14.5                   |
| AAACGTTG | Ind2       |   0   |  11   | ... |   40  | 51  |  0  | -0.02 |  0.06 | 0.4              | 1                | 13.9                   |
| AAACGTTA | Ind3       |  19   |  33   | ... |   89  | 29  |  1  |  0.05 | -0.01 | 0.2              | 0                | 14.8                   |


## Example gene location file

| gene_name   | gene_id         | seqid | start  | end    | strand |
|-------------|-----------------|-------|--------|--------|--------|
| AL627309.1  | ENSG00000237683 | 1     | 134901 | 139379 | -      |
| AL669831.1  | ENSG00000269831 | 1     | 738532 | 739137 | -      |
| AL645608.2  | ENSG00000269308 | 1     | 818043 | 819983 | +      |
| AL645608.1  | ENSG00000268179 | 1     | 861264 | 866445 | -      |
| AL590822.1  | ENSG00000240361 | 1     | 892941 | 901095 | +      |
| AL354822.1  | ENSG00000233750 | 1     | 925941 | 933567 | -      |

## Command to run one gene
```bash
bash step1_0.2.5.1.sh AL627309.1 B_cell
```
