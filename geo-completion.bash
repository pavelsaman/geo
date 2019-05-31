#!/usr/bin/env bash

function _geo_completion {
	if (( ${#COMP_WORDS[@]} > 4 || ${#COMP_WORDS[@]} == 3 )); then
		return
	fi
	
	if (( ${#COMP_WORDS[@]} == 2 )); then
		COMPREPLY=($(compgen -W "-c -C" "${COMP_WORDS[1]}" 2>/dev/null))
	fi

	if (( ${#COMP_WORDS[@]} == 4 )); then
		if [[ ${COMP_WORDS[1]} = "-c" ]]; then
			COMPREPLY=($(compgen -W "-C" "${COMP_WORDS[3]}" 2>/dev/null))
		fi
	fi

	if (( ${#COMP_WORDS[@]} == 4 )); then
		if [[ ${COMP_WORDS[1]} = "-C" ]]; then
			COMPREPLY=($(compgen -W "-c" "${COMP_WORDS[3]}" 2>/dev/null))
		fi
	fi	
}

complete -F _geo_completion geo
