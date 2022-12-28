SAMPLES = ["A", "B", "C"]

# first rule is the default target
rule all:
    input:
        "results/calls/all.vcf",
        "results/plots/quals.svg"

rule bwa_map:
    input:
        fa_and_idx=["data/genome.fa" + x for x in ["", ".amb", ".ann", ".bwt", ".fai", ".pac", ".sa"]],
        fq="data/samples/{sample}.fastq"
    output:
        "results/mapped_reads/{sample}.bam"
    threads:
        2
    log:
        "logs/mapped_reads/{sample}.log"
    conda:
        "envs/mapping.yaml"
    shell:
        "bwa mem -t {threads} {input.fa_and_idx[0]} {input.fq} | samtools view -Sb - > {output}"


rule samtools_sort:
    input:
        "results/mapped_reads/{sample}.bam"
    output:
        "results/sorted_reads/{sample}.bam"
    conda:
        "envs/mapping.yaml"
    shell:
        "samtools sort -T results/sorted_reads/{wildcards.sample} "
        "-O bam {input} > {output}"


rule samtools_index:
    input:
        "results/sorted_reads/{sample}.bam"
    output:
        "results/sorted_reads/{sample}.bam.bai"
    conda:
        "envs/mapping.yaml"
    shell:
        "samtools index {input}"


rule bcftools_call:
    input:
        fa="data/genome.fa",
        bam=expand("results/sorted_reads/{sample}.bam", sample=SAMPLES),
        bai=expand("results/sorted_reads/{sample}.bam.bai", sample=SAMPLES)
    output:
        "results/calls/all.vcf"
    conda:
        "envs/calling.yaml"
    shell:
        "bcftools mpileup -f {input.fa} {input.bam} | "
        "bcftools call -mv - > {output}"

rule plot_quals:
    input:
        "results/calls/all.vcf"
    output:
        "results/plots/quals.svg"
    script:
        "scripts/plot-quals.py"
