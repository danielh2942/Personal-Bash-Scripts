#!/bin/bash
#Bear Script for crawling directories because javac fucking sucks
#Fucking piece of shit, fuck you java >:(
#It's called "Bear" because of Winnie The Pooh Obviously :)
#bears like honey, and honey comes in "Jars" Haha get it?
#Right you're gonna need to use ANT and stuff to make JARs still though lol
#2021 Daniel Hannon :)

#FLAGS
NOCLI=1
EXECFLAG=0
HELPFLAG=0
OUTPUTDIRS=0
COMPILE=1

#STRINGS
EXECPOINT=""
OUTPUT=""
BASEDIR=""

function search() {
	for file in $(ls "$1")
	do
		#current = ${1}{$file}
		if [[ ! -d ${1}/${file} ]]; then
			#recursion time
			search "${1}/${file}"
		else
			#Check if an extension is present, ignoring LICENSE files and the like
			if [[ $NOCLI == 1 ]]; then
				NOCLI=0
				OUTPUT+="$1/$file/$file.jar"
			else
				OUTPUT+=":$1/$file/$file.jar"
			fi
		fi
	done
}
#I Think I'm doing this right :)
for i in "$@"
do
	case $1 in
		-cp=*|--classpath=*)
		OUTPUT+=" -cp "
		BASEDIR="${i#*=}"
		search "$BASEDIR"
		shift ##Next Arguement
		;;
		-ex=*|--execute=*)
		EXECFLAG=1
		EXECPOINT="${i#*=}"
		shift
		;;
		-od|--outputdirs)
		OUTPUTDIRS=1
		shift
		;;
		-n|--nocompile)
		#Only use Scraper Mode
		COMPILE=0
		OUTPUTDIRS=1
		shift
		;;
		-h|--help)
		HELPFLAG=1
		echo "Bear JAR Management Utility Version 1"
		echo "Written by Daniel Hannon 2021"
		echo "This program scrapes JAR Files from a given directory for javac"
		echo "Arguements [-cp/--classpath][-ex/--execute][-n/--nocompile][-h/--help][-od/--outputdirs]"
		echo "-cp=path : This Adds a Path to scrape Jar Files from for javac"
		echo "-ex=file : This executes the code at given entry point"
		echo "-n : this scrapes the class paths given and outputs them to dependencies.txt"
		echo "-h : Displays this message"
		echo "-od : This works like -n but it allows you to compile/run code at the same time"
		break #Prevents the program from continuing
		;;
		*)
			#Do Nothing
		;;
	esac
done

if [[ $HELPFLAG == 0 ]]; then
	if [[ $COMPILE == 1]]; then
		if [[ $NOCLI == 1 ]]; then
			echo "No Arguments Passed, no scraping :)"
			exec javac *.java
		else
			exec javac $OUTPUT *.java
		fi

		if [[ $EXECFLAG == 1 ]]; then
			if [[ $NOCLI == 1 ]]; then
				exec java $EXECPOINT
			else
				exec java $OUTPUT $EXECPOINT
			fi
		fi
	fi

	if [[ $OUTPUTDIRS == 1 ]]; then
		echo $OUTPUT >> dependencies.txt
	fi
fi
