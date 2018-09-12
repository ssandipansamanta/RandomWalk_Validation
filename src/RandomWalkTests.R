#' @Objective: Identifying a series is Random Walk or Not
#' 

rm(list = ls(all=TRUE))
gc()

path = 'C:/Excercise/R/RandomWalk/'
FileName = 'SPIValues.csv'

#' @DifferentPaths: Input, Codes and Output paths.
#' 
InputPath <- paste0(path,"Inputs/")
CodePath <- paste0(path,"src/")
OutputPath <- paste0(path,"Outputs/")

#' @SetDirectory: Calling other R Functions
#' 
setwd(CodePath)
source("RequiredLibraries.R")


#' @ReadingFiles:
#' 
series <- na.omit(read.csv(paste0(InputPath,FileName)))

DistinctRegion <- unique(series$Region)
DistinctMonth <- unique(series$Month)
AllPvalue <- NULL

pb <- txtProgressBar(min = 0, max = 8, style = 3)
k <- 1
for(R in 1:2){#length(DistinctRegion)
  for(M in 1:4){
    # R =  1
    # M = 2
    Series <- subset(series,Region == DistinctRegion[R] & Month == M)$Values
    
    #' @Menkendal
    #'  
    # library(trend)
    MK_Pvalue <- mk.test(Series, alternative = c("two.sided"),continuity = TRUE)$p.value
    
    #' @KPSS
    #'  
    # library(tseries)
    KPSS_PValue <- kpss.test(Series, null = c("Trend"), lshort = TRUE)$p.value
    
    #' @CADF
    # library(CADFtest)
    OptLag <- CADFtest(Series, max.lag.y = 10, criterion = "AIC")$max.lag.y

    #' @Lung-Box
    #'  
    LungBox_PValue <- Box.test (Series, lag = ifelse(OptLag==0,1,OptLag), type = "Ljung")$p.value
    
    #' @Augmented_Dicky_Fuller
    #' 
    # library(fUnitRoots)
    ADF_PValue <- adfTest(Series, lags = OptLag, type = c("ct"))@test$p.value
    
    #' @WildBootStrap
    #' 
    # library(vrtest)
    KimBoot_PValue <- AutoBoot.test(Series, nboot=100, wild='Normal')$pval
    
    Region <- DistinctRegion[R];Month <- M
    temp <- data.frame(Region,Month,MK_Pvalue,KPSS_PValue,LungBox_PValue,ADF_PValue,KimBoot_PValue,OptLag)
    AllPvalue <- rbind(AllPvalue,temp)
    
    #' @AddingStatusBar
    setTxtProgressBar(pb, k)
    k = k + 1
  }
}
close(pb)

#' @Output:
write.csv(file=paste0(OutputPath,"Output.csv"),AllPvalue,row.names = FALSE)

rm(list = ls(all=TRUE))
gc()