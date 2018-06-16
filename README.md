# xlff
Statistical force-field for modeling protein structure using chemical cross-linking distance constraints

The following linkers have their potential curves defined so far: DSS/BS3, DSG, 1,6-hexanediamine, 1,3-propanediamine and zero-length species. 

The following table contains information about reactive pairs towards each linker, linker length (L[XL]), min and max distances observed from the statistical analysis.

More datails can be found in Rosetta implementation document.

```
Linker_name		Link_Type L[XL] [min] [max] 
DSS/BS3			KK	11.5 	3.0 17.8  
DSS/BS3			KS	11.5	3.0 15.8  
DSS/BS3			SS	11.5 	3.0 13.4  
1,6-diaminehexane	EE	11.5 	3.0 15.1  
1,6-diaminehexane 	DE	11.5 	3.0 14.3  
1,6-diaminehexane 	DD	11.5 	3.0 13.5  


DSG                 KK        7.7   3.0   15.2  
DSG                 KS        7.7   3.0   12.4  
DSG                 SS        7.7   3.0   10.0  
1,3-diaminepropane  EE        7.7   3.0   11.6  
1,3-diaminepropane  DE        7.7   3.0   10.7  
1,3-diaminepropane  DD        7.7   3.0   9.8   


zero-length         KD        0.0   3.0   9.7   
zero-length         KE        0.0   3.0   10.5  
zero-length         SD        0.0   3.0   7.0   
zero-length         SE        0.0   3.0   7.7   
```
