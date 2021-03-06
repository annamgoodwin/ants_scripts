library(ANTsR)

#set whatever paths you want
path_to_dz <- "/spin1/users/zhoud4/ants_scripts/"
path_to_cpb <- "/home/zhoud4/cpb/ants1/lhipp3_batch/"

#read list of subject IDs to pass through loop
sub_list <- as.matrix(read.table("sub_full.txt"))

#for each subject...
for (i in sub_list) {  
  #set path for each modality (e.g. label, T1 weighted, T2* weighted)
  m1=paste("mi[",path_to_dz,"lhtemplate0_rigidtransform.nii.gz,",path_to_cpb,i,"-lab.nii.gz, 1, 32,Regular, 0.25]",sep="")
  m2=paste("mi[",path_to_dz,"lhtemplate1_rigidtransform.nii.gz,",path_to_cpb,i,"-t1.nii.gz, 1, 32,Regular, 0.25]",sep="")
  m3=paste("mi[",path_to_dz,"lhtemplate2_rigidtransform.nii.gz,",path_to_cpb,i,"-t2s.nii.gz, 1, 32,Regular, 0.25]",sep="")
  
  #set output path and file pre-fix
  output=paste(path_to_dz,"lh",i,"-30-pass2-",sep="")
  
    antsRegistration(
      list(
        d = 3, #3 dimentions
        float = 1, #as opposed to double-point
        v = 1, #verbose for more info
        u = 1, #use histogram matching
        w = "[0.01,0.99]", #winsorize image intensities; upper,lower quantile
        z = 1, #collapse output transforms to combine all adjacent transforms where possible
        r = paste("[",path_to_cpb,"lhtemplate0.nii.gz,",path_to_cpb,i,"-lab.nii.gz,1]",sep=""),
        #initial moving transform based on geometric center of the image intensities, which gets 
        #immediately incorporated into the composite transform the last transform specified on 
        #the command line is the first to be applied
        
        t = "Rigid[0.1]", #rigid transformation with 0.1 gradient step
        m = m1, #label images
        m = m2, #T1 images
        m = m3, #T2* images
        c = "[1000x500x250x0,1e-6,10]", #determines slope of normalized energy profile for the
        #last N iterations and compares to convergence threshold
        f = "6x4x2x1", #shrink factors at each level
        s = "4x2x1x0", #gaussian smoothing sigmas at each level
    
        o = output
      )
    )
}