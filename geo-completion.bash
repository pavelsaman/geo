#!/usr/bin/env bash

countries_file="${HOME}/.countries"
countries=()

function _suggest_countries {
	if [[ -f $countries_file && -r $countries_file ]]; then
		while read -r country; do
			countries+=("$country")
		done < "$countries_file"
	fi
}


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
	elif (( ${COMP_CWORD} == 2 )); then
		if [[ ${COMP_WORDS[1]} = "-C" ]]; then
			_suggest_countries

			local IFS=$'\n'
			candidates=($(compgen -W "${countries[*]}" -- "${COMP_WORDS[2]}"))
		
			if (( ${#candidates[*]} != 0 )); then
				COMPREPLY=($(printf '%q\n' "${candidates[@]}" 2>/dev/null))
			else
				COMPREPLY=()
			fi
		fi
	fi	
}

complete -F _geo_completion geo
