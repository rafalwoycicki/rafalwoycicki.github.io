# RNA-Seq Power Calculator – Full User Manual

## Purpose
This tool estimates the statistical power or required number of replicates for RNA-Seq experiments using the DESeq2 model.

## Input Parameters

- **μ (mean expression):**  
  Mean read count per isoform/gene. Can be auto-calculated if total reads and number of isoforms are provided.

- **Total reads:**  
  Optional. If filled together with the number of isoforms, overrides manual μ.

- **Number of isoforms:**  
  Required to auto-calculate μ from total reads.

- **Dispersion (α):**  
  Biological variability. Typically between 0.05 and 0.2 for most genes.

- **log2 fold change (Δ):**  
  Expected expression difference between conditions. Δ = 1 implies a 2-fold change.

- **Replicates per group:**  
  Number of biological replicates in each group. Minimum of 3 required.

- **FDR:**  
  Desired false discovery rate. Used to adjust the per-test significance level.

- **Number of isoforms (m):**  
  Total number of genes/transcripts tested.

- **Target rank (i):**  
  Defines how many top hits you want to discover. Lower rank = stricter test.

- **Target power:**  
  Desired power (e.g. 0.8 = 80%) for planning sample size.

## Buttons

- **Estimate Power:**  
  Calculates the power based on current input values.

- **Estimate Samples for Target Power:**  
  Estimates how many replicates per group are needed to reach the desired power.

## Statistical Methodology

Based on the DESeq2 model using a Negative Binomial distribution:

- `Var(Y) = μ + α·μ²`
- `SE = sqrt((2 / n) × Var / μ²)` – Standard error of log2 fold change
- `Z = |Δ| / SE` – Test statistic
- `αᵢ = (FDR × i) / m` – Per-test significance level (Benjamini-Hochberg correction)
- `Zᵅ = Φ⁻¹(1 − αᵢ)` – Critical Z value
- `Power = Φ(Z − Zᵅ)` – Probability of detecting the effect

## Tips

- Use real estimates for μ from pilot data when possible.
- Target power of 0.8 is standard; use 0.9 for more confident results.
- Lower rank (i.e., top 100 discoveries) makes the test stricter.
