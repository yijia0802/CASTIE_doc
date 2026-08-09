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