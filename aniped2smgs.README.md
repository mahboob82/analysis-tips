# This aniped2smgs.awk is a modified version of the script written by Yatuka Masuda, UNE

Here is some explanations of the script.
First of all, there is no big difference in the original and the current codes.
However, this script provides help info and some additional information on execution.

# First, get a help on this script
```
awk -f aniped2smgs.awk 
```

```
HELP:
$ awk -v anicol=[ani] -v damcol=[dam] -f ani2smgs.awk  pedfile datfile
$ awk -v anicol=5     -v damcol=6     -f ani2smgs.awk  renadd04.ped renf90.dat
```
### This script assumes
* You have run "RENUMF90" program first with a maternal effect
* You have "renf90.dat" and "renaddXX.ped" files in the folder.
  (Note: It is okey if files were renamed. Just make sure proper files names are given.)
* Your animal and pedigree codes are in integer format
* You pedigree file columns are 1 for animal, 2 for sire, and 3 for dam id


## Input files
The renf90.dat looks like below. 
* Here 6th column is animal, 7th column is dam id.
* I have to input this columns info as .awk argument
```
mahboob@sas-server:~/analysis/amat_out$ head renf90.dat
 1 1 1 1 275 39559 83944
 1 2 1 2 288 62672 84170
 1 1 1 3 275 1928 84299
 2 2 1 4 288 58828 84406
 1 2 1 5 276 35776 84459
 1 1 1 6 266 12747 84489
 1 2 1 7 281 73508 84532
 1 1 1 8 278 50346 84561
 2 1 1 9 280 18409 84573
 1 1 1 10 280 40087 84598
```

The renadd04.ped looks like below: 
* Here ani, sire, dam columns are 1st, 2nd, and 3rd columns respectively
* I don't have to input them. Just make sure columns order is as given.
```
mahboob@sas-server:~/analysis/amat_out$ head renadd05.ped
 83913 101190 180193 1 0 2 1 0 0 000000035482
 122011 85384 122012 1 0 2 0 0 1 000500642213
 110670 84642 110671 1 0 2 0 0 2 000500681049
 231452 187521 170237 1 0 2 0 0 1 000501126532
 168207 90905 168208 1 0 2 0 0 1 000500652270
 266970 206248 266971 1 0 2 0 0 1 000501255775
 168140 116872 168141 1 0 2 0 0 1 000500902631
 12 91079 154028 1 0 2 1 0 0 000000023441
 14 94013 94012 1 0 2 1 0 0 000000001864
 83940 84996 90887 1 0 2 1 0 0 000000001030
```
## Run the script

``` 
awk -v anicol=6 -v damcol=7 -f aniped2smgs.awk renadd05.ped renf90.dat
```

### Output
The output shows a glimpse of files produced.
```
 > Written updated data to 'renf90.smgs.dat'
    (check last 4 columns: aniid, damid, sireid, mgsid)
    >  1 1 1 1 275 39559 83944 83945 0
    >  1 2 1 5 276 35776 84459 84460 84463
    >  1 2 1 2 288 62672 84170 84171 84175
    >  1 2 1 7 281 73508 84532 84533 84411
    >  2 1 1 9 280 18409 84573 84490 84575
    >  1 1 1 8 278 50346 84561 84490 84563
    >  1 1 1 3 275 1928 84299 84300 84304
    >  2 2 1 4 288 58828 84406 84407 84411
    >  1 1 1 6 266 12747 84489 84490 84493
 >> Written sire-mgs pedigree to 'renadd.smgs.ped'
    sire_id sire's_sire sire's_mgs
    >> 87000 84322 87003
    >> 273869 273871 273875
    >> 199882 154042 83947
    >> 96169 84496 84173
    >> 118904 83951 85102
    >> 84324 84337 84355
    >> 273744 191455 88469
    >> 87109 84417 86449
    >> 111929 87033 85517
```
### Explanation of renadd.smgs.ped
> Since awk dictionaries do not maintain order, it is hard to tell if 87000 is the sire of 39559 animal.

> But it is sure that the script has collected the SIRE of animal-39559 and then searched for its  SIRE's sire (sire of 39559)
and it's DAM's sire or MGS (sire of 39559's dam). Be careful that this MGS is not the animal's (87000) MGS, rather its the sires' MGS.

> The smgs pedigree is also not a complete pedigree. But based on those only used as animals in the datafile.

> The final output file will have much less pedigree size.

* In pedigree file the animal id 39559 goes like :
```
# animal 39559 has a sire 83945
39559  |83945|  83944

# sire 83945 has a sire 83947
83945  |83947|  83946   1 0 2 0 744 0 020140294109

# and, finally, sire 83945 has a  dam 83946 whos sire is 83951
83946  |83951| 83950    1 0 2 0 0 2 020135260322
```

* So, the final pedigree file will have a pedigree like:
39559 animal: 83945 --> 83947 --> 83951
```
83945 83947 83951
```





