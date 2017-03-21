**Last edited: 03/20/2017 by Állan Ferrari** 
> Have a doubt? Some suggestion? Contact: ajrferrari@gmail.com

A. Ferrari, F.C.Gozzo, L.Martínez, ** Statistical potential for structural modeling using chemical cross-linking/mass spectrometry distance constraints**, 2017.

#Implementing statistical potential on Rosetta

The statistical potential for cross-linking / mass spectrometry derived constraints is implement in Rosetta numerically. This is done by taking advantage on a constraint function called in Rosetta ETABLE.ETABLE describes any function as a table of values which can be interpolated in order to approximate the function true behavior (See General explanation below).

Although ETABLE func is a default Rosetta's scoring function, it needs to be enabled. To do so, two files need to be modified. 

1) Go do the scoring fuctions directory

> $ cd ~rosetta_path/main/source/src/core/scoring/func/

2) copy to this directory the two files provided here in code directory 

>$ cp ~/files/code/FuncFactory.cc ~/files/code/EtableFunc.cc ~rosetta_path/main/source/src/scoring/func/
	
##Brief explanation
This will replace both file in the directory. If you want to keep default files, it is recommended to rename both of them first. 

The FuncFactory.cc file just add to the default file two lines specifying that EtableFunc.cc should be considered in Rosetta applications. EtableFunc.cc brings the definitions of f(x) and its derivatived, which is not present in the default file, that is, it is user-defined. 

After copy those two files, it is necesary to recompile Rosetta. 

3) Go to 

>$ cd ~rosetta_path/main/source 

and run 

>$./scons.py [parameters]

to do it. 

If no *error message* appears, you are ready to run a job using the statistical potential.

Next section explains the general format of a constraint file. A file with the options used to run SalBIII structure prediction is provided in 

>$~/files/example

#General explanation

The general input format in a constraint file applying ETABLE func is:

> AtomPair [Atom1] [ResID1] [Atom2] [ResID2] ETABLE [min] [max] [many numbers]

In this format each "[ ]" refers to a user-defined variable.

For example:

[Atom1] = CA or CB
[ResID1] = 1 or 2, etc
[min] = is the minimum valeu of x for which [many number] has been computed
[max] = is the maximum value of x for which [many numbers] has been computed
[many numbers] = values of func for x from [min] to [max] spaced out by 0.1

Some common links have their statistical potential curves defined.
Each [many numbers] file to each of the residues pairs is present in $/files/xl
A script to create a constraint file for Rosetta application is avaiable as "xl_generator" in $file/xl.

[min] and [max] are defined based on the statistics of CATH S40 non redundant database. Their values are tabulated as follows:

```
**Link_Type	L[XL]	[min]	[max]	File ($~/xl directory)**
KK	  	11.5	3.0	17.8	KK_l.17.xl
KS	  	11.5	3.0	15.8	KS_l.17.xl
SS	  	11.5	3.0	13.4	SS_l.17.xl
EE	  	11.5	3.0	15.1	EE_l.17.xl
DE	  	11.5	3.0	14.3	DE_l.17.xl
DD	  	11.5	3.0	13.5	DD_l.17.xl


KK	  	7.7	3.0	15.2	KK_s.17.xl
KS	  	7.7	3.0	12.4	KS_s.17.xl
SS	  	7.7	3.0	10.0	SS_s.17.xl
EE	  	7.7	3.0	11.6	EE_s.17.xl
DE	  	7.7	3.0	10.7	DE_s.17.xl
DD	  	7.7	3.0	9.8	DD_s.17.xl


KD	  	0.0	3.0	9.7	KD.17.xl
KE	  	0.0	3.0	10.5	KE.17.xl
SD	  	0.0	3.0	7.0	SD.17.xl
SE	  	0.0	3.0	7.7	SE.17.xl
```

##Aditional comments

-L[XL] stands for the spacer arm lenght of the cross-linker. For example, L[XL] = 11.5 A refers to DSS or 1,6-hexanediamine, L[XL] = 7.7 A refers to DSG or 1,3-propanediamine and L[XL] = 0 A refers to zero lenght species.

-f(x) is computed in the interval between [min] and [max] as an approximation of the true function by the closest value of the Euclidean distance measured. Above x = [max] a linear penalization is computed, that is, f(x) = (x - xmax_ ) if x > x_max. The derivative is computed as the angular coeficient of the linear curve described by the interpolation of the two closest tabulated values from Euclidean distance measured, x.


