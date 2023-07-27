*! Title:       todatetime_maskfinder.ado   
*! Version:     1.0 published July 27, 2023
*! Author:      Zachary King 
*! Email:       zacharyjking90@gmail.com
*! Description: Attempts to identify mask (i.e., correct order for M, D, and Y);
*!              will not work with two-digit years or otherwise ambiguous dates 

program def todatetime_maskfinder, sclass

	* Ensure Stata runs todatetime_maskfinder using version 17 syntax
	
	version 17
	
	* Define syntax
	
	syntax varlist(max=1 string)
	
	* Count number of nonmissing string dates
	
	tempvar fake_date_string
	
	qui: gen     `fake_date_string' = subinstr(`varlist'," ","",.)
	qui: replace `fake_date_string' = subinstr(`varlist',".","",.)
	
	tempname n_nonmissing_string_dates
	
	qui: count if `fake_date_string' != ""
	local `n_nonmissing_string_dates' = r(N)
	
	* Try every combination of M, D, Y and return first combination that results
	* in same number of nonmissing values as above
	
	tempvar fake_date
	
	qui: gen `fake_date' = .
	
	foreach m1 in M D Y {
		
		foreach m2 in M D Y {
			
			if "`m2'" == "`m1'" continue
			
			foreach m3 in M D Y {
				
				if "`m3'" == "`m1'" | "`m3'" == "`m2'" continue
				
				qui: replace `fake_date' = date(`varlist', "`m1'`m2'`m3'")
				
				qui: count if `fake_date' != .
		
				if r(N) == ``n_nonmissing_string_dates'' {
					sreturn local mask = "`m1'`m2'`m3'"
					exit
				}
				
			}
			
		}

	}

end