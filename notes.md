---
---
# Notes

<a name="01"></a>
`1.` [NexteraPE-PE-G.fa](/files/NexteraPE-PE-G.fa) is a downloadable custom adapter removal file designed to also remove poly(G) stretches of 35 consecutive G nucleotides (or more) in the reads data which can occur with Illumina "two-color" technology sequencers (usually in read-2). 

<a name="02"></a>
`2.` The outputs are a series of `fastq.` files 4M lines long (1M reads each). The first set are:
```
LacR1aa
LacR1ab
LacR1ac
LacR1ad
LacR1ae
(etc.)
```
The second set of files are similar but for read 2
```
LacR2aa
LacR2ab
LacR2ac
LacR2ad
LacR2ae
(etc.)
```
These are renamed as `.fastq` files in the next steps when they are concatenated.

<a name="03"></a>
`3.` This could also be done with a  well-known `sed` script such as:
```
sed -n '1~4s/^@/>/p;2~4p' LacR2aaab.fastq > LacR2aaab.fasta
```

<a name="04"></a>
`4.` The same type of piping used in script 10 could have been used here.

<a name="05"></a>
`5.` After removing plasmid reads, the Spades assembly contained no plasmid in the 
`assembly_graph_with_scaffolds.gfa` and `assembly_graph.fastg` which were both empty files.


<a name="ncbi"></a>
`6.` Currently, the PrHT3 genome and pPrHT3 plasmid2 are combined within "sample 1" of the NCBI
BioProject, but were submitted as separate `.bam` files. Until this is resolved, the separated 
`.bam` files are available by request.







[HOME](/README.md)








1. For [figures click here](/fig/)