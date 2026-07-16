#!/bin/bash
#SBATCH --job-name=asreml-server
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4  
#SBATCH --mem=1024G             
#SBATCH --time=12:00:00       
#SBATCH --output=asreml_server_%j.log

# 1. Generate a random port and secure password
PORT=$(shuf -i 8000-9999 -n 1)
NODE=$(hostname -s)
USER_PASS=$(openssl rand -hex 12)

# 2. Print connection instructions
echo "=================================================================="
echo "RStudio Server is starting."
echo "Wait a few moments, then set up your iPad SSH tunnel in Termius."
echo ""
echo "DESTINATION HOST (Compute Node): $NODE"
echo "DESTINATION PORT: $PORT"
echo ""
echo "Once your iPad tunnel is active, open Safari and navigate to:"
echo "http://localhost:${PORT}"
echo ""
echo "Login Credentials:"
echo "Username: $USER"
echo "Password: $USER_PASS"
echo "=================================================================="

# 3. Create persistent data directories in $WORK
mkdir -p $WORK/.rstudio_data/run
mkdir -p $WORK/.rstudio_data/lib
mkdir -p $WORK/.rstudio_data/tmp

# 4. Create a foolproof custom login script
echo '#!/bin/bash' > $WORK/.rstudio_data/pam_helper.sh
echo 'read -r PASSWORD' >> $WORK/.rstudio_data/pam_helper.sh
echo 'if [ "$1" == "'$USER'" ] && [ "$PASSWORD" == "'$USER_PASS'" ]; then exit 0; else exit 1; fi' >> $WORK/.rstudio_data/pam_helper.sh
chmod +x $WORK/.rstudio_data/pam_helper.sh

# 5. Launch RStudio Server using Apptainer
apptainer exec \
  --bind $WORK/.rstudio_data/run:/var/run/rstudio-server \
  --bind $WORK/.rstudio_data/lib:/var/lib/rstudio-server \
  --bind $WORK/.rstudio_data/tmp:/tmp \
  --bind $WORK \
  --bind /util/opt \
  $WORK/rstudio-env/rstudio.sif \
  /usr/lib/rstudio-server/bin/rserver \
    --server-daemonize=0 \
    --www-port $PORT \
    --server-user $USER \
    --auth-none=0 \
    --auth-pam-helper-path=$WORK/.rstudio_data/pam_helper.sh \
    --auth-timeout-minutes=0

