awk 'BEGIN {
    OFS="\t";
    print "MarkerID", "AF_Allele2", "pval_main", "age", "sex","pseudotime","S.Score","G2M.Score","pval_ge_SKAT", "Gene";
}
NR > 1 {
    split($4, pvals, ",");  # pval_ge is at column $4
    printf "%s\t%s\t%s", $1, $2, $3;  # Print MarkerID, AF_Allele2, and pval_main

    for(i = 1; i <= 5; i++) printf "\t%s", pvals[i];  # Split into age, sex, pseudotime, S.Score, G2M.Score

    printf "\t%s\t%s\n", $5, $NF;  # Append pval_ge_SKAT ($5) and Gene ($NF)
}' concatenated_file.txt > split_file.txt