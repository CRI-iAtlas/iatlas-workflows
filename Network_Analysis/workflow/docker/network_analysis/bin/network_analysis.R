library(abcnet)
library(dplyr)

#Select the grouping variable
#Select the group to compute scores. Options of group_col: "Subtype_Immune_Model_Based" "Subtype_Curated_Malta_Noushmehr_et_al" "Study"
#For sample group = "Study", it is also possible to compute scores for each tumor x immune subtype combination by setting stratify_Immune = TRUE

group_col="Subtype_Immune_Model_Based"
stratify_Immune = FALSE

#Loading data
group_df=readr::read_tsv("extdata/PanImmune_FMx_ImmuneSubtypes.tsv")
## Read available gene expression data
dfe_in <- readr::read_tsv("extdata/GenExp_All_CKine_genes.tsv")
## Read file with available cell data
dfc_in <- readr::read_tsv("extdata/PanImmune_FMx.tsv")
## Read scaffold interaction file and node type file
node_type <- readr::read_tsv("extdata/network_node_labels.tsv")
scaffold <- readr::read_tsv("extdata/try_3a.tsv")
##Read file with cells and genes of interest
cois <- readr::read_lines("extdata/cells_of_interest.txt")
gois <- readr::read_lines("extdata/immunomodulator_genes.txt")

##1.1. Filtering the scaffold to our cells and genes of interest

#Updating the list of genes of interest based on the gene expression data available
gois <- intersect(gois, colnames(dfe_in))
# Selecting the edges in the scaffold that have at least one gois, and a cois connected to a gois
filtered_scaffold <- abcnet::get_scaffold(scaffold, cois, gois)
#let's update the list of genes of interest with all genes that are present in the filtered scaffold
gois <- union(filtered_scaffold$From, filtered_scaffold$To) %>% intersect(colnames(dfe_in))


##1.2. Organizing the expression data

#Our input data is not in this format right now. As a first step, let's organize the data.

#organizing the combination of participant and grouping variable
participants <- group_df$ParticipantBarcode
groups <- group_df[[group_col]]
group_of_participant <- groups ; names(group_of_participant) <- participants

#The cell data is in a specific column, so here we are selecting it  
dfc <- dfc_in %>% #filter(ParticipantBarcode %in% participants) %>%
select(ParticipantBarcode,paste(cois,".Aggregate2",sep=""))
colnames(dfc) <- gsub(".Aggregate2","",colnames(dfc))
#Now, we include the group annotation for each sample
dfc <- dfc %>% 
dplyr::mutate(Group=group_of_participant[ParticipantBarcode]) 
#Transforming each observation in one row (ie, making a long table)
dfclong <- dfc %>% tidyr::gather(Cell,Cell_Fraction,-c(ParticipantBarcode,Group))
#This step is optional - we are just adding some noise to the measurement
dfclong <- dfclong %>% dplyr::mutate(Cell_Fraction=Cell_Fraction+rnorm(mean=0, sd=0.0001,nrow(.)))
dfclong.generic <- dfclong %>% rename(Node=Cell,Value=Cell_Fraction)

#The gene expression data requires a similar processing. After this, we can merge the data for cells and genes in one dataframe.

dfelong <- dfe_in %>% tidyr::gather(Gene,Expression,-ParticipantBarcode)
dfelong <- dfelong %>% dplyr::mutate(ExpLog2 = log2(Expression+1)+rnorm(mean=0, sd=0.0001,nrow(.))) %>%
  dplyr::select(ParticipantBarcode,Gene,Expression=ExpLog2) %>%
  dplyr::mutate(Group=group_of_participant[ParticipantBarcode])
dfelong.generic <- dfelong %>% rename(Node=Gene,Value=Expression)

dfn <- dplyr::bind_rows(dfelong.generic, dfclong.generic)

#Computing nodes scores
nodes_scores <- abcnet::compute_abundance(dfn, node= "Node", ids = "ParticipantBarcode", exprv = "Value", group = "Group", cois = cois, gois = gois)

#Organizing the scores in a table
abundance_scores <- abcnet::get_abundance_table(nodes_scores)

#Computing edges scores
edges_scores <- abcnet::compute_concordance(filtered_scaffold, nodes_scores)

#The abundance_scores and edges_scores objects are in the appropriate format to be exported as tsv files. These files can be used in network visualization softwares, such as Cytoscape. 

readr::write_tsv(abundance_scores, paste("nodes_", Sys.Date(),".tsv", sep = ""))
readr::write_tsv(edges_scores, paste("edges_", Sys.Date(),".tsv", sep = ""))

