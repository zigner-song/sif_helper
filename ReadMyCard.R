###############################
#                             #
#      read my card           #
#                             #
###############################

myCard<-readLines("E:\\LL\\submember-18-4-19.sd")
myCard<-JsonToDataframe(myCard)
names(myCard)<-c("ID","Mezame","SkillLevel","MaxCost")
myCard$ID<-as.numeric(myCard$ID)
  
myCard.List<-Card_update[myCard$ID]

################################
#                              #
#    coding the skill          #
#                              #
################################

#######################################################################
#                                                                     #
# ���ܷ���������     ʱ�䡢note��combo��perfect                       #
#                    �÷֡���Ѫ������                                 #
#                    ����perfect�����ǡ�                              #
#                    ˫Ѻ˫perfect����Ѫֵ��                          #
#                    ��������(?)                                      #
#                                                                     #
#                                                                     #
#                                                                     #
#  ����Ч����        �ж���������������                               #
#                    ���ܷ���������(Skill Boost)��                    #
#                    �ظ���һ����(Encore)                             #
#                    perfect�������ӣ�%����                           #
#                    perfect��������(��)   (Perfect Score Up)         #
#                    combo fever��%����combo fever���֣�              #
#                    ����ֵͬ��(Mirror)���ʺ��ӣ�                   #
#                    ���ܵȼ�������                                   #
#                    ����ֵ����(Appeal Boost)                         #
#                                                                     #
#######################################################################


skill_encoding<-function(skill){
  #��������
  #skill<-skill_effect0
  trigger<- ifelse(str_detect(skill,"^PERFECT"),"P",
            ifelse(str_detect(skill,"^�ꥺ�ॢ������"),"N",
            ifelse(str_detect(skill,"^�����"),"C",
            ifelse(str_detect(skill,"^[0-9]{1,}��"),"T",
            ifelse(str_detect(skill,"^������"),        "Score",
            ifelse(str_detect(skill,"^�����`��������PERFECT"),        "StarPefect",
            ifelse(str_detect(skill,"^���������\\S{3,10}���ؼ������٤ưk�Ӥ���"),        "Skill",
            "other" #ʩ��δ��
            )))))))
  
  #��������
  probability<-(str_extract(skill,"\\d{1,}%�δ_�ʤ�") %>% 
                  str_extract(.,pattern="\\d{1,}") %>% as.numeric)/100
  
  #��������
  
    #ʱ��
    T_T<-str_extract(skill,"^\\d{1,}") %>% as.numeric()
    #combo
    T_C<-str_extract(skill,"^�����\\d{1,}���_��") %>%
      str_extract(.,pattern="\\d{1,}")%>% as.numeric
    #note
    T_N<-str_extract(skill,"�ꥺ�ॢ������\\d{1,}������") %>%
      str_extract(.,pattern="\\d{1,}")%>% as.numeric
    #perfect
    T_P<-str_extract(skill,"PERFECT��\\d{1,}���_�ɤ���") %>%
      str_extract(.,pattern="\\d{1,}")%>% as.numeric
    #score
    T_Score<-str_extract(skill,"������\\d{1,}�_��") %>%
      str_extract(.,pattern="\\d{1,}")%>% as.numeric
    #star perfect
    T_StarPerfect<-str_extract(skill,"�����`��������PERFECT\\d{1,}��") %>%
      str_extract(.,pattern="\\d{1,}")%>% as.numeric
    #skill(��������)
    Skill_team<-str_extract(skill,"���������\\S{1,}���ؼ������٤ưk�Ӥ���") %>%
      str_extract(.,pattern="(��'s|Aqours)")
    Skill_subteam<-str_extract(skill,"���������\\S{1,}���ؼ������٤ưk�Ӥ���") %>%
      str_extract(.,pattern="(1����|2����|3����)")
  
  #effect
    #����Ч��
    
    effect<-ifelse(str_detect(skill,"��������\\d{1,}������$"),                         "Score Up",  #��
            ifelse(str_detect(skill,"������\\d{1,}�؏ͤ���$"),                         "Healer",    #��
            ifelse(str_detect(skill,"�ж���\\S{1,}��(�g�٤�)?���������$"),            "Perfect Lock",#��
            ifelse(str_detect(skill,"����P��\\S{1,}UP����$"),                          "Appeal Boost",
            ifelse(str_detect(skill,"PERFECT�r�Υ��å�SCORE��\\d{1,}������$"),         "Perfect Score Up",
            ifelse(str_detect(skill,"�����ؼ��ΰk�Ӵ_�ʤ�\\S{1,}���ˤʤ�$"),           "Skill Boost",
            ifelse(str_detect(skill,"ͬ������P�ˤʤ�$"),                               "Mirror",
            ifelse(str_detect(skill,"ֱǰ�˰k�Ӥ����ؼ���ԩ`��������ؼ�������k��$"),"Encore",
            "other"
                                                                             ))))))))
    #Healer
    Healer<-str_extract(skill,"������\\d{1,}�؏ͤ���$") %>%
      str_extract(.,pattern="\\d{1,}")%>% as.numeric
    #Perfect Lock
    PerfectLock<-str_extract(skill,"�ж���((\\d{1,})(.\\d{1,})?)��(�g�٤�)?���������$") %>%
      str_extract(.,pattern="((\\d{1,})(.\\d{1,})?)")%>% as.numeric*1000#��λΪ����
    #Score Up
    ScoreUp<-ifelse(effect=="Healer",Healer * 480,
                                    str_extract(skill,"��������\\d{1,}������$") %>%
                                      str_extract(.,pattern="\\d{1,}")%>% as.numeric)
    #Appeal Boost
    AppealBoost_effect<-((str_extract(skill,"����P��\\S{1,}UP����$") %>%
                                            str_extract(.,pattern="((\\d{1,})(.\\d{1,})?)")%>% as.numeric)/100+1)
    AppealBoost_duration.effect<-(str_extract(skill,"((\\d{1,})(.\\d{1,})?)���g(��'s|Aqours)(1����|2����|3����)������P��\\d{1,}%UP����$") %>%
                                             str_extract(.,pattern="^((\\d{1,})(.\\d{1,})?)")%>% as.numeric)*1000
    AppealBoost_team<-str_extract(skill,"((\\d{1,})(.\\d{1,})?)���g(��'s|Aqours)(1����|2����|3����)������P��\\d{1,}%UP����$") %>%
      str_extract(.,pattern="(��'s|Aqours)")
    AppealBoost_subteam<-str_extract(skill,"((\\d{1,})(.\\d{1,})?)���g(��'s|Aqours)(1����|2����|3����)������P��\\d{1,}%UP����$") %>%
      str_extract(.,pattern="(1����|2����|3����)")
    
    
    #Perfect Score Up
    PerfectScoreUp<-str_extract(skill,"PERFECT�r�Υ��å�SCORE��\\d{1,}������$") %>%
      str_extract(.,pattern="\\d{1,}")%>% as.numeric
    #Skill Boost
    SkillBoost<-str_extract(skill,"�����ؼ��ΰk�Ӵ_�ʤ�\\S{1,}���ˤʤ�$") %>%
      str_extract(.,pattern="((\\d{1,})(.\\d{1,})?)") %>% as.numeric
    
    #Mirror  #�ʺ�ӡ�
    #Encore
    #��
  
  xxx<-list(trigger=trigger,probability=probability,
         T_T=T_T,T_C=T_C,T_N=T_N,T_P=T_P,T_Score=T_Score,T_StarPerfect=T_StarPerfect,
         Skill_team=Skill_team,Skill_subteam=Skill_subteam,
         effect=effect,
         
         Healer=Healer,ScoreUp=ScoreUp,PerfectLock=PerfectLock,
         
         AppealBoost_effect=AppealBoost_effect,
         AppealBoost_duration.effect=AppealBoost_duration.effect,
         AppealBoost_team=AppealBoost_team,
         AppealBoost_subteam=AppealBoost_subteam,
         PerfectScoreUp=PerfectScoreUp,
         SkillBoost=SkillBoost)
  
  
  return(xxx)
  
}





myCard.List[[1]]$Card_skill
howMany_myCard<-length(myCard.List)

raw_myCard<-list()
for(i in 1:length(myCard.List)){
  card_skill0<-myCard.List[[i]]$Card_skill
  skill_level0<-myCard[i,"SkillLevel"] %>% as.numeric()
  skill_effect0<-card_skill0[skill_level0,"Effect"] %>% as.character()
  skill0<-skill_encoding(skill_effect0) %>% unlist
  
  
  #raw attribution
  for(j in c("Smile","Pure","Cool")){
    txt<-paste(j,"0<-myCard.List[[i]]$",j,myCard[i,"Mezame"],sep="")
    eval(parse(text=txt))
  }
  
  raw_myCard0<-c(myCard[i,],myCard.List[[i]][2:5],Smile=Smile0,Pure=Pure0,Cool=Cool0,
                 skill=skill_effect0,skill0) %>% 
                unlist %>% t %>% data.frame(.,stringsAsFactors=F)
  raw_myCard<-bind_rows(raw_myCard,raw_myCard0)
}
rm(list=(ls()%>%str_extract_all(".*0$") %>% unlist)[1:8])
  