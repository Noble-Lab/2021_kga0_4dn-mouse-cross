#!/bin/bash

#  Working with...
# readr::write_tsv(
#     test.CAST.bed,
#     file = "test.CAST.bed",
#     col_names = FALSE
# )

#  And...
# readr::write_tsv(
#     tmp.df.in_alt.bed,
#     file = "tmp.df.in_alt.bed",
#     col_names = FALSE
# )


# -----------------------------------------------------------------------------
path_in="/Users/kalavattam/Downloads/to-do/get_unique_fragments/Bonora"
path_out="/Users/kalavattam/Downloads/to-do/get_unique_fragments/Bonora"
path_liftOver="/Users/kalavattam/Downloads/to-do/2021-1105-1107/liftOver"


# -----------------------------------------------------------------------------
file_prefix="test.CAST"
file_in="${file_prefix}.bed"
file_in_rename_chr="${file_prefix}.rename.bed"
file_out_lifted="${file_prefix}.lifted.bed.txt"
file_out_unlifted="${file_prefix}.unlifted.bed.txt"
file_liftOver="CAST-EiJ-to-mm10.over.chain.gz"

cat "${file_in}" \
| sed 's/chr1/CM003994.1/g' \
| sed 's/chr2/CM003995.1/g' \
| sed 's/chr3/CM003996.1/g' \
| sed 's/chr4/CM003997.1/g' \
| sed 's/chr5/CM003998.1/g' \
| sed 's/chr6/CM003999.1/g' \
| sed 's/chr7/CM004000.1/g' \
| sed 's/chr8/CM004001.1/g' \
| sed 's/chr9/CM004002.1/g' \
| sed 's/chr10/CM004003.1/g' \
| sed 's/chr11/CM004004.1/g' \
| sed 's/chr12/CM004005.1/g' \
| sed 's/chr13/CM004006.1/g' \
| sed 's/chr14/CM004007.1/g' \
| sed 's/chr15/CM004008.1/g' \
| sed 's/chr16/CM004009.1/g' \
| sed 's/chr17/CM004010.1/g' \
| sed 's/chr18/CM004011.1/g' \
| sed 's/chr19/CM004012.1/g' \
| sed 's/chrX/CM004013.1/g' \
> "${file_in_rename_chr}"

head -n 10 "${file_in_rename_chr}"
# CM003994.1  2831    2880    GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_ATGTAACAATGTGACAACACAGTGGAGCACTGTTACGCTGCTGTTTAACA
# CM003994.1  2847    2896    ATTACTCGTCTTAGCCTGGGTCTCGCCGTAATCTTA:1_ACACAGTGGAGCACTGTTACGCCACTGTTTAGCACTGTGAGATCACAGTG
# CM003994.1  2951    3000    GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_GCAGAGGGGAGGACTGTGACAACATAGTTGAGAACTTGACACCACATTTC
# CM003994.1  2951    3000    GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_GCAGAGTGGAGGACTGTGACAACATAGTTGAGAACTTGACACCACATTTC
# CM003994.1  3021    3070    ATTACTCGTCTTAGCCTGGGTCTCGCCGTAATCTTA:1_GAGCACTTTGATATCACAGTGGAGCACTCATATACCACAGTGTATCATGG
# CM003994.1  6689    6738    GAATTCGTCATTATTATTCAGCCGGCTTAGGCGAAG:0_CAGAGGAACACTGTGACAACAGAGTGCACCACCGTGCCACCAAAGTGGGG
# CM003994.1  6816    6865    GAATTCGTCATTATTATTCAGCCGGCTTAGGCGAAG:0_AGTGCAGCACTGTAAGAGCACAGAGTAGCACTGTGAAATCAGTGCAGAAT
# CM003994.1  13751   13800   ATTACTCGCCAGATACGGGGTCTCGCCGGTACTGAC:1_GTGGATTATTGTAACAGCACAGTGCAGTATTGTGACACCAAATTAGAGAA
# CM003994.1  14053   14102   ATTACTCGCCAGATACGGGGTCTCGCCGGTACTGAC:1_GCACAGTGGAGCACTGTAACACCACAGTGAGCACTGCGACAGCATAGTGG
# CM003994.1  24062   24111   ATTACTCGAACGAATTCGGGTCTCGCCGCAGGACGT:1_AAGTTAGAAAAAATGGGCTCTGAGAAACAACTATCAGAAACTACCACTGT

tail -n 10 "${file_in_rename_chr}"
# CM003994.1  200415012   200415061   ATTACTCGGATCTTCGCAGTAATGATCGTAATCTTA:0_CTTGAGGAAATTAGTAATGTGTACCTGAACAACACTCCCTGCCTTTGTTT
# CM003994.1  200415265   200415314   ATTACTCGAAGTACGCGAGTAATGATCGTATAGCCT:0_CACCAGAAGATCAAGGGAATTTATATTGCAATAATGTCAAAACTATTGGA
# CM003994.1  200415410   200415459   ATTACTCGAAGTACGCGAGTAATGATCGTATAGCCT:0_AAAGTCGTGTGTATGTGTGTGCCTCCGTGTATGTACATGCACCACATGTA
# CM003994.1  200415464   200415513   GAATTCGTCATTATTATTTTAATTAGCCCCTATCCT:0_CAGGAGACCCTTTAGGTCATAAGAATGCGTAGTTCCCCTAAAACTGGAAC
# CM003994.1  200415611   200415660   GAATTCGTCATTATTATTTTAATTAGCCCCTATCCT:0_AATAACTATAAGCATGGGATAATATTTACAGAACACTAAAAGCTGTGAAG
# CM003994.1  200416211   200416260   GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_GGTTCAAGGAGTGTCTATTCAAAGAAAGTCACCCTGACCCACCCTGACCA
# CM003994.1  200416287   200416336   GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_CTATCCTTAGGGGCTCTTAGAAACTGTCTTGAGAGTTAACAATTACCAGG
# CM003994.1  200422582   200422631   GAATTCGTTCTATCGCTGTACGATCATCCAGGACGT:2_ATCTTATGTCATGATCTTACACTTGTGCTGCAACAGGAAACCTAAAAAGT
# CM003994.1  200422720   200422769   GAATTCGTTCTATCGCTGTACGATCATCCAGGACGT:2_TCATCTCCTAGTTGGTGGTCGGTCTGTTTTGTTTTGTTTAGTTTTTTTCC
# CM003994.1  200422720   200422769   GAATTCGTTCTATCGCTGTACGATCATCCAGGACGT:2_TCATCTCCTTGTTGGTGGTGGGTCTGTTTTGTTTTGTTTAGTTTTTTTCC

# -------
start=$(date +%s)

liftOver \
-bedPlus=3 \
-tab \
"${path_in}/${file_in_rename_chr}" \
"${path_liftOver}/${file_liftOver}" \
"${path_out}/${file_out_lifted}" \
"${path_out}/${file_out_unlifted}"

end=$(date +%s)

runtime=$(echo "${end} - ${start}" | bc -l)
echo ${runtime}  # 115
# -------

head -n 10 "${file_out_lifted}"
# chr3    3011307 3011356 GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_ATGTAACAATGTGACAACACAGTGGAGCACTGTTACGCTGCTGTTTAACA
# chr3    3011323 3011372 ATTACTCGTCTTAGCCTGGGTCTCGCCGTAATCTTA:1_ACACAGTGGAGCACTGTTACGCCACTGTTTAGCACTGTGAGATCACAGTG
# chr3    3011697 3011747 GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_GCAGAGGGGAGGACTGTGACAACATAGTTGAGAACTTGACACCACATTTC
# chr3    3011697 3011747 GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_GCAGAGTGGAGGACTGTGACAACATAGTTGAGAACTTGACACCACATTTC
# chr3    3011768 3011817 ATTACTCGTCTTAGCCTGGGTCTCGCCGTAATCTTA:1_GAGCACTTTGATATCACAGTGGAGCACTCATATACCACAGTGTATCATGG
# chr3    3015270 3015319 GAATTCGTCATTATTATTCAGCCGGCTTAGGCGAAG:0_CAGAGGAACACTGTGACAACAGAGTGCACCACCGTGCCACCAAAGTGGGG
# chr3    3015396 3015444 GAATTCGTCATTATTATTCAGCCGGCTTAGGCGAAG:0_AGTGCAGCACTGTAAGAGCACAGAGTAGCACTGTGAAATCAGTGCAGAAT
# chr3    3029388 3029437 ATTACTCGCCAGATACGGGGTCTCGCCGGTACTGAC:1_GTGGATTATTGTAACAGCACAGTGCAGTATTGTGACACCAAATTAGAGAA
# chr3    3029759 3029829 ATTACTCGCCAGATACGGGGTCTCGCCGGTACTGAC:1_GCACAGTGGAGCACTGTAACACCACAGTGAGCACTGCGACAGCATAGTGG
# chr3    3042493 3042542 ATTACTCGAACGAATTCGGGTCTCGCCGCAGGACGT:1_AAGTTAGAAAAAATGGGCTCTGAGAAACAACTATCAGAAACTACCACTGT

tail -n 10 "${file_out_lifted}"
# chr1    195336383   195336432   ATTACTCGGATCTTCGCAGTAATGATCGTAATCTTA:0_CTTGAGGAAATTAGTAATGTGTACCTGAACAACACTCCCTGCCTTTGTTT
# chr1    195336636   195336685   ATTACTCGAAGTACGCGAGTAATGATCGTATAGCCT:0_CACCAGAAGATCAAGGGAATTTATATTGCAATAATGTCAAAACTATTGGA
# chr1    195336781   195336830   ATTACTCGAAGTACGCGAGTAATGATCGTATAGCCT:0_AAAGTCGTGTGTATGTGTGTGCCTCCGTGTATGTACATGCACCACATGTA
# chr1    195336835   195336884   GAATTCGTCATTATTATTTTAATTAGCCCCTATCCT:0_CAGGAGACCCTTTAGGTCATAAGAATGCGTAGTTCCCCTAAAACTGGAAC
# chr1    195336981   195337030   GAATTCGTCATTATTATTTTAATTAGCCCCTATCCT:0_AATAACTATAAGCATGGGATAATATTTACAGAACACTAAAAGCTGTGAAG
# chr1    195349208   195349257   GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_GGTTCAAGGAGTGTCTATTCAAAGAAAGTCACCCTGACCCACCCTGACCA
# chr1    195349284   195349549   GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_CTATCCTTAGGGGCTCTTAGAAACTGTCTTGAGAGTTAACAATTACCAGG
# chr1    195338516   195338565   GAATTCGTTCTATCGCTGTACGATCATCCAGGACGT:2_ATCTTATGTCATGATCTTACACTTGTGCTGCAACAGGAAACCTAAAAAGT
# chr1    195338654   195338702   GAATTCGTTCTATCGCTGTACGATCATCCAGGACGT:2_TCATCTCCTAGTTGGTGGTCGGTCTGTTTTGTTTTGTTTAGTTTTTTTCC
# chr1    195338654   195338702   GAATTCGTTCTATCGCTGTACGATCATCCAGGACGT:2_TCATCTCCTTGTTGGTGGTGGGTCTGTTTTGTTTTGTTTAGTTTTTTTCC

cat "${file_out_lifted}" | wc -l  # 108310

head -n 10 "${file_out_unlifted}"
# #Partially deleted in new
# CM003994.1  24467   24516   ATTACTCGTTATTGAGGCGGCGGAGGTCTATAGCCT:0_TGAATGATTGTTGTTCTCTGTTTAATGTTGAAACGAAAAATGGTTAAAAC
# #Partially deleted in new
# CM003994.1  34076   34125   ATTACTCGCCAGATACGGGGTCTCGCCGGTACTGAC:0_CATACATATATACATACACATAGTTGATGGGTGGAAAGTACATGTTCTAA
# #Partially deleted in new
# CM003994.1  34076   34125   ATTACTCGCCAGATACGGGGTCTCGCCGGTACTGAC:1_CATACATATATACATACACATAGTTGATGGGTGGAAAGTACATGTTCTAA
# #Partially deleted in new
# CM003994.1  51187   51236   ATTACTCGTCTTAGCCTGTAGTTCTAGACAGGACGT:0_CTGATCAAGGTGATGATGGTGGCATCTCATCTATTGGTGGTATCTTGACT
# #Deleted in new
# CM003994.1  56872   56921   GAATTCGTTAAGTCCTGATCAAGATAGTAGGCGAAG:0_GTACTGGTTAGTTCATAATGTTGTTCCACCTGTAGGGTTGCAGATCCCTT

tail -n 10 "${file_out_unlifted}"
# #Deleted in new
# CM003994.1  200383182   200383231   ATTACTCGTTATTGAGGCTAGTTCTAGAGTACTGAC:0_GATCAAAACCTCAGGTGATAGCAGATGCTGTGGAGGAAGAAAAAAATTCC
# #Deleted in new
# CM003994.1  200383416   200383465   ATTACTCGTTATTGAGGCTAGTTCTAGAGTACTGAC:0_TAATAGCCAGAAGCTGGAAATAATCCAGATGCTCCTCAAAGGAAGAAAGG
# #Split in new
# CM003994.1  200386924   200386973   GAATTCGTGCGCTATGGTCTCTAACTCGTAATCTTA:0_TGCTTGCTAAGTAGCTCCACTGGCTGGCTGGTCCAGATCTAATTCAGAAG
# #Deleted in new
# CM003994.1  200390415   200390464   GAATTCGTTGATATTGCGTACGATCATCCAGGACGT:0_GAGATCTACCAGCCTCTGCCTTCTGAGTACTGGGATTAAAGGCAAACGCC
# #Partially deleted in new
# CM003994.1  200390591   200390640   GAATTCGTTGATATTGCGTACGATCATCCAGGACGT:0_TGTTTTACACTTCTTGTTTTACCTTTCTGGCTCAAACTGTACATATTGTA

cat "${file_out_unlifted}" | wc -l  # 27446
echo $(( 27446 / 2 ))  # 13723

summation=$(( 108310 + 13723 ))  # 122033
if [[ $(cat "${file_in_rename_chr}" | wc -l) -eq ${summation} ]]; then
    echo "TRUE"
else
    echo "FALSE"
fi
#  TRUE


# -----------------
file_prefix="tmp.df.in_alt"
file_in="${file_prefix}.bed"
file_out_lifted="${file_prefix}.lifted.bed.txt"
file_out_unlifted="${file_prefix}.unlifted.bed.txt"
file_liftOver="mm10-to-CAST-EiJ.over.chain.gz"

# -------
start=$(date +%s)

liftOver \
-bedPlus=3 \
-tab \
"${path_in}/${file_in}" \
"${path_liftOver}/${file_liftOver}" \
"${path_out}/${file_out_lifted}" \
"${path_out}/${file_out_unlifted}"

end=$(date +%s)

runtime=$(echo "${end} - ${start}" | bc -l)
echo ${runtime}  # 66
# -------

head -n 10 "${file_out_lifted}"
# CM003994.1  233919  233968  GAATTCGTTCTATCGCTGTACGATCATCCAGGACGT:2_CACTTGCTCACCCTCTGCAGTCTGCATGCTGATCTGCGCAGACTGTTCTC
# CM003994.1  246370  246419  ATTACTCGTCTTAGCCTGCCAGTACTTGTATAGCCT:0_ACGAATTTTATGAATATTTTTCTTTCTCCTTTTTCTCCCCTTTCTATTTC
# CM003994.1  248316  248365  ATTACTCGAACGAATTCGTAGTTCTAGATATAGCCT:0_ATCGTGCAAGATCTGAGACAACATTAAGGAAGCAGAAAACCAGCCTGACC
# CM003994.1  276818  276867  ATTACTCGAGTCCGCTGCGTAATGATCGCAGGACGT:0_ACAATCCCTAGTGACATAATTTCTCTGTCAAGGTCCTACCTTCCAAAGGT
# CM003994.1  279092  279141  GAATTCGTGCGCGTTCATTACGATCATCAGGCGAAG:0_ATTTATTTATTTATTTATTTATTTATTTATTTATTTATTTATTATACGTA
# CM003994.1  403025  403074  ATTACTCGTTATTGAGGCTAGTTCTAGAGTACTGAC:0_CATATATGATGCTTACAGGATGATGGGCTCATTTCTAAATAATCACATAT
# CM003994.1  412963  413012  ATTACTCGGCTTGAAGAGAGATCTTGGTTATAGCCT:0_TAAAGTGAAATCACCTATTCCTAGTCATTTAGAAGCATCAAATGTTGGGT
# CM003994.1  446812  446861  GAATTCGTTCTATCGCTGAGGCGAGAGCGTACTGAC:0_TATCTGACTGCAGATAACAAGGCCCTGCCTGGCCTTGTCACATCCTGCTG
# CM003994.1  457784  457833  ATTACTCGAAGTACGCGAGGTCTCGCCGGTACTGAC:1_GAAAGCAATCTACAGATTCAATGAAATCTCCATCAAACTTCCAACTGAAT
# CM003994.1  457784  457833  ATTACTCGAAGTACGCGAGGTCTCGCCGGTACTGAC:0_GAAAGCAATCTACAGATTCAATGAAATCTCCATCAAACTTCCAACTGAAT

cat "${file_out_lifted}" | wc -l  # 920

head -n 10 "${file_out_unlifted}"
# #Deleted in new
# chr1    3341931 3341980 GAATTCGTCATTATTATTAGGCGAGAGCGTACTGAC:2_GAATATTGATTTGGCCTATTACATATAATAATTTTAAATAAAATTGATAA
# #Deleted in new
# chr1    3341931 3341980 GAATTCGTCATTATTATTAGGCGAGAGCGTACTGAC:0_GAATATTGATTTGGCCTATTACATATAATAATTTTAAATAAAATTGATAA
# #Deleted in new
# chr1    3342183 3342232 ATTACTCGAAGTACGCGAGTAATGATCGTATAGCCT:0_TTTAAAATGTTGAATAATTAAGATTTAATTTGTATATTAATAGTCAATAT
# #Deleted in new
# chr1    3342212 3342261 GAATTCGTCATTATTATTAGGCGAGAGCGTACTGAC:2_TTGTATATTAATAGTCAATATATATCTCAGAGCTTACAATTGCTTAAAAT
# #Deleted in new
# chr1    3342212 3342261 GAATTCGTCATTATTATTAGGCGAGAGCGTACTGAC:0_TTGTATATTAATAGTCAATATATATCTCAGAGCTTACAATTGCTTAAAAT

cat "${file_out_unlifted}" | wc -l  # 3476

echo $(( 3476 / 2 ))  # 1738
summation=$(( 66844 + 1738 ))  # 68582
if [[ $(cat "${file_in}" | wc -l) -eq ${summation} ]]; then
    echo "TRUE"
else
    echo "FALSE"
fi
#  TRUE


# -----------------------------------------------------------------------------
#  CHECK MUNGED
file_prefix="test.CAST"
file_in="${file_prefix}.bed"
file_in_rename_chr="${file_prefix}.rename.bed"
file_out_lifted="${file_prefix}.lifted.bed.txt"
file_out_unlifted="${file_prefix}.unlifted.bed.txt"
file_liftOver="CAST-EiJ-to-mm10.over.chain.munged"

# -------
start=$(date +%s)

liftOver \
-bedPlus=3 \
-tab \
"${path_in}/${file_in_rename_chr}" \
"${path_liftOver}/${file_liftOver}" \
"${path_out}/${file_out_lifted}" \
"${path_out}/${file_out_unlifted}"

end=$(date +%s)

runtime=$(echo "${end} - ${start}" | bc -l)
echo ${runtime}  # 1
# -------

head -n 10 "${file_out_lifted}"  #  Empty

cat "${file_out_lifted}" | wc -l  # 0

head -n 10 "${file_out_unlifted}"
# #Deleted in new
# CM003994.1  2831    2880    GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_ATGTAACAATGTGACAACACAGTGGAGCACTGTTACGCTGCTGTTTAACA
# #Deleted in new
# CM003994.1  2847    2896    ATTACTCGTCTTAGCCTGGGTCTCGCCGTAATCTTA:1_ACACAGTGGAGCACTGTTACGCCACTGTTTAGCACTGTGAGATCACAGTG
# #Deleted in new
# CM003994.1  2951    3000    GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_GCAGAGGGGAGGACTGTGACAACATAGTTGAGAACTTGACACCACATTTC
# #Deleted in new
# CM003994.1  2951    3000    GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_GCAGAGTGGAGGACTGTGACAACATAGTTGAGAACTTGACACCACATTTC
# #Deleted in new
# CM003994.1  3021    3070    ATTACTCGTCTTAGCCTGGGTCTCGCCGTAATCTTA:1_GAGCACTTTGATATCACAGTGGAGCACTCATATACCACAGTGTATCATGG

cat "${file_out_unlifted}" | wc -l  # 244066

echo $(( 244066 / 2 ))  # 122033


# -----------------
#  CHECK MUNGED
file_prefix="test.CAST"
file_in="${file_prefix}.bed"
file_out_lifted="${file_prefix}.lifted.bed.txt"
file_out_unlifted="${file_prefix}.unlifted.bed.txt"
file_liftOver="CAST-EiJ-to-mm10.over.chain.munged"

# -------
start=$(date +%s)

liftOver \
-bedPlus=3 \
-tab \
"${path_in}/${file_in}" \
"${path_liftOver}/${file_liftOver}" \
"${path_out}/${file_out_lifted}" \
"${path_out}/${file_out_unlifted}"

end=$(date +%s)

runtime=$(echo "${end} - ${start}" | bc -l)
echo ${runtime}  # 116
# -------

head -n 10 "${file_out_lifted}"
# chr3    3011307 3011356 GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_ATGTAACAATGTGACAACACAGTGGAGCACTGTTACGCTGCTGTTTAACA
# chr3    3011323 3011372 ATTACTCGTCTTAGCCTGGGTCTCGCCGTAATCTTA:1_ACACAGTGGAGCACTGTTACGCCACTGTTTAGCACTGTGAGATCACAGTG
# chr3    3011697 3011747 GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_GCAGAGGGGAGGACTGTGACAACATAGTTGAGAACTTGACACCACATTTC
# chr3    3011697 3011747 GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_GCAGAGTGGAGGACTGTGACAACATAGTTGAGAACTTGACACCACATTTC
# chr3    3011768 3011817 ATTACTCGTCTTAGCCTGGGTCTCGCCGTAATCTTA:1_GAGCACTTTGATATCACAGTGGAGCACTCATATACCACAGTGTATCATGG
# chr3    3015270 3015319 GAATTCGTCATTATTATTCAGCCGGCTTAGGCGAAG:0_CAGAGGAACACTGTGACAACAGAGTGCACCACCGTGCCACCAAAGTGGGG
# chr3    3015396 3015444 GAATTCGTCATTATTATTCAGCCGGCTTAGGCGAAG:0_AGTGCAGCACTGTAAGAGCACAGAGTAGCACTGTGAAATCAGTGCAGAAT
# chr3    3029388 3029437 ATTACTCGCCAGATACGGGGTCTCGCCGGTACTGAC:1_GTGGATTATTGTAACAGCACAGTGCAGTATTGTGACACCAAATTAGAGAA
# chr3    3029759 3029829 ATTACTCGCCAGATACGGGGTCTCGCCGGTACTGAC:1_GCACAGTGGAGCACTGTAACACCACAGTGAGCACTGCGACAGCATAGTGG
# chr3    3042493 3042542 ATTACTCGAACGAATTCGGGTCTCGCCGCAGGACGT:1_AAGTTAGAAAAAATGGGCTCTGAGAAACAACTATCAGAAACTACCACTGT

tail -n 10 "${file_out_lifted}"
# chr1    195336383   195336432   ATTACTCGGATCTTCGCAGTAATGATCGTAATCTTA:0_CTTGAGGAAATTAGTAATGTGTACCTGAACAACACTCCCTGCCTTTGTTT
# chr1    195336636   195336685   ATTACTCGAAGTACGCGAGTAATGATCGTATAGCCT:0_CACCAGAAGATCAAGGGAATTTATATTGCAATAATGTCAAAACTATTGGA
# chr1    195336781   195336830   ATTACTCGAAGTACGCGAGTAATGATCGTATAGCCT:0_AAAGTCGTGTGTATGTGTGTGCCTCCGTGTATGTACATGCACCACATGTA
# chr1    195336835   195336884   GAATTCGTCATTATTATTTTAATTAGCCCCTATCCT:0_CAGGAGACCCTTTAGGTCATAAGAATGCGTAGTTCCCCTAAAACTGGAAC
# chr1    195336981   195337030   GAATTCGTCATTATTATTTTAATTAGCCCCTATCCT:0_AATAACTATAAGCATGGGATAATATTTACAGAACACTAAAAGCTGTGAAG
# chr1    195349208   195349257   GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_GGTTCAAGGAGTGTCTATTCAAAGAAAGTCACCCTGACCCACCCTGACCA
# chr1    195349284   195349549   GAATTCGTGCGCTATGGTTAATTGACCTGTACTGAC:0_CTATCCTTAGGGGCTCTTAGAAACTGTCTTGAGAGTTAACAATTACCAGG
# chr1    195338516   195338565   GAATTCGTTCTATCGCTGTACGATCATCCAGGACGT:2_ATCTTATGTCATGATCTTACACTTGTGCTGCAACAGGAAACCTAAAAAGT
# chr1    195338654   195338702   GAATTCGTTCTATCGCTGTACGATCATCCAGGACGT:2_TCATCTCCTAGTTGGTGGTCGGTCTGTTTTGTTTTGTTTAGTTTTTTTCC
# chr1    195338654   195338702   GAATTCGTTCTATCGCTGTACGATCATCCAGGACGT:2_TCATCTCCTTGTTGGTGGTGGGTCTGTTTTGTTTTGTTTAGTTTTTTTCC

cat "${file_out_lifted}" | wc -l  # 108291

head -n 10 "${file_out_unlifted}"
# #Partially deleted in new
# chr1    24467   24516   ATTACTCGTTATTGAGGCGGCGGAGGTCTATAGCCT:0_TGAATGATTGTTGTTCTCTGTTTAATGTTGAAACGAAAAATGGTTAAAAC
# #Partially deleted in new
# chr1    34076   34125   ATTACTCGCCAGATACGGGGTCTCGCCGGTACTGAC:0_CATACATATATACATACACATAGTTGATGGGTGGAAAGTACATGTTCTAA
# #Partially deleted in new
# chr1    34076   34125   ATTACTCGCCAGATACGGGGTCTCGCCGGTACTGAC:1_CATACATATATACATACACATAGTTGATGGGTGGAAAGTACATGTTCTAA
# #Partially deleted in new
# chr1    51187   51236   ATTACTCGTCTTAGCCTGTAGTTCTAGACAGGACGT:0_CTGATCAAGGTGATGATGGTGGCATCTCATCTATTGGTGGTATCTTGACT
# #Deleted in new
# chr1    56872   56921   GAATTCGTTAAGTCCTGATCAAGATAGTAGGCGAAG:0_GTACTGGTTAGTTCATAATGTTGTTCCACCTGTAGGGTTGCAGATCCCTT

tail -n 10 "${file_out_unlifted}"
# #Deleted in new
# chr1    200383182   200383231   ATTACTCGTTATTGAGGCTAGTTCTAGAGTACTGAC:0_GATCAAAACCTCAGGTGATAGCAGATGCTGTGGAGGAAGAAAAAAATTCC
# #Deleted in new
# chr1    200383416   200383465   ATTACTCGTTATTGAGGCTAGTTCTAGAGTACTGAC:0_TAATAGCCAGAAGCTGGAAATAATCCAGATGCTCCTCAAAGGAAGAAAGG
# #Split in new
# chr1    200386924   200386973   GAATTCGTGCGCTATGGTCTCTAACTCGTAATCTTA:0_TGCTTGCTAAGTAGCTCCACTGGCTGGCTGGTCCAGATCTAATTCAGAAG
# #Deleted in new
# chr1    200390415   200390464   GAATTCGTTGATATTGCGTACGATCATCCAGGACGT:0_GAGATCTACCAGCCTCTGCCTTCTGAGTACTGGGATTAAAGGCAAACGCC
# #Partially deleted in new
# chr1    200390591   200390640   GAATTCGTTGATATTGCGTACGATCATCCAGGACGT:0_TGTTTTACACTTCTTGTTTTACCTTTCTGGCTCAAACTGTACATATTGTA

cat "${file_out_unlifted}" | wc -l  # 27484

echo $(( 27484 / 2 ))  # 13742


# -----------------
#  CHECK MUNGED
file_prefix="tmp.df.in_alt"
file_in="${file_prefix}.bed"
file_out_lifted="${file_prefix}.lifted.bed.txt"
file_out_unlifted="${file_prefix}.unlifted.bed.txt"
file_liftOver="mm10-to-CAST-EiJ.over.chain.munged"

# -------
start=$(date +%s)

liftOver \
-bedPlus=3 \
-tab \
"${path_in}/${file_in}" \
"${path_liftOver}/${file_liftOver}" \
"${path_out}/${file_out_lifted}" \
"${path_out}/${file_out_unlifted}"

end=$(date +%s)

runtime=$(echo "${end} - ${start}" | bc -l)
echo ${runtime}  # 68
# -------

head -n 10 "${file_out_lifted}"
# chr1    233919  233968  GAATTCGTTCTATCGCTGTACGATCATCCAGGACGT:2_CACTTGCTCACCCTCTGCAGTCTGCATGCTGATCTGCGCAGACTGTTCTC
# chr1    246370  246419  ATTACTCGTCTTAGCCTGCCAGTACTTGTATAGCCT:0_ACGAATTTTATGAATATTTTTCTTTCTCCTTTTTCTCCCCTTTCTATTTC
# chr1    248316  248365  ATTACTCGAACGAATTCGTAGTTCTAGATATAGCCT:0_ATCGTGCAAGATCTGAGACAACATTAAGGAAGCAGAAAACCAGCCTGACC
# chr1    276818  276867  ATTACTCGAGTCCGCTGCGTAATGATCGCAGGACGT:0_ACAATCCCTAGTGACATAATTTCTCTGTCAAGGTCCTACCTTCCAAAGGT
# chr1    279092  279141  GAATTCGTGCGCGTTCATTACGATCATCAGGCGAAG:0_ATTTATTTATTTATTTATTTATTTATTTATTTATTTATTTATTATACGTA
# chr1    403025  403074  ATTACTCGTTATTGAGGCTAGTTCTAGAGTACTGAC:0_CATATATGATGCTTACAGGATGATGGGCTCATTTCTAAATAATCACATAT
# chr1    412963  413012  ATTACTCGGCTTGAAGAGAGATCTTGGTTATAGCCT:0_TAAAGTGAAATCACCTATTCCTAGTCATTTAGAAGCATCAAATGTTGGGT
# chr1    446812  446861  GAATTCGTTCTATCGCTGAGGCGAGAGCGTACTGAC:0_TATCTGACTGCAGATAACAAGGCCCTGCCTGGCCTTGTCACATCCTGCTG
# chr1    457784  457833  ATTACTCGAAGTACGCGAGGTCTCGCCGGTACTGAC:1_GAAAGCAATCTACAGATTCAATGAAATCTCCATCAAACTTCCAACTGAAT
# chr1    457784  457833  ATTACTCGAAGTACGCGAGGTCTCGCCGGTACTGAC:0_GAAAGCAATCTACAGATTCAATGAAATCTCCATCAAACTTCCAACTGAAT

tail -n 10 "${file_out_lifted}"
# chr1    200380250   200380303   GAATTCGTTAAGTCCTGATCAAGATAGTGTACTGAC:0_GTACATAATCAATCAATCAATCAATAAATAAATCAATCTTTAAAAATAAT
# chr1    200396536   200396585   GAATTCGTGGCTTACTCCCTCTAACTCGTATAGCCT:0_CAGAAATAGCATCCCTTTATTCTAAATCTCTGTTGATCAGACATAGCTTC
# chr1    200404363   200404412   ATTACTCGAAGTACGCGAGTAATGATCGTATAGCCT:0_GGTTAGAAGGCACTGCATTCTTGGGACTCCAACCTATCTGTAAAATAAGT
# chr1    200404806   200404855   GAATTCGTGCGCTATGGTCAGAGAGGTCTATAGCCT:0_CCCTTGAAGAGAAAAAAAGCATCTGTGTTTCTCAGTGGCCTCACAGATTG
# chr1    200404872   200404921   GAATTCGTGCGCTATGGTCAGAGAGGTCTATAGCCT:0_AAATGTCAGAAGACCTGCCTCAGTGTTTCAAGGGTCTTTGTGTCCTTGAT
# chr1    200412590   200412639   GAATTCGTCATTATTATTAGGCGAGAGCGTACTGAC:0_TATTGTTGTTTCTAAGAAAGTGTCTTCTAGCCGGGCGTGGTCATGCACGC
# chr1    200414093   200414143   GAATTCGTGCGCGTTCATCAGAGAGGTCGTACTGAC:0_CTTTTAAAATGCTTTTCCAGGGAAACCTCTCAAAAAAAGAGGGGAGGGGG
# chr1    200414110   200414160   GAATTCGTGAGCGCGATGCAGAGAGGTCGTACTGAC:0_CAGGGAAACCTCTCAAAAAAAGAGGGGAGGGGGGTGCACTCCTTCATTCC
# chr1    200414110   200414160   GAATTCGTGAGCGCGATGCAGAGAGGTCGTACTGAC:1_CAGGGAAACCTCTCAAAAAAAGAGGGGAGGGGGGTGCACTCCTTCATTCC
# chr1    200414128   200414178   GAATTCGTGCGCGTTCATCAGAGAGGTCGTACTGAC:0_CCCCCGGGAGGGGGGTGCACTCCTTCATTCCCTGCAGTGAACTTTCAGAC

cat "${file_out_lifted}" | wc -l  # 66842

head -n 10 "${file_out_unlifted}"
# #Deleted in new
# chr1    3341931 3341980 GAATTCGTCATTATTATTAGGCGAGAGCGTACTGAC:2_GAATATTGATTTGGCCTATTACATATAATAATTTTAAATAAAATTGATAA
# #Deleted in new
# chr1    3341931 3341980 GAATTCGTCATTATTATTAGGCGAGAGCGTACTGAC:0_GAATATTGATTTGGCCTATTACATATAATAATTTTAAATAAAATTGATAA
# #Deleted in new
# chr1    3342183 3342232 ATTACTCGAAGTACGCGAGTAATGATCGTATAGCCT:0_TTTAAAATGTTGAATAATTAAGATTTAATTTGTATATTAATAGTCAATAT
# #Deleted in new
# chr1    3342212 3342261 GAATTCGTCATTATTATTAGGCGAGAGCGTACTGAC:2_TTGTATATTAATAGTCAATATATATCTCAGAGCTTACAATTGCTTAAAAT
# #Deleted in new
# chr1    3342212 3342261 GAATTCGTCATTATTATTAGGCGAGAGCGTACTGAC:0_TTGTATATTAATAGTCAATATATATCTCAGAGCTTACAATTGCTTAAAAT

tail -n 10 "${file_out_unlifted}"
# #Partially deleted in new
# chr1    193538786   193538835   ATTACTCGTTATTGAGGCTTGGAGTTAGGTACTGAC:0_GAAGTCGACTGCATTGTGACTCAAAACTGTGAAGGTGGGGTGCATCTGCA
# #Partially deleted in new
# chr1    193539708   193539757   GAATTCGTCATTATTATTTCAAGATAGTGTACTGAC:0_TGTGTTCATTCTTTGTATGTGTGCGTGCACACACACACATATACACACAT
# #Partially deleted in new
# chr1    193539710   193539759   GAATTCGTCATTATTATTTCAAGATAGTGTACTGAC:0_TGTTCATTCTTTGTATGTGTGCGTGCACACACACACACATATACACACAT
# #Partially deleted in new
# chr1    193539710   193539759   GAATTCGTCATTATTATTTCAAGATAGTGTACTGAC:1_TGTTCATTCTTTGTATGTGTGCGTGCACACACACACACATATACACACAT
# #Partially deleted in new
# chr1    193540107   193540156   ATTACTCGTATTGCTGGAGTAATGATCGGTACTGAC:0_GTTCTAATGTTGCCCTAATGGGCCCTGCTTTACAGGAGACTCCTGAGTGA

cat "${file_out_unlifted}" | wc -l  # 3480

echo $(( 3480 / 2 ))  # 1740


# -----------------
#TBD
# file_out_lifted="${file_prefix}.lifted.bed"
# file_out_unlifted="${file_prefix}.unlifted.bed"
