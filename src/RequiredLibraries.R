InstalledPackages <- function(packageNeedtoInstall){
  if(!eval(parse(text=paste0("require(",packageNeedtoInstall,")"))))
      install.packages(packageNeedtoInstall)
        eval(parse(text=paste0("library(",packageNeedtoInstall,")")))
        Sys.sleep(1)
}
Packages = c("trend","tseries","CADFtest","fUnitRoots","vrtest","wavelets","wavethresh","data.table")
lapply(Packages, InstalledPackages)
cat("\014")
