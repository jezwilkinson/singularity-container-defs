# Sandbox builder for deploying O2 to farm

These scripts and instructions will allow you to package your own custom build of O2Physics from your own local machine or a local disk on a build server, to deploy for testing on distributed computing (e.g. your institute's computing cluster)

## Requirements
All scripts require `fakeroot` rights to be applied to your user account on the build server. Alternatively, the same commands from the scripts can be run on your local machine with administrative rights, substituting `sudo singularity` instead of `singularity --fakeroot`.
Keep this environment **as clean as possible**: Any additions will expand the size of the container, and may push it over the limit and cause the SIF export to fail. ***Only build one branch at a time into this sandbox***.

## Contents
- `definition_buildcontainer_slc7.def`: Singularity build definition for O2 build container.
- `init_sandbox.sh`: First-time initialisation script to create sandboxed container from definition
- `enterBuildEnv.sh`: Script that opens the build container in writable mode
- `packageSandboxToSif.sh`: Packages your sandbox folder into a single `.sif` file for deployment

## First-time initialisation
Run `./init_sandbox.sh`
This script invokes the build with the following:
- `--fakeroot`: grants "fake root" rights (required for build)
- `--sandbox`: Creates a writable "sandbox" instead of a compressed `.sif`
- `--fix-perms`: Sets permissions in the folder such that it can be removed by the user later on

A new folder will be created, named `sandboxo2/`. This folder is your **sandbox container**, which is editable, unlike a normal .sif container.
If you ever need to reset your container to scratch and start over, run this script again and say "yes" when prompted to remove the existing directory

## Entering the build environment
Use the script `enterBuildEnv.sh`. This will shell into the sandbox with the following switches:
- `--no-home`: ignore home directory (for python installation)
- `--fakeroot`: grant fakeroot privileges to edit files
- `--writable`: allow container to be written to

The build script has created and initialised an aliBuild environment for you under the folder `/opt/alibuild`: There you will find the usual source folders for O2 and O2Physics.

### Add your Github branch to the contained source folder and pull
- `cd /opt/alibuild/O2Physics`
- `git remote add [user] http://github.com/[user]/O2Physics`
- `git pull [user] [branchname]`

### Build O2Physics using the pulled branch
- `cd /opt/alibuild`
- `aliBuild build O2Physics --defaults o2 -j30`
- `alienv enter O2Physics::latest`

Important: ALWAYS run `alienv enter` once after building to cache the environment details while the container is still writable. If you miss this step, the eventual .sif will be unable to load your environment

## Packaging the sandbox into a .SIF container
Exit out of your container, and then run
- `./packageSandboxToSif.sh`

This will take your `sandboxo2` directory and convert it into a compressed container, `singularity_o2deploy.sif`.
This process will take a little while - even if it looks like it's not doing much, just let it run. It'll get there eventually.

## Using your container on another system

You can now copy your exported `.sif` file to another filesystem (`/lustre`, your own laptop, wherever) and use it to run your version of O2Physics.

- `singularity shell singularity_o2deploy.sif`
- `alienv -w /opt/alibuild enter O2Physics::latest`

If you are using distributed computing, you may need to initialise an AliEn token and then copy it to somewhere on network storage that the farm nodes can access. Create a folder for token storage, and then:
- `source /cvmfs/alice.cern.ch/etc/login.sh`
- `alienv enter xjalienfs::1.3.7-19`
- `alien-token-init`
- `cp /tmp/tokencert_$UID.pem /tmp/tokenkey_$UID.pem -t /path/to/tokenstore`
- `exit`

These will be accessed by setting `JALIEN_TOKEN_CERT` and `JALIEN_TOKEN_KEY` to the correct paths when running

### syntax to load the environment from SLURM scripts
```sh
singularity shell /path/to/singularity_o2deploy.sif<<\EOF
export JALIEN_TOKEN_CERT=/path/to/tokenstore/tokencert_$UID.pem
export JALIEN_TOKEN_KEY=/path/to/tokenstore/tokenkey_$UID.pem
alienv -w /opt/alibuild enter O2Physics::latest

# Your O2 workflow goes here
 o2-analysis-pid-tpc-full --add-qa 1 --aod-file /path/to/AO2D.root | \
 o2-analysis-pid-tpc --add-qa 1 | \
 o2-analysis-trackextension | \
 o2-analysis-pid-tof-full --add-qa 1 | \
 o2-analysis-weak-decay-indices | \
 o2-analysis-lf-lambdakzerobuilder --isRun2 1 | \
 o2-analysis-lf-lambdakzeroanalysis | \
 o2-analysis-timestamp  | \
 o2-analysis-event-selection | \
 o2-analysis-trackselection | \
 o2-analysis-centrality-table | \
 o2-analysis-multiplicity-table -b

# EOF to trigger the end of the singularity command
EOF

```
