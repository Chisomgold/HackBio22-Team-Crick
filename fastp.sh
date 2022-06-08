#!/usr/bin/bash
mkdir fastp_output

SAMPLES=(
	"ACBarrie",
	"Alsen",
	"Baxte"
)
for SAMPLE in "{$SAMPLES[@]}"; do
	fastp \
	-i "$PWD/${SAMPLE}_R1.fastq.gz" \
	-I "$PWD/${SAMPLE}_R2.fastq.gz" \
	-o "fastp_output/${SAMPLE}_R1.fastq.gz" \
	-O "fastp_output/${SAMPLE}_R2.fastq.gz" \
	--html "fastp_output/${SAMPLE}_fastp.html" 
done
