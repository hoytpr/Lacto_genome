---
---
[HOME](/README.md)


# Validation of Lactococcus lactis PrHT3 Species

The `CheckM` software was downloaded from  [the CheckM website](https://ecogenomics.github.io/CheckM/). It was installed using
the `conda` method as described on the [CheckM website](https://github.com/Ecogenomics/CheckM/wiki/Installation#how-to-install-checkm) onto the ["Pete" high performance computer at
Oklahoma State University](https://hpcc.okstate.edu/)

The commands used to generate these data are:
```
module load anaconda3/2021.05
checkm data setRoot data
checkm taxonomy_wf genus Lactococcus bins lacout
checkm tree -r bins trees
checkm tree_qa -o 1 -f otrees trees --tab_table
checkm lineage_set trees omarkers
checkm taxon_list --rank genus
checkm taxon_set genus Lactococcus omarkers
checkm analyze -t 12 omarkers bins outputs --ali --nt
checkm qa omarkers outputs --out_format 2
```
The `data` folder conatined the required pre-determined CheckM marker set `checkm_data_2015_01_16.tar.gz`

The `bins` folder contained the PrHT3 assemblies as contigs, and several 
relevant Lactococcus lactis genomes (in fasta format) downloaded from NCBI RefSeq.

The `lacout` folder holds analytics of the CheckM software inferred by NCBI
genomes

The `outputs` folder holds the analytics from the pre-determined CheckM markers.  

The `trees` folder holds the outputs of phylogenetic analyses

To ascertain the validity of the Lactococcus lactis strain designation
the final L. lactis PrHT3 contigs (with and without plasmid sequences included)
were compared to the built-in set of lineage-specific taxon markers required for the 
CheckM software downloaded from [https://data.ace.uq.edu.au/public/CheckM_databases/](https://data.ace.uq.edu.au/public/CheckM_databases/) 
and compared to other known Lactococcus lactis genomes from the 
NCBI RefSeq database including both "complete" and incomplete genomes. 
The NCBI genomes insured that Lactococcus lactis makers were well represented to CheckM.
The files used were:
- GCF_000478255.1_ASM47825v2_genomic.fna
- GCF_004194355.1_ASM419435v1_genomic.fna
- GCF_016028835.1_ASM1602883v1_genomic.fna (used to map reads for NCBI)
- GCF_016406265.1_ASM1640626v1_genomic.fna
- GCF_016921015.1_ASM1692101v1_genomic.fna
- GCF_020221755.1_ASM2022175v1_genomic.fna
- GCF_020463755.1_ASM2046375v1_genomic.fna (the L. lactis reference genome)
- GCF_023734755.1_ASM2373475v1_genomic.fna


**The final genomic DNA contigs submitted to NCBI as a BAM alignment were named:**
- PrHT3-FINAL-genomic-scaffolds.fna 

(download these data [HERE](/files/PrHT3-FINAL-genomic-scaffolds.fna))

An unpublshed PrHT3 assembly that included the plasmid sequences was named:
- PrHT3-with-plasmids.fna  

The `PrHT3-with-plasmids.fna` was included in the CheckM analyses because some of the NCBI genomes contained plasmid DNA

### CONCLUSIONS ###

**The results indicate that PrHT3 is Lactococcus lactis.** 

The phylogenetic analyses are included in the image below and show that identification
and use of GCF_016028835.1_ASM1602883v1 for read mapping was appropriate because it 
is the most highly related genome to PrHT3.

![PhyloLac.png](/img/PhyLoLac.png)

This image is a partial visualization (using Dendroscope version 3.5.9) the the phylogenetic tree in Newick format named [concatenated.tre](/files/concatenated.tre). 

The summary statistics ("strain heterogeneity") of CheckM are available as file [bin_stats.analyze.tsv](/files/bin_stats.analyze.tsv). 

[HOME](/README.md)
