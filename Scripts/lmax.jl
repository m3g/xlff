#
# Script to plot Lmax as a function of the percentage cutoff
#
# Run with: julia lmax.jl file1.dat lmax.pdf
#
# file1.dat:
# File containing the CB-CB distances for all Nz-Nz distances
# smaller than the linker length. d(CB-CB) distances must be
# in column 2 
#
# lmax.pdf
# the name of the plot that will generated
#
# 102mA00.log: 16 56 21.316 23.336
#
# where the two last numbers (columns 4 and 5) are read and must
# be the eucliean and topological distance of the pair.
#
# In the example, 
# file1 = KK_CB.dat
#
# so, run with:  julia lmax.jl KK_CB.dat plot.pdf
#
# L. Martinez - IQ/UNICAMP; Sep 16, 2018
#

using PyPlot
using Printf

let LmaxTest

  include("read_data.jl")

  file1 = ARGS[1]
  plot1 = ARGS[2]
  
  ndata, dnz, dcb = read_data(file1,cols=[1,2])

  Lmax = [ 0. for i in 1:100 ]
  p_Lmax = [ Float64(i)/100. for i in 1:100 ]
          
  Lmax[100] = maximum(dcb)
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
    text(0.,Lmax[i]+0.1, @sprintf "%.2f" i/100.)
  end
  xlabel("Cutoff Fraction")
  ylabel("Lmax(Cutoff Fraction)")
  savefig(plot1)

end
