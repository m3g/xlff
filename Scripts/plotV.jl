#
# Script to plot the statistical potential for different Lmax
#
# Run with: julia plotV.jl file1.dat file2.dat plot.pdf
#
# file1.dat:
# File containing the CB-CB distances for all Nz-Nz distances
# smaller than the linker length. d(CB-CB) distances must be
# in column 2 
#
# file2.dat
# File containing all CB-CB distances, both euclidean en topological.
# each line has the format: 
#
# plot.pdf
# the name of the plot that will generated
#
# 102mA00.log: 16 56 21.316 23.336
#
# where the two last numbers (columns 4 and 5) are read and must
# be the eucliean and topological distance of the pair.
#
# In the example, 
# file1 = KK_CB.dat
# file2 = dCB_euc_top.dat
#
# so, run with:  julia plotV.jl KK_CB.dat dCB_euc_top.dat plot.pdf
#
# L. Martinez - IQ/UNICAMP; Sep 16, 2018
#

using PyPlot
using Printf

let PlotV

  include("read_data.jl")

  file1 = ARGS[1]
  file2 = ARGS[2]
  plot1 = ARGS[3]

  # You can choose which fractions appear in the plot here
  fractions = [ 100, 99, 95, 90 ]
  
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

  ndCB, dCB_euc, dCB_top = read_data(file2,cols=[4,5])

  ncb = Vector{Int64}(undef,nd)
  p_dcb_lt_Lmax = Matrix{Float64}(undef,nd,100)
  for i in 1:nd
    ncb[i] = 0.
    for j in 1:100
      p_dcb_lt_Lmax[i,j] = 0.
    end
  end

  # Computing the probability vector

  for i in 1:ndCB
    j = Int64(trunc(dCB_euc[i]/step))
    if j > nd ; println("error") ; exit() ; end
    ncb[j] = ncb[j] + 1
    for k in 1:100
      if dCB_top[i] < Lmax[k]
        p_dcb_lt_Lmax[j,k] = p_dcb_lt_Lmax[j,k] + 1.
      end
    end 
  end
  for i in 1:nd
    if ncb[i] > 0 
      for j in 1:100
        p_dcb_lt_Lmax[i,j] = p_dcb_lt_Lmax[i,j] / ncb[i]
      end
    end
  end

  #
  # Plot probability as a function of cutoff
  #

  subplot(211)

  xlim(-1,25)
  ylow = -0.1; yhigh = 1.1 ; yline = [ ylow, yhigh ]
  for j in fractions
    # plot line
    x = [Lmax[j],Lmax[j]]; plot(x,yline,"--",color="black",linewidth=0.5)
    text(Lmax[j],    1.15,string(j/100.))
    # plot probability
    y = [ p_dcb_lt_Lmax[i,j] for i in 1:nd ]
    plot(cutoff,y,color="blue")
  end
  ylim(ylow,yhigh)
  ylabel(" p[dtop(CB,CB)<Lmax(x)] ")

  #
  # Plot potential as a function cutoff
  #

  subplot(212)                                      

  nplots = length(fractions)

  v = Matrix{Float64}(undef, nd, nplots)
  for j in 1:nplots
    k = fractions[j]
    for i in 1:nd
      v[i,j] = -0.569*log(p_dcb_lt_Lmax[i,k]) - 2.5
    end
  end
  ylow = -3; yhigh = 1 ; y = [ ylow, yhigh ]

  # Plot lines
  for j in fractions
    x = [Lmax[j],Lmax[j]]; plot(x,y,"--",color="black",linewidth=0.5)
  end
  for j in 1:nplots
    y = [ v[i,j] for i in 1:nd ]
    plot(cutoff,y,color="blue")
  end

  ylim(ylow,yhigh)
  xlim(-1,25)
  ylabel("Potential")
  xlabel("Euclidean CB-CB distance")
  
  savefig(plot1)

end




