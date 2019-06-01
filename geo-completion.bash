#!/usr/bin/env bash

function _geo_completion {
	if (( ${COMP_CWORD} == 1 )); then
		COMPREPLY=($(compgen -W "-c -C --lat --lon" -- "${COMP_WORDS[1]}" 2>/dev/null))
	elif (( ${COMP_CWORD} == 3 )); then
		if [[ ${COMP_WORDS[1]} = "-c" ]]; then
			COMPREPLY=($(compgen -W "-C" -- "${COMP_WORDS[3]}" 2>/dev/null))
		elif [[ ${COMP_WORDS[1]} = "-C" ]]; then
			COMPREPLY=($(compgen -W "-c" -- "${COMP_WORDS[3]}" 2>/dev/null))
		elif [[ ${COMP_WORDS[1]} = "--lat" ]]; then
			COMPREPLY=($(compgen -W "--lon" -- "${COMP_WORDS[3]}" 2>/dev/null))
		elif [[ ${COMP_WORDS[1]} = "--lon" ]]; then
			COMPREPLY=($(compgen -W "--lat" -- "${COMP_WORDS[3]}" 2>/dev/null))
		else
			return
		fi
	fi	
}

complete -F _geo_completion geo
