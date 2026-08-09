---
layout: default
title: Step 2
parent: CASTIE
nav_order: 2
permalink: /docs/step2/
---

# SAIGE-QTL Dynamic Step 2

Step 2 performs association test for each genetic marker (apply SKAT test for combining all interaction effects).

## Example script: [`step2_0.2.5.1.sh`]({{ '/assets/codes/step2_0.2.5.1.sh' | relative_url }})

```bash
genename=$1
cellType=$2
traitType=count
windowsize=1000000

geneLocationFile=/.../GeneLocations.tsv
outpath=/.../step2_output/
i=$(awk -v gene=$genename '$1 == gene {print $3}' $geneLocationFile)

echo "$i"

groupFile=${outpath}Gene_${genename}_${windowsize}.grp
regionFilewithname=${outpath}Gene_${genename}_${windowsize}.region
regionFile=${outpath}Gene_${genename}_${windowsize}.region.noname

awk -v gene="$genename" -v windowsize="$windowsize" '
$1 == gene {print $3, $4 - windowsize, $5 + windowsize}
' $geneLocationFile > ${regionFilewithname}
awk '{print $1, $2, $3}' ${regionFilewithname} > ${regionFile} 

step1output=/.../step1_output/
step1prefix=${step1output}${genename}_${cellType}_${traitType}_0.2.5.1
step2output=/.../step2_output/
step2prefix=${step2output}${genename}_${cellType}_${traitType}_saigeqtl_cis_window_${windowsize}.singleVar.txt_ge_SAIGEQTL_0.2.5.1

step2_tests_qtl.R \
    --bedFile=/.../full_genome_chr${i}.bed \
    --bimFile=/.../full_genome_chr${i}.bim \
    --famFile=/.../full_genome_chr${i}.fam \
    --SAIGEOutputFile=${step2prefix} \
    --chrom=${i} \
    --minMAF=0.01 \
    --minMAC=5 \
    --LOCO=FALSE \
    --GMMATmodelFile=${step1prefix}.rda \
    --SPAcutoff=2 \
    --varianceRatioFile=${step1prefix}.varianceRatio.txt \
    --markers_per_chunk=1000 \
    --rangestoIncludeFile=${regionFile}	\
    --pval_cutoff_for_gxe=1 \
    --is_permute_e=FALSE \
    --is_permute_ginge=FALSE
```

## Command to run one gene
```bash
bash step2_0.2.5.1.sh AL627309.1 B_cell
```

## Output
Step 2 outputs the effect size (beta), standard error, and P-value for both the main effect and the GxC interactions.

- Main effects are reported in the columns `BETA`, `SE`, and `p.value`.
- GxC interaction results are reported as comma-separated vectors in the columns `Beta_ge`, `seBeta_ge`, and `pval_ge`, in the same order as the dynamic covariates specified by the `--dynamicCovarColList` flag in Step 1.
