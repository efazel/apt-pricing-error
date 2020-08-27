#############################################################
###################### FUNCTION perror ######################
## Author: Ehsan Fazel (Concordia University)              ##
## This version: Feb. 2019                                 ##
##                                                         ##
## This function measures the pricing errors for the       ## 
## Arbitrage Pricing Theory using a rolling window         ##
## regression. For theoretical framework, refer to Geweke  ##
## and Zhou (1996)                                         ##
##                                                         ##
## Inputs:                                                 ##
##     returns: TbyN matrix of asset returns               ##
##     factor: Tby1 vector of the factor                   ##
##     w: rolling window length                            ##
##                                                         ##
## Outputs:                                                ##
##     Mean: mean of the pricing errors                    ##
##     SD: standard deviation of the pricing errors        ##
##     CI: %95 confidence interval                         ##
#############################################################
#############################################################
