# rstudio-server

# Running RStudio Server on SLURM HPC via Apptainer

This guide outlines a complete, root-less workflow for running RStudio Server on a SLURM-managed HPC cluster using Apptainer (formerly Singularity). It includes specific configurations to bypass common HPC permission errors and provides instructions for accessing the server via SSH tunneling on both an iPad and a PC.

## 1. Pull the Docker Image

To avoid strict thread limits on login nodes (which often kill the `mksquashfs` process during image conversion), pull the container using an interactive compute node.

```bash
# Request an interactive session
srun --nodes=1 --ntasks=1 --cpus-per-task=4 --mem=8G --time=01:00:00 --pty bash

# Create an environment directory in your workspace
mkdir -p $WORK/rstudio-env && cd $WORK/rstudio-env

# Pull the Rocker tidyverse image
apptainer pull rstudio.sif docker://rocker/tidyverse:latest

# Return to the login node
exit

