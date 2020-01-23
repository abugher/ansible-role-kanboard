#!/bin/bash

changed=no
apache_path=/etc/apache2

for available in "${apache_path}"/mods-available/php[0-9].[0-9].{conf,load}; do 
  name=$(sed 's/^.*\///g' <<< "${available}")
  enabled="${apache_path}"/mods-enabled/"${name}"
  link_target=../mods-available/"${name}"
  if ! test -e "${enabled}"; then
    # -e fails on broken symbolic link.  Remove any such.
    rm -f "${enabled}"
    if ln -s "${link_target}" "${enabled}"; then
      echo "CHANGED"
    else
      exit 1
    fi
  fi
done
