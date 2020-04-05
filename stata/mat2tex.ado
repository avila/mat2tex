*! Date    : 03 Apr 2020
*! Version : 0.0.43
*! Author  : Marcelo Rainho Avila
*! Email   : m dot rainho dot avila ɑt gmɑil dot com
*! Exports a matrix as a latex table body 

/* START HELP FILE
        title[A command to export a matrix as a latex table body.]

        desc[{cmd:mat2tex}  generates a latex table body from a stata matrix. Please
        note that I am still trying to get the hang of stata's hell, I mean, help file
        system, with the help of {cmd:makehlp}. In any case, I can not yet get, for
        example, the replace out of over there under the main options, and also can not
        indicate properly the required and optional arguments, as in other help files.
        More detailed usage and exaplanations will be found at {browse
        github.com/avila/mat2tex}. Respect to stata's devs that write amazingly helpful
        help files _l⌒lo !]

        opt[matrix()   Matrix to be exported into tex (Required). ]

        opt[saving()   Filename to be exported (Required). ]

        opt2[replace  Replaces existing file (or writes a new, if inexistent.)]

        opt2[append  Appends table to existing file.]

        opt2[notiming  Do not include date and time of table creation, which is included
        by default.]

        opt2[comment()  Include additional comment that might be helpful to indentify
        the origin of table body.]

        opt2[format()  Format of each column of matrix (Default: "%12.0g").
                If only one included it is applied to all columns, otherwise it is
                applied in a 1 by 1 manner. See {stata help format} for more information
                on formating options. If less format arguments are passed than number of
                columns of matrix, I believe stata is crazy enough to cycle through the
                rest of the columns matrix with last format given by the user
                ¯\_(ツ)_/¯. 
                {cmd:mat2tex} won't check mathing lengths in formating
                arguments and matrix columns. The format options is not applied to the
                rownames (first column) ]

        opt2[rownames()  Accepts quoted strings separated blank spaces. No comma between names!. 
                It can be usefull to circunvent 32 chars maximum string lenght of
                stata's matrix rownames. Make sure to match the number of rows of the
                matrix. Presently, colnames are not used here and should be directly
                adapted in LaTeX's table headers.]

        opt2[grouptitle()  When appending sub-tables it might be useful. I have no idea 
                when I should quote or not strings in stata, but here, strings should be
                unquoted!. Note that the user has to add "\\" to tell LaTeX to break the
                line. I could do it autmatically, but maybe the flexibility might be 
                used in unexpected ways... 
        ]

        opt2[quietly  Do not print output onto results window.]

        example[ 
        {stata  sysuse auto}

        {stata  tabstat price weight mpg rep78, by(foreign) stat(mean sd min max) nototal long save}

        {stata  mat mat_to_export = r(Stat1) \ r(Stat2)}

        {stata  mat2tex using test.tex, matrix(mat_to_export) replace comment(data from auto dataset)}


        For more detailed and examples, plase see {browse www.gitgithub.com/avila/mat2tex}
        ]


        author[Marcelo Rainho Avila]
        institute[Student Assistent@DIW Berlin]
        email[mavila@diw.de]

        references[
        This program is a near shameless remix of {stata help mat2txt} from Michael Blasnik and Ben Jann. 

        -  Michael Blasnik & Ben Jann, 2004. "MAT2TXT: Stata module to write matrix to ASCII file,"

                Statistical Software Components S437601, Boston College Department of Economics, revised 28 Nov 2004. 

        This help file was created with {stata help makehlp}

        - Adrian Mander, 2012. "MAKEHLP: Stata module to automatically create a help file,

                " Statistical Software Components S457483, Boston College Department of Economics, revised 15 Mar 2019. ]
END HELP FILE */


cap program drop mat2tex
program define mat2tex
        version 10
        syntax using/, Matrix(name) [ REPLace APPend NOTIMing COMment(str) Format(str) ROWNames(str asis) GROUPtitle(str asis) QUIetly ]
	local debug 0
        if `debug' di 1 // i dont know if stata has a debugger... so bombing it with prints
        if "`format'"=="" local format "%12.0g"
        local formatn: word count `format'
        local using: subinstr local using "." ".", count(local ext)
        if !`ext' local using "`using'.tex"
        if `debug' di 1.2

        local nrows = rowsof(`matrix')
        local ncols = colsof(`matrix')

        // extract row and col names
        __QuotedFullnames `matrix' col
	if `debug' di 2.2
        if `"`rownames'"'=="" {
                __QuotedFullnames `matrix' row
        } 
        else {
        // check length of row names against table nr of rows
        local rownames_n: word count `rownames'
                if `nrows' != `rownames_n & rownames' {
                        di as error "Error: Number of matrix rows (`nrows') and given rownames (`rownames_n') do not match."
                        di as error "Note: Empty strings are allowed, if row should not be named"
                        exit
                }
        }
        if `debug' di 3

        tempname myfile
	file open `myfile' using `using', write text `append' `replace'
        if `debug' di 4

        if "`notiming'"!=="" {
                file write `myfile' `"% $S_DATE | $S_TIME "' _n
        }
        if "`comment'"!="" {
                file write `myfile' `"% `comment'"' _n
        }

        local sep =  "& " 
        // first row: col titles
        file write `myfile' "%" _tab "`sep'"
        foreach colname of local colnames {
                file write `myfile' `"`colname'"' _tab "`sep'"
        }
        file write `myfile' _n // end of 1st row

        if "`grouptitle'"!="" file write `myfile' `"`grouptitle'"' _n


        forvalues r=1/`nrows' {
                local rowname: word `r' of `rownames'
                file write `myfile' `"`rowname'"' _tab "`sep'"
                forvalues c=1/`ncols' {
                        if `c'<=`formatn' local fmt: word `c' of `format'
                        // condition so that no separator is printed on last col
                        if `c'<`ncols' file write `myfile' `fmt' (`matrix'[`r',`c']) _tab "`sep'"
                        // print new line on last col
                        if `c'==`ncols' file write `myfile' `fmt' (`matrix'[`r',`c']) " \\" _n
                }
                
        }
        file close `myfile'
        if "`quietly'" == ""   cat `using'
        di as txt `"Latex file written to {browse `using'}"'

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

