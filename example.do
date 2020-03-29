sysuse auto
tabstat price weight mpg rep78, by(foreign) stat(mean sd min max) nototal long save
mat mat_to_export = r(Stat1) \ r(Stat2)
tempfile exporter_file
local NL "\\\\\\"
mat2tex using `exporter_file', matrix(mat_to_export) replace comm(data from auto dataset) ///
    format(%6.0f %6.1f %5.2f %5.2f %5.2f) rownames(    /// 
    "\rowgroupit{Domestic} `NL' mean"      ///
    "sd"                                   ///
    "min" "max"                            ///
    "\rowgroupit{Foreign} `NL' mean"       ///
    "sd"                                   ///
    "min"                                  ///
    "max" )
// for some reasons here is 6 \ to produce a doble backslash so to break a line in the table body

// place the following command at tha tex preamble or before the table
// \newcommand{\rowgroupit}[1]{\hspace{-1.5em}\textit{#1} \rule{0pt}{3ex} }

// for the indantion, the >{\quad} specification can be used
// \begin{tabular}{ >{\qquad}l rr rr }
