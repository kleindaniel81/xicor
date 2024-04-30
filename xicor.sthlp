{smcl}
{* *! version 1.0.0  30apr2024}{...}
{vieweralsosee "[R] correlate" "help correlate"}{...}
{vieweralsosee "[R] spearman" "help spearman"}{...}
{viewerjumpto "Syntax" "xicor##syntax"}{...}
{viewerjumpto "Description" "xicor##description"}{...}
{viewerjumpto "Examples" "xicor##examples"}{...}
{viewerjumpto "Stored results" "xicor##results"}{...}
{viewerjumpto "Acknowledgements" "xicor##acknowledgements"}{...}
{viewerjumpto "References" "xicor##references"}{...}
{viewerjumpto "Support" "xicor##support"}{...}
{...}
{cmd:xicor} {hline 2} Association measurement through cross rank increments


{marker syntax}{...}
{title:Syntax}

{p 8 18 2}
{cmd:xicor}
{varlist}
{ifin}


{marker description}{...}
{title:Description}

{pstd}
The {opt xicor} command 
computes a matrix of xi correlation coefficients 
(Chatterjee, 2021).

{pstd}
The xi correlation matrix is not symmetric. 
The rows of the matrix represent Xs 
and the columns of the matrix represent Ys. 
Thus, the correlation coefficient xi(X_i,Y_j) 
is found in the {it:i}th row and {it:j}th column. 

{pstd}
Ties in the values of {it:varlist} are broken randomly (see {help sort}). 
Therefore in the presence of ties, 
the xi correlation coefficients are random. 
More specifically, the xi correlation coefficients 
depend on the current sort order of the data and 
on the {help sortseed:sortseed}.
For more than two variables, the xi coefficients 
also depend on the order of variables in {it:varlist}. 
Last, the xi correlation coefficient 
might depend on the {help set_sortmethod:sort method}.


{marker examples}{...}
{title:Example}

{pstd}Setup (see {help correlate}){p_end}
{phang2}{cmd:. webuse census13}{p_end}

{pstd}Estimate xi correlation matrix{p_end}
{phang2}{cmd:. xicor mrgrate dvcrate medage}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:xicor} stores the following in {cmd:r()}:

{synoptset 12 tabbed}{...}
{p2col 5 12 16 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}

{p2col 5 12 16 2: Matrices}{p_end}
{synopt:{cmd:r(xi)}}xi correlation matrix{p_end}


{marker acknowledgement}{...}
{title:Acknowledgements}

{pstd}
R code from
{browse "https://cran.r-project.org/web/packages/XICOR/index.html":Holmes & Chatterjee (2023)} 
was helpful for clarifying some details in Chatterjee (2021).

{pstd}
Part of the code is adapted from StataCorp 
{help mf_uniqrows:uniqrows()}.

{pstd}
A request from Eric Melse on 
{browse "https://www.statalist.org/forums/forum/general-stata-discussion/general/1751355-xicor-a-new-coefficient-of-correlation":Statalist}
led this package. 


{marker references}{...}
{title:References}

{pstd}
Chatterjee, S., Holmes, S. (2023). XICOR: Robust and generalized correlation coefficients. 
{browse "https://github.com/spholmes/XICOR"}, {browse "https://CRAN.R-project.org/package=XICOR"}

{pstd}
Chatterjee, S. (2021). A New Coefficient of Correlation. {it:Journal of the American Statistical Association,} 116(536), 2009–-2022. {browse "https://doi.org/10.1080/01621459.2020.1758115"}


{marker support}{...}
{title:Support}

{pstd}
Daniel Klein{break}
klein.daniel.81@gmail.com
