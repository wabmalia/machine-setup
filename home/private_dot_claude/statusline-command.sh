#!/bin/sh
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

if [ -n "$used" ]; then
  used_int=$(printf '%.0f' "$used")
  filled=$(( used_int / 5 ))
  empty=$(( 20 - filled ))
  bar=""
  i=0
  while [ $i -lt $filled ]; do
    bar="${bar}#"
    i=$(( i + 1 ))
  done
  i=0
  while [ $i -lt $empty ]; do
    bar="${bar}-"
    i=$(( i + 1 ))
  done
  printf '%s  [%s] %d%%' "$model" "$bar" "$used_int"
else
  printf '%s  [--------------------] -%%' "$model"
fi
