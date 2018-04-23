#######################################################################
#                                                                     #
# ���ܷ���������     ʱ�䡢note��combo��perfect                       #
#                    �÷֡���Ѫ������                                 #
#                    ����perfect�����ǡ�                              #
#                    ˫Ѻ˫perfect����Ѫֵ��                          #
#                    ��������                                         #
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


#��������


Skill_Coding<-function(data_Card_skill){
  data_Card_skill$trigger<- ifelse(str_detect(data_Card_skill$skill,"^PERFECT"),"P",
                                   ifelse(str_detect(data_Card_skill$skill,"^�ꥺ�ॢ������"),"N",
                                          ifelse(str_detect(data_Card_skill$skill,"^�����"),"C",
                                                 ifelse(str_detect(data_Card_skill$skill,"^[0-9]{1,}��"),   "T",
                                                        ifelse(str_detect(data_Card_skill$skill,"^������"),        "Score",
                                                               ifelse(str_detect(data_Card_skill$skill,"^�����`��������PERFECT"),        "StarPefect",
                                                                      ifelse(str_detect(data_Card_skill$skill,"^���������\\S{3,10}���ؼ������٤ưk�Ӥ���"),        "Skill",
                                                                             "other" #ʩ��δ��
                                                                      )))))))
  
  
  
  
  #��������
  data_Card_skill$probability<-(str_extract(data_Card_skill$skill,"\\d{1,}%�δ_�ʤ�") %>% 
                                  str_extract(.,pattern="\\d{1,}") %>% as.numeric)/100
  
  #��������
  
  #ʱ��
  data_Card_skill$T_T<-str_extract(data_Card_skill$skill,"^\\d{1,}") %>% as.numeric()
  #combo
  data_Card_skill$T_C<-str_extract(data_Card_skill$skill,"^�����\\d{1,}���_��") %>%
    str_extract(.,pattern="\\d{1,}")%>% as.numeric
  #note
  data_Card_skill$T_N<-str_extract(data_Card_skill$skill,"�ꥺ�ॢ������\\d{1,}������") %>%
    str_extract(.,pattern="\\d{1,}")%>% as.numeric
  #perfect
  data_Card_skill$T_P<-str_extract(data_Card_skill$skill,"PERFECT��\\d{1,}���_�ɤ���") %>%
    str_extract(.,pattern="\\d{1,}")%>% as.numeric
  #score
  data_Card_skill$T_Score<-str_extract(data_Card_skill$skill,"������\\d{1,}�_��") %>%
    str_extract(.,pattern="\\d{1,}")%>% as.numeric
  #star perfect
  data_Card_skill$T_StarPerfect<-str_extract(data_Card_skill$skill,"�����`��������PERFECT\\d{1,}��") %>%
    str_extract(.,pattern="\\d{1,}")%>% as.numeric
  #skill(��������)
  data_Card_skill$Skill_team<-str_extract(data_Card_skill$skill,"���������\\S{1,}���ؼ������٤ưk�Ӥ���") %>%
    str_extract(.,pattern="(��'s|Aqours)")
  data_Card_skill$Skill_subteam<-str_extract(data_Card_skill$skill,"���������\\S{1,}���ؼ������٤ưk�Ӥ���") %>%
    str_extract(.,pattern="(1����|2����|3����)")
  
  
  
  
  
  
  #����Ч��
  
  data_Card_skill$effect<-ifelse(str_detect(data_Card_skill$skill,"��������\\d{1,}������$"),                         "Score Up",
                                 ifelse(str_detect(data_Card_skill$skill,"������\\d{1,}�؏ͤ���$"),                         "Healer",
                                        ifelse(str_detect(data_Card_skill$skill,"�ж���\\S{1,}��(�g�٤�)?���������$"),            "Perfect Lock",
                                               ifelse(str_detect(data_Card_skill$skill,"����P��\\S{1,}UP����$"),                          "Appeal Boost",
                                                      ifelse(str_detect(data_Card_skill$skill,"PERFECT�r�Υ��å�SCORE��\\d{1,}������$"),         "Perfect Score Up",
                                                             ifelse(str_detect(data_Card_skill$skill,"�����ؼ��ΰk�Ӵ_�ʤ�\\S{1,}���ˤʤ�$"),           "Skill Boost",
                                                                    ifelse(str_detect(data_Card_skill$skill,"ͬ������P�ˤʤ�$"),                               "Mirror",
                                                                           ifelse(str_detect(data_Card_skill$skill,"ֱǰ�˰k�Ӥ����ؼ���ԩ`��������ؼ�������k��$"),"Encore",
                                                                                  "other"
                                                                           ))))))))
  
  #Healer
  data_Card_skill$Healer<-str_extract(data_Card_skill$skill,"������\\d{1,}�؏ͤ���$") %>%
    str_extract(.,pattern="\\d{1,}")%>% as.numeric
  #Perfect Lock
  data_Card_skill$PerfectLock<-str_extract(data_Card_skill$skill,"�ж���((\\d{1,})(.\\d{1,})?)��(�g�٤�)?���������$") %>%
    str_extract(.,pattern="((\\d{1,})(.\\d{1,})?)")%>% as.numeric*1000#��λΪ����
  #Score Up
  data_Card_skill$ScoreUp<-ifelse(data_Card_skill$effect=="Healer",data_Card_skill$Healer * 480,
                                  str_extract(data_Card_skill$skill,"��������\\d{1,}������$") %>%
                                    str_extract(.,pattern="\\d{1,}")%>% as.numeric)
  #Appeal Boost
  data_Card_skill$AppealBoost_effect<-((str_extract(data_Card_skill$skill,"����P��\\S{1,}UP����$") %>%
                                          str_extract(.,pattern="((\\d{1,})(.\\d{1,})?)")%>% as.numeric)/100+1)
  data_Card_skill$AppealBoost_t.effect<-(str_extract(data_Card_skill$skill,"((\\d{1,})(.\\d{1,})?)���g(��'s|Aqours)(1����|2����|3����)������P��\\d{1,}%UP����$") %>%
                                           str_extract(.,pattern="^((\\d{1,})(.\\d{1,})?)")%>% as.numeric)*1000
  data_Card_skill$AppealBoost_team<-str_extract(data_Card_skill$skill,"((\\d{1,})(.\\d{1,})?)���g(��'s|Aqours)(1����|2����|3����)������P��\\d{1,}%UP����$") %>%
    str_extract(.,pattern="(��'s|Aqours)")
  data_Card_skill$AppealBoost_subteam<-str_extract(data_Card_skill$skill,"((\\d{1,})(.\\d{1,})?)���g(��'s|Aqours)(1����|2����|3����)������P��\\d{1,}%UP����$") %>%
    str_extract(.,pattern="(1����|2����|3����)")
  
  
  #Perfect Score Up
  data_Card_skill$PerfectScoreUp<-str_extract(data_Card_skill$skill,"PERFECT�r�Υ��å�SCORE��\\d{1,}������$") %>%
    str_extract(.,pattern="\\d{1,}")%>% as.numeric
  #Skill Boost
  data_Card_skill$SkillBoost<-str_extract(data_Card_skill$skill,"�����ؼ��ΰk�Ӵ_�ʤ�\\S{1,}���ˤʤ�$") %>%
    str_extract(.,pattern="((\\d{1,})(.\\d{1,})?)") %>% as.numeric
  
  #Mirror  #�ʺ�ӡ�
  #Encore
  #��
  
  return(data_Card_skill)
}