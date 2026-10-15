#!/usr/bin/env bash
# =============================================================================
# curli_screen.sh
# Curli (Pfam PF07012) screen of the MGnify human-gut UHGP-100 protein catalogue,
# expanded from 100%-identity cluster representatives to all member genomes.
#
# Assumes the following are already downloaded and present in $RAW (from the
# MGnify FTP server, human-gut v2.0.2):
#   genomes-all_metadata.tsv
#   uhgp-100/uhgp-100.faa      (representative protein sequences)
#   uhgp-100/uhgp-100.tsv      (cluster membership)
#   PF07012.hmm (+ pressed index, PF07012.hmm.h3*)   # from InterPro/Pfam
#
# Code was AI-assisted for clean handling; it reproduces the same results as the
# original manual process. Assumes >= 4 CPU threads (adjust --cpu as needed).
# =============================================================================
set -eu
cd ~/curli_project/raw_data

# 1. Search the 100% protein catalogue for the curli motif.
#    --cut_ga uses Pfam's curated per-family (gathering) threshold.
hmmsearch --cut_ga --cpu 4 --tblout curli_hits.tblout PF07012.hmm uhgp-100/uhgp-100.faa >/dev/null

# 2. Reference file: all representative hits with E-value and score (best first).
grep -v '^#' curli_hits.tblout | awk '{print $1"\t"$5"\t"$6}' | sort -k3,3 -gr > hits_tmp.txt
n=$(wc -l < hits_tmp.txt)
{ echo "# Curli PF07012 hits across UHGP-100 (representative proteins)"
  echo "# total hits: $n"
  echo "# protein_id    evalue    score"
  cat hits_tmp.txt; } > curli_hits_reference.txt
rm hits_tmp.txt

# 3. Unique hit representatives.
grep -v '^#' curli_hits.tblout | awk '{print $1}' | sort -u > reps.txt

# 4. Expand each representative to all member proteins of its 100% cluster,
#    reduce each to its genome ID (MGYG...), and count curli proteins per genome.
awk 'NR==FNR{reps[$1];next} ($1 in reps){print $2}' reps.txt uhgp-100/uhgp-100.tsv \
  | grep -oE 'MGYG[0-9]+' | sort | uniq -c > genome_copies.txt
awk '{print $2}' genome_copies.txt > curli_genomes.txt

# 5. Attach taxonomy (phylum, genus, species) from the metadata lineage.
awk -F'\t' '
  NR==FNR{want[$1];next}
  FNR==1{for(i=1;i<=NF;i++){if($i=="Genome")G=i;if($i=="Lineage")L=i};next}
  ($G in want){
    match($L,/p__[^;]*/); p=substr($L,RSTART+3,RLENGTH-3)
    match($L,/g__[^;]*/); g=substr($L,RSTART+3,RLENGTH-3)
    match($L,/s__[^;]*/); s=substr($L,RSTART+3,RLENGTH-3)
    print p"\t"g"\t"s}' curli_genomes.txt genomes-all_metadata.tsv > genome_tax.txt

# 6. Supplementary summary tables (label,count).
cut -f1 genome_tax.txt | sort | uniq -c | sort -rn | awk '{c=$1;$1="";sub(/^ +/,"");print $0","c}' > summary_phylum.csv
cut -f2 genome_tax.txt | sort | uniq -c | sort -rn | awk '{c=$1;$1="";sub(/^ +/,"");print $0","c}' > summary_genus.csv
awk -F'\t' '$2=="Escherichia"{print $3}' genome_tax.txt | sort | uniq -c | sort -rn \
  | awk '{c=$1;$1="";sub(/^ +/,"");print $0","c}' > summary_escherichia_species.csv

# 7. Key totals to the terminal (each count paired with its database size).
echo "Catalogue genomes:        $(tail -n +2 genomes-all_metadata.tsv | wc -l)"
echo "Representative proteins:   $(grep -c '^>' uhgp-100/uhgp-100.faa)"
echo "Representative hits:       $(wc -l < reps.txt)"
echo "Expanded curli proteins:   $(awk '{s+=$1}END{print s}' genome_copies.txt)"
pos=$(wc -l < curli_genomes.txt); tot=$(tail -n +2 genomes-all_metadata.tsv | wc -l)
awk -v p="$pos" -v t="$tot" 'BEGIN{printf "Curli-positive genomes:    %d of %d (%.2f%%)\n", p,t,100*p/t}'
echo; echo "Outputs: curli_hits_reference.txt, reps.txt, curli_genomes.txt, genome_tax.txt,"
echo "         summary_phylum.csv, summary_genus.csv, summary_escherichia_species.csv"
