---
---

## Plasmid-1ab

Plasmid-1ab is named (as might be inferred) for plasmid-1a and plasmid-1b. We were unable to resolve whether this is one plasmid or two plasmids (described below). If this is one plasmid, the overall size (with overlaps) estimated by Bandage is 19,297 bp. Conversely, if there are two plasmids, each plasmid is about half that size, or **~9,648 bp each**. Also note that when submitting `.fastq` files to NCBI, we cannot include any "contig" under 200bp. After assembly, the total length of the submitted contigs was **17,155 bp**. To confirm the sequence(s) and length(s) of Plasmid-1ab, one will have to isolate the plasmid(s) from a culture of Lactococcus, then clone and sequence the plasmid using Sanger sequencing. 

Shown [previously](/metadata.md#band01), the initial SPAdes `--plasmid` option generated `.gfa` files where plasmid-1ab had much higher copy numbers than other elements when viewed by read depth in Bandage. For example, when using 4-million paired end reads, the mean read depth of plasmid-1ab nodes is 381x, while the genome nodes read depth is 54x. This indicates a plasmid copy number of over 7 per cell.

NOTE: In all the images below read depth is ***relative*** and colored with "red" for higher read depth, and a darker color indicating lower read depths.

When viewed in Bandage, the original presumptive Plasmid-1ab nodes appear complex. Much of this is due to small and low-copy-number nodes. In the following image the original node edges have been stretched apart so that the nodes and edges are all visible. 

![complex](/fig/Plasmid1ab-exploded-before-trimming-selected.png)

We charted the depth of all 106 nodes and and found a distinct 
threshold at a read depth of 25x where nodes might be complicating the analyses. These 
nodes represented only 0.8% of the total coverage within the plasmid-1ab assembly. 
There was also a threshold at approximately 500x that suggested where shared/duplicated sequences might be 
showing up in the graph assembly. 

![threshold](/fig/plasmid-1ab-node-depth.png)

Looking at the raw data, the inflection point in coverage increase went from **24.4x (node #222887) to 224.5x (node #221355)**. Subsequently reads below **25x** were removed as putative artifacts. After **removing** nodes with read depth below **25x**, the graph assembly is greatly simplified.

 ![greatly simplified](/fig/Plasmid1ab-exploded-after-trimming.png) 
 
 When redrawn, the graph appears as contiguous paths having seven (7) bubbles to resolve, suggesting two plasmids with  shared sequence identity. 
 
 ![significant shared sequence identity](/fig/990-selection-graph.png) 
 
 Only one node pair (#600074 and #276613) marked with an asterisk in the above image, remained as an unresolved repeated sequence. When we zoom in on these nodes we can see that the copy numbers suggests that node #276613 (505x) is the repeated element, not #600074 (270x).
 
 ![unresolved repeated sequence](/fig/600074-and-276613-graph-labels.png) 
 
  This repeat can be resolved *in silico* using Bandage by replicating node 276613 (59bp, 505x) and placing a copy of 276613 (each now at 252x depth) on either side of node 600074. In Bandage after replicating a node, this is done by removing edges (blue colored) as shown effectively "splitting" the node into  a contiguous sequence. More information on these processes can be found at the [Bandage GitHub wiki.](https://github.com/rrwick/Bandage/wiki)
  
![Before edge removal](/fig/resolving-600074-v-2sm.png)
![After edge removal](/fig/resolving-600074-v2-Bsm.png) 

The next level of resolving the graph involves splitting six (6) individual nodes (#37, #606278, #41, #1113, and #378121) as well as a run of three consecutive shared nodes (#89-#1265-#447099) between the bubbles in the graph. 

![between bubbles](/fig/Plasmid1ab-after-depth-25-trimming-best-layout-depth250-700.png) 

To resolve the contiguity of the plasmid(s), proper linkage could be acheived by matching sequence read depth on each side of the split shared nodes. For example if a shared node (A), had two nodes on one side with coverages of 100X (B) and 600x (B'), then also had two nodes on the other side with 590x (C) and 110x (C'), it would be reasonable to split the shared node, and delete edges such that the node with 100x coverage would connect to the now split shared node (A), then to the node with 110x coverage (B-A-C'). Conversely, the node with 600x coverage would connect to the split shared node (A'), and then to the node with 590x coverage (B'-A'-C). This is (simplistically) how a [directed acyclic graph](https://en.wikipedia.org/wiki/Directed_acyclic_graph) algorithm works during an assembly ("construction") process. 

Unfortunately, using descriptors from the analogy above, the read depths on opposing sides of all shared nodes (referred to in clockwise mode "CW") are too similar (read depths in parentheses) and cannot be split confidently. This is shown in the table below:

| Shared-node-A | CW-node-B | CW-node-B' | CW-node-C | CW-node-C' | 
| --- | --- | --- | --- | --- |
| 37 (839x) | 15 (309x) | 622375 (290x) | 1247 (366x) | 1271 (423x) |
| 378121 (648x) | 1145 (366x) | 1221 (367x) | 616158 (403x) | 591624 (378x) |
| 1113 (657x) | 621353 (405x) | 595144 (361x) | 1277 (344x) | 1302 (356x) |
| 609586 (771x) | 614554 (405x) | 619531 (393x) | 1117 (360x) | 1281 (339x) |
| 41 (732x) | 1279 (329x) | 83 (322x) | 615970 (480x) | 620521 (482x) |
| 606278 (990x) | 1298 (434x) | 1312 (417x) | 618166 (400x) | 57 (378x) |
| 89-1265-447099 (798x) | 277 (492x) | 275 (501x) | 85 (290x) | 75 (274x) |

(This is a little messy but so is labeling every node and showing images). Below we show that with no other options for graph simplification or node splitting
the contiguous nodes can be merged resulting in a final graph suggesting two plasmids.  
with shared homology (shared nodes are labeled) as the final product of our analyses. 

![our analyses](/fig/Plasmid1ab-simplified_graphs.png) 

However, it is also possible that these nodes could be split such that 
a single larger plasmid is the final result. Because these structural probabilities are unresolvable, the term "Plasmid-1ab" was deemed most appropriate. 

These Bandage node names were used to extract Plasmid-1ab reads from the total reads. Below we show some of the 
command-line scripts used to extract the nodes shown from the bandage image, and then 
recover the names and assemble the reads that make up Plasmid-1ab. The process is essentially the same as on the [metadata page](/metadata.md) 
and [scripts #15 and #16 on the scripts](/scripts.md#scr15) page. Because the re-assembled plasmid contigs did not appear as contiguous sequences when using Blast+ on the NCBI "nt" database (homologies that appeared were fragmented), we believe this plasmid (or plasmids) is "novel", *i.e.* not previously described.


```
fr1r2=LacR1R2
fs1=LacR1_plas1
fs2=LacR2_plas1
db1=/plasmid1
grep -E $'^S\t' ${fr1r2}00_careful_plasmid/assembly_graph_with_scaffolds.gfa > ${fr1r2}gfa.out
for line in ${fr1r2}gfa.out 
    do 
    awk '{print ">" $2}''{print $3}' ${line} >> ${fr1r2}gfa.out.fasta 
done 
makeblastdb -in ${fr1r2}gfa.out.fasta -out ${db1} -parse_seqids -dbtype nucl 
sed -n '1~4s/^@/>/p;2~4p' ${fs1}_00.fastq > ${fs1}_00.fasta
sed -n '1~4s/^@/>/p;2~4p' ${fs2}_00.fastq > ${fs2}_00.fasta
blastn -db ${db1} -num_threads 32 -evalue 0.001 -query ${fs1}_00.fasta -out ${fs1}.out -outfmt "6 qseqid"
blastn -db ${db1} -num_threads 32 -evalue 0.001 -query ${fs2}_00.fasta -out ${fs2}.out -outfmt "6 qseqid"
awk '{print $1}' ${fs1}.out | uniq > ${fs1}names
awk '{print $1}' ${fs2}.out | uniq > ${fs2}names
grep -A3 --file=${fs1}names LacR1aaabacad.fastq | grep -E -v '\--' > {fs1}.fastq 
grep -A3 --file=${fs2}names LacR2aaabacad.fastq | grep -E -v '\--' > {fs2}.fastq 
repair.sh in1=${fs1}.fastq in2=${fs2}.fastq out1=${fs1}fixPlas1.fastq out2=${fs2}fixPlas1.fastq outs=${fs1}orphPlas1.fastq
```

```
$ wc -l ${fs1}fixPlas1.fastq
1143464 LacR1_plas1fixPlas1.fastq  (285,866 reads)
$ wc -l ${fs2}fixPlas2.fastq
1143464 LacR2_plas1fixPlas2.fastq  (285,866 reads)
```

```
module load spades/3.15.0
module load python3/3.6.4
spades.py -t 32 -m 768 -k 29,31,33,55 -1 ${fs1}fixPlas1.fastq -2 ${fs2}fixPlas2.fastq --isolate --cov-cutoff auto -o ${fr1r2}_Plasmid1_isolate
```

| [To README Page](/README.md) | [To metadata page](/metadata.md) |
| --- | --- |



