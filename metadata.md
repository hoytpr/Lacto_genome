---
---
# Lactococcus Metadata

Genomic DNA was received on 2021-02-26 at the Oklahoma State University Genomics Center.


Library kit:

Sequencing Kit: Illumina (2 X 75bp) MID-output kit (150 cycles)

Sequencing Start Date: 2021-03-09

Sequencing Completed Date: 2021-03-10

Sequencing Output: 18.85 GB

Run Number: 210309_NB501827_0133_AHMV5HAFX2

Data Archive Date: 2021-03-10

Archive Location: The University of Oklahoma Petastore (soon to be OURRstore)

Primary Data Filenames: L_lactis_S1_LALL_R1_001.fastq.gz, L_lactis_S1_LALL_R2_001.fastq.gz

Files processed through `bcl2fastq`?: YES

Number of Reads Passed Filter Read1:144,378,652

Number of Reads Passed Filter Read2:144,378,652

Post-sequencing QC:Trimmomatic v. 0.38 

Trimmomatic Command: ***[script 1](/scripts.md#trim01)**

Orphaned reads from Trimmomatic were discarded and trimmed reads were repaired using BBTools `re-pair` software v. 38.90 **[script 2](/scripts.md#BB01)**

Number of Reads surviving Trimmomatic and `re-pair` Read1:135,271,743

Number of Reads surviving Trimmomatic and `re-pair` Read2:135,271,743

### ASSEMBLY

Current readfile names: L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq, L_lactis_S1_LALL_R2
.trim.Gtrim.fixed.fastq

Genome reads are thresholded to 1-million read chunks **[script3](/scripts.md#thresh01)**

Thresholded `.fastq` files containing 1M-4M reads each are created by `cat` at defined sizes to be tested for best assembly. Smaller and larger sizes were tested. The use of ≤4M reads total gave good overall genome coverage for identifying plasmid elements, while higher numbers (8M) could be used with read mapping. 
**[script4](/scripts.md#cat01)**

After testing, 2M read `fastq` files were named: `LacR1aaab.fastq`, and `LacR2aaab.fastq`. Similarly, 4M read `fastq` files were named: `LacR1aaabacad.fastq`, and `LacR2aaabacad.fastq`.

#### Pre-Assembly (Assembly with plasmids)

All Reads were assembled using SPAdes 3.15.0 using the --careful and --plasmid options as in [script 5](/scripts.md#scr05). This step was taken to allow for the removal of plasmid sequences from the genomic assembly if plasmids are present. 

Plasmid output graph pathways are the most important part of this output. In this case the file `assembly_graph_after_simplification.gfa` is output. This file was opened using `Bandage` v. 0.8.1 [http://rrwick.github.io/Bandage/](http://rrwick.github.io/Bandage/). The default image created (colored by read depth) is shown below:

![Lactococcus assembly using --plasmid --careful](/fig/graph1.png).

This graph shows several important issues:
1. The Illumina sequencing was very high quality as there is only one (1) "dead-end".
2. This graph clearly shows at least one separate high-copy-number plasmid.
3. The graph *implies* there is another high-copy region within the genome assembly.

An additional outputs are the files `assembly_graph_with_scaffolds.gfa` and `assembly_graph.fastg` which are the SPAdes predicted plasmid sequence elements. 

![Lactococcus predicted plasmids from SPAdes using --plasmid --careful](/fig/graph0_scaffolding.png).

Now we can see that SPAdes predicts at least two plasmids with one set of predicted plasmid scaffolds having much higher read counts than the other (or the genomic). Based on these data three processes were performed

1. Isolation of the high-copy read plasmid sequences (Plasmid1)
2. Isolation of the lower-copy read plasmid sequences (Plasmid2)
3. Removal of the presumptive plasmid reads from the rest of the genomic reads for assembly. 

The metadata for the predicted plasmid sequences is shown below:
|Node count:	|1,743	|N50:	|37,182 bp|
|Edge count:	 |2,358	|Shortest node:	|32 bp|
|Edge overlaps:	|31 bp	|Lower quartile node:	|45 bp|
|Total length:	 |2,57 9,211bp	|Median node:	|63 bp|
|Total length (no overlaps):	 |2,525,178bp	|Upper quartile node:	|116 bp|
		|Longest node:	|15  |6,326 bp||

  
   
    
	 
	  
	   
	   












For [figures click here](/fig/)