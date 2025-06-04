# 🧬 Gene Exon Painter – visualize exons directly on genomic sequence

**Gene Exon Painter** is an interactive tool for mapping exons from multiple transcripts onto a genomic sequence. It helps you:

- Understand alternative splicing,
- Detect overlapping or shared exons,
- Visualize transcript structures in context,
- Teach gene structure in an intuitive way.

---

## 📘 How to Use Gene Exon Painter

### 1. Prepare your files
- **Genomic sequence** file in `.fasta`, `.fa`, or `.txt` format.
- **Exon FASTA files**: one or more `.fasta` files with headers formatted like `>TranscriptID:ExonLabel` (e.g., `>ENST00000619216:exon_1`).

### 2. Load the data
1. Use the **Genomic sequence** file input on the left panel to load your genomic sequence.
2. Then use the **Exon FASTA files** input to upload one or more exon FASTA files.

### 3. Explore the visualization
- Select a transcript to view its exons.
- Click an exon to highlight it on the genomic sequence.
- You can activate multiple exons — overlapping areas will be shown with gradients.
- You can also click on a nucleotide in the sequence to activate the corresponding exon.

### 4. Exon Details Panel
When an exon is selected, the right panel shows:
- Exon sequence and position,
- Other exons with the exact same sequence,
- Overlapping exons from other transcripts.
