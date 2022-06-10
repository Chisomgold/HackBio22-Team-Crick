#!/bin/bash

#beginning of stage one
wget https://raw.githubusercontent.com/HackBio-Internship/wale-home-tasks/main/DNA.fa

#counting the number of sequences in file
grep ">" DNA.fa | wc -l

#getting the total ATGC counts
grep -o DNA.fa -e A -e T -e G -e C | sort | uniq -c

#setting up conda environment
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod +x Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh

#installing packages fastqc, fastp and multiqc

#installing fastqc, fastp and multiqc
sudo apt-get install fastqc
sudo apt-get install fastp
sudo apt-get install multiqc

#these disn't work as expected
#conda install -c bioconda fastqc #for quality control
#conda install -c bioconda fastp #for trimming sequence adapter
#conda install -c bioconda multiqc #for assembling quality control reports

#downloading datasets from GitHub
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/ACBarrie_R1.fastq.gz?raw=true -O ACBarrie_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/ACBarrie_R2.fastq.gz?raw=true -O ACBarrie_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Alsen_R1.fastq.gz?raw=true -O Alsen_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Alsen_R2.fastq.gz?raw=true -O Alsen_R2.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Baxter_R1.fastq.gz?raw=true -O Baxter_R1.fastq.gz
wget https://github.com/josoga2/yt-dataset/blob/main/dataset/raw_reads/Baxter_R2.fastq.gz?raw=true -O Baxter_R2.fastq.gz

#making output directory 
mkdir output

mkdir fastqc_output

#running installed packages on files

#quality control checks on downloaded files
fastqc ACBarrie_R1.fastq.gz -o ./fastqc_output
fastqc ACBarrie_R2.fastq.gz -o ./fastqc_output
fastqc Alsen_R1.fastq.gz -o ./fastqc_output
fastqc Alsen_R2.fastq.gz -o ./fastqc_output
fastqc Baxter_R1.fastq.gz -o ./fastqc_output
fastqc Baxter_R2.fastq.gz -o ./output

#Trimming adapter sequences from files
wget https://raw.githubusercontent.com/Chisomgold/HackBio22-Team-Crick/main/fastp.sh
chmod +x fastp.sh
./fastp.sh

#moving results to output directory
mv fastqc_output output
mv fastp_output output

#Assembling quality control report

cd output
multiqc fastqc_output/

#viewing results
ls fastqc_output/
ls fasp_output/
ls

#end of task
