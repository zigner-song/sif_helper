#packages


library(XML)
library(rvest)
library(stringr)
library(dplyr)
library(rjson)
library(plyr)
library(psych)
library(bitops)
library(RCurl)


JsonToDataframe<-function(jsonFile){
  jsonFile.list<-fromJSON(jsonFile) #��json��ʽ��ȡΪlist����
  jsonFile.df<-data.frame()
  for(i in 1:length(jsonFile.list)){#һ��һ�еĶ�ȡ��Ȼ��ϲ�
    jsonFile.vec<-unlist(jsonFile.list[[i]],recursive = TRUE, use.names = TRUE) %>%  t %>% data.frame(.,stringsAsFactors = F)
    jsonFile.df<-bind_rows(jsonFile.df,jsonFile.vec)
  }
  return(jsonFile.df)
}




#��ȡ��ҳ��Ϣ
read_Url <- function(url) {
  out <- tryCatch({
    url %>% as.character() %>% read_html() 
  },
  error=function(cond) {
    message(paste("URL does not seem to exist:", url))
    message("Here's the original error message:")
    message(cond)
    return(NA)
  })    
  return(out)
}




#������
progress_bar<-function(start.Time=Sys.time(),i_rightnow,total_length){
  now.Time<-Sys.time()
  duration<-difftime(now.Time,start.Time,units = "secs") %>% as.numeric()
  
  
  percentage<-i_rightnow/total_length
  total.time<-duration/percentage
  stop.time<-start.Time+total.time
  
  
  print(paste(">>>> ",floor(percentage*10000)/100,
              "% >>>> �ѻ���ʱ��",floor(duration*100)/100,"sec >>>> Ԥ�����ʱ��",stop.time,sep=""))
  return(stop.time)
}