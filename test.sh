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
    check "$f" sheet-date $date
    check "$f" sheet-author "~"

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
    check "$f" sheet-date "$(date +%Y-%m-%d)"
    check "$f" sheet-author "~"

    ((i+=1))
done
rm -rf $tmp/*

cp testfile.sch $tmp/filename.sch
./gsheetattr $tmp/filename.sch
echo "Checking filename.sch"
check $tmp/filename.sch sheet-filename "filename.sch"
rm -rf $tmp/*

cp testfile.sch $tmp/author.sch
./gsheetattr --author "my author" $tmp/author.sch
echo "Checking author.sch"
check $tmp/author.sch sheet-author "my author"
rm -rf $tmp/*

cp testfile.sch $tmp/date.sch
./gsheetattr --date "my date" $tmp/date.sch
echo "Checking date.sch"
check $tmp/date.sch sheet-date "my date"
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
