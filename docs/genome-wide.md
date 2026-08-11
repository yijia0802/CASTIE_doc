---
layout: default
title: HPC example
parent: CASTIE
nav_order: 4
permalink: /docs/HPC example/
---

# Example scripts on running one gene on HPC using apptainer

## Pull sif file on HPC
Pull sif file using apptainer/singularity (this might take a while)
```bash
apptainer pull CASTIE.sif docker://yijia0802/castie:Latest
```
## preprocessing phenotype file
Convert phenotype tsv file to H5 for faster computational speed if the phenotype tsv is large
`--metaCols` should list all columns that are NOT gene names in the pheno file.

example script:
```bash
PROJECT_DIR=/path/to/your/project
SIF="${PROJECT_DIR}/CASTIE.sif"

apptainer shell \
  --bind "${PROJECT_DIR}:${PROJECT_DIR}" \
  "${SIF}" \
  convert_phenoFile_to_h5.R \
    --phenoFile /path/to/your/data/t_all.tsv \
    --output /path/to/your/data/t_all.h5 \
    --sampleIDCol individual \
    --cellIDCol barcode \
    --chunkSize 5000 \
    --metaCols "individual,barcode,sex,pc1,pc2,pc3,pc4,pc5,pc6,age,pf1,pf2,\
  onek1k_celltype,ASA,Proliferation,ASA_binary,Proliferation_binary,\
  Multinomial_Label,CellCycle.G2M,Translation,HLA,ISG,Mito,Doublet.RBC,\
  gdT,CellCycle.S,Cytotoxic,Doublet.Platelet,NME1.FABP5,Th22,MAIT,\
  CellCycle.Late.S,Cytoskeleton,Heatshock,Multi.Cytokine,TEMRA,\
  Doublet.Myeloid,Metallothionein,CD4.CM,IEG,CD8.EM,IEG2,CD4.Naive,\
  Treg,Th17.Resting,Poor.Quality,CD8.Naive,RGCC.MYADM,TIMD4.TIM3,\
  Doublet.Plasmablast,BCL2.FAM13A,IL10.IL19,Th2.Activated,Th2.Resting,\
  ICOS.CD38,Doublet.Bcell,Th1.Like,CTLA4.CD38,CD8.Trm,Th17.Activated,\
  Tfh.2,OX40.EBI3,CD172a.MERTK,IEG3,Doublet.Fibroblast,SOX4.TOX2,\
  CD40LG.TXNIP,Tph,Exhaustion,Tfh.1,MOFA1,MOFA2,MOFA3,MOFA4,MOFA5,\
  MOFA6,MOFA7,MOFA8,MOFA9,MOFA10,total_read_counts,log_total_read_counts"
```

## CASTIE step 1
Run step 1 with one gene interactively.

get into the container
```bash
PROJECT_DIR=/path/to/your/project
SIF="${PROJECT_DIR}/CASTIE.sif"

apptainer shell \
  --bind "${PROJECT_DIR}:${PROJECT_DIR}" \
  "${SIF}"
```

example `step1.sh`:
```bash
# -------- Analysis settings --------
genename=$1
cellType=$2
traitType=count
windowsize=1000000

phenofile=/path/to/your/data/t_all.h5
geneLocationFile=/path/to/your/genelocationfile/GeneLocations.tsv

i=$(awk -v gene=$genename '$1 == gene {print $3}' $geneLocationFile)
echo "$i"

step1output=/path/to/your/results/step1
step1prefix=${step1output}${genename}_${cellType}_${traitType}_0.2.5.8

# Create the output directory on the host.
mkdir -p /path/to/your/results/step1/

# Run step 1
step1_fitNULLGLMM_qtl.R  \
	--useSparseGRMtoFitNULL=FALSE  \
    --useGRMtoFitNULL=FALSE \
    --phenoFile=${phenofile}        \
    --phenoCol=${genename}  \
    --sampleCovarColList=age,sex,pc1,pc2,pc3,pc4,pc5,pc6    \
    --sampleIDColinphenoFile=individual \
    --traitType=${traitType} \
    --outputPrefix=${step1prefix}   \
    --skipVarianceRatioEstimation=FALSE  \
    --isRemoveZerosinPheno=FALSE \
    --isCovariateOffset=FALSE  \
    --isCovariateTransform=TRUE  \
    --skipModelFitting=FALSE  \
    --tol=0.00001   \
    --plinkFile=/path/to/your/genotype/pruned_random_3000 \
    --IsOverwriteVarianceRatioFile=TRUE	\
    --maxiterPCG=500	\
    --isStoreSigma=TRUE	\
    --tauInit=1,0.1,0	\
    --maxiter=500	\
    --nThreads=4	\
    --covarColList=age,sex,pc1,pc2,pc3,pc4,pc5,pc6,pf1,pf2,CD4.Naive,CD4.CM,Th1.Like,Th2.Resting,Th2.Activated,Th17.Activated,Th22,Tfh.1,Tfh.2,Tph,CD8.EM,CD8.Trm,TEMRA,MAIT,Cytotoxic,Exhaustion,CellCycle.S,CellCycle.G2M \
	  --dynamicCovarColList=age,sex,CD4.Naive,CD4.CM,Th1.Like,Th2.Resting,Th2.Activated,Th17.Activated,Th22,Tfh.1,Tfh.2,Tph,CD8.EM,CD8.Trm,TEMRA,MAIT,Cytotoxic,Exhaustion,CellCycle.S,CellCycle.G2M \
	  --offsetCol=log_total_read_counts \
    --usePCG=FALSE \
    --isWriteReport=TRUE
```
run with `bash step1.sh {gene} {cell_type}`

## CASTIE step 2
Run step 2 with one gene interactively.

example `step2.sh`:
```bash
genename=$1
cellType=$2
traitType=count
windowsize=1000000

geneLocationFile=/path/to/your/genelocationfile/GeneLocations.tsv
outpath=/path/to/your/results/step2/

i=$(awk -v gene=$genename '$1 == gene {print $3}' $geneLocationFile)
echo "$i"

groupFile=${outpath}Gene_${genename}_${windowsize}.grp
regionFilewithname=${outpath}Gene_${genename}_${windowsize}.region
regionFile=${outpath}Gene_${genename}_${windowsize}.region.noname

awk -v gene="$genename" -v windowsize="$windowsize" '
$1 == gene {print $3, $4 - windowsize, $5 + windowsize}
' $geneLocationFile > ${regionFilewithname}

awk '{print $1, $2, $3}' ${regionFilewithname} > ${regionFile}

step1output=/path/to/your/results/step1/
step1prefix=${step1output}${genename}_${cellType}_${traitType}_0.2.5.8

# Create the output directory on the host.
mkdir -p /path/to/your/results/step2/

step2output=/path/to/your/results/step2/
step2prefix=${step2output}${genename}_${cellType}_${traitType}_0.2.5.8

step2_tests_qtl.R \
    --bedFile=/path/to/your/genotype/full_genome_chr${i}.bed \
    --bimFile=/path/to/your/genotype/full_genome_chr${i}.bim \
    --famFile=/path/to/your/genotype/full_genome_chr${i}.fam  \
    --SAIGEOutputFile=${step2prefix} \
    --chrom=${i} \
    --minMAF=0.05 \
    --minMAC=5 \
    --LOCO=FALSE \
    --GMMATmodelFile=${step1prefix}.rda \
    --SPAcutoff=2 \
    --varianceRatioFile=${step1prefix}.varianceRatio.txt \
    --markers_per_chunk=1000 \
    --rangestoIncludeFile=${regionFile} \
    --pval_cutoff_for_gxe=1 \
    --is_permute_e=FALSE \
    --is_permute_ginge=FALSE \
    --pval_cutoff_for_fastTest=1 \
    --output_format=parquet
```
run with `bash step2.sh {gene} {cell_type}`

## Concatenate step 2 results for step 3 (only needed if you have > 1 gene)
```bash
concat_step2_results.py \
  --input-dir=/path/to/your/results/step2/ \
  --output=/path/to/your/results/step2/step3_input.txt \
  --contexts=age,sex,CD4.Naive,CD4.CM,Th1.Like,Th2.Resting,Th2.Activated,Th17.Activated,Th22,Tfh.1,Tfh.2,Tph,CD8.EM,CD8.Trm,TEMRA,MAIT,Cytotoxic,Exhaustion,CellCycle.S,CellCycle.G2M \
  --file-pattern='*.parquet' \
  --gene-regex='^(?P<gene>.+)_0[.]2[.]5[.]8[.]parquet$' \
  --maf-min=0.05 \
  --maf-max=0.95
```

## CASTIE step 3 (only needed if you have > 1 gene)

example script
```bash
mkdir -p /path/to/your/results/step3/

step3_gene_pvalue.R \
  --input=/path/to/your/results/step2/step3_input.txt \
  --outdir=/path/to/your/results/step3/

mkdir -p /path/to/your/results/step3/eGenes/

step4_get_egenes.R \
  --input=/path/to/your/results/step3/step3_longformat.txt \
  --outdir=/path/to/your/results/step3/eGenes/ \
  --fdr=0.05
```

For genome-wide cis-region scans (e.g. 10,000+ genes), we recommend submitting jobs in parallel (e.g. 20 - 100 genes per job). 

