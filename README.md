# rstudio-server

# Running RStudio Server on SLURM HPC via Apptainer

This guide outlines a complete, root-less workflow for running RStudio Server on a SLURM-managed HPC cluster using Apptainer (formerly Singularity). It includes specific configurations to bypass common HPC permission errors and provides instructions for accessing the server via SSH tunneling on an iPad or PC, as well as a local Windows WSL alternative.

## 1. Pull the Docker Image

To avoid strict thread limits on login nodes (which often kill the `mksquashfs` process during image conversion), pull the container using an interactive compute node.

```bash
# Request an interactive session
srun --nodes=1 --ntasks=1 --cpus-per-task=4 --mem=8G --time=01:00:00 --pty 
```

### Create an environment directory in your workspace
```bash
mkdir -p $WORK/rstudio-env && cd $WORK/rstudio-env 
```

### Pull the Rocker tidyverse image
```bash
apptainer pull rstudio.sif docker://rocker/tidyverse:latest 
```

### Return to the login node
exit

## 2. Create and Run the SLURM Script
Create a file named `start_rstudio_server.slurm` in your $WORK/rstudio-env directory:

### create a new file
touch start_rstudio_server.slurm 

### open the file with a text editor
`nano start_rstudio_server.slurm`

Copy the code from the `start_rstudio_server.slurm` file in this repository and paste it into your file.

To save and exit nano:

Press `Ctrl + O` to save (Write Out), then press Enter to confirm the file name.

Press `Ctrl + X` to exit the editor.

### run the script
```bash
sbatch start_rstudio_server.slurm 
```

Run `squeue -u $USER` from the login node of the cluster to check that you have a job running.

Once your job is running, check the generated output log (e.g., cat rstudio_server_*.log) to get your assigned Compute Node, Port, username and Password.

## 3. Accessing from a PC (Windows/Mac/Linux)
Desktop operating systems have native SSH capabilities, so no third-party apps are required.

    1. Open your terminal (PowerShell, Command Prompt, or Mac/Linux Terminal).

    2. Run the SSH Tunnel Command, replacing <PORT>, <NODE>, <USERNAME>, and <LOGIN_NODE_ADDRESS> with your specific values.

```bash
ssh -N -L <PORT>:<NODE>:<PORT> <USERNAME>@<LOGIN_NODE_ADDRESS>
# Example: ssh -N -L 8136:c2508:8136 user@swan.unl.edu
```

        👉 -N: Prevents a shell prompt from opening (hangs quietly in the background).
        👉 -L: Establishes the local port forwarding link.

    3. Authenticate: Enter your HPC password and complete 2FA if prompted. The terminal will hang with a blinking cursor, indicating the tunnel is active.

    4. Connect: Open your web browser and navigate to http://localhost:<PORT>.

    5. Disconnect: When finished, return to the terminal window and press Ctrl + C to sever the tunnel.