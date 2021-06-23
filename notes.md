---
---
# Notes

<a name="01"></a>
`Note 1.` [NexteraPE-PE-G.fa](/files/NexteraPE-PE-G.fa) is a downloadable custom adapter removal file designed to also remove poly(G) stretches of 35 consecutive G nucleotides (or more) in the reads data which can occur with Illumina "two-color" technology sequencers (usually in read-2). 

<a name="02"></a>
`Note 2.` The outputs are a series of `fastq.` files 4M lines long (1M reads each). The files are by default given alphabetical suffixes. The first set are:
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
`Note 3.` This could also be done with a  well-known `sed` script such as:
```
sed -n '1~4s/^@/>/p;2~4p' LacR2aaab.fastq > LacR2aaab.fasta
```

<a name="04"></a>
`Note 4.` The same type of piping used in script 10 could have been used here.

<a name="05"></a>
`Note 5.` After removing plasmid reads, the Spades assembly contained no plasmid in the 
`assembly_graph_with_scaffolds.gfa` and `assembly_graph.fastg` which were both empty files.

<a name="06"></a>
`Note 6.` These scripts could have been simplified to (for example):
```
blastn -db /lactoplasmid/lactoplasmid/lactoplas_db -num_threads 32 -evalue 0.001 -query LacR1aaabacad.fasta -out /lactoplasmid/lactoplasmid/R1aaablactoplas.out -outfmt "6 qseqid"
```
This would have produced read name files that did not need to be "cleaned" with further `awk` scripts. 

[Go back to assembly metadata](/metadata.md#met01)







[HOME](/README.md)








1. For [figures click here](/fig/)