---
---
# Notes

<a name="01"></a>
`1.` [NexteraPE-PE-G.fa](/files/NexteraPE-PE-G.fa) is a downloadable custom adapter removal file designed to also remove poly(G) stretches of up to 35 consecutive G nucleotides in the data which sometimes occur with the NextSeq500 sequencer (usually in read-2). 

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

[HOME](/README.md)








1. For [figures click here](/fig/)