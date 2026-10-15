# Curli (PF07012) prevalence in the human gut microbiome

Screen of the MGnify human-gut UHGP-100 protein catalogue (v2.0.2) for curli
subunit genes (Pfam **PF07012**, repeat shared by CsgA and CsgB)

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


## Data and tool citations

- MGnify human-gut v2.0.2 catalogue (Gurbich et al. 2023, *J Mol Biol*)
- UHGP protein catalogue method (Almeida et al. 2021, *Nat Biotechnol*)
- GTDB r202 taxonomy (Parks et al. 2022, *Nucleic Acids Res*)
- Pfam / PF07012 (Mistry et al. 2021, *Nucleic Acids Res*)
- HMMER (Eddy 2011, *PLoS Comput Biol*)
