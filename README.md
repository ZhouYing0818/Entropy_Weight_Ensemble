### Entropy Weight Ensemble

* The output file from Xrare, Examiner and deepPVP must prepare in advance;

* Preparing a set of example data from our first cohort in "example" fold;

* Sourcing "Combined2.R" and "EWE2.R" in R to ensemble Xrare and Exomiser results, for example:

  ~~~
  Source("Combined2.R")
  Source("EWE2.R")
  EWE2_output<-Combined2(rootpath="./", 
                      xrare_path="./example/xrare/", #The path of Xrare output files
                      exo_path="./example/exo/" #The path of Exomiser output files
  )
  write.csv(EWE2_output,"EWE2_output.csv",fileEncoding='GB18030') #saving combined results
  ~~~

* Sourcing "Combined3.R" and "EWE3.R" in R to ensemble Xrare, Exomiser results, for example:

  ~~~
  Source("Combined3.R")
  Source("EWE3.R")
  EWE3_output<-Combined2(rootpath="./", 
                      xrare_path="./example/xrare/", #The path of Xrare output files
                      exo_path="./example/exo/", #The path of Exomiser output files
                      deepPVP_path="./example/deepPVP/" #The path of deepPVP files
  )
  write.csv(EWE3_output,"EWE3_output.csv",fileEncoding='GB18030') #Saving combined results
  ~~~

  