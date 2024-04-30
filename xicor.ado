*! version 0.1.0  30apr2024
program xicor , rclass
    
    version 16.1
    
    syntax varlist(min=2 numeric) [ if ] [ in ]
    
    marksample touse
    
    quietly count if `touse'
    if (r(N) < 2) error 2000+r(N)
    
    mata : xicor_ado(tokens(st_local("varlist")),"`touse'")
    
    display as txt "(Obs=" r(N) ")"
    matlist r(xi)
    
    return add
    
end


/*  _________________________________________________________________________
                                                                     Mata  */

version 16.1


mata :


mata set matastrict   on
mata set mataoptimize on


    /*  _________________________________  entry point ado  */

void xicor_ado(
    
    string rowvector varlist,
    string scalar    touse
    
    )
{
    real matrix XY
    
    pragma unset XY
    
    
    st_view(XY,.,varlist,touse)
    
    st_matrix("r(xi)",xicor_mat(XY))
    st_matrixcolstripe("r(xi)",(J(cols(varlist),1,""),varlist'))
    st_matrixrowstripe("r(xi)",(J(cols(varlist),1,""),varlist'))
}


    /*  _________________________________  compute xi coefficients matrix  */

real matrix xicor_mat(real matrix XY)
{
    real scalar    n
    real scalar    k
    real matrix    XI
    real matrix    P
    real matrix    R
    real matrix    L
    real scalar    i, j
    
    
    n = rows(XY)
    k = cols(XY)
    
    XI = J(k,k,.)
    
    P = R = L = J(n,k,.)
    
    /*
        We rank all variables just once;
        then simply re-index the matrices.
        
        This approach is hopefully fast;
        consumes lots of memory, though.
    */
    
    for (i=k; i; i--) {
        
        P[,i] = order(XY[,i],1)         // ties broken randomly
        R[,i] = rank_highest(XY[,i],n)  // Y(j) <= Y(i)
        L[,i] = rank_highest(-XY[,i],n) // Y(j) >= Y(i)
        
    }
    
    for (i=k; i; i--) {
        
        XI[i,i] = xicor_u(R[,i],L[,i],P[,i],n)
        
        for (j=k-1; j; j--) {
            
            XI[i,j] = xicor_u(R[,j],L[,j],P[,i],n) // rows are xs
            XI[j,i] = xicor_u(R[,i],L[,i],P[,j],n) // cols are ys
            
        }
        
    }
    
    return(XI)
}


real colvector rank_highest(
    
    real colvector y,
    real scalar    n // no need to call rows() repeatedly
    
    )
{
    real colvector p
    real colvector uniqrows
    real colvector rank
    
    p = order(y,1) // so we preserve the sort order of y
    
    /*
        see StataCorp. uniqrows() 
        *! version 2.0.0  01sep2017
    */
    
    uniqrows = (1\(y[p][2::n]:!=y[p][1::n-1]))  // n x 1
    
    rank = (select((0::n-1),uniqrows)\n)[|2\.|]
    
    /*
        We follow Chatterjee & Holmes (2020) 
        XICOR on CRAN and divide the ranks by n.
        
        I think this avoids summing large numbers.
    */
    
    if (rows(rank) == 1) // y is a constant
        return( J(n,1,1 /* because we divide by n */ ) )
    
    rank = rank[quadrunningsum(uniqrows)] // expand uniq rows
    rank[p] = rank/n
    
    return(rank)
}


real scalar xicor_u(
    
    real colvector r, // divided by n
    real colvector l, // divided by n
    real colvector p,
    real scalar    n
    
    )
{
    return( // Chatterjee (2021, 2010); rearranged
        1 - 
        ( (n^2)*quadcolsum(abs(r[p][2::n]-r[p][1::n-1])) ) / 
        ( 2*(n^2)*quadcolsum(l[p]:-l[p]:^2) )
        )
}


end


exit


/*  _________________________________________________________________________
                                                              version history

0.1.0   30apr2024   bug fix when y is constant
                    change order of results matrix; rows are xs, cols are ys
                    change returned results name: r(Xi) now r(xi)
                    minor refactoring
                    add comments throughout the code
0.0.1   29apr2024   upload to Statalist
                    (https://www.statalist.org/forums/forum/general-stata-discussion/general/1751355-xicor-a-new-coefficient-of-correlation?p=1751606#post1751606)