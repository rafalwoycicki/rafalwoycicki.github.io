# Ensembl download of Mus_musculus.GRCm39.113.gtf.gz and Mus_musculus.GRCm39.dna.chromosome.9.fa.gz or Mus_musculus.GRCm39.dna.primary_assembly.fa.gz
# Extract Ccdc33 gene information from GTF file and create BED files (substract 1 from start position)
gzip -cd Mus_musculus.GRCm39.113.gtf.gz | grep -v '#' | awk '$3=="gene"' | grep 'Ccdc33' | tr ';' '\t' | sed 's/\t /\t/g' | tr ' ' '\t' | cut -f1-8,10,14 | sed 's/"//g' | awk '{print $1"\t"($4=$4-1)"\t"$5"\t"$9":"$10"\t0\t"$7}' > Ccdc33.gene.bed
# Extract fasta for Ccdc33 gene from Mus_musculus.GRCm39.dna.chromosome.9.fa.gz
seqtk subseq -s Mus_musculus.GRCm39.dna.chromosome.9.fa.gz Ccdc33.gene.bed > Ccdc33.gene_str.fa
# Transform fasta to text file and remove the first line with '>' character
tail -n -1 Ccdc33.gene_str.fa > Ccdc33.gene_str.txt
# Extract the UTRs information from the GTF file and create BED files (substract 1 from start position)
gzip -cd Mus_musculus.GRCm39.113.gtf.gz | grep -v '#' | grep 'Ccdc33' | awk '$3=="five_prime_utr"||$3=="three_prime_utr"' | cut -f1,3,4,5,7,9 | tr ';' '\t' | sed 's/ //g' | cut -f1-5,8,13 | sed 's/transcript_id//' | sed 's/exon_number/Ex\./' | sed 's/transcript_name//' | sed 's/"//g' | awk '{print $1"\t"($3=$3-1)"\t"$4"\t"$6":"$7":"$2"\t0\t"$5}' > Mus_musculus.GRCm39.113.gtf.Cdcc33.UTR.bed
# Extract the exons information from the GTF file and create BED files (substract 1 from start position)
gzip -cd Mus_musculus.GRCm39.113.gtf.gz | grep -v '#' | grep 'Ccdc33' | awk '$3=="exon"' | cut -f1,3,4,5,7,9 | tr ';' '\t' | sed 's/ //g' | cut -f1-5,8,10,14 | sed 's/transcript_id//' | sed 's/exon_number/Ex\./' | sed 's/transcript_name//' | sed 's/"//g' | awk '{print $1"\t"($3=$3-1)"\t"$4"\t"$6":"$8":"$7"\t0\t"$5}' > Mus_musculus.GRCm39.113.gtf.Cdcc33.exon.bed
# Merge UTR and exon BED files
cat Mus_musculus.GRCm39.113.gtf.Cdcc33.exon.bed Mus_musculus.GRCm39.113.gtf.Cdcc33.UTR.bed > Mus_musculus.GRCm39.113.gtf.Cdcc33.UTRexon.bed
# Extract transript names from GTF file and create a list of unique transcript names
gzip -cd Mus_musculus.GRCm39.113.gtf.gz | grep -v '#' | awk '$3=="transcript"' | grep 'Ccdc33' | tr ';' '\t' | cut -f11 | cut -f3 -d" " | sed 's/"//g' | sort -u > Mus_musculus.GRCm39.113.gtf.Ccdc33.transcripts.list
# Make separate BED files for each transcript
cat Mus_musculus.GRCm39.113.gtf.Ccdc33.transcripts.list | while read transcript; do echo "$transcript"; grep $transcript Mus_musculus.GRCm39.113.gtf.Cdcc33.UTRexon.bed > Mus_musculus.GRCm39.113.gtf.Cdcc33."$transcript".UTRexon.bed ; done
# Sort the BED files by chromosome and start position
ls -1 Mus_musculus.GRCm39.113.gtf.Cdcc33.ENSMUST*.UTRexon.bed | while read file; do echo "$file"; cat $file | sort -k2,2r -k3,3r > $file.sorted.bed; done
# Extract the sequences from the Mus_musculus.GRCm39.dna.chromosome.9.fa.gz file for each exon and UTR of each transcript
ls -1 *.UTRexon.bed.sorted.bed | while read file; do echo "$file"; cat Mus_musculus.GRCm39.113.gtf.Ccdc33.transcripts.list | while read transcript; do echo "$transcript"; seqtk subseq -s Mus_musculus.GRCm39.dna.chromosome.9.fa.gz "$file" > exonsUTRs."$transcript".fasta ;done; done
# Rename the sequences in the fasta files to match the transcript names
cat Mus_musculus.GRCm39.113.gtf.Ccdc33.transcripts.list | while read transcript; do echo "$transcript"; awk 'FNR==NR {names[++i]=$4; next} /^>/ {$0=">" names[++j]} 1' *."$transcript".UTRexon.bed.sorted.bed exonsUTRs."$transcript".fasta > exonsUTRs."$transcript".renamed.fasta; done
