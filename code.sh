



gmx pdb2gmx -f protein.pdb -o protein.gro -p protein.top -ignh -ter
gmx editconf -f protein.gro -o protein-PBC.gro -bt dodecahedron -d 1.2


gmx grompp -v -f 01_em_vac_PME.mdp -c protein-PBC.gro -p protein.top -o protein-EM-vacuum.tpr
gmx mdrun -v -deffnm protein-EM-vacuum -nt 16
gmx solvate -cp protein-EM-vacuum.gro -cs spc216.gro -p protein.top -o protein-water.gro


gmx grompp -v -f 02_em_sol_PME.mdp -c protein-water.gro -p protein.top -o protein-water.tpr
gmx genion -s protein-water.tpr -o protein-solvated.gro -conc 0.15 -p protein.top -pname NA -nname CL -neutral


gmx grompp -v -f 02_em_sol_PME.mdp -c protein-solvated.gro -p protein.top -o protein-EM-solvated.tpr
gmx mdrun -v -deffnm protein-EM-solvated -nt 16


gmx grompp -v -f 03_nvt_pr1000_PME.mdp -c protein-EM-solvated.gro -p protein.top -o protein-NVT-PR1000.tpr 

gmx mdrun -v -deffnm protein-NVT-PR1000 


gmx grompp -v -f 04_npt_pr_PME.mdp -c protein-NVT-PR1000.gro -p protein.top -o protein-NPT-PR1000.tpr
gmx mdrun -v -deffnm protein-NPT-PR1000

gmx grompp -v -f 04_npt_pr_PME.mdp -c protein-NPT-PR1000.gro -p protein.top -o protein-NPT-PR100.tpr
gmx mdrun -v -deffnm protein-NPT-PR100

gmx grompp -v -f 04_npt_pr_PME.mdp -c protein-NPT-PR100.gro -p protein.top -o protein-NPT-PR10.tpr
gmx mdrun -v -deffnm protein-NPT-PR10

gmx grompp -v -f 05_npt_NOpr_PME.mdp -c protein-NPT-PR10.gro -p protein.top -o protein-NPT-noPR.tpr
gmx mdrun -v -deffnm protein-NPT-noPR


gmx grompp -v -f 06_md_PME.mdp -c protein-NPT-noPR.gro -p protein.top -o protein_md.tpr
gmx mdrun -v -deffnm protein_md


gmx make_ndx -f protein_md.gro -o index357.ndx


gmx distance -s topol.tpr -f traj.xtc -n index357.ndx -select 'com of group "r_357" plus com of group "non-Water"' -oall distance357.xvg






