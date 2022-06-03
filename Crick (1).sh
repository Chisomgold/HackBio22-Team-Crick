#!/usr/bin/env bash

#command for the first two tasks

#nano names.sh
echo "$first $last"
echo "$first"
echo "$last"


#commands for story one
mkdir halimat
mkdir biocomputing && cd biocomputing
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.fna
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk
wget https://raw.githubusercontent.com/josoga2/dataset-repos/main/wildtype.gbk
mv wildtype.fna ./halimat
rm wildtype.gbk.1
grep “tatatata” wildtype.fna
grep “tatatata” wildtype.fna > mutant.fna
find halimat biocomputing -type f
clear
history

#commands for story 2

sudo apt install figlet
figlet Team Crick
echo "#xcowsay not working"
mkdir compare
cd compare
wget https://www.bioinformatics.babraham.ac.uk/training/Introduction%20to%20Unix/unix_intro_data.tar.gz
gunzip unix_intro_data.tar.gz
tar xvf unix_intro_data.tar
ls
cd ./seqmonk_genomes
cd ./Saccharomyces\ cerevisiae
cd ./EF4
nano Mito.dat
grep “rRNA” Mito.dat
cp Mito.dat ~/compare
nano Mito.dat
mv Mito.dat Mitochondrion.txt
cd ~/compare/FastQ_Data
wc -l lane8_DD_P4_TTAGGC_L008_R1.fastq.gz
wc -l *.gz > filelines

#github link
echo "https://github.com/Chisomgold/HackBio22-Team-Crick.git"

#link to stories
echo "https://docs.google.com/document/d/1nd4Cf2g_OHGsH6GNSezNgjECLbgAGhOFtryEMhgQHW4/edit?usp=sharing"
echo "https://docs.google.com/document/d/19MSCaS6tAZn92rHxez0NhKIcxAU8xHjAXm2Gvhn_HjI/edit?usp=sharing"
