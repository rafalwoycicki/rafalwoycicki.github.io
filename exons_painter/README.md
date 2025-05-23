
# Gene Exon Painter

An interactive exon painter — a web tool to visualize exon structures within transcripts and their positions on the genomic sequence.

## 🧬 What this tool does

- Allows users to **load a genomic sequence file** (`.txt` or `.fasta`) and **one or more exon `.fasta` files**.
- Displays the genomic sequence with exons **highlighted by color**.
- Supports overlapping exons using color **gradients**.
- Automatically scrolls to a selected exon when clicked or chosen from a dropdown.
- Shows a **tooltip** with transcript and exon name on hover.
- Clicking multiple exons in the same transcript **adds highlights cumulatively**.
- Switching to a different transcript **clears previous highlights**.
- Exons are listed in:
  - a dropdown menu,
  - a per-transcript side panel,
  - and a compact interactive table at the top.

## 📂 How to use it

0. Tool created specifically for gene `Ccds33` in Mouse (`Mus_musculus.GRCm39.113.gtf.gz and Mus_musculus.GRCm39.dna.chromosome.9.fa.gz).`
1. If other genes needed, so make Ensembl download of `*.gtf.gz` and `*.dna.chromosome.9.fa.gz` or `*.dna.primary_assembly.fa.gz`.
2. Run code `create_input_files.bash` to create input files for Painter. (need to change filenames inside the script)
3. Open `index.html` in your browser.
4. Use the **Genomic sequence** input to upload a `.txt` or `.fasta` file containing the gene sequence.
5. Upload one or more **`.fasta` files with exon sequences** (from any number of transcripts).
6. Select a transcript from the dropdown to explore its exons.
7. Click or select exons to highlight them on the genomic sequence.

## 📄 Input file formats

### Genomic sequence (`.txt` / `.fasta`)
- Plain nucleotide string (FASTA headers like `>` are ignored).
- Must match the coordinate system used in exon `.fasta` files.

### Exons (`.fasta`)
- Each entry should follow this header format:  
  `>ENSMUST00000000000:TranscriptName:Ex.1`
- Sequence must match exactly the corresponding genomic region.

## ✅ Browser compatibility

- Chrome
- Firefox
- Edge

> This app runs entirely in the browser — no backend or server needed.

## 📌 Default behavior

By default, no data is loaded automatically.  
Users must **manually load** the genomic and exon files from disk using the file upload inputs in the left panel.
The example data are in the folder exons_painter.

---
