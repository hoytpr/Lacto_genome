---
---
[HOME](/README.md)


# Validation of Lactococcus lactis PrHT3 Species

The `CheckM` software was downloaded from  [the CheckM website](https://ecogenomics.github.io/CheckM/). It was installed using
the `conda` method as described on the [CheckM website](https://github.com/Ecogenomics/CheckM/wiki/Installation#how-to-install-checkm) onto the ["Pete" high performance computer at
Oklahoma State University](https://hpcc.okstate.edu/)

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
- GCF_016028835.1_ASM1602883v1_genomic.fna
- GCF_016406265.1_ASM1640626v1_genomic.fna
- GCF_016921015.1_ASM1692101v1_genomic.fna
- GCF_020221755.1_ASM2022175v1_genomic.fna
- GCF_020463755.1_ASM2046375v1_genomic.fna
- GCF_023734755.1_ASM2373475v1_genomic.fna

**The final genomic DNA contigs submitted to NCBI were named:**
- PrHT3-FINAL-genomic-scaffolds.fna 

(download these data [HERE](/files/PrHT3-FINAL-genomic-scaffolds.fna))

An unpublshed PrHT3 assembly that included the plasmid sequences was named:
- PrHT3-with-plasmids.fna  

The `PrHT3-with-plasmids.fna` and other contigs/assemblies were included in the CheckM analyses because some of the NCBI genomes contained plasmid DNA

**The results indicate that PrHT3 is Lactococcus lactis.** 

The phylogenetic analyses are included in the image below

![PhyloLac.png](/img/PhyLoLac.png)

This image is a partial visualization the the phylogenetic tree in Newick format named [concatenated.tre](/files/concatenated.tre). and the summary statistics ("strain heterogeneity") are available as file [bin_stats.analyze.tsv](/files/bin_stats.analyze.tsv). 

[HOME](/README.md)
