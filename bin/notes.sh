#!/bin/bash

set -e

DATE_FORMAT="%a, %d %b %Y %H:%M:%S %z"
BASEDIR=~/notes
PID=$$


if [ ! -d "$BASEDIR" ]; then
	mkdir -p "$BASEDIR"/{tmp,new,cur}
fi

unpack_mime() {
	FILE="$1"
	DIR="$2"

	DATE=$(grep -m 1 "^Date: " < $FILE | sed  -n "s/^Date: \(.*\)$/\1/p")
	SUBJECT=$(grep -m 1 "^Subject: " < $FILE | sed -n "s/^Subject: \(.*\)$/\1/p")
	TIMESTAMP=$(date -jf "$DATE_FORMAT" '+%s' "$DATE")

	echo $DATE
	echo $TIMESTAMP
	echo $SUBJECT
}

new_entry() {
	ENTRY_FILE=$(mktemp)

	vim -c ":set syntax=markdown" \
		-c "1 s/^/# /" \
		-c "norm $" \
		"$ENTRY_FILE"

	if [ -s "$ENTRY_FILE" ]; then
		MIME_TIMESTAMP=$(LC_ALL="en_US.UTF-8" date "+$DATE_FORMAT")
		UNIX_TIMESTAMP=$(date "+%s")
		HOSTNAME=$(hostname -s)
		SUBJECT=$(head -1 "$ENTRY_FILE")
		SUBJECT=${SUBJECT#"# "}

		RESULT=$(mktemp)
		echo "Date: $MIME_TIMESTAMP" >> "$RESULT"
		echo "Subject: $SUBJECT" >> "$RESULT"
		echo "MIME-Version: 1.0" >> "$RESULT"
		echo "Content-Type: text/plain; charset=utf-8" >> "$RESULT"
		echo "Content-Disposition: inline" >> "$RESULT"
		echo "" >> "$RESULT"
		sed "1d" < "$ENTRY_FILE" >> "$RESULT"

		#cat "$RESULT"

		FILENAME="$UNIX_TIMESTAMP.${PID}_1.${HOSTNAME}:2,S"
		mv "$RESULT" "$BASEDIR/cur/$FILENAME"

		echo "done"
	fi
}

edit_entry() {
    unpack_mime "$1" ~/scratch/notes
}

while (( "$#" )); do
  case "$1" in
    -n|--new)
      new_entry
      exit 0
      ;;
    -l|--list)
      list_entries
      exit 0
      ;;
    -e|--edit)
      if [ -z "$2" ]; then
        echo "Misssing argument for $1"
        exit 1
      fi
      edit_entry "$2"
      exit 0
      ;;
    -p|--preview)
      if [ -z "$2" ]; then
        echo "Misssing argument for $1"
        exit 1
      fi
      preview "$2"
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac

done

usage
exit 1
