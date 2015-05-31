#!/bin/bash
#
# Written by: Jonathan Cordeiro
# June 17th, 2013
#
# Run this script in the 'Camera Uploads' folder
# of your Dropbox and it will sort through all
# of your pictures and place them into directories
# based on the year they were taken
#
# As of right now, this script only works with
# pictures taken by iPhones and Androids because it is 
# dependent on their naming conventions of
# YEAR-MONTH-DAY.[file_extension]
# i.e 2010-01-23.png
#
# This script currentely searches for
# .jpg, .png, .mov, and .mp4 files, but other file
# types can be supported by adding them to the list
# on line 39

# Accept start year as first argument, go through the current year

START_YEAR=$1
CURRENT_YEAR=$(date +"%Y")

# default to 2010 if no start year argument given

[ -z $1 ] && START_YEAR=2010

echo -e "start year: $START_YEAR current year: $CURRENT_YEAR"

# Make directories, supress warnings if they already exist

for DIR in $(seq $START_YEAR $CURRENT_YEAR)
do
  mkdir $DIR 2> /dev/null
  for MONTH in $(seq -w 12)
  do
    mkdir $DIR/$MONTH 2> /dev/null
  done
done

# Move photos and videos into correct folders

for DIR in $(seq $START_YEAR $CURRENT_YEAR)
do

	echo -e "\nSorting through $DIR photos and videos"

  # For each extension search through and mv the files into their new directory
  for ext in jpg png mov mp4
  do
      if [ $(ls $DIR*.$ext 2> /dev/null | wc -l) -ne 0 ]
      then
         echo " $(ls $DIR*.$ext 2> /dev/null | wc -l) .$ext files sorted for $DIR"
         mv $DIR*.$ext $DIR 2> /dev/null

         # Sort files by month as well. These files are named YYYY-MM...
         for MONTH in $(seq -w 12)
         do
           mv $DIR/$DIR-$MONTH*.$ext $DIR/$MONTH 2> /dev/null
         done
      else
         echo "No .$ext files to sort for $DIR"
      fi 
  done

done

echo -e "\nSorting completed\n"

