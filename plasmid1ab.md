---
---

## Plasmid-1ab

Plasmid-1ab is named (as might be inferred) for plasmid-1a and plasmid-1b. We don't know the sizes of the two plasmids, but the overall size (with overlaps) is 19,297 bp. So a rough estimate is that each plasmid is about half that size, or **~9,648 bp each**. Also note that when submitting `.fastq` files to NCBI, we cannot include any "contig" under 200bp. So the amount of contig length sequence submitted amounted to 17,155 bp. At this point, the data scientists have to make room for the life scientists (not that one can't be ***both***) to isolate the plasmid(s) from a culture of Lactococcus, then clone and sequence the plasmid using Sanger sequencing (which is NOT a trivial amount of work!). 

The SPAdes `--plasmid` option generated `.gfa` files where plasmid-1ab had much higher copy numbers than other elements when viewed by read depth in Bandage. The mean read depth of plasmid-1ab nodes is 381x, while the genome nodes read depth is 54x (both values obtained using 4M PE reads). This indicates a plasmid copy number of over 7 per cell.

NOTE: in all the images below read depth is relative and colored with "red" being higher read depth, and darker color indicating lower read depths.



When viewed in Bandage, the original presumptive plasmid nodes appear complex. Below the original node edges have been stretched apart so that the nodes are all visible. 

![complex](/fig/Plasmid1ab-exploded-before-trimming-selected.png)

We charted the depth of all 106 selected nodes and this showed that there was a distinct 
threshold at a depth of 25x where nodes could be excluded that might be complicating the analyses. These 
nodes represented only 0.8% of the total coverage within the plasmid-1ab assembly. 
There was also a less distinct threshold at approximately 500x that suggested where duplicated sequences might be 
showing up in the graph assembly. 

![threshold](/fig/plasmid-1ab-node-depth.png)

Looking at the raw data, the inflection point in coverage increase went from 24.4x (node #222887) to 224.5x (node #221355). These reads below 25x were subsequently removed as possible artifacts. After **removing** nodes with read depth below **25x**, the graph assembly is greatly simplified.

 ![greatly simplified](/fig/Plasmid1ab-exploded-after-trimming.png) 
 
 When redrawn, the graph appears as contiguous paths with seven (7) bubbles to resolve, suggesting two plasmids with significant shared sequence identity. 
 
 ![significant shared sequence identity](/fig/990-selection-graph.png) 
 
 Only one node pair (#600074 and #276613) marked with an asterisk in the above image, remained as an unresolved repeated sequence. When we zoom in on these nodes we can see that the copy number suggests that node #276613 (505x) is the repeated element, not #600074 (270x).
 
 ![unresolved repeated sequence](/fig/600074-and-276613-graph-labels.png) 
 
  This repeat can be resolved *in silico* by replicating node 276613 (59bp, 505x) and placing a copy of 276613 (each now at 252x depth) on either side of node 600074. In bandage after duplicating a node, this is done by removing edges (blue colored) as shown.
  
![Before edge removal](/fig/resolving-600074-v-2sm.png)
![After edge removal](/fig/resolving-600074-v2-Bsm.png) 

The next level of resolving the graph involves splitting six (6) individual nodes between bubbles (#37, #606278, #41, #1113, and #378121) as well as a run of three consecutive shared nodes (#89-#1265-#447099). 

![between bubbles](/fig/Plasmid1ab-after-depth-25-trimming-best-layout-depth250-700.png) 

The individual nodes could be duplicated to resolve the contiguity of the plasmid(s), and proper linkage could conceivably be done by matching sequence read depth on either side of the duplicated node. For example if a shared node (A), had two nodes on one side with coverages of 100X (B) and 600x (B'), then also had two nodes on the other side with 590x (C) and 110x (C'), it would be reasonable to split the shared node, and delete edges where coverage is not similar. The node with 100x coverage would connect to the shared node, then to the node with 110x coverage (B-A-C'). Conversely, the node with 600x coverage would connect to the shared node, and then to the node with 590x coverage (B'-A-C). This is (simplistically) how a [Directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) algorithm works during an assembly ("construction") process. Unfortunately, the read depths on opposing sides of all these shared nodes (referred to in clockwise mode "CW") are too similar as shown in table 1 below:

| Shared node (A) | CW-node(B) | CW-node(B') | CW-node(C) | CWR-node(C') | 
| --- | --- | --- | --- | --- |
| 37 (839x) | 15 (309x) | 622375 (290x) | 1247 (366x) | 1271 (423x) |
| 378121 (648x) | 1145 (366x) | 1221 (367x) | 616158 (403x) | 591624 (378x) |
| 1113 (657x) | 621353 (405x) | 595144 (361x) | 1277 (344x) | 1302 (356x) |
| 609586 (771x) | 614554 (405x) | 619531 (393x) | 1117 (360x) | 1281 (339x) |
| 41 (732x) | 1279 (329x) | 83 (322x) | 615970 (480x) | 620521 (482x) |
| 606278 (990x) | 1298 (434x) | 1312 (417x) | 618166 (400x) | 57 (378x) |
| 89-1265-447099 (798x) | 277 (492x) | 275 (501x) | 85 (290x) | 75 (274x) |

This is a little messy without labeling every node and showing imaages of them, but you can see below that with no other options for graph simplification or node separations
the contiguous nodes can be merged into a final graph suggesting two plasmids ("a" & "b") 
with shared homology (nodes labeled) as the final product of our analyses. ![our analyses](/fig/Plasmid1ab-simplified_graphs.png) 

Below are some of the command-line scripts used to extract the nodes shown from the bandage image, and then 
recover the names and assemble the reads that make up plasmid-1ab. The process is the same as on the [metadata](/metadata.md) 
and [scripts](/scripts.md) pages. But these reads did not appear as contiguous sequences when using Blast+ on the NCBI "nt" database (some fragments did show up). As such we believe this plasmid (or plasmids) is "novel", or not previously described.


```
 grep -A3 --file=LacR1R2aaabacad-unique-plasmid1-names.txt LacR1aaabacad.fastq | grep -E -v '\--' > R1aaabacadPlasmid1.fastq
 grep -A3 --file=LacR1R2aaabacad-unique-plasmid1-names.txt LacR2aaabacad.fastq | grep -E -v '\--' > R1aaabacadPlasmid1.fastq
```

```
$ wc -l R1aaabacadPlasmid1.fastq
1143464 R1aaabacadPlasmid1.fastq  (285,866 reads)
$ wc -l R2aaabacadPlasmid1.fastq
1143464 R2aaabacadPlasmid1.fastq  (285,866 reads)
```

```
module load spades/3.15.0
module load python3/3.6.4
spades.py -t 32 -m 768 -k 29,31,33,55 -1 R1aaabacadPlasmid1.fastq -2 R2aaabacadPlasmid1.fastq --isolate --cov-cutoff auto -o LACaaabacad_Plasmid1_isolate
```





