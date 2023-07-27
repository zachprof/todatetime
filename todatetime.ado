*! Title:       todatetime.ado   
*! Version:     1.0 published July 26, 2023
*! Author:      Zachary King 
*! Email:       zacharyjking90@gmail.com
*! Description: Convert strings to datetime format

program def todatetime

	* Ensure Stata runs todatetime using version 17 syntax
	
	version 17
	
	* Define syntax
	
	syntax varlist(min=1) , infmt(string) [suffix(string) UNDO]
	
	* Set default suffix if not specified
	
	if "`suffix'" == "" local suffix "_string"
	
	* Ensure variables in varlist are strings if undo not specified
	
	if "`undo'" == "" {
		
		tempname notstring
		local `notstring' = 0
		
		foreach v of varlist `varlist' {
		
			qui: ds `v' , has(type string)
			
			if "`r(varlist)'" == "" {
				local `notstring' = ``notstring'' + 1
				di as error "variable {bf:`v'} not a string;"
			}
		
		}
		
		if ``notstring'' > 0 {
			di as error "only string variables allowed"
			exit 198
		} 
		
	}
	
	* Ensure only one variable in varlist if undo specified
	
	if "`undo'" != "" & wordcount("`varlist'") > 1 {
		di as error "too many variables; only one allowed with {bf:undo} option"
		exit 103
	}
	
	* Ensure variable in varlist is datetime format if undo specified
	
	if "`undo'" != "" {
		
		qui: ds `varlist' , has(format %t*)
		
		if "`r(varlist)'" == "" {
			di as error "variable {bf:`varlist'} not in datetime format;"
			di as error "only datetime variables allowed if {bf:undo} specified"
			exit 198
		}
		
	}
	
	* Ensure undo variable exists if undo specified
	
	if "`undo'" != "" {

		cap confirm variable `varlist'`suffix', exact
	
		if _rc != 0 {
			di as error "could not complete {bf:undo};"
			di as error "variable {bf:`varlist'`suffix'} not found;"
			di as error "use {bf:suffix} option to change suffix of {bf:`varlist'`suffix'}"
			exit 111
		}
	
	}
	
	* Ensure undo variable converts to varlist variable if undo specified
	
	if "`undo'" != "" {
		
		tempvar undo_test
		
		qui: gen `undo_test' = date(`varlist'`suffix', "`infmt'")
		
		cap assert `undo_test' == `varlist'
		
		if _rc != 0 {
			di as error "could not complete {bf:undo};"
			di as error "{bf:`varlist'} and {bf:`varlist'`suffix'} represent different dates;"
			di as error "use {bf:suffix} option to change suffix of {bf:`varlist'`suffix'} or check {bf:infmt}"
			exit 198
		}
	
	}
	
	* Reverse changes made by todatetime if undo specified
	
	tempname lab
	
	if "`undo'" != "" {
		
		local `lab': variable label `varlist'
		
		qui: drop `varlist'
		rename `varlist'`suffix' `varlist'
		
		label variable `varlist' "``lab''"
		
		exit
		
	}
	
	* Convert variables in varlist to datetime format if undo not specified
	
	foreach v of varlist `varlist' {
		
		local `lab': variable label `v'
		
		rename `v' `v'`suffix'
		
		qui: g `v' = date(`v'`suffix', "`infmt'")
		format `v' %td
		
		order `v' , before(`v'`suffix')
		
		label variable `v' "``lab''"
		label variable `v'`suffix' "``lab'' - string"
		
	}
	
	* Undo and display warning if new variable is missing for every observation
	
	foreach v of varlist `varlist' {
		
		qui: count if `v' != .
		
		if r(N) == 0 {
			
			local `lab': variable label `v'
			
			qui: drop `v'
			
			rename `v'`suffix' `v'
			label variable `v' "``lab''"
			
			di as error "Warning: {bf:`v'} could not be converted to datetime format; check {bf:infmt}"
			
		}
		
	}

end