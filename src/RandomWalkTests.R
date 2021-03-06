#' @Objective: Identifying a series is Random Walk or Not
#' 

rm(list = ls(all=TRUE))
gc()

path = 'C:/Excercise/R/RandomWalk/'
FileName = '2SPI.csv' #'SPIValues.csv'

#' @DifferentPaths: Input, Codes and Output paths.
#' 
InputPath   <- paste0(path,"Inputs/")
CodePath    <- paste0(path,"src/")
OutputPath  <- paste0(path,"Outputs/")

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

pb <- txtProgressBar(min = 0, max = (length(DistinctRegion) * length(DistinctMonth)), style = 3)
k <- 1
for(R in 1:length(DistinctRegion)){#
  for(M in 1:length(DistinctMonth)){
    # R =  1
    # M = 2
    Series <- subset(series,Region == DistinctRegion[R] & Month == M)$Values
    
    #' @Mannkendal
    #'  
    # library(trend)
    MK_Pvalue <- mk.test(Series, alternative = c("two.sided"),continuity = TRUE)$p.value
    
    #' @KPSS
    #'  
    # library(tseries)
    KPSS_PValue <- kpss.test(Series, null = c("Trend"), lshort = TRUE)$p.value
    
    #' @Lung-Box
    #'  
    LungBox_PValue <- Box.test (Series, lag = min(10,length(Series)/5), type = "Ljung")$p.value
    
    #' @CADF
    # library(CADFtest)
    OptLag <- CADFtest(Series, max.lag.y = min(10,length(Series)/5), criterion = "AIC")$max.lag.y
    
    #' @Augmented_Dicky_Fuller
    #' 
    # library(fUnitRoots)
    ADF_PValue <- adfTest(Series, lags = OptLag, type = c("ct"))@test$p.value
    
    #' @WildBootStrap
    #' 
    # library(vrtest)
    KimBoot_PValue <- 0#AutoBoot.test(Series, nboot=1000, wild='Normal')$pval
    
    #' @WaveletBased
    #' 
    #' library(wavelets) & library(wavethresh)
    
    N <- 128
    NoLevel <- log(N,base = 2)-1
    dwt<- dwt(Series[(length(Series)-N):length(Series)], "haar", n.levels=NoLevel)
    
    wMatrix <- matrix(unlist(dwt@W), ncol = NoLevel, byrow = FALSE) 
    vVector <- dwt@V[[NoLevel]]
    
    # G statistic value computation
    
    varWMatrix <- apply(wMatrix, 2, var)
    varvVector <- var(vVector)
    
    G <- sum(varWMatrix)/varvVector
    
    FStats <- (N - N/2^NoLevel)/(G*(N/2^NoLevel-1))
    FPvalue <- 1 - pf(FStats, df1=(N/2^NoLevel-1), df2=(N - N/2^NoLevel), lower.tail = TRUE, log.p = FALSE)
    
    Region <- DistinctRegion[R];Month <- M
    temp <- data.frame(Region,Month,MK_Pvalue,KPSS_PValue,LungBox_PValue,ADF_PValue,KimBoot_PValue,OptLag,G,FStats,FPvalue)
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

