# rstudio-server

# Running RStudio Server on SLURM HPC via Apptainer

This guide outlines a complete, root-less workflow for running RStudio Server on a SLURM-managed HPC cluster using Apptainer (formerly Singularity). It includes specific configurations to bypass common HPC permission errors and provides instructions for accessing the server via SSH tunneling on an iPad or PC, as well as a local Windows WSL alternative.

## 1. Pull the Docker Image

To avoid strict thread limits on login nodes (which often kill the `mksquashfs` process during image conversion), pull the container using an interactive compute node.

```bash
# Request an interactive session
srun --nodes=1 --ntasks=1 --cpus-per-task=4 --mem=8G --time=01:00:00 --pty ```

# Create an environment directory in your workspace
```bash
mkdir -p $WORK/rstudio-env && cd $WORK/rstudio-env ```

# Pull the Rocker tidyverse image
```bash
apptainer pull rstudio.sif docker://rocker/tidyverse:latest ```

# Return to the login node
exit

## 2. Create and Run the SLURM Script
Create a file named `start_rstudio_server.slurm` in your $WORK/rstudio-env directory:

# create a new file
touch start_rstudio_server.slurm 

# open the file with a text editor
nano start_rstudio_server.slurm

Copy the code from the start_rstudio_server.slurm file in this repository and paste it into your file.

To save and exit nano:

Press Ctrl + O to save (Write Out), then press Enter to confirm the file name.

Press Ctrl + X to exit the editor.

# run the script
```bash
sbatch start_rstudio_server.slurm ```