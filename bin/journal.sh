#!/bin/bash
#
# A simple plain-text journal
#
# Keeps a yearly journal file in ~/journal/<year>.md
#
# To create a new journal entry, type:
# journal -n
#
# To list all entries:
# journal -l
#
# If you have a fzf utility, you can search and open an existing entry:
# journal.sh -l | fzf | xargs -o journal.sh -e
#
# If you'd like to get a preview while searching with fzf:
# journal.sh -l | fzf --preview "journal.sh -p {}" --preview-window :wrap | xargs -o journal.sh -e
#
# If you have a "highlight" utility, you can search with fzf and have the markdown highlighted:
# journal.sh -l | fzf --preview "journal.sh -p {} | highlight --syntax markdown -O ansi" --preview-window :wrap | xargs -o journal.sh -e

set -e

BASEDIR=~/journal
YEAR=$(date "+%Y")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M")
CURRENT="$BASEDIR/$YEAR.md"

new_entry() {
  if [ ! -d "$BASEDIR" ]; then
    mkdir "$BASEDIR"
  fi

  if [ ! -f "$CURRENT" ]; then
    touch "$CURRENT"
  fi

  ENTRY_FILE=$(mktemp)

  vim -c ":set syntax=markdown" \
      -c "1 s/^/# $TIMESTAMP /" \
      -c "norm $" \
      "$ENTRY_FILE"

  if [ -s "$ENTRY_FILE" ]; then
    echo "non-empty"
    cat "$ENTRY_FILE"

    RESULT=$(mktemp)

    cat "$ENTRY_FILE" "$CURRENT" > "$RESULT"
    mv "$RESULT" "$CURRENT"
  fi

  echo "done"
}

list_entries() {
  grep -r -n -E "^# [0-9]{4}-[0-9]{2}-[0-9]{2}" "$BASEDIR" || true
}

edit_line() {
  FILENAME="${1%%:*}"
  REST="${1#*:}"
  LINE="${REST%%:*}"
  vim -c "norm ${LINE}gg" -c "norm zt" "$FILENAME"
}

preview() {
  FILENAME="${1%%:*}"
  REST="${1#*:}"
  LINE="${REST%%:*}"

  FILTER="{\
    if (NR>=$LINE) {\
      if (\$0~/^# [0-9]{4}-[0-9]{2}-[0-9]{2}/ && body==1) {\
        exit\
      }\
      else if (\$0~/^# [0-9]{4}-[0-9]{2}-[0-9]{2}/) {\
        body=1\
      }\
\
      print \$0\
    }\
  }"

  awk "$FILTER" "$FILENAME"
}

usage() {
  echo "$0 {--new,--list,--edit,--help}"
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
      edit_line "$2"
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
