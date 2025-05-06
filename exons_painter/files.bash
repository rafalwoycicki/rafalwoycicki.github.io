
# INPUT FILES
GTF_FILE="Mus_musculus.GRCm39.113.gtf.gz"
FASTA_FILE="Mus_musculus.GRCm39.dna.chromosome.9.fa.gz"
GENE_NAME="Ccdc33"
OUT_PREFIX="ccdc33"

# Extract gene information and create BED
gzip -cd "$GTF_FILE" | grep -v '#' | awk '$3=="gene"' | grep "$GENE_NAME" | tr ';' '\t' | sed 's/\t /\t/g' | tr ' ' '\t' | cut -f1-8,10,14 | sed 's/"//g' | awk '{print $1"\t"($4=$4-1)"\t"$5"\t"$9":"$10"\t0\t"$7}' > ${OUT_PREFIX}.gene.bed

# Extract fasta for gene region
seqtk subseq -s "$FASTA_FILE" ${OUT_PREFIX}.gene.bed > ${OUT_PREFIX}.gene_str.fa

# Remove first line ('>') to get plain sequence
tail -n -1 ${OUT_PREFIX}.gene_str.fa > ${OUT_PREFIX}.gene_str.txt

# Extract UTRs and create BED
gzip -cd "$GTF_FILE" | grep -v '#' | grep "$GENE_NAME" | awk '$3=="five_prime_utr"||$3=="three_prime_utr"' | cut -f1,3,4,5,7,9 | tr ';' '\t' | sed 's/ //g' | cut -f1-5,8,13 | sed 's/transcript_id//' | sed 's/exon_number/Ex\./' | sed 's/transcript_name//' | sed 's/"//g' | awk '{print $1"\t"($3=$3-1)"\t"$4"\t"$6":"$7":"$2"\t0\t"$5}' > ${OUT_PREFIX}.utr.bed

# Extract exons and create BED
gzip -cd "$GTF_FILE" | grep -v '#' | grep "$GENE_NAME" | awk '$3=="exon"' | cut -f1,3,4,5,7,9 | tr ';' '\t' | sed 's/ //g' | cut -f1-5,8,10,14 | sed 's/transcript_id//' | sed 's/exon_number/Ex\./' | sed 's/transcript_name//' | sed 's/"//g' | awk '{print $1"\t"($3=$3-1)"\t"$4"\t"$6":"$8":"$7"\t0\t"$5}' > ${OUT_PREFIX}.exon.bed

# Merge exon and UTR BED files
cat ${OUT_PREFIX}.exon.bed ${OUT_PREFIX}.utr.bed > ${OUT_PREFIX}.utr_exon.bed

# List transcript names
gzip -cd "$GTF_FILE" | grep -v '#' | awk '$3=="transcript"' | grep "$GENE_NAME" | tr ';' '\t' | cut -f11 | cut -f3 -d" " | sed 's/"//g' | sort -u > ${OUT_PREFIX}.transcripts.list

# Create BED per transcript
cat ${OUT_PREFIX}.transcripts.list | while read transcript; do
    grep $transcript ${OUT_PREFIX}.utr_exon.bed > ${OUT_PREFIX}.${transcript}.UTRexon.bed
done

# Sort BED files
ls -1 ${OUT_PREFIX}.ENSMUST*.UTRexon.bed | while read file; do
    sort -k2,2r -k3,3r $file > $file.sorted.bed
done

# Extract sequences per transcript
ls -1 *.UTRexon.bed.sorted.bed | while read file; do
    cat ${OUT_PREFIX}.transcripts.list | while read transcript; do
        seqtk subseq -s "$FASTA_FILE" "$file" > ${OUT_PREFIX}.${transcript}.fasta
    done
done

# Rename fasta headers to match transcript names
cat ${OUT_PREFIX}.transcripts.list | while read transcript; do
    awk 'FNR==NR {names[++i]=$4; next} /^>/ {$0=">" names[++j]} 1' *."$transcript".UTRexon.bed.sorted.bed ${OUT_PREFIX}.${transcript}.fasta > ${OUT_PREFIX}.${transcript}.renamed.fasta
done

