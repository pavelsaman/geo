#!/usr/bin/env bash

http_client=""
python=""
api_key="$GEO_API_KEY"
api_uri="https://eu1.locationiq.com/v1/search.php?key=${api_key}&q=SEARCH_PATTERN&format=json"
city=""
country=""
lat=""
lon=""
response=""

# prints help - how to use the program
function print_help {
	cat <<EOF
Version 1.0

This program provides latitude and longitude of places around the world.
Reverse search possible is possible as well.

Command Usage:
geo.bash Prague
geo.bash -c Tallinn
geo.bash -C Estonia
geo.bash -c Prague -C "Czech Republic"
geo.bash --help for printing this help
geo.bash --lat 50.0874654 --lon 14.4212535

Prerequisites:
-python2 || python3
-curl || wget || httpie
-Internet connection

MIT licence
Made by Pavel Saman
EOF
}

# checks for correct params and save city and country
function check_params {
	# there have to be between 1 and 4 params
	if (( $# > 4 || $# < 1 || $# == 3 )); then
		return 1
	fi	
	
	# if I have only 1 param
	if (( $# == 1 )); then
		# no empty query string
		[[ -z $1 ]] && return 1
		city="$1"
		return 0
	fi

	# if I have only 2 params
	if (( $# == 2 )); then
		# no empty query string
		[[ -z $2 ]] && return 1
		[[ $1 = "-c" ]] && { city="$2"; return 0; }
		[[ $1 = "-C" ]] && { country="$2"; return 0; }
		return 1
	fi
	
	# no empty query string
	[[ -z $1 || -z $3 ]] && return 1

	# 1st and 3rd have to be -c and -C, or --lat and --lon for reverse search
	if [[ $1 = "-c" ]]; then
		[[ $3 != "-C" ]] && return 1
		city="$2"
		country="$4"
		return 0
	fi

	if [[ $1 = "-C" ]]; then
		[[ $3 != "-c" ]] && return 1
		city="$4"
		country="$2"
		return 0
	fi

	if [[ $1 = "--lat" ]]; then
		[[ $3 != "--lon" ]] && return 1
		lat="$2"
		lon="$4"
		return 0
	fi

	if [[ $1 = "--lon" ]]; then
		[[ $3 != "--lat" ]] && return 1
		lat="$4"
		lon="$2"
		return 0
	fi

	return 1
}

# checks if the api_key is set
function check_api_key {
	[[ -z $api_key ]] && return 1
	return 0
}

# gets a HTTP client - if none, returns 1
function get_http_client {
	if wget -V >/dev/null 2>&1; then
		http_client="wget"
	elif curl -V >/dev/null 2>&1; then
		echo "curl"
		http_client="curl"
	elif http --version >/dev/null 2>&1; then
		http_client="http"
	else
		return 1
	fi

	return 0
}

# checks if Python 2 or 3 is available - if not return 1
function check_python {
	python2 -V >/dev/null 2>&1 && { python="2"; return 0; }
	python3 -V >/dev/null 2>&1 && { python="3"; return 0; }
	return 1
}

# performs a http request
function get_resource {
	[[ -n $city && -z $country ]] && api_uri=${api_uri//q=SEARCH_PATTERN/city=${city}} 
	[[ -z $city && -n $country ]] && api_uri=${api_uri//q=SEARCH_PATTERN/country=${country}}
	[[ -n $city && -n $country ]] && api_uri=${api_uri//SEARCH_PATTERN/${city},${country}}
	[[ -n $lat && -n $lon ]] && { api_uri=${api_uri//search/reverse}; api_uri=${api_uri//q=SEARCH_PATTERN/lat=${lat}&lon=${lon}}; }

	case $http_client in
		curl)
			response=$(curl -s --request GET "$api_uri")
			;;
		wget)
			response=$(wget -qO- "$api_uri")
			;;
		http)
			response=$(http -b GET "$api_uri")
			;;
	esac

	[[ -z $response ]] && return 1
	return 0
}

# prints data from http response; different for python 2 and 3
function print_response {
	(( number_of_results=$(echo "$response" | grep -o "display_name" | wc -l) ))
	
	if [[ $python = "2" ]]; then
		for (( i=0; i < number_of_results; i++ )); do
			if [[ -n $lat ]]; then
				echo "$response" | python2 -c "import sys, json; print json.load(sys.stdin)['display_name']"
				printf "lat: "
				echo "$response" | python2 -c "import sys, json; print json.load(sys.stdin)['lat']"
				printf "lon: "
				echo "$response" | python2 -c "import sys, json; print json.load(sys.stdin)['lon']"
			else
				echo "$response" | python2 -c "import sys, json; print json.load(sys.stdin)[$i]['display_name']"
				printf "lat: "
				echo "$response" | python2 -c "import sys, json; print json.load(sys.stdin)[$i]['lat']"
				printf "lon: "
				echo "$response" | python2 -c "import sys, json; print json.load(sys.stdin)[$i]['lon']"
			fi
		done
	else
		for (( i=0; i < number_of_results; i++ )); do
			if [[ -n $lat ]]; then
				echo "$response" | python2 -c "import sys, json; print(json.load(sys.stdin)['display_name'])"
				printf "lat: "
				echo "$response" | python2 -c "import sys, json; print(json.load(sys.stdin)['lat'])"
				printf "lon: "
				echo "$response" | python2 -c "import sys, json; print(json.load(sys.stdin)['lon'])"
			else
				echo "$response" | python3 -c "import sys, json; print(json.load(sys.stdin)[$i]['display_name'])"
				printf "lat: "
				echo "$response" | python3 -c "import sys, json; print(json.load(sys.stdin)[$i]['lat'])"
				printf "lon: "
				echo "$response" | python3 -c "import sys, json; print(json.load(sys.stdin)[$i]['lon'])"
			fi
		done
	fi
}

case "$1" in
	h | H | help | HELP | --help | --HELP | -h | -H)
		print_help
		;;
	*)
		check_params "$@" || { echo "Wrong parameters. Check --help."; exit 1; }
		check_api_key || { echo 'GEO_API_KEY was not found among exported variables. Cannot continue.'; exit 1; }
		get_http_client || { echo "None of the following is installed: wget, curl, httpie. Cannot continue."; exit 1; }
		check_python || { echo "Your python (os just a symlink) is not in version 2, nor 3. Cannot continue."; exit 1; }
		get_resource "$api_uri" || { echo "An error occured when getting the resource. Cannot continue."; exit 1; }
		print_response
		;;
esac	

exit 0
