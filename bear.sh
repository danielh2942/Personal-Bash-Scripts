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

function destroy() {
	TEMP="${1##/*/}"
	for file in $(ls "$1" | egrep "*.jar")
	do
		if [[ $NOCLI == 1 ]]; then
			OUTPUT+=" $1/$file"
			NOCLI=0
		else
			OUTPUT+=":$1/$file"
		fi
	done
}

function search() {
	destroy "${1}"
	for subdir in $(ls "$1")
	do
		if [[ -d ${1}/${subdir} ]]; then
			search "${1}/${subdir}"
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
	if [[ $COMPILE == 1 ]]; then
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
