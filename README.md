# JcLipidWorflow

Collection of scripts used for the simulations made during the analysis of the reconstructed metabolic network of *Jatropha curcas*

## Description

This collection of scripts encompasses several functions that allow the analysis of three growth scenarios using the reconstructed metabolic network for *Jatropha curcas*. The simulations are performed by using several functions of the COBRA Toolbox [1,2] to generate the raw data that is subsequently analyzed with the scripts included in this collection.

## Requirements

* A functional Matlab installation (R2016b or higher).
* The COBRA toolbox for MATLAB.

## Instructions

* Download the files and save them in a known location
* In Matlab change into the current folder to the location were the files were stored
* Start the analysis by typing “LipidNetworkWorflow” in the Matlab command window to run the main script
* Choose the model file stored in the “InputFiles” folder
* Select the number of conditions to evaluate
* Use “Y” or “N” to select the analysis to perform
* To see the results after running the main script go to the “OutputFiles” folder

Note: The “BiomassOptimum” script is used to estimate the optimum biomass formation rate under simulating different environmental constraints.

## Contributors

* Sandra Correa (Cordoba@mpimp-golm.mpg.de)

## References

[1] Vlassis N, Pacheco MP, Sauter T (2014) Fast Reconstruction of Compact Context-Specific Metabolic Network Models. PLoS Comput Biol 10(1): e1003424.
[2] Laurent Heirendt & Sylvain Arreckx, Thomas Pfau, Sebastian N. Mendoza, Anne Richelle, Almut Heinken, Hulda S. Haraldsdottir, Jacek Wachowiak, Sarah M. Keating, Vanja Vlasov, Stefania Magnusdottir, Chiam Yu Ng, German Preciat, Alise Zagare, Siu H.J. Chan, Maike K. Aurich, Catherine M. Clancy, Jennifer Modamio, John T. Sauls, Alberto Noronha, Aarash Bordbar, Benjamin Cousins, Diana C. El Assal, Luis V. Valcarcel, Inigo Apaolaza, Susan Ghaderi, Masoud Ahookhosh, Marouen Ben Guebila, Andrejs Kostromins, Nicolas Sompairac, Hoai M. Le, Ding Ma, Yuekai Sun, Lin Wang, James T. Yurkovich, Miguel A.P. Oliveira, Phan T. Vuong, Lemmer P. El Assal, Inna Kuperstein, Andrei Zinovyev, H. Scott Hinton, William A. Bryant, Francisco J. Aragon Artacho, Francisco J. Planes, Egils Stalidzans, Alejandro Maass, Santosh Vempala, Michael Hucka, Michael A. Saunders, Costas D. Maranas, Nathan E. Lewis, Thomas Sauter, Bernhard Ø. Palsson, Ines Thiele, Ronan M.T. Fleming, Creation and analysis of biochemical constraint-based models: the COBRA Toolbox v3.0, Nature Protocols, volume 14, pages 639–702, 2019 doi.org/10.1038/s41596-018-0098-2.
