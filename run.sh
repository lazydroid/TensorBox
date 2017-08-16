#!/bin/bash
#!/bin/sh
# time: 7/25/2017
# author: zhihui.luo@ingenic.com
#
# Parameters config:
# Sigmoid optional value:
#     SIGMOID PLAN SONF INTERPOLATION EXPONENT AREAS PLAN_LUT LUT_BIT_LEVEL_004 LUT_BIT_LEVEL_001 DCT_LUT_6
#     DCT_LUT_4
# Tanh optional value:
#     TANH PLAN EXPONENT AREAS PLAN_LUT LUT_BIT_LEVEL_004 LUT_BIT_LEVEL_001 DCT_LUT_6 DCT_LUT_4
# LSTM activation type:
#     origin sigmoid_diy tanh_diy sigmoid_tanh_diy
#
####################################################
GPU_ID=0
sigmoid_type=DCT_LUT_4
tanh_type=AREAS
lstm_type=origin

# function for change sigmoid type
function SetSigmoidType()
{
    awk -v type=$1 -F ' ' '{ if (($1 == "op_type") && ($2 == "="))
                   { print " "" "" "" " $1 " " $2 " " type";"}
                   else { print $0;}}' sigmoid_diy.cpp >| tmp.cpp
    cp tmp.cpp sigmoid_diy.cpp
    rm tmp.cpp
}

# function for change tanh type
function SetTanhType()
{
    awk -v type=$1 -F ' ' '{ if (($1 == "op_type") && ($2 == "="))
                   { print " "" "" "" " $1 " " $2 " " type";"}
                   else { print $0;}}' tanh_diy.cpp >| tmp.cpp
    cp tmp.cpp tanh_diy.cpp
    rm tmp.cpp
}

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cd utils/activation_util/sigmoid
SetSigmoidType $sigmoid_type
./compile.sh |& tee log

# check compile
grep "error" log
ERROR=$?
if [ $ERROR -eq 0 ]; then
    exit
fi

echo "Sigmoid function type:"
grep "op_type ="  sigmoid_diy.cpp 
echo "Sigmoid compiler done!"

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cd ../tanh
SetTanhType $tanh_type
./compile.sh |& tee log

# check compile
grep "error" log
ERROR=$?
if [ $ERROR -eq 0 ]; then
    exit
fi

echo "Tanh function type:"
grep "op_type =" tanh_diy.cpp
echo "Tanh compiler done!"

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "LSTM mode: $lstm_type"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

cd ../../../
python evaluate.py --lstm_type=$lstm_type --weights output/lstm_rezoom_2017_08_11_23.58/save.ckpt-800000 --test_boxes data/brainwash/val_boxes.json --gpu $GPU_ID 
