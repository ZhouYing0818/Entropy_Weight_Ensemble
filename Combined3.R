Combined3<-function(rootpath="./",
                    xrare_path="./example/xrare/",
                    exo_path="./example/Exomiser/",
                    deepPVP_path="./example/deepPVP/"
                    ){
  setwd(rootpath)
  xrare_list<-dir(xrare_path)
  exo_list<-dir(exo_path)
  deepPVP_list<-dir(deepPVP_path)
    for (j in 1:length(xrare_list)){
      tmp_xrare<-data.frame()
      tmp_file<-xrare_list[j]
      tmp<-strsplit(tmp_file,fixed = T,split = "_")[[1]]
      NGS_xrare<-paste(tmp[1],tmp[2],sep="_")
      flag1=FALSE
      filename=paste(xrare_path,tmp_file,sep="")
      tmp_xrare<-read.csv(filename,header = T)
      tmp_xrare["CHROM:POS"]<-paste(tmp_xrare$CHROM,tmp_xrare$POS,sep = ":")
      flag1=TRUE
      break
      }
    for (n in 1:length(exo_list)){
      tmp_exo<-data.frame()
      tmp_file<-exo_list[n]
      tmp<-strsplit(tmp_file,fixed = T,split = "_")[[1]]
      NGS_exo<-paste(tmp[1],tmp[2],sep="_")
      flag2=FALSE
      filename=paste(exo_path,tmp_file,sep="")
      tmp_exo<-read.csv(filename,header = T)
      tmp_colname<-colnames(tmp_exo)
      tmp_colname[1]<-"CHROM"
      colnames(tmp_exo)<-tmp_colname
      tmp_exo["CHROM:POS"]<-paste(tmp_exo$CHROM,tmp_exo$POS,sep = ":")
      flag2=TRUE
      break
    }
    for (n in 1:length(deepPVP_list)){
      tmp_deepPVP<-data.frame()
      tmp_file<-deepPVP_list[n]
      tmp<-strsplit(tmp_file,fixed = T,split = ".")[[1]][2]
      if (tmp=='res'){
        tmp<-strsplit(tmp_file,fixed = T,split = "_")[[1]]
        NGS_deepPVP<-paste(tmp[1],tmp[2],sep="_")
        flag3=FALSE
        filename=paste(deepPVP_path,tmp_file,sep="")
        tmp_deepPVP<-read.table(filename,header = T)
        tmp_colname<-colnames(tmp_deepPVP)
        tmp_colname[1]<-"CHROM"
        tmp_colname[2]<-"POS"
        colnames(tmp_deepPVP)<-tmp_colname
        tmp_deepPVP["CHROM:POS"]<-paste(tmp_deepPVP$CHROM,tmp_deepPVP$POS,sep = ":")
        flag3=TRUE
        break
      }
    }
    if (flag1&&flag2&&flag3){
      tmp_merge<-merge(tmp_exo,tmp_xrare,by="CHROM:POS",all = T)
      tmp_merge<-merge(tmp_merge,tmp_deepPVP,by="CHROM:POS",all = T)
      tmp_merge[is.na(tmp_merge[,33]),33]<-0
      tmp_merge[is.na(tmp_merge[,139]),139]<-0
      tmp_merge[is.na(tmp_merge[,150]),150]<-0
      score_matrix<-tmp_merge[,c(33,139,150)]
      tmp_merge[,"EWE3"]<-EWE3(score_matrix)
    }
  tmp_merge<-tmp_merge[order(tmp_merge$EWE3,decreasing = T),]
  tmp_merge<-tmp_merge[!duplicated(tmp_merge$`CHROM:POS`),]
  tmp_merge<-tmp_merge[,c(151,150,139,33,1:32,34:138,140:149)]
  tmp_colnames<-colnames(tmp_merge)
  tmp_colnames[4]<-"Exomiser_SCORE"
  tmp_colnames[3]<-"Xrare_SCORE"
  tmp_colnames[2]<-"deepPVP_SCORE"
  tmp_colnames[1]<-"EWE3"
  colnames(tmp_merge)<-tmp_colnames
  return(tmp_merge)
}
