#!/bin/bash

# Define input directory and output file
input_dir="/.../step2_output/"
output_file="/.../concatenated_file.txt"

# Create output directory if it doesn't exist
mkdir -p "$(dirname "$output_file")"

# Find the first file with content
first_file=$(find "$input_dir" -type f -name "*.txt_ge_SAIGEQTL_0.2.5.1" -size +0c | head -n 1)

# If no files are found, exit
if [[ ! -f "$first_file" ]]; then
    echo "No non-empty files found in $input_dir"
    exit 1
fi

# Extract column indices dynamically (assuming tab-delimited file)
header=$(head -n 1 "$first_file")

marker_col=$(echo -e "$header" | awk -F'\t' '{for(i=1;i<=NF;i++) if($i=="MarkerID") print i}')
af_col=$(echo -e "$header" | awk -F'\t' '{for(i=1;i<=NF;i++) if($i=="AF_Allele2") print i}')
pmain_col=$(echo -e "$header" | awk -F'\t' '{for(i=1;i<=NF;i++) if($i=="p.value") print i}')
pge_col=$(echo -e "$header" | awk -F'\t' '{for(i=1;i<=NF;i++) if($i=="pval_ge") print i}')
pskat_col=$(echo -e "$header" | awk -F'\t' '{for(i=1;i<=NF;i++) if($i=="pval_ge_SKAT") print i}')

# Check if all columns exist
if [[ -z "$marker_col" || -z "$af_col" || -z "$pmain_col" || -z "$pge_col" || -z "$pskat_col" ]]; then
    echo "One or more required columns (MarkerID, AF_Allele2, p.value, pval_ge, pval_ge_SKAT) are missing in the input files."
    exit 1
fi

# Write header to output file with additional "Gene" column
echo -e "MarkerID\tAF_Allele2\tpval_main\tpval_ge\tpval_ge_SKAT\tGene" > "$output_file"

# Process all files
for file in "$input_dir"/*.txt_ge_SAIGEQTL_0.2.5.1; do
    # Extract only the gene name from the filename
    gene_name=$(basename "$file" | sed -E 's/_B_all_count_saigeqtl_cis_window_1000000.singleVar.txt_ge_SAIGEQTL_0.2.5.1$//')

    awk -F'\t' -v m="$marker_col" -v a="$af_col" -v pm="$pmain_col" -v pg="$pge_col" -v ps="$pskat_col" -v g="$gene_name" '
    NR>1 { 
        print $m "\t" $a "\t" $pm "\t" $pg "\t" $ps "\t" g 
    }' "$file" >> "$output_file"
done

echo "Merged data saved to: $output_file"