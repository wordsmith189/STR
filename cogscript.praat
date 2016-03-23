#########################################################################################
# This script automatically extracts COG measurements and related info from a TextGrid.   
# 
# INPUT 
# Script expects a sound file in .wav format and a TextGrid with two interval
# tiers: 1 - phone, 2 - word. Files must have the same name, but different file name
# extensions: .wav and .TextGrid, respectively. Script expects labels in the phone tier 
# to be either "sl" (for lexical s) or "sn" (for nonstandard s).
#
# OUTPUT
# .csv file containing:	var, word, begin, dur, cog1, cog2, cog3 and others. Some values
# will need to be added post-hoc.
# Also, some chatter in the info window.
#
# To use: Change the directoryName$ and fileName$ variables below to 
# their appropriate values.
#					                                                                                                 
# Written 2015 by Brian P. Hodge and Lars Hinrichs (texasenglish@utexas.edu).
# Use at your own risk.
#
#########################################################################################


clearinfo
appendInfoLine: "SOME INFO ON SCRIPT EXECUTION..."


# Change these variables to the respective directory and name for your files
directoryName$ = "~/CoG/"
fileName$ = "sample_10"

# These variables set themselves automatically according to the naming convention
gridName$ = fileName$ + ".TextGrid"
soundName$ = fileName$ + ".wav"

myGrid = Read from file: directoryName$ + gridName$
mySound = Read from file: directoryName$ + soundName$
soundObj$ = soundName$ - ".wav"


# Create a blank table with the appropriate headings
table = Create Table with column names:
... "table", 0, "speaker file var word begin dur preSeg folSeg cog1 cog2 cog3 gender yearBorn interviewYear style education"

select myGrid

# Get number of intervals in Tier 1 (phone tier)
nintervals_phone = Get number of intervals... 1

# Get number of intervals in Tier 2 (word tier)
nintervals_word = Get number of intervals... 2

# This loop determines all info relevant to the table, performs COG measurements, and 
# writes the results to a new row of the table. 

# We need to open the editor window so that we can perform COG measurements later
select Sound 'soundObj$'
Edit


for j from 1 to nintervals_phone
	appendInfoLine: " "
	select myGrid
	appendInfoLine: "interval on tier 1: ", j
	phone$ = Get label of interval: 1, j
	appendInfoLine: "label: ", phone$


# Set all variables to "null" to prevent fall-through assignments
	var$ = ""
	word$ = ""
	begin = 0
	end = 0
	dur = 0
	cog1 = 0
	cog2 = 0
	cog3 = 0


	if phone$ == "sl"
		var$ = "sl"

		# Get time points for interval
		begin = Get starting point: 1, j
		end = Get end point: 1, j
		dur = end - begin

		# Get points for COG
		measure1 = begin + dur / 4
		measure2 = begin + dur / 2
		measure3 = begin + dur * (3/4)




		# Get word to which sibilant belongs
		tierForWord = 2
    	intervalForWord = Get interval at time: tierForWord, measure2
    	word$ = Get label of interval: tierForWord, intervalForWord


		appendInfoLine: "phone: ", phone$
		appendInfoLine: "word: ", word$
		appendInfoLine: "begin: ", begin
		appendInfoLine: "end: ", end
		appendInfoLine: "dur: ", dur
		appendInfoLine: "m1: ", measure1 
		appendInfoLine: "m2: ", measure2
		appendInfoLine: "m3: ", measure3		


		# COG measurements
	
		# COG about measure1 (1/4 mark)
		
		selectObject(mySound)
		textGrid$ = gridName$ - ".TextGrid"
		editor Sound 'soundObj$'
		Move cursor to: measure1
		spectr = View spectral slice
		endeditor
		selectObject(spectr)
		cog1 = Get centre of gravity... 2
		#Close
		removeObject(spectr)
		
		appendInfoLine: "cog1: ", cog1


	
		# COG about measure2
		selectObject(mySound)
		textGrid$ = gridName$ - ".TextGrid"
		editor Sound 'soundObj$'
		Move cursor to... measure2
		spectr = View spectral slice
		endeditor
		selectObject(spectr)
		cog2 = Get centre of gravity... 2
		#Close
		removeObject(spectr)

		appendInfoLine: "cog2: ", cog2



		# COG about measure3
		selectObject(mySound)
		textGrid$ = gridName$ - ".TextGrid"
		editor Sound 'soundObj$'
		Move cursor to... measure3
		spectr = View spectral slice
		endeditor
		selectObject(spectr)
		cog3 = Get centre of gravity... 2
		#Close
		removeObject(spectr)

		appendInfoLine: "cog3: ", cog3


		# Write values to a new row of the table
		selectObject(table)
		Append row
		current_row = Get number of rows
		Set string value: current_row, "var", var$
		Set string value: current_row, "file", fileName$
		Set string value: current_row, "word", word$
		Set numeric value: current_row, "begin", begin
		Set numeric value: current_row, "dur", dur
		Set numeric value: current_row, "cog1", cog1
		Set numeric value: current_row, "cog2", cog2
		Set numeric value: current_row, "cog3", cog3	

	
	elsif phone$ == "sn"
		var$ = "sn"		

		# Get time points for interval
		begin = Get starting point: 1, j
		end = Get end point: 1, j
		dur = end - begin

		# Get points for COG
		measure1 = begin + (dur) / 4
		measure2 = begin + (dur) / 2
		measure3 = begin + (dur) * (3/4)
		
		# Get word to which sibilant belongs
		tierForWord = 2
    	intervalForWord = Get interval at time... tierForWord measure2
    	word$ = Get label of interval... tierForWord intervalForWord

		appendInfoLine: "phone: ", phone$
		appendInfoLine: "word: ", word$
		appendInfoLine: "begin: ", begin
		appendInfoLine: "end: ", end
		appendInfoLine: "dur: ", dur
		appendInfoLine: "m1: ", measure1 
		appendInfoLine: "m2: ", measure2
		appendInfoLine: "m3: ", measure3		
	


		# COG measurements
	
		# COG about measure1 (1/4 mark)
		selectObject(mySound)
		textGrid$ = gridName$ - ".TextGrid"
		editor Sound 'soundObj$'
		Move cursor to... measure1
		spectr = View spectral slice
		endeditor
		selectObject(spectr)
		cog1 = Get centre of gravity... 2
		#Close
		removeObject(spectr)

		appendInfoLine: "cog1: ", cog1

	
		# COG about measure2
		selectObject(mySound)
		textGrid$ = gridName$ - ".TextGrid"
		editor Sound 'soundObj$'
		Move cursor to... measure2
		spectr = View spectral slice
		endeditor
		selectObject(spectr)
		cog2 = Get centre of gravity... 2
		#Close
		removeObject(spectr)

		appendInfoLine: "cog2: ", cog2



		# COG about measure3
		selectObject(mySound)
		textGrid$ = gridName$ - ".TextGrid"
		editor Sound 'soundObj$'
		Move cursor to... measure3
		spectr = View spectral slice
		endeditor
		selectObject(spectr)
		cog3 = Get centre of gravity... 2
		#Close
		removeObject(spectr)

		appendInfoLine: "cog3: ", cog3


		# Write values to a new row of the table
		selectObject(table)
		Append row
		current_row = Get number of rows
		Set string value: current_row, "var", var$
		Set string value: current_row, "file", fileName$
		Set string value: current_row, "word", word$
		#Set numeric value: current_row, "begin", begin
		Set numeric value: current_row, "dur", dur
		Set numeric value: current_row, "cog1", cog1
		Set numeric value: current_row, "cog2", cog2
		Set numeric value: current_row, "cog3", cog3	
	else
		appendInfoLine: "This interval is neither sl nor sn."


	endif


endfor





# Now close the editor window we opened
endeditor

# Output to .csv file
selectObject(table)
Save as comma-separated file: directoryName$ + fileName$ + ".csv"
removeObject(table)
selectObject(mySound)
plusObject(myGrid)
Remove
appendInfoLine: " "
appendInfoLine: "Script executed. Look for results in ", directoryName$, fileName$, ".csv"



	
	
