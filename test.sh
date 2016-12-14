#!/bin/bash
tmp=$(mktemp -d --tmpdir=.) || exit 1
failures=0
cleanup() {
    rm -rf $tmp
}
trap cleanup EXIT  # remove temp dir on exit

check() {
    # file sheet-attr value
    echo -en "\t$2=$3... "
    if grep "$2=$3" $1 >/dev/null; then
        echo "PASS"
    else
        echo "FAIL (expected $3, got $(grep "$2=" $1 | cut -d'=' -f2))"
        ((failures+=1))
        return 1
    fi
    return 0
}

cp testfile.sch $tmp/f1.sch
cp testfile.sch $tmp/f2.sch
cp testfile.sch $tmp/f3.sch
date="2001-02-03"
touch -m -d "$date" $tmp/*
./gsheetattr $tmp/*
for f in $tmp/*; do
    echo "Checking no options (date and filename)"

    check "$f" sheet-pagenumber "~"
    check "$f" sheet-pagetotal "~"
    check "$f" sheet-filename "$(basename $f)"
    check "$f" sheet-drawndate $date
    check "$f" sheet-drawnby "~"

done
rm -rf $tmp/*

cp testfile.sch $tmp/f1.sch
cp testfile.sch $tmp/f2.sch
cp testfile.sch $tmp/f3.sch
./gsheetattr --pages $tmp/*
numfiles=$(ls -l $tmp/* | wc -l)
i=1
for f in $tmp/*; do
    echo "Checking --pages"

    check "$f" sheet-pagenumber "$i"
    check "$f" sheet-pagetotal "$numfiles"
    check "$f" sheet-filename "$(basename $f)"
    check "$f" sheet-drawndate "$(date +%Y-%m-%d)"
    check "$f" sheet-drawnby "~"

    ((i+=1))
done
rm -rf $tmp/*

cp testfile.sch $tmp/filename.sch
./gsheetattr $tmp/filename.sch
echo "Checking filename.sch"
check $tmp/filename.sch sheet-filename "filename.sch"
rm -rf $tmp/*

cp testfile.sch $tmp/checkedby.sch
./gsheetattr --checkedby "my checkedby" $tmp/checkedby.sch
echo "Checking checkedby.sch"
check $tmp/checkedby.sch sheet-checkedby "my checkedby"
rm -rf $tmp/*

cp testfile.sch $tmp/checkedcomment.sch
./gsheetattr --checkedcomment "my checkedcomment" $tmp/checkedcomment.sch
echo "Checking checkedcomment.sch"
check $tmp/checkedcomment.sch sheet-checkedcomment "my checkedcomment"
rm -rf $tmp/*

cp testfile.sch $tmp/checkeddate.sch
./gsheetattr --checkeddate "my checkeddate" $tmp/checkeddate.sch
echo "Checking checkeddate.sch"
check $tmp/checkeddate.sch sheet-checkeddate "my checkeddate"
rm -rf $tmp/*

cp testfile.sch $tmp/drawnby.sch
./gsheetattr --drawnby "my drawnby" $tmp/drawnby.sch
echo "Checking drawnby.sch"
check $tmp/drawnby.sch sheet-drawnby "my drawnby"
rm -rf $tmp/*

cp testfile.sch $tmp/drawncomment.sch
./gsheetattr --drawncomment "my drawncomment" $tmp/drawncomment.sch
echo "Checking drawncomment.sch"
check $tmp/drawncomment.sch sheet-drawncomment "my drawncomment"
rm -rf $tmp/*

cp testfile.sch $tmp/drawndate.sch
./gsheetattr --drawndate "my drawndate" $tmp/drawndate.sch
echo "Checking drawndate.sch"
check $tmp/drawndate.sch sheet-drawndate "my drawndate"
rm -rf $tmp/*

cp testfile.sch $tmp/mfgapprovedby.sch
./gsheetattr --mfgapprovedby "my mfgapprovedby" $tmp/mfgapprovedby.sch
echo "Checking mfgapprovedby.sch"
check $tmp/mfgapprovedby.sch sheet-mfgapprovedby "my mfgapprovedby"
rm -rf $tmp/*

cp testfile.sch $tmp/mfgapprovedcomment.sch
./gsheetattr --mfgapprovedcomment "my mfgapprovedcomment" $tmp/mfgapprovedcomment.sch
echo "Checking mfgapprovedcomment.sch"
check $tmp/mfgapprovedcomment.sch sheet-mfgapprovedcomment "my mfgapprovedcomment"
rm -rf $tmp/*

cp testfile.sch $tmp/mfgapproveddate.sch
./gsheetattr --mfgapproveddate "my mfgapproveddate" $tmp/mfgapproveddate.sch
echo "Checking mfgapproveddate.sch"
check $tmp/mfgapproveddate.sch sheet-mfgapproveddate "my mfgapproveddate"
rm -rf $tmp/*

cp testfile.sch $tmp/project.sch
./gsheetattr --project "my project" $tmp/*
for f in $tmp/*; do
    echo "Checking $(basename $f)"
    check "$f" sheet-project "my project"
done
rm -rf $tmp/*

cp testfile.sch $tmp/revision.sch
./gsheetattr --rev "my revision" $tmp/*
for f in $tmp/*; do
    echo "Checking $(basename $f)"
    check "$f" sheet-revision "my revision"
done
rm -rf $tmp/*

cp testfile.sch $tmp/title.sch
./gsheetattr --title "my title" $tmp/*
for f in $tmp/*; do
    echo "Checking $(basename $f)"
    check "$f" sheet-title "my title"
done
rm -rf $tmp/*


if [ $failures -gt 0 ]; then
    echo "$failures tests FAILED"
    exit 1
else
    echo "All tests passed"
fi
