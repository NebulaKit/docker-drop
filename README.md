# DROP Docker Environment

This repository contains the Dockerfile and instructions for running the DROP v1.4.0 environment for RNA-seq diagnostics using DNAnexus Cloud Workstation.

## 🔗 Docker Hub
[`rsubioinfogroup/drop:1.4.0`](https://hub.docker.com/repository/docker/rsubioinfogroup/drop)

## 📦 Included
- Dockerfile
- drop-1.4.0.tar.gz (Docker image archive)
- DROP_1.4.0.yaml (from [DROP GitHub](https://github.com/gagneurlab/drop))
- drop_1.4.0_instructions.md (DNAnexus Cloud Workstation usage instructions)
- cws_folder_structure.md (Directory structure for DROP inputs and outputs on DNAnexus Cloud Workstation)

## 📄 Citation
If you use DROP, cite:
- DROP: [https://www.nature.com/articles/s41596-020-00462-5](https://www.nature.com/articles/s41596-020-00462-5)
- OUTRIDER: [https://doi.org/10.1016/j.ajhg.2018.10.025](https://doi.org/10.1016/j.ajhg.2018.10.025)
- FRASER: [https://www.nature.com/articles/s41467-020-20573-7](https://www.nature.com/articles/s41467-020-20573-7) or
- FRASER2: [https://www.sciencedirect.com/science/article/pii/S0002929723003671?dgcid=coauthor](https://www.sciencedirect.com/science/article/pii/S0002929723003671?dgcid=coauthor)
- MAE module: [Kremer, Bader et al study](https://www.nature.com/articles/ncomms15824) and [DESeq2](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8).

## 🛠 Usage (summary)
```bash
docker pull rsubioinfogroup/drop:latest

docker run --rm -it \
  -v /path/to/drop-project:/drop/analysis \
  rsubioinfogroup/drop:latest

snakemake --cores 8
```

## 🧾 License
MIT License. DROP environment YAML is reproduced here from the [Gagneur lab DROP repository](https://github.com/gagneurlab/drop) under MIT terms.
