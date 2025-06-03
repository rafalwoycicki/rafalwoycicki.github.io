# Analiza Mikromacierzowa: Materiały i Metody

## Wstępne Przetwarzanie i Normalizacja Danych Mikromacierzowych 🔬

Analiza mikromacierzowa została przeprowadzona na danych z macierzy Affymetrix MoGene-1_0-st-v1. Surowe pliki CEL zostały wcześniej przetworzone i znormalizowane przy użyciu **Affymetrix Power Tools (APT)** z algorytmem **plier-gcbg**. Wynikowe znormalizowane dane ekspresji, z jedną próbką (Probe9, odpowiadającą KO6_4) już usuniętą, zostały załadowane z pliku tekstowego rozdzielanego tabulatorami (`../after_plier-gcbg_apt.txt`).

Identyfikatory próbek zostały ustandaryzowane poprzez usunięcie sufiksu `_MoGene.1_0.st.v1.CEL`. Próbki następnie posortowano numerycznie za pomocą funkcji `mixedsort` z pakietu `gtools` i kolejno przemianowano: "Probe1" do "Probe5" na "KO5_1" do "KO5_5", a "Probe6", "Probe7", "Probe8", "Probe10" na "KO6_1", "KO6_2", "KO6_3" i "KO6_5", co dało 5 próbek dla grupy KO5 i 4 próbki dla grupy KO6.

Znormalizowane dane ekspresji poddano **transformacji log2**. Wszelkie wynikowe wartości ekspresji mniejsze od zera ustawiono na zero. Zidentyfikowano sondy wykazujące zerową ekspresję we wszystkich próbkach, ale główny krok filtrowania polegał na usunięciu sond, które miały wartość zero w *jakiejkolwiek* próbce. Ten przefiltrowany zbiór danych (`plier_gcbg_log_no_any_zeros`) został użyty do kolejnych analiz.

---

## Kontrola Jakości i Eksploracyjna Analiza Danych (QC/EDA) 📊

Na danych po transformacji log2 i filtrowaniu przeprowadzono kilka etapów kontroli jakości (QC) oraz eksploracyjnej analizy danych (EDA). 
* Wygenerowano **histogramy intensywności sygnału** oraz **wykresy pudełkowe** w celu wizualizacji rozkładu danych.
* **Analizę głównych składowych (PCA)** przeprowadzono na transponowanej macierzy ekspresji (`prcomp(t(plier_gcbg_log))`) w celu oceny grupowania próbek.
* Relacje między próbkami badano dalej za pomocą **mapy ciepła macierzy korelacji** (wygenerowanej funkcją `pheatmap`, używając domyślnych metod klastrowania, tj. odległości euklidesowej i metody "complete") oraz **hierarchicznego klastrowania** opartego na odległościach euklidesowych (obliczanych funkcją `dist`) i domyślnej metodzie "complete" funkcji `hclust`.
* **Medianę ekspresji** dla każdej próbki zwizualizowano za pomocą wykresów słupkowych.

Oceniono zmienność sond, a mapy ciepła (skalowane według wierszy, `scale = "row"`, przy użyciu domyślnych metod klastrowania `pheatmap`) wygenerowano dla 100, 500 i 1000 najbardziej zmiennych sond. Odległości euklidesowe między próbkami również zwizualizowano jako mapę ciepła.

---

## Analiza Ekspresji Określonych Zestawów Genów 🧬

Zbadano wzorce ekspresji predefiniowanych zestawów genów:
1.  **Geny związane z knockoutem**: "Acr", "Tnp2", "H1f6", "Spmap2", "Creb3l4", "Tex22".
2.  **Geny referencyjne dla badań jąder** (plus Ccdc33 i Pxt1): "Ccdc33", "Pxt1", "Gapdh", "Actb", "Hprt", "Ppia", "Polr2a", "Rpl13a", "Ywhaz", "Tbp", "18srRNA", "Sdha".
3.  **Sondy tła**: Załadowane z zewnętrznego pliku (`../bcg.probes`).

Identyfikatory sond opatrzone zostały adnotacjami symboli genów przy użyciu pakietu `mogene10sttranscriptcluster.db` (wersja zależna od użytej wersji Bioconductor). Profile ekspresji tych genów/sond zwizualizowano za pomocą wykresów liniowych (`ggplot2`), zapisując wyniki jako:
* `[results/plots/Knockout_genes_expression_plot_apt.jpg]`
* `[results/plots/reference_genes_testis_apt.jpg]`
* `[results/tables/Knockout_genes_table_apt.csv]`
* `[results/tables/subset_genes_table_apt1.csv]`
* `[results/plots/BckgProbesets_apt.jpg]`
* `[results/tables/BckProbes_apt.csv]`
* `[results/plots/Variationwise_expression_Probes_KO5vsKO6_apt.jpg]`

---

## Filtrowanie do Analizy Różnicowej Ekspresji Genów 📉

Przed analizą różnicowej ekspresji genów (DE), sondy dodatkowo przefiltrowano. Sondy zachowano, jeśli spełniały kryteria:
* Średnia ekspresja log2 wynosiła **≥ 8** w co najmniej jednej grupie (KO5 lub KO6). Próg ten wybrano na podstawie obserwowanych wartości ekspresji po normalizacji plier-gcbg.
* Wariancja ekspresji log2 wynosiła **> 0.01** w co najmniej jednej grupie.
Wynikowy zbiór danych nazwano `plier_gcbg_log_filtered`.

---

## Analiza Różnicowej Ekspresji Genów (DE) 🔬➡️📊

Analizę DE między grupami KO6 i KO5 przeprowadzono przy użyciu pakietu **`limma`**. Model liniowy dopasowano (`lmFit`) używając macierzy projektowej (`model.matrix(~ group)`). Statystyki empiryczne Bayesa (t-statystyki, P-wartości, log2FC) obliczono funkcją `eBayes`. Obliczono również 95% przedziały ufności dla logFC. Wyniki wyekstrahowano (`topTable`, `coef = 2`) i zapisano do pliku: `[results/tables/results_apt.csv]`.

---

## Adnotacja Genów i Rozwiązywanie Niejednoznaczności 📝

Identyfikatory sond z wyników DE opatrzone zostały adnotacjami z dwóch źródeł:
1.  **Adnotacja oryginalna**: pakiet `mogene10sttranscriptcluster.db` (wersja zależna od Bioconductor; zapytania przez `AnnotationDbi::select`).
2.  **Adnotacja nowa**: Eksport BioMart z Ensembl (baza GRCm39, v114, dostęp 28.05.2025 wg skryptu), plik `../mart_export_Final.txt`.

Dla każdego źródła: połączono wyniki DE z adnotacjami, usunięto wpisy bez SYMBOL/ENSEMBL. Sondy mapujące się do wielu genów o sprzecznych korzeniach/ID usunięto lub losowo wybrano jedno mapowanie przy zgodności. Sondy mapujące się do tego samego genu zgrupowano w "klastry", wybierając reprezentanta na podstawie `adj.P.Val` i `logFC`. Wyniki zapisano jako:
* `[results/tables/diff_expr_resultsF_oryg_annot_uniq.csv]`
* `[results/tables/diff_expr_resultsF_new_annot_uniq.csv]`
Pełne, niefiltrowane tabele z adnotacjami zapisano jako:
* `[results/tables/diff_expr_resultsF_oryg_annot.csv]`
* `[results/tables/diff_expr_resultsF_newannot.csv]`

---

## Łączenie i Finalizowanie Adnotacji 🏅

Dwie przetworzone listy DE połączono. Ustalono `SYMBOL_final` i `ENSEMBL_final`, priorytetyzując adnotację oryginalną (df1) dla wspólnych sond, chyba że była pusta (wtedy df2). Dla unikalnych sond użyto ich źródłowej adnotacji. Utworzono kolumnę `GENES` (`SYMBOL_final` + `ENSEMBL_final`). Aby zapewnić jedną najlepszą adnotację na sondę, priorytetyzowano obecność obu identyfikatorów, potem SYMBOL, z preferencją źródła: "only_in_df1" > "common" > "only_in_df2". Aby zapewnić jedną sondę na gen, ponownie zastosowano klastrowanie i wybór najlepszej sondy (status źródła > `adj.P.Val` > `abs(logFC)`). Finalna tabela: `[results/tables/final_combined_unique.csv]`.

---

## Wizualizacja Wyników Analizy DE 🖼️

Wygenerowano następujące wizualizacje z `final_combined_unique`:
* **Wykres MA** (`limma::plotMA`).
* **Wykres wulkaniczny** (`ggplot2`, `ggrepel`): -log10(P-wartość) vs logFC. Geny z `adj.P.Val < 0.05` i `abs(logFC) > 0.5` podświetlono.
* **Histogram wartości P**.
* **Mapy ciepła** (`pheatmap`, `scale = "row"`): dla top 100 i 500 genów DE.
* **Wykres przedziałów ufności (CI Plot)**: dla logFC top 50 genów DE. Geny z CI całkowicie w zakresie -0.5 do 0.5 zidentyfikowano i zapisano do: `[results/tables/genes_excluded_biological_change_final_combined_unique.csv]`.
*(Uwaga: skrypt generuje wykresy wulkaniczne i mapy ciepła DE, ale nie zapisuje ich jawnie do plików w tej sekcji analizy DE).*

---

## Analizy Wzbogacenia Funkcjonalnego 🌐

Geny uznano za różnicowo wyrażane (DEGs), jeśli `adj.P.Val < 0.05` i `abs(logFC) > 0.5`. Użyto `SYMBOL_final` tych DEG.

* **FGSEA (Fast Gene Set Enrichment Analysis)**:
    * Ranking genów: t-statystyka (`limma`).
    * Zestawy genów: Gene Ontology (BP, CC, MF) z MSigDB (mysz, v`2024.1.Mm`, pliki `m5.go.*.v2024.1.Mm.symbols.gmt`).
    * Parametry: `minSize = 15`, `maxSize = 500`.
    * Wyniki zapisano do plików CSV (np. `[results/tables/fgsea_new_GO_BP.csv]`) i zwizualizowano (top 30 ścieżek).

* **gProfiler2**:
    * Funkcja `gost`, lista symboli DEG.
    * Organizm: `mmusculus`. Źródła: GO:BP, GO:CC, GO:MF, KEGG, REAC.
    * Korekcja: FDR (`correction_method = "fdr"`), próg: 0.05 (`user_threshold = 0.05`).
    * Wyniki: `[results/tables/gprofiler_enrichment_full.csv]`, wyniki dla źródeł (np. `[results/tables/gprofiler_GO_BP_results_new.csv]`) zwizualizowano.

* **topGO**:
    * Uniwersum: wszystkie unikalne `SYMBOL_final`.
    * Ontologie: BP, MF, CC. Adnotacja: `org.Mm.eg.db` (wersja zależna od Bioconductor).
    * Algorytm: "elim" (`algorithm = "elim"`), test Fishera (`statistic = "fisher"`).
    * Wyniki (top 30 terminów, `topNodes = 30`) zapisano do CSV (np. `[results/tables/topGO_BP_results_new.csv]`). Grafy GO (top 10 węzłów, `firstSigNodes = 10`) zapisano jako PDF (np. `[results/plots/topGO_GOgraph_BP.pdf]`).

---

## Oprogramowanie Statystyczne i Pakiety 💻

Wszystkie analizy przeprowadzono w **R**. Wersja R oraz wersje poszczególnych pakietów Bioconductor nie zostały jawnie zapisane w analizowanym skrypcie, jednak ich wyspecyfikowanie jest kluczowe dla pełnej odtwarzalności analiz. Kluczowe pakiety R użyte w analizie obejmowały:
`oligo`, `limma`, `pd.mogene.1.0.st.v1`, `mogene10sttranscriptcluster.db`, `AnnotationDbi`, `org.Mm.eg.db`, `tidyverse` (w tym `dplyr`, `stringr`, `ggplot2`), `pheatmap`, `ggrepel`, `fgsea`, `gprofiler2`, `topGO`, `gtools`, `Rgraphviz` oraz `igraph`.
Wynikowe tabele i wykresy zapisano w katalogach `[results/tables/]` i `[results/plots/]`.
