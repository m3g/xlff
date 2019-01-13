# XLFF
Cross-linking force field: a physical-inspired statistical approach to represent cross-linking derived constraints for structural modeling.


*Reference:*

**Statistical force-field for structural modeling using chemical cross-linking/mass spectrometry distance constraints**

Allan J R Ferrari, Fabio C Gozzo, Leandro Martínez

Bioinformatics, 2019, https://doi.org/10.1093/bioinformatics/btz013





**What we made available so far?**

The following linkers have their knowledge-based potentials defined so far: DSS/BS3, DSG, 1,6-hexanediamine, 1,3-propanediamine and zero-length species. 

The table below contains information about reactive pairs towards each linker, linker length (L[XL]) and max distances observed from the statistical analysis.

More details on the modeling implementation setup can be found in Rosetta.




**Cross-linking validation**

*Reference based on CATH-S40 (V4.1) analysis with Topolink (v17.091) https://gibhub.com/mcubeg/topolink*

```
Linker_name	      Link_Type L[XL] [max] 
DSS/BS3		      KK        11.5  17.8  
DSS/BS3		      KS	11.5  15.8  
DSS/BS3		      SS	11.5  13.4  
1,6-diaminehexane     EE        11.5  15.1  
1,6-diaminehexane     DE	11.5  14.3  
1,6-diaminehexane     DD	11.5  13.5  


DSG                   KK        7.7   15.2  
DSG                   KS        7.7   12.4  
DSG                   SS        7.7   10.0  
1,3-diaminepropane    EE        7.7   11.6  
1,3-diaminepropane    DE        7.7   10.7  
1,3-diaminepropane    DD        7.7   9.8   

zero-length           KD        0.0   9.7   
zero-length           KE        0.0   10.5  
zero-length           SD        0.0   7.0   
zero-length           SE        0.0   7.7   
```
