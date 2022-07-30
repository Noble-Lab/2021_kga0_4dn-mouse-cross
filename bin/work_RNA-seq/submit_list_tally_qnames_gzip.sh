#!/bin/bash

#  submit_list_tally_qnames_gzip.sh
#  KA


#  Parse positional arguments and set up variables ----------------------------
script="list_tally_qnames_gzip.sh"
project="${1:-"sage"}"
h_rt="${2:-"7:59:59"}"
mfree="${3:-"2G"}"
pe_serial="${4:-"1"}"
queue="${5:-"sage-short.q"}"
inpath="${6:-"./alignments_None/alignments_primary"}"

unset infiles
typeset -a infiles
while IFS=" " read -r -d $'\0'; do
    infiles+=( "${REPLY}" )
done < <(find "${inpath}" -type f -maxdepth 1 -name "*.sort-n.bam" -print0)
for i in "${infiles[@]}"; do echo "${i}"; done


#  Load module and submit jobs ------------------------------------------------
# shellcheck disable=1091
. /etc/profile.d/modules.sh
module load modules modules-init modules-gs modules-noble samtools/1.14


for i in "${infiles[@]}"; do
    qsub \
    -S "/bin/bash" \
    -R "y" \
    -P "${project}" \
    -l h_rt="${h_rt}" \
    -l mfree="${mfree}" \
    -l gpgpu=FALSE \
    -pe serial "${pe_serial}" \
    -q "${queue}" \
    -cwd \
    "${script}" \
    "${i}"
done
