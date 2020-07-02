# Geo 

Geo is a tool for getting latitute and longitude of places around the world. Reverse search is possible as well.

The API that gets queried for data is https://locationiq.com/

Make sure you have python2 or python3 installed as well as one of the following: wget, curl, httpie. If you want to use autocompletion for countries (\<tab\>\<tab\> after -C option), you need to have jq installed.

If you want to save the first result (-s or --save option), Redis has to be installed.

# Installation Steps
1) git clone or just get both of the .bash scripts as well as Makefile
2) cd geo
3) make install
4) in your .bashrc or similar: source ~/.local/bin/geo-completion.bash
5) get your API KEY on https://locationiq.com/ and export variable GEO\_API\_KEY
6) optional: for more comfortable use, add an alias to your .bashrc or similar

Uninstall with make uninstall or make clean

# Example Usage
```
$ geo.bash Prague
$ geo.bash -c Tallinn
$ geo.bash -C Estonia
$ geo.bash -c Prague -C "Czech Republic"
$ geo.bash --lat 50.0874654 --lon 14.4212535
$ geo.bash -c Lisbon -C Portugal --save
$ geo.bash -c Berlin -C Germany -s
```

# Example Output
```
$ geo.bash Prague
Prague, okres Hlavní město Praha, Hlavní město Praha, Prague, Czechia
lat: 50.0874654
lon: 14.4212535
Prague, Oklahoma, 74864, USA
lat: 35.4867369
lon: -96.6850174
Prague, Saunders County, Nebraska, USA
lat: 41.3102835
lon: -96.8083629
Prague, Grant County, Arkansas, USA
lat: 34.2867635
lon: -92.2807058
La Prague, Chinon, Indre-et-Loire, Centre-Loire Valley, Metropolitan France, 86230, France
lat: 46.9408456
lon: 0.4155891
Prague, Saint-Apollinaire-de-Rias, Privas, Ardèche, Auvergne-Rhône-Alpes, Metropolitan France, 07240, France
lat: 44.9153691
lon: 4.6018475
Pragu, Central Java, 59219, Indonesia
lat: -6.7481107
lon: 111.3365866
```

# Countries Autocompletion

The program will attempt to get all countries around the world from https://restcountries.eu/ and save the names into ~/.countries. This will run in the background, so the prompt will be given back fast.

Next time a user can use autocompletion for countries as shown below.

```
$ geo.bash -C <tab><tab>
Display all 250 possibilities? (y or n)

$ geo.bash -C Ca<tab><tab>
Cabo\ Verde      Cambodia         Cameroon         Canada           Cayman\ Islands
```

# Redis storage

The first result could be saved into Redis with -s or --save option as the 5th parameter.
The key used is taken from $GEO_REDIS_KEY environment variable, if the variable is not present or is empty, the fallback key is "places".
Members are in the following format: ${city}:${country}

Redis connection could be set by REDIS_HOSTNAME and REDIS_PORT environment variables. Fallback values are localhost and 6379 respectively.

