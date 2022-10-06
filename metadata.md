---
---
[HOME](/README.md)


# Lactococcus lactis PrHT3 Metadata

Genomic DNA was received on 2021-02-26 at the [Oklahoma State University Genomics Center](https://genomics.okstate.edu/).

DNA quality by Tapestation analysis:

![DNA](/fig/genomic-DNA-tapestation.png)

DNA concentration by picogreen fluorometry: 17.4 ng/ul

Library kit: KAPA/Roche HyperPlus (Cat.# KK8512)

Library preparation result:

![library](/fig/Library-QC.png)

Sequencing Kit: Illumina (2 X 75bp) MID-output kit (150 cycles)

Sequencing Start Date: 2021-03-09

Sequencing Completed Date: 2021-03-10

Sequencing Output: 18.85 GB

Run Number: 210309_NB501827_0133_AHMV5HAFX2

Data Archive Date: 2021-03-10

Archive Location: The University of Oklahoma [OURRstore Regional archives](https://ou.edu/oscer/resources/ourrstore--ou---regional-research-store)

Primary Data Filenames: `L_lactis_S1_LALL_R1_001.fastq.gz` and `L_lactis_S1_LALL_R2_001.fastq.gz`

Files processed through `bcl2fastq`? YES

Number of Reads Passed Filter Read1: 144,378,652

Number of Reads Passed Filter Read2: 144,378,652

Post-sequencing QC: Trimmomatic v. 0.38 ([Citations](/citations.md#cit02))

Orphaned reads from Trimmomatic were discarded and trimmed reads were repaired using BBTools `re-pair` software v. 38.90 ([Citations](/citations.md#cit09))

Number of Reads surviving Trimmomatic and `re-pair` Read1: 135,271,743

Number of Reads surviving Trimmomatic and `re-pair` Read2: 135,271,743

### ASSEMBLY

Data wrangling and assembly were performed at the [Genomics Center](https://genomics.okstate.edu/).

Assembly readfile names: `L_lactis_S1_LALL_R1.trim.Gtrim.fixed.fastq`, `L_lactis_S1_LALL_R2.trim.Gtrim.fixed.fastq`

Preliminary SPAdes assemblies predict at least two plasmids. One set of predicted plasmid scaffolds have much higher read counts than the other. Based on these data, three processes were performed to allow for independent assemblies:

1. Isolation of the high-copy read plasmid sequences (Plasmid1) and reassembly. 
2. Isolation of the lower-copy read plasmid sequences (Plasmid2) and reassembly.
3. Removal of the presumptive plasmid reads from the rest of the genomic reads for genome assembly. 

### The scripting and assembly

The Lactococcus genome and plasmid reads were separated and independently re-assembled and mapped to referece sequences (except for Plasmid1ab).

The script used for these processes was **[lactoscript-only.sh](/files/lactoscript-only.sh)**.

**All data output from the analyses are located in BioProject [PRJNA731925](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA731925)**. 

The genome `.BAM` file was submitted with a scaffolded contig assembly to NCBI as part of BioProject [PRJNA731925](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA731925).

The Plasmid 2 consensus sequence was found by Blast (NCBI) to be over 98% identical to [CP065736.1](https://www.ncbi.nlm.nih.gov/nuccore/CP065736.1), an unnamed 58,335 bp plasmid associated with our reference strain [CP065737.1](https://www.ncbi.nlm.nih.gov/nuccore/CP065737.1). It was converted to a `.BAM` file for submission by the [Genomics Center](https://genomics.okstate.edu/) to NCBI with its assembly under **BioProject [PRJNA731925](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA731925)** and BioSample [SAMN19301478](https://www.ncbi.nlm.nih.gov/biosample/19301478).
 
The Plasmid 1 (later named Plasmid-1ab) assembly did not show an overall contiguous homology greater than 60% to any plasmids or genomes in the NCBI databases. Because Plasmid 1 had no identifiable reference sequence, it was assembled into contigs and submitted as a contig assembly, and as `.fastq` reads to the SRA. **Plasmid-1ab reads have the same BioSample Accession number [SAMN19301478](https://www.ncbi.nlm.nih.gov/biosample/19301478) but a different SRA; [SRS9038783](https://www.ncbi.nlm.nih.gov/sra?LinkName=biosample_sra&from_uid=19301479) on NCBI BioProject [PRJNA731925](https://www.ncbi.nlm.nih.gov/bioproject/?term=PRJNA731925)**.

 
### QUAST outputs
 
QUAST default contig size cutoff = 500 bp.
 
| Genome stats | PrHT3_with_plasmids | PrHT3_Plasmid-1ab | PrHT3_Plasmid2| PrHT3_genome_only | 
|-|-|-|-|-|
| # N's | 0 | 0 | 0 | 0 | 
| # contigs | 77 | 4 | 7 | 66 |
| # contigs (>= 0 bp) | 119 | **8** | **13** | **98** |
| # contigs (>= 1000 bp) | 65 | 4 | 7 | 54 |
| Largest contig | 435796 | 4753 | 12568 | 435796 |
| Total length (>= 0 bp) | 2518618 | **12772** | **57382** | **2448464** |
| Total length (>= 1000 bp) | 2497578 | 11842 | 55552 | 2430184 |
| N50 | 134484 | 4564 | 11477 | 134484 |
| N90 | 20903 | 1367 | 5972 | 32769 |
| L50 | 5 | 2 | 3 | 5 | 
| L90 | 23 | 3 | 5 | 20 | 
| GC (%) | 35.22 | 31.69 | 34.69 | 35.25 | 
 
 
### Final numbers of reads and coverage

|  | L. lactis PrHT3 | Plasmid-1ab | Plasmid-2 |
| --- | --- | --- | --- |
| Reads used | 7,005,986 | 571,732 | 417,160 |
| Coverage | 215x | 3,357x | 545x |
| N50 | 134,484 | 4564 | 11477|
| GC% | 35.25 | 31.69 | 34.69 |
| SRA Accesion | SRS9038781 | SRS9038783 | SRS9038781 |


### Plasmid-1ab: Is it one or two plasmids?

We have [a separate page](/plasmid1ab.md) to describe why the higher-copy-number plasmid was left as "Plasmid-1ab"

| [To README Page](/README.md) | [To citations page](/citations.md) |
| --- | --- |

