for i in `seq 3000 9000 30000`; do
    sbatch -e logs/full_transformer/$i.log -o logs/full_transformer/$i.log freeze_transformer.slurm full_transformer $i
done 
