# Geo 

Geo is a tool for getting latitute and longitude of places around the world.

The API that gets queried for data is https://locationiq.com/

Make sure you have python2 or python3 installed as well as one of the following: wget, curl, httpie.

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

