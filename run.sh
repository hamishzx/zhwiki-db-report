#!/bin/bash

#: Database report runner
#:
#: Arguments:
#:		1) The type of reports to run (e.g. daily, tri_weekly, weekly, weekly_python)
#:
#: Author: Fastily

ZHWIKI="zhwiki"
COMMONSWIKI="commonswiki"

REPORT_DIR=./reports
SCRIPT_DIR=./

##
# Runs a MySQL query against the labs replica database and puts the result in ~/public_html/r.
#
# Arguments:
#	1) The database to use (e.g. 'enwiki', 'commonswiki')
#	2) Path(s) to the sql file(s) to execute
##
do_query() {
    for s in ${@:2}; do
        mysql --defaults-file=~/replica.my.cnf -q -r -B -N -h "${1}.analytics.db.svc.wikimedia.cloud" "${1}_p" < "${SCRIPT_DIR}/${s}.sql" > "${REPORT_DIR}/${s}.txt"
    done
}

##
# Get the intersection of two sorted reports and save the result in ~/public_html/r.
#
# Arguments:
#	1) The id of the first file to use.  This should be the smaller file (it will be loaded into memory)
#	2) The id of the second file to use.  This should be the larger file
#	3) The output file id
##
intersection() {
    awk 'NR==FNR { lines[$0]=1; next } $0 in lines' "${REPORT_DIR}/${1}.txt" "${REPORT_DIR}/${2}.txt" > "${REPORT_DIR}/${3}.txt"
}

case "$1" in
    report)
        do_query $COMMONSWIKI commonswiki
        do_query $ZHWIKI zhwiki
        intersection zhwiki commonswiki report1
        ;;
    *)
        printf "Not a known argument: %s\n\n" "$1"
        ;;
esac