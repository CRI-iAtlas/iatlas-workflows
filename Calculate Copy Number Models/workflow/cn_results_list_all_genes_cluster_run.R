
library(magrittr)

dat <- readr::read_tsv('Calculate Copy Number Models/workflow/examples/all_thresholded.by_genes_whitelisted.tsv.gz')
data_df <- feather::read_feather("/home/aelamb/repos/irwg/shiny-iatlas/data/fmx_df.feather")
driver_results <- readRDS("Calculate Copy Number Models/workflow/examples/driver_results.rds")
dat1 <- readr::read_tsv('Calculate Copy Number Models/workflow/examples/five_signature_mclust_ensemble_results.tsv.gz')
dat1$ParticipantBarcode <- stringr::str_sub(dat1$SampleBarcode, 1, 12)

metrics <- unique(driver_results$metric)

groups <- c("Study", "Subtype_Immune_Model_Based", "Subtype_Curated_Malta_Noushmehr_et_al")

allgenes <- unique(dat$`Gene Symbol`)

genes <- allgenes[1:3]

dat2 <- dat %>% dplyr::select(-'Locus ID', -'Cytoband')
dat2 <- t(dat2[,-1])
pb <- stringr::str_sub(rownames(dat2), 1, 12)
colnames(dat2) <- dat$`Gene Symbol`
dat2 <- as.data.frame(dat2)
dat2 <- cbind(ParticipantBarcode=pb, dat2)
dat2 <- dat2[dat2$ParticipantBarcode %in% dat1$ParticipantBarcode,]

rm(dat)
gc()

data_df <- data_df %>%
  dplyr::inner_join(dat2) %>%
  dplyr::select(c(groups, metrics, genes))

rm(dat2)
gc()

############################

add_group_size_metrcs <- function(.tbl){
  .tbl %>%
    dplyr::group_by(group) %>%
    dplyr::mutate(
      n_total = dplyr::n(),
      n_wt = sum(gene == "Wt")
    ) %>%
    dplyr::mutate(n_mut = n_total - n_wt) %>%
    dplyr::filter(n_mut > 1 & n_wt > 1) %>%
    dplyr::ungroup()
}


add_effect_size_metrics <- function(.tbl){
  effect_size_df <- .tbl %>%
    dplyr::group_by(group, gene) %>%
    dplyr::summarise(
      mean = mean(metric),
      median = median(metric),
      sd = sd(metric)) %>%
    dplyr::ungroup() %>%
    tidyr::gather(
      key = summary_metric,
      value = summary_value,
      mean,
      median,
      sd) %>%
    tidyr::unite(col = summary_metric, gene, summary_metric) %>%
    tidyr::spread(summary_metric, summary_value) %>%
    dplyr::filter(Mut_mean > 0, Wt_mean > 0) %>%
    dplyr::mutate(effect_size = -log10(Wt_mean/Mut_mean))

  dplyr::inner_join(.tbl, effect_size_df, by = "group")
}

###################################

combination_df <-
  merge(metrics, genes) %>%
  merge(data.frame(groups)) %>%
  merge(data.frame(direction=c('Amp','Del'))) %>%
  dplyr::rename(metric = x, gene = y, group = groups) %>%
  dplyr::as_tibble() %>%
  dplyr::mutate_if(is.factor, as.character)


do_t_by_groups <- function(metric, gene, group, direction, data_df){

  data_df2 <-
    data_df %>%
    dplyr::select(
      metric = metric,
      gene = gene,
      group = group
    ) %>%
    tidyr::drop_na() %>%
    dplyr::filter(!is.infinite(metric))

  if (nrow(data_df2) == 0) return(dplyr::tibble())

  if (direction == 'Amp') {
    data_df2 %>%
      tidyr::nest(metric, gene) %>%
      dplyr::mutate(result = purrr::map(data, calculate_t_pvalue_amp)) %>%
      tidyr::unnest(result) %>%
      dplyr::mutate(neg_log10_pvalue = -log10(pvalue)) %>%
      dplyr::select(-data) %>%
      dplyr::mutate(metric=metric, direction='Amp', gene=gene, label = stringr::str_c(gene, ";", group))
  } else if (direction == 'Del') {
    data_df2 %>%
      tidyr::nest(metric, gene) %>%
      dplyr::mutate(result = purrr::map(data, calculate_t_pvalue_del)) %>%
      tidyr::unnest(result) %>%
      dplyr::mutate(neg_log10_pvalue = -log10(pvalue)) %>%
      dplyr::select(-data) %>%
      dplyr::mutate(metric=metric, direction='Del', gene=gene, label = stringr::str_c(gene, ";", group))
  } else {
    print("ERROR ERRORRRR")
    return()
  }
}


calculate_t_pvalue_amp <- function(data){
  result <- data.frame(Mean_Norm = NA, Mean_CNV = NA, t=NA, pvalue=NA)
  try(silent=T, expr={
    xx <- data$metric[data$gene == 0]
    yy <- data$metric[data$gene >  0]
    if (length(yy) > 3 & length(xx) > 3) {
      res0 <- t.test(x=xx, y=yy)
      result <- (data.frame(Mean_Norm = res0$estimate[1], Mean_CNV = res0$estimate[2], t=res0$statistic, pvalue=res0$p.value))
    }
  })
  return(result)
}

calculate_t_pvalue_del <- function(data){
  result <-  data.frame(Mean_Norm = NA, Mean_CNV = NA, t=NA, pvalue=NA)
  try(silent=T, expr={
    xx <- data$metric[data$gene == 0]
    yy <- data$metric[data$gene <  0]
    if (length(yy) > 3 & length(xx) > 3) {
      res0 <- t.test(x=xx, y=yy)
      result <- (data.frame(Mean_Norm = res0$estimate[1], Mean_CNV = res0$estimate[2], t=res0$statistic, pvalue=res0$p.value))
    }
  })
  return(result)
}

# result_list <- lapply(1:nrow(combination_df), function(i) {
#   if (i %% 1001 == 0) { print(i) }
#   metric <- as.character(combination_df[i,1])
#   gene   <- as.character(combination_df[i,2])
#   group  <- as.character(combination_df[i,3])
#   direction <- as.character(combination_df[i,4])
#   do_t_by_groups(metric, gene, group, direction, data_df)
#   }
# )


metric <- as.character(combination_df[1,1])
gene   <- as.character(combination_df[1,2])
group  <- as.character(combination_df[1,3])
direction <- as.character(combination_df[1,4])
result <- do_t_by_groups(metric, gene, group, direction, data_df)




# save(result_list, file=paste0('/titan/cancerregulome9/workspaces/users/dgibbs/iatlas/all_Results_list_v4_',startgene,'_',endgene,'.rda'))
