#!bin/bash
mkdir fastp_output

samples=(
	"ACBarrie",
	"Alsen",
	"Baxte"
)
for sample in "{$samples[@]}"; do
	fastp \
	-i "PWD/${sample}_R1.fastq.gz" \
	-I "PWD/${sample}_R2.fastq.gz" \
	-o "fastp_output/${sample}_R1.fastq.gz" \
	-O "fastp_output/${sample}_R2.fastq.gz" \
	--html "fastp_output/${sample}_fastp.html" 
done
