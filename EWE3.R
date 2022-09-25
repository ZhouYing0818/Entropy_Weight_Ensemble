EWE3<-function(input_data){
  min.max.norm<-function(x){
    (x-min(x))/(max(x)-min(x))
  }
  norm_data<-apply(input_data,2,min.max.norm)
  contribution <- function(input_data)
  {
    x <- c(input_data)
    for(i in 1:length(input_data))
      x[i] = input_data[i]/sum(input_data)
    return(x)
  }
  all_contri <- apply(norm_data,2,contribution)
  inform_entropy <- function(input_data)
  {
    x <- c(input_data)
    for(i in 1:length(input_data)){
      if(input_data[i] == 0){
        x[i] = 0
      }else{
        x[i] = input_data[i] * log(input_data[i])
      }
    }
    return(x)
  }
  all_entropy<-apply(all_contri,2,inform_entropy)
  k<-1/log(length(all_entropy[,1]))
  d<-(-k * colSums(all_entropy))
  d=1-d
  w=d/sum(d)
  combined_score<-data.frame()
  for (i in 1:dim(input_data)[1]){
    combined_score[i,1]<-as.numeric(norm_data[i,1]*w[1]+norm_data[i,2]*w[2]+norm_data[i,3]*w[3]) #+input_data[i,3]*w[3])
  }
  return(combined_score)
}