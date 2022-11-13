# A PROGRAM TO CONVERT AN ANIMAL PEDIGREE TO SIRE-MGS PEDIGREE

#################################################################################
# Disclaimer: 
# The codes below are an exact adoption of script by Yutaka Masuda, PhD.
# I, Mahboob Alam, just annotated the codes for readability enhancement with
# some minor refinements in codes for better understanding.
################################################################################

# Please: Use this program after running RENUMF90 program.

# Better not run using your raw pedigree.
# NOTE: This script assumes the pedigree and data files
#       are outputs of renumf90 program run and ids are in integer format.
#       All ids in integer format is a requirement.

#=======================================================================
# Usage: 
#   awk -v anicol=[ani] -v damcol=[dam] -f ani2smgs.awk pedfile datfile
#
# Example:
#   awk -v anicol=5 -v damcol=6 -f ani2smgs.awk renadd04.ped renf90.dat
#########################################################################


BEGIN{
   red="\033[31m"
   cyan="\033[36m"
   black="\033[0m"
   if(anicol<1){
	  print "HELP:"
      print "$ awk -v anicol=[ani] -v damcol=[dam] -f ani2smgs.awk pedfile datfile"; 
	  print "$ awk -v anicol=" cyan "5   " black "  -v damcol=" cyan "6    " black \
	        red " -f ani2smgs.awk " black " renadd04.ped renf90.dat"
      exit
   }
   
}

# When internal filehandle is pedigree file
FILENAME==ARGV[1] {
	# save sire-id($2) & damid($3) of each recoded animal($1) in renpedXX.ped
	# sire and dam are global variables
	sire[$1] = $2  
	dam [$1] = $3
	# print "reading pedigree: ", $1, $2
}


# When internal filehandle is data file
FILENAME!=ARGV[1] {
	# Now we assume pedfile is recoded by renumf90
	# Reading renumf90created datafile line-by-line

	# e.g., ani_col==5, then get its sire from the sire_hash.
	sireid = int(sire[$anicol])
	
	# e.g., dam_col==6, then get its sire from the sire_hash.
	if( damcol>0 ){ # if dam columnd index is valid
		mgsid = int(sire[$damcol])
	}else{
		mgsid = 0
	}
   
   # keep reference of all valid sires
   if( sireid>0 ){ sireped[sireid]++; }
   if( mgsid>0  ){ sireped[mgsid]++; }
   
   # add two extra columns (sireid,mgsid) in the final datafile
   print $0, sireid, mgsid > "renf90.smgs.dat"
}

# Codes below saves 10 lines of final output data which will be printed on screen at END block
FILENAME != ARGV[1] && FNR<=10  {
	tmp = sprintf ("%s %s %s", $0,sireid,mgsid);
	updated_dat[tmp]=1
}

END{
   # printing updated data head on screen	
   print " > Written updated data to 'renf90.smgs.dat' "
   print "   (check last 4 columns: aniid, damid, sireid, mgsid)" 
   for(dat in updated_dat){ print "    >", dat  }
   
   # printing updated sire-mgs head on screen	
   print " >> Written sire-mgs pedigree to 'renadd.smgs.ped'" 
   print "    sire_id sire's_sire sire's_mgs"
   cnt=0
   for(sireid in sireped){
	cnt = cnt+1
	sires_sireid = int(sire[sireid])
	sires_dam   = dam[sireid]
	sires_mgsid = int(sire[sires_dam]) # get sire's_dam's_sire
	print sireid,sires_sireid,sires_mgsid > "renadd.smgs.ped"
	if (cnt <10){
		print "    >>",sireid,sires_sireid,sires_mgsid
	}
   }
}
