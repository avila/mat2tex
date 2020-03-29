sysuse auto
tabstat price weight mpg rep78, by(foreign) stat(mean sd min max) nototal long save
mat mat_to_export = r(Stat1) \ r(Stat2)
tempfile exporter_file
if 0 { 
mat2tex using `exporter_file'.tex, matrix(mat_to_export) replace /// 
        comm(data from auto dataset) format(%9.2fc)
}

if 0 {
mat2tex using `exporter_file', matrix(mat_to_export) replace comm(data from auto dataset) ///
    format(%9.0fc %9.1fc %9.3fc %9.3fc) rownames(   /// 
    "\rowgroupit{Domestic} \\ mean"                 ///
    "sd"                                            ///
    "min"                                           ///
    "max"                                           ///
    "\rowgroupit{Foreign} \\ mean"                  ///
    "sd"                                            ///
    "min"                                           ///
    "max" )
}


if 1 {
mat group_1 = r(Stat1)
local gt  "\rowgroupit{Domestic}\\"
mat2tex using `exporter_file', matrix(group_1) replace  ///
    format(%9.0fc %9.1fc %9.3fc %9.3fc) grouptitle(`gt')

mat group_2 = r(Stat2)
mat2tex using `exporter_file', matrix(group_2) append  notiming ///
    format(%9.0fc %9.1fc %9.3fc %9.3fc) grouptitle(\rowgroupit{Foreign}\\)
}
