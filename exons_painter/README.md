# 🧬 Gene Exon Painter – User Manual

## Introduction

**Gene Exon Painter** is an interactive web-based tool for visualizing exons from multiple transcripts mapped onto a genomic sequence. It helps you:

- Understand transcript structure and exon organization
- Explore alternative splicing
- Identify shared and overlapping exons
- Demonstrate gene architecture in teaching

---

## Installation & Requirements

1. Tool created specifically for gene Ccds33 in Mouse (Mus_musculus.GRCm39.113.gtf.gz and Mus_musculus.GRCm39.dna.chromosome.9.fa.gz).
2. If other genes needed, so make Ensembl download of *.gtf.gz and *.dna.chromosome.9.fa.gz or *.dna.primary_assembly.fa.gz.
3. Run code create_input_files.bash to create input files for Painter. (need to change filenames inside the script)
4. Open index.html in your browser.
5. Upload a genomic sequence file (.txt or .fasta). Here available gene Cdcc33.
6. Upload one or more exon .fasta files. Exon sequence for gene Cdcc33 available here.
7. Select a transcript and highlight its exons.

   ## Example Files for Download

Below are the download links for the example files for the Gene Exon Painter tool:

* **Genomic sequence:**
    * [Ccdc33_gene_str.txt](https://raw.githubusercontent.com/rafalwoycicki/rafalwoycicki.github.io/refs/heads/main/exons_painter/Ccdc33_gene_str.txt)
* **Exon FASTA files (please download all):**
    * [exonsUTRs.ENSMUST00000042205.renamed.fasta](https://raw.githubusercontent.com/rafalwoycicki/rafalwoycicki.github.io/refs/heads/main/exons_painter/exonsUTRs.ENSMUST00000042205.renamed.fasta)
    * [exonsUTRs.ENSMUST00000098681.renamed.fasta](https://raw.githubusercontent.com/rafalwoycicki/rafalwoycicki.github.io/refs/heads/main/exons_painter/exonsUTRs.ENSMUST00000098681.renamed.fasta)
    * [exonsUTRs.ENSMUST00000098682.renamed.fasta](https://raw.githubusercontent.com/rafalwoycicki/rafalwoycicki.github.io/refs/heads/main/exons_painter/exonsUTRs.ENSMUST00000098682.renamed.fasta)
    * [exonsUTRs.ENSMUST00000119665.renamed.fasta](https://raw.githubusercontent.com/rafalwoycicki/rafalwoycicki.github.io/refs/heads/main/exons_painter/exonsUTRs.ENSMUST00000119665.renamed.fasta)
    * [exonsUTRs.ENSMUST00000123746.renamed.fasta](https://raw.githubusercontent.com/rafalwoycicki/rafalwoycicki.github.io/refs/heads/main/exons_painter/exonsUTRs.ENSMUST00000123746.renamed.fasta)
    * [exonsUTRs.ENSMUST00000143797.renamed.fasta](https://raw.githubusercontent.com/rafalwoycicki/rafalwoycicki.github.io/refs/heads/main/exons_painter/exonsUTRs.ENSMUST00000143797.renamed.fasta)
    * [exonsUTRs.ENSMUST00000144887.renamed.fasta](https://raw.githubusercontent.com/rafalwoycicki/rafalwoycicki.github.io/refs/heads/main/exons_painter/exonsUTRs.ENSMUST00000144887.renamed.fasta)
    * [exonsUTRs.ENSMUST00000146741.renamed.fasta](https://raw.githubusercontent.com/rafalwoycicki/rafalwoycicki.github.io/refs/heads/main/exons_painter/exonsUTRs.ENSMUST00000146741.renamed.fasta)
    * [exonsUTRs.ENSMUST00000151404.renamed.fasta](https://raw.githubusercontent.com/rafalwoycicki/rafalwoycicki.github.io/refs/heads/main/exons_painter/exonsUTRs.ENSMUST00000151404.renamed.fasta)
    * [exonsUTRs.ENSMUST00000215944.renamed.fasta](https://raw.githubusercontent.com/rafalwoycicki/rafalwoycicki.github.io/refs/heads/main/exons_painter/exonsUTRs.ENSMUST00000215944.renamed.fasta)

### Instructions for use:

1.  Download the genomic sequence file (`Ccdc33_gene_str.txt`).
2.  Download all the Exon FASTA files (`exonsUTRs...renamed.fasta`).
3.  Open the [Gene Exon Painter](https://rafalwoycicki.github.io/exons_painter/exons_painter.html) page.
4.  Load the files:
    * Click "Choose File" next to "Genomic sequence (.txt/.fasta):" and select the downloaded `Ccdc33_gene_str.txt` file.
    * Click "Choose Files" next to "Exon FASTA files (multiple):" and select all the downloaded `exonsUTRs...renamed.fasta` files.

- **No installation required** – just open the HTML file in your browser
- Works offline after loading
- Supported browsers:
  - Chrome (recommended)
  - Firefox
  - Edge
  - Safari (limited)

---

## Input Files

### Genomic Sequence

- Format: `.fasta`, `.fa`, or `.txt`
- Must contain one continuous sequence (no line breaks within bases)
- Plain string; headers (>) ignored
- Must match coordinates used in exon files
- Example:
  ```
  >chr9_mouse
  AGTCGATCGATCGTACGTAGCTAGCTAGC...
  ```

### Exon FASTA Files

- Format: `.fasta`, `.fa` (can upload multiple)
- Each entry header should be:
  ```
  >ENSMUST00000000000:TranscriptName:Ex.1
  ```
- Sequence must match exactly a region in the genomic sequence
- Example:
  ```
  >ENSMUST00000000000:TranscriptName:Ex.1
  ATGCGTACTGACGTTAG
  ```

---

## Step-by-Step Usage

### 1. Load Files

- Upload your **genomic sequence file** using the left panel
- Upload **one or more exon FASTA files**

### 2. Select and View Transcripts

- Choose a transcript from the dropdown
- Exons for that transcript will appear below

### 3. Highlight Exons

- Click exon names in the list or table to highlight their positions
- Multiple exons can be selected
- Overlaps are visualized using color gradients

### 4. View Details

- Click a base in the sequence to open the related exon
- The panel shows:
  - Exon label, position and sequence
  - Exons with identical sequence
  - Exons overlapping the selected one

---

## Features

- Color-coded exon visualization
- Gradients for overlapping regions
- Clickable base-by-base interaction
- Dynamic dropdowns and filtering
- Detection of identical sequences and overlaps

---

## Error Handling

- Exons not found in the genome are skipped (warning in console)
- Genomes over ~500,000 bp may reduce performance

---

## Known Limitations

- No export functionality (planned)
- No strand/directionality support
- Compressed files (`.gz`) not supported

---

## Troubleshooting

### Exons not showing?

- Check if the exon sequence matches the genomic region exactly
- Ensure the genome file was uploaded first

### Colors confusing?

- Each transcript is assigned a unique color
- Overlapping exons show blended gradients
- Hover over bases to see transcript:exon labels

### Sequence loaded but nothing appears?

- Inspect the browser console (F12) for loading errors
- Check if sequences match exactly (including case and characters)

---

## Citation & Contact

If you use this tool, please cite the repository or author.

For questions or suggestions, open an issue on GitHub or contact the maintainer.

---

## Example Files

### genomic.txt

```
>GeneXYZ
ATGCGTACTGACGTTAGCTAGCATCGATCGTACGTAGC
```

### exons.fa

```
>TranscriptA:Exon1
ATGCGTACTGACGTTAG
>TranscriptB:Exon2
CTAGCATCGATCGTACG
```
