*! 1.1.2 Ben Jann 24 Nov 2004
*! 1.1.1 M Blasnik 18 Feb 2004
cap program drop mat2tex
program define mat2tex
        version 8.2
        syntax , Matrix(name) SAVing(str) [ REPlace APPend Timing(str) COMment(str) Format(str) NOTe(str) ROWNames(str asis) QUIetly ]
	local debug 0
        if `debug' di 1
        if "`format'"=="" local format "%10.0g"
        local formatn: word count `format'
        local saving: subinstr local saving "." ".", count(local ext)
        if !`ext' local saving "`saving'.txt"
        tempname myfile
        file open `myfile' using "`saving'", write text `append' `replace'
        local nrows=rowsof(`matrix')
        local ncols=colsof(`matrix')

        __QuotedFullnames `matrix' col
	if `debug' di 2.2
        if `"`rownames'"'=="" {
                __QuotedFullnames `matrix' row
        }

        if "`timing'"!="" {
                file write `myfile' `"% $S_DATE | $S_TIME "' _n
        }
        if "`comment'"!="" {
                file write `myfile' `"% `comment'"' _n
        }

        local sep =  "& " 
        file write `myfile' "%" _tab _tab "`sep'"
        foreach colname of local colnames {
                file write `myfile' `"`colname'"' _tab _tab "`sep'"
        }
        file write `myfile' _n
        forvalues r=1/`nrows' {
                local rowname: word `r' of `rownames'
                file write `myfile' `"`rowname'"' _tab _tab "`sep'"
                forvalues c=1/`ncols' {
                        if `c'<=`formatn' local fmt: word `c' of `format'
                        file write `myfile' `fmt' (`matrix'[`r',`c']) _tab _tab "`sep'"
                }
                file write `myfile' " //" _n
        }
        if "`note'"!="" {
        file write `myfile' `"`note'"' _n
        }
        file close `myfile'
        if "`quietly'" == "" cat `saving'
        di as txt `"Latex file written to {browse `saving'}"'

end

cap program drop __QuotedFullnames
program define __QuotedFullnames
        args matrix type
        tempname extract
        local one 1
        local i one
        local j one
        if "`type'"=="row" local i k
        if "`type'"=="col" local j k
        local K = `type'sof(`matrix')
        forv k = 1/`K' {
                mat `extract' = `matrix'[``i''..``i'',``j''..``j'']
                local name: `type'names `extract'
                local eq: `type'eq `extract'
                if `"`eq'"'=="_" local eq
                else local eq `"`eq':"'
                local names `"`names'`"`eq'`name'"' "'
        }
        c_local `type'names `"`names'"'
end


cap program drop __genRowNamesFromUserInput
program define __genRowNamesFromUserInput
        syntax, comma_separated_string(str asis)
	*di "`comma_separated_string'"
        mata: x = tokens(`"`comma_separated_string'"' , " ")
	mata: nan = cols(x)
	mata: st_numscalar("n_names", nan)
	di "n `=n_names'"	
	local K = `=n_names' // check!!rowsof(`matrix')
	local rownames ""
	forv k = 1/`=n_names' {
		mata: st_local("name", x[`k'])
		local rownames `"`rownames'`"`name'"' "'
		
	}
	di `"`rownames'"'
	c_local rownames `"`rownames'"'
end

__genRowNamesFromUserInput, comma_separated_string("aaa" "bbb" "c ccc cccc" ddd "e")



__genRowNamesFromUserInput, comma_separated_string("a,  b c, d\ a ")
__genRowNamesFromUserInput, comma_separated_string(a,  "a" c, d\ a )

local title = "a b C"
mat2tex, matrix(a) saving("mat_to_txt.csv") replace  timing(`title') format(%6.0f %6.1f %5.3f) 
mat2tex, matrix(a) saving("mat_to_txt.csv") replace  timing(`title') format(%6.0f %6.1f %5.3f) rownames("fake" "b" "\alskdjcc a" "") quietly

cat mat_to_txt.csv
