{smcl}
{* *! version 1.1  Published July 27, 2023}{...}
{p2colset 2 16 18 28}{...}
{right: Version 1.1 }
{p2col:{bf:todatetime} {hline 2}}Convert strings to datetime format{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmdab:todatetime} {it:datevars}
[{cmd:,}
{it:options}]

where {it:datevars} are strings containing dates unless {opt undo} is specified

{synoptset 14 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt infmt(s1)}}defines input format of {it:datevars}; {it:s1} can be any permutation of {bf:M}, {bf:D}, and {bf:[##]Y}, with their order defining the order of month, day, and year in {it:datevars}{p_end}
{synopt:{opt suffix(s2)}}{opt todatetime} saves the original strings in {it:datevars} to new variables with the suffix {it:_string}; if {opt suffix} is specified, {it:_string} is replaced with {it:s2}{p_end}
{synopt:{opt undo}}undoes changes made by {opt todatetime}; see {browse "www.zach.prof":zach.prof} for examples{p_end}
{synopt:{opt erasestring}}Erases strings rather than saving to new variable with suffix {it:_string} or {it:s2}; changes made using {opt erasestring} cannot be undone{p_end}
{synoptline}


{p2colreset}{...}
{marker description}{...}
{title:Description}

{pstd}{opt todatetime} converts one or more date variables imported as strings to Stata's {help datetime} format.{p_end}


{marker examples}{...}
{title:Examples}

{pstd}
Examples provided at {browse "www.zach.prof":zach.prof}
{p_end}


{marker contact}{...}
{title:Author}

{pstd}
Zachary King{break}
Email: {browse "mailto:zacharyjking90@gmail.com":zacharyjking90@gmail.com}{break}
Website: {browse "www.zach.prof":zach.prof}{break}
SSRN: {browse "https://papers.ssrn.com/sol3/cf_dev/AbsByAuth.cfm?per_id=2623799":https://papers.ssrn.com}
{p_end}


{title:Acknowledgements}

{pstd}
I thank the following individuals for helpful feedback and suggestions on {opt todatetime}, this help file, and the associated documentation on {browse "www.zach.prof":zach.prof}:{p_end}

{pstd}
Diana Weng{break}
Erika Wheeler
{p_end}