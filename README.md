# Curli (PF07012) prevalence in the human gut microbiome

Screen of the MGnify human-gut UHGP-100 protein catalogue (v2.0.2) for curli
subunit genes (Pfam **PF07012**, the curlin repeat shared by CsgA and CsgB),
to estimate which gut taxa could be affected by introduced CsgC.

This repository contains the analysis code and the summary output tables for
the metagenomics section of our project.

## Summary of the method

1. Search the UHGP-100 representative proteins with the PF07012 HMM (`hmmsearch`,
   Pfam gathering threshold `--cut_ga`).
2. Expand each hit representative to all member proteins of its 100%-identity
   cluster (`uhgp-100.tsv`) and map each to its source genome (MGYG accession).
   A genome is counted only if it encodes a protein identical to a hit, so the
   expansion is exact.
3. Attach GTDB taxonomy from the catalogue metadata and tabulate curli-positive
   genomes by phylum, genus, and (within *Escherichia*) species.

See the project write-up for full Methods, Results, and interpretation.

## Requirements

- A Debian/Ubuntu-style Linux system
- `hmmer`, plus standard Unix tools (`awk`, `grep`, `sort`)
- The MGnify human-gut v2.0.2 inputs (see below)

## Inputs (not included here; download from MGnify)

From `https://www.ebi.ac.uk/metagenomics/genome-catalogues/human-gut-v2-0`
(FTP mirror `ftp.ebi.ac.uk/.../human-gut/v2.0.2/`):

- `genomes-all_metadata.tsv`
- `protein_catalogue/uhgp-100.tar.gz` -> extract to `uhgp-100/` (gives
  `uhgp-100.faa` and `uhgp-100.tsv`)

The PF07012 HMM is fetched from InterPro and indexed with `hmmpress`.

## Usage

Place the inputs in `~/curli_project/raw_data/` (or edit the path at the top of
the script), then:

```bash
bash curli_screen.sh
```

## Outputs

| File | Description |
|------|-------------|
| `curli_hits.tblout` | raw hmmsearch hit table |
| `curli_hits_reference.txt` | all representative hits with E-value and score |
| `reps.txt` | unique hit representative protein IDs |
| `curli_genomes.txt` | all curli-positive genome accessions (expanded) |
| `genome_tax.txt` | phylum, genus, species for each curli-positive genome |
| `summary_phylum.csv` | curli-positive genome count per phylum |
| `summary_genus.csv` | curli-positive genome count per genus (full list) |
| `summary_escherichia_species.csv` | *Escherichia* species breakdown |

## Key results (release v2.0.2, `--cut_ga`)

- 204 representative hits out of 36,202,010 proteins searched
- 7,187 expanded member proteins across **6,123 of 289,231 genomes (2.12%)**
- 99.9% Proteobacteria; ~85% *Escherichia*, almost all *E. coli_D*

## Data and tool citations

- MGnify human-gut v2.0.2 catalogue (Gurbich et al. 2023, *J Mol Biol*)
- UHGP protein catalogue method (Almeida et al. 2021, *Nat Biotechnol*)
- GTDB r202 taxonomy (Parks et al. 2022, *Nucleic Acids Res*)
- Pfam / PF07012 (Mistry et al. 2021, *Nucleic Acids Res*)
- HMMER (Eddy 2011, *PLoS Comput Biol*)
