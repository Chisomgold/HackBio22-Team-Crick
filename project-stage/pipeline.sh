#!/bin/bash

echo -e "\n Starting analysis..."

echo -e "\n Running fastp for trimming adapters..."

mkdir -p trimmed

for file in *.fastq.gz
do
base=$(basename $file .fastq.gz)
echo $base 
fastp -i $file -o trimmed/${base}.fastq.gz
--html trimmed/${base}_fastp.html
done

echo -e "\n Running fastqc and multiqc..."

mkdir -p fastqc_reports

cd trimmed

for file in *
do
fastqc $file -o ../fastqc_reports
done

cd ..

#multiqc fastqc_reports -o fastqc_reports

echo -e "\n Getting the reference genome..."
mkdir -p ref
cd ref
echo -e "Insert link to download reference genome of interest... (Copy and paste with shift+insert)"
#inserting link to ref seq
read refgenomelink
downloading reference genome
wget $refgenomelink
ls
gunzip *
ls -lh #confirming the presence of unzipped refrence file

echo -e "\n Indexing the reference genome..."

bwa index *.fa

echo -e "\n Indexing complete..."

cd ..

echo -e "\n Starting mapping..."
mkdir -p map
bwa mem -t 4 ref/*.fa trimmed/*N*r1* trimmed/*N*r2* | samtools view -b > map/normal.bam # mapping normal gene sequences
bwa mem -t 4 ref/*.fa trimmed/*T*r2* trimmed/*T*r2* | samtools view -b > map/tumor.bam # mapping tumor gene sequences
ls map > seq.txt #for easier iteration of files for dowmstream processes
echo -e "\n Sorting bam file output..."
for sample in `cat seq.txt`
do
samtools sort -@ 4 map/${sample} > map/${sample}.sorted.bam
echo -e "\n Indexing bam file..."
samtools index map/${sample}.sorted.bam
echo -e "\n Samtools viewing and filtering..."
samtools view -q 1 -f 0x2 -F 0x8 -b map/${sample}.sorted.bam > map/${sample}.filtered1.bam
echo -e "Viewing filtered data..."
samtools flagstat map/${sample}.filtered1.bam
echo -e "\n Removing PCR duplicates and left alignment..."
samtools rmdup map/${sample}.sorted.bam map/${sample}.clean.bam 
cat map/${sample}.clean.bam | bamleftalign -f ref/*.fa -m 5 -c > map/${sample}.leftalign.bam
echo -e "\n Recalibrating..."
samtools calmd -@ 4 map/${sample}.leftalign.bam ref/*.fa > map/${sample}.recalibrate.bam
done
echo -e  "\n Refiltering..."
for sample in `cat seq.txt`
do
bamtools filter -in map/${sample}.recalibrate.bam -mapQuality "<=254" > map/${sample}.refilter.bam
done
echo -e "\n Converting data to pileup for variant calling..."
mkdir -p var
for sample in `cat seq.txt`
do
samtools mpileup -f ref/*.fa map/${sample}.refilter.bam --min-MQ 1 --min-BQ 28 > var/${sample}.pileup
done
echo -e "\n Calling variants..."
varscan var/normal*.pileup var/tumor*.pileup var/finaloutput1 --normal-purity 1  --tumor-purity 0.5 --output-vcf 1

echo -e "\n Merge VCF files..."
bgzip var/finaloutput1.snp.vcf > var/finaloutput1.snp.vcf.gz
bgzip var/finaloutput1.indel.vcf > var/finaloutput1.indel.vcf.gz
tabix var/finaloutput1.snp.vcf.gz
tabix var/finaloutput1.indel.vcf.gz
bcftools merge var/finaloutput1.snp.vcf.gz var/finaloutput1.indel.vcf.gz > var/finaloutput1.vcf  --force-samples

echo -e "\n Analysis complete. Check file sizes..."
ls -lh map #alignment files
ls -lh var #variant files
