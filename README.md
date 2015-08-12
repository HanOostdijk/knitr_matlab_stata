# knitr_matlab_stata
knitr engines for MATLAB and Stata and an example that uses them

Building on existing knitr engines we now support MATLAB and Stata.  
Contents of this repository:
* knitr_engine_functions.r :  older version now extended with MATLAB and Stata engines
* example.rnw : an input file that shows the capabilities of knitr in general and the new engines in particular
* example1.r : contains code chunks for use with example.rnw
* stata_testfile.dta : a Stata input file
* example.pdf : the resulting pdf-file
* 
Both the rnw- and the pdf-file explain (a little) what is done. Of course the pdf-file is easier to read but the rnw-file gives all the details.

I had some timing problems with the MATLAB engine that I could only solve by introducing a waiting-time.  
Maybe you have a better solution? If so, please tell me.  
Any other comments, let me know.
