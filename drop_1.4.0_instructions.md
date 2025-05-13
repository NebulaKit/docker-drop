# DROP v1.4.0 on DNAnexus Cloud Workstation

This guide explains how to use the DROP v1.4.0 Docker image on the DNAnexus Cloud Workstation platform.

---

## 🧰 Technologies Used
- **Docker**: Containerization of the DROP environment
- **Conda (via Mamba)**: Package and environment management
- **dx-toolkit**: DNAnexus command-line utilities (`dx`)
- **DNAnexus Cloud Workstation**: Interactive cloud-based Linux shell
- **GRCh38, GENCODE, 1000 Genomes**: Reference files used in DROP pipelines

---

## 🚀 Launch the Cloud Workstation
```bash
# Authenticate with your DNAnexus account
dx login

# Navigate to your project or destination folder in DNAnexus
# Replace <project-path> with the actual DNAnexus path you're working in
dx cd <project-path>

# Create a new subdirectory for your analysis session (named by date for traceability)
dx mkdir <your-session-folder>

# Move into the newly created folder where all downstream data and work will be staged
dx cd <your-session-folder>

# Launch a new DNAnexus Cloud Workstation session using an appropriate instance type
# Choose the instance based on your expected compute/memory requirements
dx run app-cloud_workstation --ssh --brief --instance-type mem1_ssd1_x32
# You can optionally extend the session time (e.g., 3d) and attach files like Docker images for use
# Example: drop-1.4.0.tar.gz uploaded from the DNAnexus project location

```

---

## 🗂️ Prepare Workspace
```bash
# Unset the temporary Cloud Workstation workspace ID and switch back to your primary project context
# This ensures all file operations happen in your actual project, not the isolated temp session
unset DX_WORKSPACE_ID && dx cd $DX_PROJECT_CONTEXT_ID

# Create the root analysis directory and subfolders for organizing input and output data
mkdir drop_analysis && cd drop_analysis
mkdir data && mkdir data/vcf_files && mkdir data/bam_files
mkdir analysis && mkdir output
```

---

## 📥 Download Required Files

### RNA-seq BAM files
```bash
cd data/bam_files
dx cd <bam-folder-path>
dx download *.bam
dx download *.bam.bai
```

### Reference Genome & Annotations
```bash
cd ../
# Navigate to the folder where your reference genome and annotation files are stored
dx cd <reference-and-annotation-folder-path>

# GRCh38 FASTA and index
dx download GRCh38.no_alt_analysis_set.fa
dx download GRCh38.no_alt_analysis_set.fa.fai

# Reference VCF and index
dx download qc_vcf_1000G_hg38*

# Gene annotations (GENCODE v40)
dx download gencode.v40.annotation.gtf
```

### DROP Configuration Files
```bash
# Navigate to the folder where your config and annotation files are stored
dx cd <config-folder-path>

# Download your DROP config YAML file and sample annotation table
dx download <drop-config-file>.yaml
dx download <sample-annotation-file>.tsv
```

### Annotated VCFs
```bash
cd ../vcf_files
# Navigate to the folder where your VCF files are stored
dx cd <vcf-folder-path>
dx download *VEP.vcf.gz
dx download *VEP.vcf.gz.tbi
```

---

## 🐳 Load & Run Docker Image

### Load the Docker image
```bash
cd ~
# Option 1: Load from a tarball you downloaded into the Cloud Workstation
docker load -i drop_1.4.0.tar.gz

# Option 2: Pull directly from Docker Hub (requires internet access)
docker pull kristinagrausa/drop:1.4.0
```

### Run the container
```bash
# Option 1: if image loaded from a tarball you downloaded into the Cloud Workstation
docker run -ti -v "/home/dnanexus/drop_analysis:/drop" drop:1.4.0

# Option 2: if image pulled directly from Docker Hub 
docker run -ti -v "/home/dnanexus/drop_analysis:/drop" kristinagrausa/drop:1.4.0
```

### Activate the DROP environment
```bash
source /opt/conda/bin/activate /opt/conda/envs/DROP_1.4.0
```

---

## ⚙️ Set Up and Run DROP
```bash
# Navigate to the mounted working directory
cd /drop

# Check if all files are present in the expected paths
cd drop

# Optional: update DROP to latest available version within the environment
mamba update drop

# Initialize a new DROP project structure
drop init

# Check and edit config file to reflect correct paths
cd data
vi <drop-config-file>.yaml
rm ../config.yaml
mv <drop-config-file>.yaml ../config.yaml

# Standardize sample annotation file naming
mv *sample_annotation.tsv ./sample_annotation.tsv

# Standardize reference file names
mv *hg38.vcf.gz ./qcVCF.vcf.gz
mv *hg38.vcf.gz.tbi ./qcVCF.vcf.gz.tbi

mv *set.fa ./reference_genome.fa
mv *set.fa.fai ./reference_genome.fa.fai

mv *gtf ./gene_annotation.gtf

# Perform a dry run to preview workflow steps
snakemake --cores 32 -n

# Run DROP with 32 cores
snakemake --cores 32

# Exit Docker when analysis is complete
exit
```

---

## ☁️ Upload Results Back to DNAnexus
```bash
# Navigate to your desired DNAnexus folder
dx cd <result-folder-path>

# Upload relevant results (e.g. output/ or analysis/ folders)
dx upload output --recursive
dx upload analysis --recursive
```

---

## 🔁 Reconnect to the Workstation later (if needed)
```bash
dx ssh <job-id>
```

---

## 📝 Notes
- The Docker image mounts the DNAnexus `drop_analysis` directory under `/drop` inside the container.

---

See the [README](./README.md) for full citation and Docker Hub image reference.
