cd D:\PhD\PhD_Research\Activating_potatoes

git clone https://github.com/M-Uzair-Rahil/CTSM.git

cd CTSM

git remote add upstream https://github.com/ESCOMP/CTSM.git
git fetch upstream --tags

git checkout -b potato-development alpha-ctsm5.2.mksrf.27_ctsm5.1.dev176


checkout externals doesn't work. i am putting code and then pushing and checking out in derecho. 

now I copy all these files: 
src/biogeochem/CNSubstorPotatoMod.F90
src/biogeochem/CMakeLists.txt
src/biogeochem/CNPhenologyMod.F90
src/biogeochem/CNAllocationMod.F90
src/biogeochem/CNVegCarbonFluxType.F90
src/biogeochem/CropType.F90
src/main/pftconMod.F90

Optional, Not Needed To Run-- Id didn't copy these but keep it in docs. 
Only copy these if you want documentation/usermod convenience:
cime_config/usermods_dirs/output_crop/user_nl_clm
cime_config/testdefs/testmods_dirs/clm/crop/user_nl_clm
doc/source/users_guide/setting-up-and-running-a-case/history_fields_nofates.rst
doc/source/tech_note/Crop_Irrigation/CLM50_Tech_Note_Crop_Irrigation.rst




####  Now I push to GitHub. 
git add .
git commit -m "Add potato crop modifications"
git push -u origin potato-development

Now i go to derecho: 
cd /glade/work/rahilmoh/CLM/Model

# 1. Go to your model directory
cd /glade/work/rahilmoh/CLM/Model

# 2. Clone your GitHub repository
git clone -b potato-development https://github.com/M-Uzair-Rahil/CTSM.git CTSM_potatoes_clean

# 3. Enter the repository
cd CTSM_potatoes_clean

# 4. Add the official CTSM repository
git remote add upstream https://github.com/ESCOMP/CTSM.git

# 5. Fetch all CTSM tags
git fetch upstream --tags

# 6. Reset your branch to the official CTSM tag
git checkout -B potato-development alpha-ctsm5.2.mksrf.27_ctsm5.1.dev176

# 7. Pull your potato modifications from GitHub
git pull origin potato-development

# 8. Initialize all CTSM externals
./manage_externals/checkout_externals

# 9. Check that everything is clean
git status