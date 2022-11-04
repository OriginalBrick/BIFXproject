configfile: "config.yaml"

SAMPLEID = glob_wildcards("trimmed_fastq_small/{sampleID}_1.trim.sub.fastq").sampleID

rule all:
  input:
    expand("results/vcf/{sampleID}_final_variants.vcf", sampleID = SAMPLEID)
  
rule trim:
  output:
    paired1 = "trimmed_fastq/{sample}_1.trimmed.fastq.gz",
    unpaired1 = "trimmed_fastq/{sample}_1un.trimmed.fastq.gz",
    paired2 = "trimmed_fastq/{sample}_2.trimmed.fastq.gz",
    unpaired2 = "trimmed_fastq/{sample}_2un.trimmed.fastq.gz"
  input:
    file1 = "untrimmed_fastq/{sample}_1.fastq.gz",
    file2 = "untrimmed_fastq/{sample}_2.fastq.gz",
    adapters = "untrimmed_fastq/NexteraPE-PE.fa"
  params:
    trim_minlen = config.get("trim_minlen", "25"),
    trim_window = config.get("trim_window", "4:20"),
    trim_clip = config.get("trim_clip", "2:40:15")
  shell:
    "trimmomatic PE -threads 1 {input.file1} {input.file2} \
     {output.paired1} {output.unpaired1} {output.paired2} {output.unpaired2} \
     SLIDINGWINDOW:{params.trim_window} MINLEN:{params.trim_minlen} \
     ILLUMINACLIP:{input.adapters}:{params.trim_clip}"

rule qc:
  output:
    html = "qc/{sampleID}.trimmed_fastqc.html",
    zip = "qc/{sampleID}.trimmed_fastqc.zip"
  input:
    "trimmed_fastq/{sampleID}.trimmed.fastq.gz"
  shell:
    "fastqc -o qc {input}"

rule align:
  output:
    "results/sam/{sampleID}.aligned.sam"
  input:
    read1 = "trimmed_fastq_small/{sampleID}_1.trim.sub.fastq",
    read2 = "trimmed_fastq_small/{sampleID}_2.trim.sub.fastq"
  params:
    fasta = config.get("align_fasta")
  shell:
    "bwa mem {params.fasta} {input.read1} {input.read2} > {output}"

rule convert:
  output:
    "results/bam/{sampleID}.aligned.bam"
  input:
    "results/sam/{sampleID}.aligned.sam"
  shell:
    "samtools view -S -b {input} > {output}"

rule sort:
  output:
    "results/bam/{sampleID}.aligned.sorted.bam"
  input:
    "results/bam/{sampleID}.aligned.bam"
  shell:
    "samtools sort -o {output} {input}"

rule coverage:
  output:
    "results/bcf/{sampleID}_raw.bcf"
  input:
    "results/bam/{sampleID}.aligned.sorted.bam"
  params:
    fasta = config.get("align_fasta")
  shell:
    "bcftools mpileup -O b -o {output} -f {params.fasta} {input}"

rule vcf:
  output:
    final = "results/vcf/{sampleID}_final_variants.vcf",
    inter = "results/vcf/{sampleID}_variants.vcf"
  input:
    "results/bcf/{sampleID}_raw.bcf"
  params:
    ploidy = config.get("ploidy", "2")
  shell:
    r"""bcftools call --ploidy {params.ploidy} -m -v -o {output.inter} {input}
    vcfutils.pl varFilter {output.inter} > {output.final}
    """
