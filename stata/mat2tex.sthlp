{smcl}
{* *! version 1.0 30 Mar 2020}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install command2" "ssc install command2"}{...}
{vieweralsosee "Help command2 (if installed)" "help command2"}{...}
{viewerjumpto "Syntax" "mat2tex##syntax"}{...}
{viewerjumpto "Description" "mat2tex##description"}{...}
{viewerjumpto "Options" "mat2tex##options"}{...}
{viewerjumpto "Remarks" "mat2tex##remarks"}{...}
{viewerjumpto "Examples" "mat2tex##examples"}{...}
{title:Title}
{phang}
{bf:mat2tex} {hline 2} a command to export a matrix as a latex table body.

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:mat2tex}
using/
[{cmd:,}
{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt m:atrix(name)}}    Matrix to be exported into tex (Required). 

{pstd}
{p_end}
{synopt:{opt repl:ace}} replace {p_end}
{synopt:{opt app:end}}  {p_end}
{synopt:{opt notim:ing}}  {p_end}
{synopt:{opt com:ment(str)}}  {p_end}
{synopt:{opt f:ormat(str)}}  {p_end}
{synopt:{opt rown:ames(str asis)}}  {p_end}
{synopt:{opt group:title(str asis)}}  {p_end}
{synopt:{opt qui:etly}}  {p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:Description}
{pstd}
{cmd:mat2tex}  generates a latex table body from a stata matrix. Please
note that I am still trying to get the hang of stata's hell, I mean, help file
system, with the help of {cmd:makehlp}. In any case, I can not yet get, for
example, the replace out of over there under the main options, and also can not
indicate properly the required and optional arguments, as in other help files.
More detailed usage and exaplanations will be found at {browse
github.com/avila/mat2tex}. Respect to stata's devs that write amazingly helpful
help files _l⌒lo !

{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt m:atrix(name)}       Matrix to be exported into tex (Required). 

{pstd}
{p_end}
{phang}
{opt repl:ace}   Replaces existing filename (or writes a new, if inexistent.)

{pstd}
{p_end}
{phang}
{opt app:end}   Appends table to existing filename.

{pstd}
{p_end}
{phang}
{opt notim:ing}   Do not include date and time of table creation, which is included
by default.
{p_end}
{phang}
{opt com:ment(str)}   Include additional comment that might be helpful to indentify
the origin of table body.
{p_end}
{phang}
{opt f:ormat(str)}   Format of each column of matrix (Default: "%12.0g").
        If only one included it is applied to all columns, otherwise it is
        applied in a 1 by 1 manner. See {stata help format} for more information
        on formating options. If less format arguments are passed than number of
        columns of matrix, I believe stata is crazy enough to cycle through the
        rest of the columns matrix with last format given by the user
        ¯\_(ツ)_/¯. 
        {cmd:mat2tex} won't check mathing lengths in formating
        arguments and matrix columns. The format options is not applied to the
        rownames (first column) 
{p_end}
{phang}
{opt rown:ames(str asis)}   Accepts quoted strings separated blank spaces. No comma between names!. 
        It can be usefull to circunvent 32 chars maximum string lenght of
        stata's matrix rownames. Make sure to match the number of rows of the
        matrix. Presently, colnames are not used here and should be directly
        adapted in LaTeX's table headers.
{p_end}
{phang}
{opt group:title(str asis)}   When appending sub-tables it might be useful. I have no idea 
        when I should quote or not strings in stata, but here, strings should be
        unquoted!. Note that the user has to add "\\" to tell LaTeX to break the
        line. I could do it autmatically, but maybe the flexibility might be 
        used in unexpected ways... 
{p_end}
{phang}
{opt qui:etly}   Do not print output onto results window.

{pstd}
{p_end}


{marker examples}{...}
{title:Examples}
{pstd}

{pstd}
{stata  sysuse auto}

{pstd}
{stata  tabstat price weight mpg rep78, by(foreign) stat(mean sd min max) nototal long save}

{pstd}
{stata  mat mat_to_export = r(Stat1) \ r(Stat2)}

{pstd}
{stata  mat2tex using test.tex, matrix(mat_to_export) replace comm(data from auto dataset)}

{pstd}

{pstd}
For more detailed and examples, plase see {browse www.gitgithub.com/avila/mat2tex}


{title:References}
{pstd}

{pstd}
This program is a near shameless remix of {stata help mat2txt} from Michael Blasnik and Ben Jann. 

{pstd}
-  Michael Blasnik & Ben Jann, 2004. "MAT2TXT: Stata module to write matrix to ASCII file,"

{pstd}
        Statistical Software Components S437601, Boston College Department of Economics, revised 28 Nov 2004. 

{pstd}
This help file was created with {stata help makehlp}

{pstd}
- Adrian Mander, 2012. "MAKEHLP: Stata module to automatically create a help file,

{pstd}
        " Statistical Software Components S457483, Boston College Department of Economics, revised 15 Mar 2019. 


{title:Author}
{p}

Marcelo Rainho Avila, Student Assistent@DIW Berlin.

Email {browse "mailto:mavila@diw.de":mavila@diw.de}


