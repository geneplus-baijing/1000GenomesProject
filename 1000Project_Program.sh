#work on linux
# Unzip the files
cd Data
tar -zxvf 1000_Project_SNP_RAW.vcf.tar.gz
tar -zxvf OurData_SNP_RAW.vcf.tar.gz

#Part I. Process the 1000 Genome Project data
#
plink --vcf 1000_Project_SNP_RAW.vcf --make-bed --out v2p.Combine.PanelRegion.1KGP.vcf
plink --bfile v2p.Combine.PanelRegion.1KGP.vcf --indep 50 5 2 --allow-no-sex --make-bed --out v2p.Combine.PanelRegion.1KGP.vcf.Windows
plink --bfile v2p.Combine.PanelRegion.1KGP.vcf.Windows --allow-no-sex --mind 0.1 --out v2p.Combine.PanelRegion.1KGP.vcf.mind --make-bed
plink --bfile v2p.Combine.PanelRegion.1KGP.vcf.mind --maf 0.01 --allow-no-sex --make-bed --out v2p.Combine.PanelRegion.1KGP.vcf.maf
plink --bfile v2p.Combine.PanelRegion.1KGP.vcf.maf --geno 0.1 --allow-no-sex --make-bed --out v2p.Combine.PanelRegion.1KGP.vcf.geno
plink --bfile v2p.Combine.PanelRegion.1KGP.vcf.geno --hwe 0.000001 --allow-no-sex --out v2p.Combine.PanelRegion.1KGP.vcf.handy --make-bed
plink --bfile v2p.Combine.PanelRegion.1KGP.vcf.handy --export vcf --out v2p.Combine.PanelRegion.1KGP.vcf.handy.final


#Part II. Process our internal data
#
plink --vcf OurData_SNP_RAW.vcf --make-bed --out v2p.02.combined_GT.vcf
plink --bfile v2p.02.combined_GT.vcf --indep 50 5 2 --allow-no-sex --make-bed --out v2p.02.combined_GT.vcf.Windows
plink --bfile v2p.02.combined_GT.vcf.Windows --allow-no-sex  --mind 0.1  --out v2p.02.combined_GT.vcf.mind --make-bed 
plink --bfile v2p.02.combined_GT.vcf.mind --maf 0.01  --allow-no-sex  --make-bed  --out v2p.02.combined_GT.vcf.maf
plink --bfile v2p.02.combined_GT.vcf.maf --geno 0.1  --allow-no-sex  --make-bed  --out v2p.02.combined_
GT.vcf.geno
plink --bfile v2p.02.combined_GT.vcf.geno --hwe 0.000001 --allow-no-sex  --out v2p.02.combined_GT.vcf.h
andy --make-bed
plink --bfile v2p.02.combined_GT.vcf.handy --export vcf --out v2p.02.combined_GT.vcf.handy.final




#Part III. Extract the Common SNP between the 1000 Genome data and our data, and perform PCA analysis
bgzip -c Common.v2p.02.combined_GT.vcf.handy.final.vcf >  Common.v2p.02.combined_GT.vcf.handy.final.vcf.gz
bgzip -c  Common.v2p.Combine.PanelRegion.1KGP.vcf.handy.final.vcf > Common.v2p.Combine.PanelRegion.1KGP.vcf.handy.final.vcf.gz
bcftools index -t Common.v2p.02.combined_GT.vcf.handy.final.vcf.gz
bcftools index -t Common.v2p.Combine.PanelRegion.1KGP.vcf.handy.final.vcf.gz
bcftools merge -m snps -f PASS,. --force-samples Common.v2p.02.combined_GT.vcf.handy.final.vcf.gz Common.v2p.Combine.PanelRegion.1KGP.vcf.handy.final.vcf.gz > PCA_combined_Common_SNP.vcf
plink --vcf PCA_combined_Common_SNP.vcf --recode --out PCA_combined_Common_SNP.vcf --const-fid --allow-extra-chr
plink --allow-extra-chr --file PCA_combined_Common_SNP.vcf --noweb --make-bed --out PCA_combined_Common_SNP.vcf
plink --vcf PCA_combined_Common_SNP.vcf --pca 2 --out PCA_2_combined_Common_SNP.vcf


#Using EIGENSOFT to calculate the fst 
/usr/local/src/EIG-7.2.1/bin/convertf -p transfer.conf
/usr/local/src/EIG-7.2.1/bin/smartpca -p runningpca.conf
