#!/bin/bash
  
NUM_ACCELERATORS=${NUM_ACCELERATORS:-1}
echo "NUM_ACCELERATORS=${NUM_ACCELERATORS}"

if [ -d results ]; then
    mv results results_$(date +%Y%m%d%H%M%S)
fi
mkdir results

batchs='128 256 512'



for batch in $batchs
do
        echo "----------------------------------------------------------------"
        echo "Running training with batch size of $batch"
        echo "----------------------------------------------------------------"
        start=`date +%s%N`
        python main.py --epochs=1 --batch_size=$batch --model_dir=./ckpt_${batch} |& tee ./results/result_train_${batch}.txt
        end=`date +%s%N`
        total_time=`bc <<< "scale = 3; ($end-$start)/1000000000"`
        echo "System performance in seconds is: $total_time" >> ./results/result_train_${batch}.txt
done

python process_results.py --train
