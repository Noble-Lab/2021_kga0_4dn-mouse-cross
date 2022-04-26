#!/bin/bash

# qlogin -l mfree=2G -pe serial 6
# qlogin -l hostname=n004
# qlogin -l hostname=n015

# cd "${TMPDIR}" || ! echo "cd failed..."

# infile="Disteche_sample_7.mm10.bam"
# infile="Disteche_sample_7.CAST.bam"
infile="${1}"
# cp "/net/noble/vol8/kga0/2021_kga0_4dn-mouse-cross/results/2022-0416-0417_test-preprocessing-module/${infile}" .


#  Functions ------------------------------------------------------------------
calculateRunTime() {
    # Calculate run time for processes
    # 
    # :param 1: start time in $(date +%s) format
    # :param 2: end time in $(date +%s) format
    # :param 3: message to be displayed when printing the run time
    run_time="$(echo "${2}" - "${1}" | bc -l)"
    
    echo ""
    echo "${3}"
    echo "Run time: ${run_time} seconds."
    echo ""
}


checkDependency() {
    # Check if program is available in "${PATH}"; exit if not
    # 
    # :param 1: program to be checked (chr)
    command -v "${1}" &>/dev/null ||
        {
            echo "Exiting: ${1} not found. Install ${1}."
            exit 1
        }
}


displaySpinningIcon() {
    # Display "spinning icon" while a background process runs
    # 
    # :param 1: PID of the last program the shell ran in the background (int)
    # :param 2: message to be displayed next to the spinning icon (chr)
    spin="/|\\–"
    i=0
    while kill -0 "${1}" 2> /dev/null; do
        i=$(( (i + 1) % 4 ))
        printf "\r${spin:$i:1} %s" "${2}"
        sleep .15
    done
}


listAndTallyQnames() {
    # List and tally QNAMEs in a bam infile; function acts on a bam infile to
    # perform piped commands (samtools view, cut, sort, uniq -c, sort -nr) that
    # list and tally QNAMEs; function writes the results to a txt outfile, the
    # name of which is derived from the txt infile
    #
    # :param 1: name of bam infile, including path (chr)
    start="$(date +%s)"
    
    samtools view "${1}" \
    | cut -f 1 \
    | sort \
    | uniq -c \
    | sort -nr \
    > "${1/.bam/.QNAME.tmp.txt}" &
    displaySpinningIcon $! \
    "Running piped commands (samtools view, cut, parsort, uniq -c, parsort -nr) on $(basename "${1}")... "

    if [[ -f "${1/.bam/.QNAME.tmp.txt}" ]]; then
        cut -c 6- "${1/.bam/.QNAME.tmp.txt}" > "${1/.bam/.QNAME.txt}" &
        displaySpinningIcon $! \
        "Trimming away leading whitespaces in $(basename "${1/.bam/.QNAME.tmp.txt}")... "
    else
        echo "${1/.bam/.QNAME.tmp.txt} not found."
        return 1
    fi

    if [[ -f "${1/.bam/.QNAME.txt}" ]]; then
        rm "${1/.bam/.QNAME.tmp.txt}"
    else
        echo "${1/.bam/.QNAME.txt} not found."
        return 1
    fi
        
    end="$(date +%s)"
    echo ""
    calculateRunTime "${start}" "${end}"  \
    "List and tally QNAMEs in $(basename "${1}")."
}


identifyQnames() {
    # Using txt infile from listAndTallyQnames(), create txt files for
    # QNAME == 2; outfile names are derived from infile name; function runs the
    # following commands in succession:
    #    1. filter txt infile for 'QNAME == 2', 'QNAME > 2', or 'QNAME < 2'
    #       based on user specification; write results to new txt file
    #    2. create a txt-file list of QNAMEs without tallies from the txt file
    #       output by step 1
    #    3. if 'keep', keep the txt file output by step 1; if 'gzip', gzip the
    #       txt file output by step 1; if 'delete', rm the txt file output by
    #       step 1
    # 
    # :param 1: number of cores for parallelization (int >= 1)
    # :param 2: 'eq' (QNAME = 2), 'gt' (QNAME > 2), or 'lt' (QNAME < 2) for
    #           evaluation of QNAMEs (chr; default: 'eq')
    # :param 3: 'tmp' split files in /tmp, 'tmpdir' to split files in ${TMPDIR}
    # :param 4: txt infile, including path (chr)
    # :param 5: 'keep', 'gzip', or 'delete' txt output from step 1 (chr;
    #           default: 'delete')
    start="$(date +%s)"

    case "$(echo "${2:-"eq"}" | tr '[:upper:]' '[:lower:]')" in
        eq | e) \
            comp="\$1 == 2"
            str="eq"
            ;;
        gt | g) \
            comp="\$1 > 2"
            str="gt"
            ;;
        lt | l) \
            comp="\$1 < 2"
            str="lt"
            ;;
        *) \
            echo "Parameter 1 is not \"eq\", \"gt\", or \"lt\""
            echo "Setting parameter 1 to \"eq\""
            comp="'\$1 == 2'"
            str="eq"
            ;;
    esac

    case "$(echo "${3}" | tr '[:upper:]' '[:lower:]')" in
        tmp) \
            dir_str="tmp"  # For use on local computer
            ;;
        tmpdir) \
            dir_str="tmpdir"  # For use with GS HPC
            ;;
        *) \
            echo "Exiting: Parameter 2 is not \"tmp\" or \"tmpdir\"."
            return 1
            ;;
    esac

    #  Step 1
    # shellcheck disable=SC2016
    getQnameInParallel "${1}" \
    "${dir_str}" \
    "${comp}" \
    "${4}" \
    "${4/.txt/.${str}.tally.txt}" &
    displaySpinningIcon $! \
    "Listing QNAME entries in which \"QNAME ${str} 2\" for $(basename "${4}")... "

    #  Step 2
    cut -c 4- "${4/.txt/.${str}.tally.txt}" > "${4/.txt/.${str}.txt}"
    
    #  Step 3
    case "$(echo "${5:-"delete"}" | tr '[:upper:]' '[:lower:]')" in
        keep | k) \
            :
            ;;
        gzip | g) \
            gzip "${4/.txt/.${str}.tally.txt}"
            ;;
        delete | d) \
            rm "${4/.txt/.${str}.tally.txt}"
            ;;
        *) \
            echo "Parameter 5 is not \"keep\", \"gzip\", or \"delete\""
            echo "Will delete (rm) $(basename "${4/.txt/.${str}.tally.txt}")"
            rm "${4/.txt/.${str}.tally.txt}"
            ;;
    esac

    end="$(date +%s)"
    echo ""
    calculateRunTime "${start}" "${end}" \
    "List entries with \"QNAME ${str} 2\" for $(basename "${4}")."
}


getQnameInParallel() {
    # Select QNAME entries with a awk-comparison string input by the user,
    # e.g., '$1 == 2' or '$1 > 2' by splitting txt infile into chunks,
    # processing the chunks with awk in parallel ("pawk"), then outputting a
    # txt file for QNAME entries < 2
    # 
    # :param 1: number of cores for parallelization (int >= 1)
    # :param 2: 'tmp' split files in /tmp, 'tmpdir' to split files in ${TMPDIR}
    # :param 3: awk evaluation for a field, e.g., '$1 == 2'
    # :param 4: txt infile, including path (chr)
    # :param 5: txt outfile, including path (chr)
    case "$(echo "${2}" | tr '[:upper:]' '[:lower:]')" in
        tmp) \
            str="/tmp"  # For use on M1 MacBook Pro 2020

            gsplit -n l/"${1}" "${4}" "${str}/_pawk"$$
            ;;
        tmpdir) \
            str="${TMPDIR}"  # For use with GS HPC

            split -n l/"${1}" "${4}" "${str}/_pawk"$$
            ;;
        *) \
            echo "Exiting: Parameter 2 is not \"tmp\" or \"tmpdir\"."
            return 1
            ;;
    esac

    # shellcheck disable=SC2231
    for i in "${str}/_pawk"$$*; do
        awk "${3}" "${i}" > "${i}.out" &
    done
    wait
    cat "${str}/_pawk"$$*.out > "${5}"
    rm "${str}/_pawk"$$*
}


removeLowQualityReads() {
    # From a bam infile, remove reads with MAPQ < 30 and with flags for ‘read
    # unmapped’ (0x4) and ‘mate unmapped’ (0x8) while retaining reads with
    # flags for ‘mate paired’ (0x1) and ‘read mapped in proper pair’ (0x2);
    # outfile name is derived from infile name
    # 
    # :param 1: number of cores for parallelization (int >= 1)
    # :param 2: name of bam infile, including path (chr)
    # :param 3: name of bam outfile, including path (chr; cannot be same as bam
    #           infile)
    start="$(date +%s)"
    
    samtools view -@ "${1}" -h -b -f 3 -F 12 -q 30 "${2}" -o "${3}" &
    displaySpinningIcon $! \
    "Running samtools view (-f 3 -F 12 -q 30) on $(basename "${2}")... "

    end="$(date +%s)"
    echo ""
    calculateRunTime "${start}" "${end}"  \
    "Filter out reads based on MAPQ scores and pairing status for $(basename "${2}")."
}


retainQnameReads() {
    # Using a txt file from identifyQnamesEq2(), identifyQnamesGt2(), or
    # identifyQnamesLt2(), filter a bam infile to include reads with QNAMEs
    # listed in the txt file; write the filtered results to a bam outfile, the
    # name and path of which is user-specified
    # 
    # :param 1: name of bam infile, including path (chr)
    # :param 2: name of txt QNAME list, including path (chr)
    # :param 3: name of bam outfile, including path (chr; cannot be same as bam
    #           infile)
    start="$(date +%s)"
    
    samtools view -hN "${2}" "${1}" \
    | samtools view -b - \
    > "${3}" &
    displaySpinningIcon $! "Running samtools view -hN with $(basename "${1}") filtered by $(basename "${2}")"

    end="$(date +%s)"
    echo ""
    calculateRunTime "${start}" "${end}"  \
    "Retain reads in $(basename "${1}") based on QNAMEs in $(basename "${2}")."
}


runFlagstat() {
    # Run samtools flagstat on a bam infile
    # 
    # :param 1: number of cores for parallelization (int >= 1)
    # :param 2: name of bam infile, including path (chr)
    # :param 3: name of flagstat outfile, including path (chr)
    start="$(date +%s)"

    samtools flagstat -@ "${1}" "${2}" > "${3}" &
    displaySpinningIcon $! "Running samtools flagstat for $(basename "${2}")... "

    end="$(date +%s)"
    calculateRunTime "${start}" "${end}" \
    "Generate flag statistics for $(basename "${2}")."
}


runSortFixmate() {
    # Run samtools sort -n and fixmate on bam infile; outfile name is derived
    # from infile name
    # 
    # :param 1: number of cores for parallelization (int >= 1)
    # :param 2: name of bam infile, including path (chr)
    start="$(date +%s)"

    samtools sort -n -@ "${1}" "${2}" > "${2/.bam/.sort-n.bam}" &
    displaySpinningIcon $! "Running samtools sort -n on $(basename "${2}")... "

    samtools fixmate -@ "${1}" "${2/.bam/.sort-n.bam}" "${2/.bam/.sort-n.fixmate.bam}" &
    displaySpinningIcon $! "Running samtools fixmate on $(basename "${2/.bam/.sort-n.bam}")... "

    rm "${2/.bam/.sort-n.bam}"

    end="$(date +%s)"
    calculateRunTime "${start}" "${end}" \
    "Run samtools sort -n and samtools fixmate on $(basename "${2}")."
}


splitBamByChromosome() {
    # Run samtools view on a bam infile to split it by chromosome; bam outfile
    # name is derived from infile and chromosome names
    # 
    # :param 1: Number of cores for parallelization (int >= 1)
    # :param 2: Name of bam infile, including path (chr)
    # :param 3: Name of chromosome to split out from bam infile (chr)  #TODO Add check
    start="$(date +%s)"

    samtools view -@ "${1}" -bh "${2}" "${3}" \
    > "${2/.bam/.${3}.bam}" &
    displaySpinningIcon $! "Running samtools view to create $(basename "${2/.bam/.${3}.bam}")... "

    end="$(date +%s)"
    calculateRunTime "${start}" "${end}" \
    "Run samtools view to create $(basename "${2/.bam/.${3}.bam}")."
}


# #  Run preprocessing steps ----------------------------------------------------
# #  All metrics pertain to "Disteche_sample_7.mm10.bam" as infile
#
# removeLowQualityReads "6" \
# "${infile}" \
# "${infile/.bam/.filter.bam}"  # 411 seconds, 7.1 G
#
#
# [[ ! -f "${infile/.bam/.filter.bam}" ]] ||
#     {
#         listAndTallyQnames "${infile/.bam/.filter.bam}"
#     }  # 8000 seconds, 4.5 G, 88165342 lines
#
#
# [[ ! -f "${infile/.bam/.filter.QNAME.txt}" ]] ||
#     {
#         identifyQnames "6" "eq" "tmpdir" \
#         "${infile/.bam/.filter.QNAME.txt}" "delete"
#     }  # 415 seconds, 4.3 G, 88163217 lines
# echo $(( 88165342 - 88163217 ))  # 2125 lines difference
#
#
# [[ ! -f "${infile/.bam/.filter.QNAME.txt}" ]] ||
#     {
#         identifyQnames "6" "gt" "tmpdir" \
#         "${infile/.bam/.filter.QNAME.txt}" "delete"
#     }  # 62 seconds, 94 K, 1863 lines
# echo $(( 88165342 - 1863 ))  # 88163479 lines difference
#
#
# [[ ! -f "${infile/.bam/.filter.QNAME.txt}" ]] ||
#     {
#         identifyQnames "6" "lt" "tmpdir" \
#         "${infile/.bam/.filter.QNAME.txt}" "delete"
#     }  # 70 seconds, 14 K, 262 lines
# echo $(( 88165342 - 262 ))  # 88165080 lines difference
# echo $(( 1863 + 262 ))  # 2125 lines
#
#
# [[ ! -f "${infile/.bam/.filter.bam}" ]] ||
# [[ ! -f "${infile/.bam/.filter.QNAME.eq.txt}" ]] ||
#     {
#         retainQnameReads \
#         "${infile/.bam/.filter.bam}" \
#         "${infile/.bam/.filter.QNAME.eq.txt}" \
#         "${infile/.bam/.filter.QNAME.eq.bam}"
#     }  # 939 seconds, 7.1 G
#
# [[ ! -f "${infile/.bam/.filter.QNAME.eq.bam}" ]] ||
#     {
#         runFlagstat "6" \
#         "${infile/.bam/.filter.QNAME.eq.bam}" \
#         "${infile/.bam/.filter.QNAME.eq.flagstat.txt}"
#     }  # 34 seconds, 527 b, 176326434 records
# echo $(( 88163217 * 2 ))  # 176326434
#
#
# [[ ! -f "${infile/.bam/.filter.QNAME.eq.bam}" ]] ||
# {
#     repair -d -T 6 -c \
#     -i "${infile/.bam/.filter.QNAME.eq.bam}" \
#     -o "${infile/.bam/.filter.QNAME.eq.repair.bam}"
# }
# # All finished in 6.51 minutes
# # Total input reads: 176326434; Unpaired reads: 0
#
#
# [[ ! -f "${infile/.bam/.filter.QNAME.eq.repair.bam}" ]] ||
#     {
#         runFlagstat "6" \
#         "${infile/.bam/.filter.QNAME.eq.repair.bam}" \
#         "${infile/.bam/.filter.QNAME.eq.repair.flagstat.txt}"
#     }  # 65 seconds, 527 b, 176326434 records
#
#
# [[ ! -f "${infile/.bam/.filter.QNAME.eq.bam}" ]] ||
#     {
#         runSortFixmate "6" \
#         "${infile/.bam/.filter.QNAME.eq.bam}"
#     }  # 1652 seconds, 8.2 G
#
#
# [[ ! -f "${infile/.bam/.filter.QNAME.eq.sort-n.fixmate.bam}" ]] ||
#     {
#         runFlagstat "6" \
#         "${infile/.bam/.filter.QNAME.eq.sort-n.fixmate.bam}" \
#         "${infile/.bam/.filter.QNAME.eq.sort-n.fixmate.flagstat.txt}"
#     }  # 45 seconds, 527 b, 176326434 records


#  Run preprocessing steps ----------------------------------------------------
#  All metrics pertain to "Disteche_sample_7.CAST.bam" as infile
removeLowQualityReads "6" \
"${infile}" \
"${infile/.bam/.filter.bam}"  # 

[[ ! -f "${infile/.bam/.filter.bam}" ]] ||
    {
        listAndTallyQnames "${infile/.bam/.filter.bam}"
    }  # 


[[ ! -f "${infile/.bam/.filter.QNAME.txt}" ]] ||
    {
        identifyQnames "6" "eq" "tmpdir" \
        "${infile/.bam/.filter.QNAME.txt}" "delete"
    }  # 
# echo $(( x - y ))  # 


[[ ! -f "${infile/.bam/.filter.QNAME.txt}" ]] ||
    {
        identifyQnames "6" "gt" "tmpdir" \
        "${infile/.bam/.filter.QNAME.txt}" "delete"
    }  # 62 seconds, 94 K, 1863 lines
# echo $(( x - y ))  # 


[[ ! -f "${infile/.bam/.filter.QNAME.txt}" ]] ||
    {
        identifyQnames "6" "lt" "tmpdir" \
        "${infile/.bam/.filter.QNAME.txt}" "delete"
    }  # 70 seconds, 14 K, 262 lines
# echo $(( x - y ))  # 
# echo $(( x + y ))  # 


[[ ! -f "${infile/.bam/.filter.bam}" ]] ||
[[ ! -f "${infile/.bam/.filter.QNAME.eq.txt}" ]] ||
    {
        retainQnameReads \
        "${infile/.bam/.filter.bam}" \
        "${infile/.bam/.filter.QNAME.eq.txt}" \
        "${infile/.bam/.filter.QNAME.eq.bam}"
    }  # 


[[ ! -f "${infile/.bam/.filter.QNAME.eq.bam}" ]] ||
    {
        runFlagstat "6" \
        "${infile/.bam/.filter.QNAME.eq.bam}" \
        "${infile/.bam/.filter.QNAME.eq.flagstat.txt}"
    }  # 
# echo $(( x * 2 ))  # 


[[ ! -f "${infile/.bam/.filter.QNAME.eq.bam}" ]] ||
{
    repair -d -T 6 -c \
    -i "${infile/.bam/.filter.QNAME.eq.bam}" \
    -o "${infile/.bam/.filter.QNAME.eq.repair.bam}"
}
# All finished in 
# Total input reads: ; Unpaired reads: 


[[ ! -f "${infile/.bam/.filter.QNAME.eq.repair.bam}" ]] ||
    {
        runFlagstat "6" \
        "${infile/.bam/.filter.QNAME.eq.repair.bam}" \
        "${infile/.bam/.filter.QNAME.eq.repair.flagstat.txt}"
    }  # 


[[ ! -f "${infile/.bam/.filter.QNAME.eq.bam}" ]] ||
    {
        runSortFixmate "6" \
        "${infile/.bam/.filter.QNAME.eq.bam}"
    }  # 


[[ ! -f "${infile/.bam/.filter.QNAME.eq.sort-n.fixmate.bam}" ]] ||
    {
        runFlagstat "6" \
        "${infile/.bam/.filter.QNAME.eq.sort-n.fixmate.bam}" \
        "${infile/.bam/.filter.QNAME.eq.sort-n.fixmate.flagstat.txt}"
    }  # 
