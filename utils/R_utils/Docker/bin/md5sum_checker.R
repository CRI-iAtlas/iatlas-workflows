args = commandArgs(trailingOnly=TRUE)

sum1 <- tools::md5sum(args[1])
sum2 <- tools::md5sum(args[2])

if(sum1 == sum2){
    result <- "Pass"  
} else { 
    result <- "Fail"
}

write(result, stdout())