Combined2<-function(rootpath="./",
                    xrare_path="./example/xrare/",
                    exo_path="./example/exo/"
){
  setwd(rootpath)
  xrare_list<-dir(xrare_path)
  exo_list<-dir(exo_path)
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
  if (flag1&&flag2){
    tmp_merge<-merge(tmp_exo,tmp_xrare,by="CHROM:POS",all = T)
    tmp_merge[is.na(tmp_merge[,33]),33]<-0
    tmp_merge[is.na(tmp_merge[,135]),139]<-0
    score_matrix<-tmp_merge[,c(33,139)]
    tmp_merge[,"EWE2"]<-EWE2(score_matrix)
  }
  tmp_merge<-tmp_merge[order(tmp_merge$EWE2,decreasing = T),]
  tmp_merge<-tmp_merge[!duplicated(tmp_merge$`CHROM:POS`),]
  tmp_merge<-tmp_merge[,c(12,2:11,33,139,140)]
  colnames(tmp_merge)<-c("GENE","CHROME","POS","REF","ALT","QUAL","FILTER","GENOTYPE","COVERAGE","FUNCYIONAL_CLASS","HGVS","Exo_SCORE","Xrare_SCORE","EWE2")
  return(tmp_merge)
}
