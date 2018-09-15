#
# Reads distance output data and plots probabilities and
# potentials
#

let LmaxTest

  using PyPlot

  include("read_data.jl")
  
  ndata, dnz, dcb = read_data("KK_CB.dat",cols=[1,2])

  Lmax100 = maximum(dcb)
  step = 0.1
  nd = Int64((1. / step)*trunc(Lmax100+1.))
  println(" Lmax100 = ", Lmax100 )

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

  Lmax90 = 0.
  Lmax95 = 0.
  Lmax99 = 0.
  fcut = [ 0. for i in 1:nd ]
  for i in 1:nd
    fcut[i] = Float64(ncut[i]) / ndata
    if Lmax90 == 0. && fcut[i] > 0.90
      Lmax90 = step*i
    end
    if Lmax95 == 0. && fcut[i] > 0.95
      Lmax95 = step*i
    end
    if Lmax99 == 0. && fcut[i] > 0.99
      Lmax99 = step*i
    end
  end
  println(" Lmax99 = ", Lmax99)
  println(" Lmax95 = ", Lmax95)
  println(" Lmax90 = ", Lmax90)

  ndCB, dCB_euc, dCB_top = read_data("dCB_euc_top.dat",cols=[4,5])

  println(" ndCB = ", ndCB )
  println(" max euc dCB = ", maximum(dCB_euc))
  println(" max top dCB = ", maximum(dCB_top))

  ncb = [ 0 for i in 1:nd ]
  p_dcb_lt_Lmax100 = [ 0. for i in 1:nd ]
  p_dcb_lt_Lmax99 = [ 0. for i in 1:nd ]
  p_dcb_lt_Lmax95 = [ 0. for i in 1:nd ]
  p_dcb_lt_Lmax90 = [ 0. for i in 1:nd ]
  for i in 1:ndCB
    j = Int64(trunc(dCB_euc[i]/step))
    if j > nd ; println("error") ; exit() ; end
    ncb[j] = ncb[j] + 1
    if dCB_top[i] < Lmax100
      p_dcb_lt_Lmax100[j] = p_dcb_lt_Lmax100[j] + 1.
    end
    if dCB_top[i] < Lmax99
      p_dcb_lt_Lmax99[j] = p_dcb_lt_Lmax99[j] + 1.
    end
    if dCB_top[i] < Lmax95
      p_dcb_lt_Lmax95[j] = p_dcb_lt_Lmax95[j] + 1.
    end
    if dCB_top[i] < Lmax90
      p_dcb_lt_Lmax90[j] = p_dcb_lt_Lmax90[j] + 1.
    end
  end
  for i in 1:nd
    if ncb[i] > 0 
      p_dcb_lt_Lmax100[i] = p_dcb_lt_Lmax100[i] / ncb[i]
      p_dcb_lt_Lmax99[i] = p_dcb_lt_Lmax99[i] / ncb[i]
      p_dcb_lt_Lmax95[i] = p_dcb_lt_Lmax95[i] / ncb[i]
      p_dcb_lt_Lmax90[i] = p_dcb_lt_Lmax90[i] / ncb[i]
    end
  end

  subplot(211)
  xlim(-1,25)
  ylow = -0.1; yhigh = 1.1 ; y = [ ylow, yhigh ]
  x = [Lmax100,Lmax100]; plot(x,y,"--",color="black")
  x = [Lmax99,Lmax99]; plot(x,y,"--",color="black")
  x = [Lmax95,Lmax95]; plot(x,y,"--",color="black")
  x = [Lmax90,Lmax90]; plot(x,y,"--",color="black")
  text(Lmax100,    1.15,"1.00")
  text(Lmax99,     1.15,"0.99")
  text(Lmax95-0.5, 1.15,"0.95")
  text(Lmax90-1.5, 1.15,"0.90")

  ylim(ylow,yhigh)
  plot(cutoff,p_dcb_lt_Lmax100,color="blue")
  plot(cutoff,p_dcb_lt_Lmax99,color="red")
  plot(cutoff,p_dcb_lt_Lmax95,color="green")
  plot(cutoff,p_dcb_lt_Lmax90,color="black")
  ylabel(" p[d(CB,CB)<Lmax(x)] ")

  subplot(212)                                      

  v100 = [ 0. for i in 1:nd ]
  v99 = [ 0. for i in 1:nd ]
  v95 = [ 0. for i in 1:nd ] 
  v90 = [ 0. for i in 1:nd ] 
  for i in 1:nd          
    v100[i] = -0.569*log(p_dcb_lt_Lmax100[i]) - 2.5
    v99[i] = -0.569*log(p_dcb_lt_Lmax99[i]) - 2.5
    v95[i] = -0.569*log(p_dcb_lt_Lmax95[i]) - 2.5
    v90[i] = -0.569*log(p_dcb_lt_Lmax90[i]) - 2.5
  end
  ylow = -3; yhigh = 1 ; y = [ ylow, yhigh ]
  x = [Lmax100,Lmax100]; plot(x,y,"--",color="black")
  x = [Lmax99,Lmax99]; plot(x,y,"--",color="black")
  x = [Lmax95,Lmax95]; plot(x,y,"--",color="black")
  x = [Lmax90,Lmax90]; plot(x,y,"--",color="black")

  plot(cutoff,v100,color="blue")
  plot(cutoff,v99,color="red")
  plot(cutoff,v95,color="green")
  plot(cutoff,v90,color="black")
  ylim(ylow,yhigh)
  xlim(-1,25)
  ylabel("Potential")
  xlabel("Euclidean CB-CB distance")
  
  savefig("KK.pdf")

end
