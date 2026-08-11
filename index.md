---
layout: default
title: CASTIE
nav_order: 1
has_children: true
permalink: /
---

# CASTIE

CASTIE (Context-Aware Single-cell Tool for Investigating regulatory Effects)
maps context-dependent eQTLs directly from single-cell data without pseudobulk
aggregation.

<img src="{{ site.baseurl }}/img/CASTIE_overview.jpeg" alt="CASTIE overview">

## Analysis workflow

<img src="{{ site.baseurl }}/img/CASTIE_steps.jpeg" alt="CASTIE workflow overview">

CASTIE has four analysis steps. Step 1 fits the null model, Step 2 performs
variant-level association tests, Step 3 combines variant p-values with ACAT,
and Step 4 applies FDR control to call eGenes. Because Steps 3 and 4 form the
gene-level analysis stage, they are presented together below.

## Option A — Docker or Singularity/Apptainer (recommended)

The image contains CASTIE, all dependencies, the command-line scripts, and the
simulated tutorial. No source checkout or compilation is required.

### Docker

```bash
docker pull yijia0802/castie:Latest
mkdir -p castie_tutorial_output
```

On Apple Silicon, please use `docker pull --platform linux/amd64 yijia0802/castie:Latest`. It can usually be omitted on
an Intel/AMD Linux host.

### Singularity or Apptainer

```bash
apptainer pull CASTIE.sif docker://yijia0802/castie:Latest
mkdir -p castie_tutorial_output
```

Use `singularity` in place of `apptainer` when that is the command provided by
your HPC system. To run the entire bundled tutorial at once:

```bash
apptainer exec \
  --bind "$PWD/castie_tutorial_output:/app/tutorial/output" \
  CASTIE.sif \
  bash /app/tutorial/run_tutorial_in_container.sh
```

<div class="castie-tabs" data-tabs markdown="1">
  <div class="castie-tab-list" role="tablist" aria-label="Container tutorial steps">
    <button type="button" role="tab" aria-selected="true" data-tab-target="container-step1">Step 1</button>
    <button type="button" role="tab" aria-selected="false" data-tab-target="container-step2">Step 2</button>
    <button type="button" role="tab" aria-selected="false" data-tab-target="container-step34">Step 3 + 4</button>
  </div>

  <div class="castie-tab-panel" data-tab-panel="container-step1" markdown="1">

```bash
docker run --rm --platform linux/amd64 \
  -v "$PWD/castie_tutorial_output:/app/tutorial/output" \
  -w /app/tutorial \
  yijia0802/castie:Latest \
  step1_fitNULLGLMM_qtl.R \
    --useSparseGRMtoFitNULL=FALSE \
    --useGRMtoFitNULL=FALSE \
    --phenoFile=data/phenotypes.tsv \
    --phenoCol=gene_1 \
    --covarColList=X1,X2,pf1,pf2 \
    --sampleCovarColList=X1,X2 \
    --dynamicCovarColList=pf1,pf2 \
    --sampleIDColinphenoFile=IND_ID \
    --traitType=count \
    --outputPrefix=output/gene_1 \
    --skipVarianceRatioEstimation=FALSE \
    --isRemoveZerosinPheno=FALSE \
    --isCovariateOffset=FALSE \
    --isCovariateTransform=TRUE \
    --skipModelFitting=FALSE \
    --tol=0.00001 \
    --plinkFile=data/grm_variants \
    --IsOverwriteVarianceRatioFile=TRUE
```

  </div>
  <div class="castie-tab-panel" data-tab-panel="container-step2" hidden markdown="1">

```bash
docker run --rm --platform linux/amd64 \
  -v "$PWD/castie_tutorial_output:/app/tutorial/output" \
  -w /app/tutorial \
  yijia0802/castie:Latest \
  step2_tests_qtl.R \
    --bedFile=data/genotypes.bed \
    --bimFile=data/genotypes.bim \
    --famFile=data/genotypes.fam \
    --SAIGEOutputFile=output/gene_1_cis \
    --chrom=1 \
    --minMAF=0.05 \
    --minMAC=5 \
    --LOCO=FALSE \
    --GMMATmodelFile=output/gene_1.rda \
    --SPAcutoff=2 \
    --varianceRatioFile=output/gene_1.varianceRatio.txt \
    --rangestoIncludeFile=data/gene_1_region.tsv \
    --markers_per_chunk=1000 \
    --output_format=txt
```

  </div>
  <div class="castie-tab-panel" data-tab-panel="container-step34" hidden markdown="1">

```bash
docker run --rm --platform linux/amd64 \
  -v "$PWD/castie_tutorial_output:/app/tutorial/output" \
  -w /app/tutorial \
  yijia0802/castie:Latest \
  bash -lc '
    concat_step2_results.py \
      --input-dir=output \
      --output=output/step3_input.txt \
      --contexts=pf1,pf2 \
      --file-pattern="*_cis" \
      --gene-regex="^(?P<gene>.+)_cis$" \
      --maf-min=0.05 \
      --maf-max=0.95

    step3_gene_pvalue.R \
      --input=output/step3_input.txt \
      --outdir=output/step3

    step4_get_egenes.R \
      --input=output/step3/step3_longformat.txt \
      --outdir=output/step4 \
      --fdr=0.05
  '
```

  </div>
</div>

For Singularity/Apptainer, the commands inside each tab are the same. Replace
the `docker run` wrapper with `apptainer exec`, bind the output directory to
`/app/tutorial/output`, and run from `/app/tutorial`.

## Option B — source installation with Pixi (Linux and macOS)

[Pixi](https://pixi.sh/) creates a self-contained environment inside the
checkout. Conda, R, a compiler, and administrator access are not required
beforehand; Pixi downloads the required tools and dependencies. CASTIE is
compiled once during installation.

```bash
# Install Pixi once, then reopen the terminal.
curl -fsSL https://pixi.sh/install.sh | sh

# Clone and install CASTIE.
git clone https://github.com/ZhouLabGenetics/CASTIE.git
cd CASTIE
pixi install
pixi run build
pixi run test

# Enter the environment and tutorial directory.
pixi shell
cd tutorial
```

For non-interactive HPC jobs, use `pixi run --manifest-path=/path/to/CASTIE/pixi.toml COMMAND`
instead of `pixi shell`. 

<div class="castie-tabs" data-tabs markdown="1">
  <div class="castie-tab-list" role="tablist" aria-label="Pixi tutorial steps">
    <button type="button" role="tab" aria-selected="true" data-tab-target="pixi-step1">Step 1</button>
    <button type="button" role="tab" aria-selected="false" data-tab-target="pixi-step2">Step 2</button>
    <button type="button" role="tab" aria-selected="false" data-tab-target="pixi-step34">Step 3 + 4</button>
  </div>

  <div class="castie-tab-panel" data-tab-panel="pixi-step1" markdown="1">

```bash
step1_fitNULLGLMM_qtl.R \
  --useSparseGRMtoFitNULL=FALSE \
  --useGRMtoFitNULL=FALSE \
  --phenoFile=data/phenotypes.tsv \
  --phenoCol=gene_1 \
  --covarColList=X1,X2,pf1,pf2 \
  --sampleCovarColList=X1,X2 \
  --dynamicCovarColList=pf1,pf2 \
  --sampleIDColinphenoFile=IND_ID \
  --traitType=count \
  --outputPrefix=output/gene_1 \
  --skipVarianceRatioEstimation=FALSE \
  --isRemoveZerosinPheno=FALSE \
  --isCovariateOffset=FALSE \
  --isCovariateTransform=TRUE \
  --skipModelFitting=FALSE \
  --tol=0.00001 \
  --plinkFile=data/grm_variants \
  --IsOverwriteVarianceRatioFile=TRUE
```

  </div>
  <div class="castie-tab-panel" data-tab-panel="pixi-step2" hidden markdown="1">

```bash
step2_tests_qtl.R \
  --bedFile=data/genotypes.bed \
  --bimFile=data/genotypes.bim \
  --famFile=data/genotypes.fam \
  --SAIGEOutputFile=output/gene_1_cis \
  --chrom=1 \
  --minMAF=0 \
  --minMAC=1 \
  --LOCO=FALSE \
  --GMMATmodelFile=output/gene_1.rda \
  --SPAcutoff=2 \
  --varianceRatioFile=output/gene_1.varianceRatio.txt \
  --rangestoIncludeFile=data/gene_1_region.tsv \
  --markers_per_chunk=1000 \
  --output_format=txt
```

  </div>
  <div class="castie-tab-panel" data-tab-panel="pixi-step34" hidden markdown="1">

```bash
concat_step2_results.py \
  --input-dir=output \
  --output=output/step3_input.txt \
  --contexts=pf1,pf2 \
  --file-pattern='*_cis' \
  --gene-regex='^(?P<gene>.+)_cis$' \
  --maf-min=0.05 \
  --maf-max=0.95

step3_gene_pvalue.R \
  --input=output/step3_input.txt \
  --outdir=output/step3

step4_get_egenes.R \
  --input=output/step3/step3_longformat.txt \
  --outdir=output/step4 \
  --fdr=0.05
```

  </div>
</div>

To run all four tutorial steps automatically from the repository root:

```bash
exit  # only if currently inside pixi shell
bash tutorial/run_tutorial_with_pixi.sh
```

## Tutorial results

The final eGene result is written to:

```text
tutorial/output/step4/pval_main_egene.tsv
```

The simulated tutorial analyzes one gene for software validation. Its q-value
equals its p-value; meaningful FDR estimation requires a real multi-gene run.

## Support

For questions, contact Christiana Liu at
[liuyijia@broadinstitute.org](mailto:liuyijia@broadinstitute.org).
