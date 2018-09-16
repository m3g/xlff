#
# Script to plot Lmax as a function of the percentage cutoff
#
# Run with: julia lmax.jl file1.dat lmax.pdf [user_max_d]
#
# file1.dat:
# File containing the CB-CB distances for all Nz-Nz distances
# smaller than the linker length. d(CB-CB) distances must be
# in column 2 
#
# lmax.pdf
# the name of the plot that will generated
#
# user_max_d is an optional real parameter indicating the maximum
# tolerated distance, assuming that something greater than that is 
# probably an error
#
# In the examples, the files have names as 
# file1 = ./data/KK_I_CB_t
#
# so, run with:  julia lmax.jl ./data/KK_I_CB_t KK_lmax.pdf
#
# L. Martinez - IQ/UNICAMP; Sep 16, 2018
#

using PyPlot
using LaTeXStrings
using Printf

let LmaxTest

  include("read_data.jl")

  file1 = ARGS[1]
  plot1 = ARGS[2]
  
  ndata_read, dnz_read, dcb_read = read_data(file1,cols=[1,2])

  Lmax = [ 0. for i in 1:100 ]
  p_Lmax = [ Float64(i)/100. for i in 1:100 ]
          
  # Removing outliers (data that does not fit user_max_d)

  if length(ARGS) == 3
    user_max_d = parse(Float64,ARGS[3])
    nremove = 0
    for i in 1:ndata_read
      if dcb_read[i] > user_max_d
        nremove = nremove + 1
      end
    end
    remfrac = @sprintf "%.2f" 100*float(nremove)/ndata_read
    println(" Will remove ", nremove, 
            " (", remfrac, "%) points with d > user_max_d ")
    ndata = ndata_read - nremove
    dnz = Vector{Float64}(undef,ndata)
    dcb = Vector{Float64}(undef,ndata)
    j = 0
    for i in 1:ndata_read
      if dcb_read[i] <= user_max_d
        j = j + 1
        dnz[j] = dnz_read[i]
        dcb[j] = dcb_read[i]
      end
    end
  else
    ndata = ndata_read
    dnz = dnz_read
    dcb = dcb_read
  end
  Lmax[100] = maximum(dcb)

  println(" Lmax[100] = ", Lmax[100])
  step = 0.1

  nd = Int64( trunc((1. / step)*(Lmax[100]+1.)) )

  cutoff = [ step*i for i in 1:nd ]
  ncut = [ 0 for i in 1:nd ]
  ncb = [ 0 for i in 1:nd ]

  for i in 1:ndata 
    icut = Int64(trunc(dnz[i]/step))
    jcut = Int64(trunc(dcb[i]/step))
    if icut > nd || jcut > nd 
      println(" error ", dnz[i]," ",dcb[i])
      exit()
    end
    for j in jcut:nd 
      ncut[j] = ncut[j] + 1
    end
    ncb[jcut] = ncb[jcut] + 1
  end

  fcut = [ 0. for i in 1:nd ]
  for i in 1:nd
    fcut[i] = Float64(ncut[i]) / ndata
    for j in 1:100
      if Lmax[j] == 0. && fcut[i] >= p_Lmax[j]
        Lmax[j] = step*i
      end 
    end 
  end

  plot(p_Lmax,Lmax)
  xlow = -0.1; xhigh = 1.1 ; x = [ xlow, xhigh ]
  for i in [100,99,95,90]
    y = [Lmax[i],Lmax[i]]; plot(x,y,"--",color="black",linewidth=0.5)
    text(0.,Lmax[i]+0.1, @sprintf "f = %.2f / Lmax = %.1f" i/100. Lmax[i])
  end
  # Theoretical (user-provided) maximum length
  if length(ARGS) == 3
    y = [user_max_d,user_max_d]; plot(x,y,"--",color="black",linewidth=0.5)
    text(0.,user_max_d+0.1, @sprintf "Extended linker, Lmax = %.1f" user_max_d)
  end 

  xlabel("Cutoff Fraction")
  ylabel("Lmax(Cutoff Fraction)")
  savefig(plot1)

end
