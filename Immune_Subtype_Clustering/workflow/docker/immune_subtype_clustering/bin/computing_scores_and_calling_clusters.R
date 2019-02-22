
# David L Gibbs
# dgibbs@systemsbiology.org

# this script will form the backend of the shiny app.


# this function computes scores given some expression data.



require(sva)
require(clue)
require(mclust)

source("/usr/local/bin/ImmuneSigs68_function.R")
source("/usr/local/bin/signature_mclust_ensemble.R")
load("/usr/local/bin/wolf_set_slim1.rda")
load('/usr/local/bin/comparative_immuneSigs_geneLists4.rda')
tcgaSubset <- read.table('/usr/local/bin/ebppSubset.tsv.bz2', header = T, sep = '\t', stringsAsFactors = F)
reportedScores <- read.table('/usr/local/bin/five_signature_mclust_ensemble_results.tsv.gz', sep='\t', header=T, stringsAsFactors = F)


newScores <- function(newdata, logflag = F, cores = 1, ensemblesize = 256, combatflag = T) {


  zscore.cols2<-function(x){
    return((apply(x, 2, function(x) (x - median(na.omit(x)))/sd(na.omit(x)))))
  }
  
  # 1. the EBPP expression data subset
  rownames(reportedScores) <- reportedScores$AliquotBarcode
  
  # done already
  tcgaSubset <- log2(tcgaSubset + 1)
  
  # 2 we get some new data in.. require:
  #    it is RPKM  
  #    and   log2 transformed 
  #    and   gene symbols as row names
  #    and   median centered
  didx <- !duplicated(as.character(newdata[,1]))
  dat <- newdata[didx,]
  rownames(dat) <- dat[,1]
  dat <- dat[,-1]  # needs row names as symbols
  
  # just in case we need a log transform
  if (logflag) {
    datlog2 <- log2(dat+1)
  } else {
    datlog2 <- dat
  }
  
  
  ### joining data sets ###
  sharedGenes  <- intersect(rownames(tcgaSubset), rownames(dat))

  # first median scale each data set
  newDatSub    <- datlog2[sharedGenes,]
  newDatSubMeds<- apply(newDatSub, 1, median, na.rm=T)  
  newDatSub    <- sweep(newDatSub,1,newDatSubMeds,'-')
  
  tcgaSubsetSub <- tcgaSubset[sharedGenes,]
  tcgaSubsetSubMeds <- apply(tcgaSubsetSub, 1, median, na.rm=T)  
  tcgaSubsetSub <- sweep(tcgaSubsetSub,1,tcgaSubsetSubMeds,'-')
  
  # then join them at the genes
  joinDat      <- cbind(newDatSub, tcgaSubsetSub)
  
  if (combatflag) {
    # then batch correction between scores...
    batch <- c(rep(1,ncol(newDatSub)), rep(2,ncol(tcgaSubsetSub)))
    modcombat = model.matrix(~1, data=as.data.frame(t(joinDat)))
    combat_edata = ComBat(dat=joinDat, batch=batch, mod=modcombat, 
                          par.prior=TRUE, prior.plots=FALSE, ref.batch = 2)
  } else {
    combat_edata = joinDat    
  }
  
  ### compute scores.
  datScores <- ImmuneSigs_function(combat_edata, sigs1_2_eg2,sigs12_weighted_means,
                                   sigs12_module_weights,sigs1_2_names2,sigs1_2_type2,
                                   cores)

  
  # and we subset the 5 scores used in clustering
  idx <- c("LIexpression_score", "CSF1_response", "TGFB_score_21050467", "Module3_IFN_score", "CHANG_CORE_SERUM_RESPONSE_UP")
  scores <- t(datScores[idx,])
  zscores <- zscore.cols2(scores)

  # load the clustering model trained on all pancan data.
  #incProgress()

  
  # make cluster calls using the models.
  calls <- consensusEnsemble(mods2, zscores, cores, ensemblesize)
  
  # get the top scoring cluster for each sample
  maxcalls <- apply(calls$.Data, 1, function(a) which(a == max(a))[1])
  names(maxcalls) <- rownames(scores)
  
  # then we'll look at the new vs. old cluster calls for TCGA samples
  sharedIDs <- intersect(reportedScores$AliquotBarcode, rownames(scores))
  t1 <-table(Reported=as.numeric(reportedScores[sharedIDs, 'ClusterModel1']),
             NewCalls=as.numeric(maxcalls[sharedIDs]))
  
  # then we can align the new calls to old calls.
  reported <- 1:6
  optcalls <- 1:6
  otherway <- 1:6
  for (i in reported) {
    
    # for subtype i, where did most of the samples end up?
    j <- which(as.numeric(t1[i,]) == max(as.numeric(t1[i,])))
    # rename maxcall j <- i
    optcalls[i] <- j
    otherway[j] <- i
  }
  
  print(optcalls)
  print(otherway)
  
  # these are the re-mapped calls
  alignedCalls <- sapply(maxcalls, function(a) which(a == optcalls)[1])

  # make sure it works
  t2 <-table(Reported=as.numeric(reportedScores[sharedIDs, 'ClusterModel1']),
             NewCalls=as.numeric(alignedCalls[sharedIDs]))

  # assemble the results
  jdx <- match(table=rownames(scores), x=colnames(dat))  # index to new data scores
  pcalls <- calls$.Data[jdx,]                            # get that table
  rownames(pcalls) <- colnames(dat)                      # name it from the new data
  pcalls <- pcalls[,optcalls]
  
  pcalls <- cbind(pcalls, data.frame(Call=alignedCalls[jdx]))  # bring in the aligned calls
  pcalls <- cbind(pcalls, zscores[jdx,])                       # and the scores
    
  return(list(AlignedCalls=alignedCalls[jdx], Table=t2, ProbCalls=pcalls))
}






