#!/bin/bash
#SBATCH --account=nn9447k
#SBATCH --partition=accel
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --time=72:00:00
#SBATCH --mem-per-cpu=16G

set -o errexit
source ~/.bashrc
module purge
conda activate fairseq

export KMP_INIT_AT_FORK=FALSE
PYTHONUNBUFFERED=x fairseq-train ./wikitext-103/wiki-bin \
    --task masked_lm --criterion masked_lm --arch masked_lm \
    --tensorboard-logdir ./stats/lca --log-interval 1 \
    --sample-break-mode complete --tokens-per-sample 512 \
    --optimizer adam --adam-betas '(0.9,0.98)' --adam-eps 1e-6 --clip-norm 0.0 \
    --lr-scheduler polynomial_decay --lr 5e-4 \
    --warmup-updates 10000 --total-num-update 125000 \
    --save-dir ./models/lca --save-interval 1000000 \
    --dropout 0.1 --attention-dropout 0.1 --weight-decay 0.01 \
    --update-freq 16 --max-update 30000 --max-sentences 16
