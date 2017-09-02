#!/bin/bash
#!/bin/sh
# time: 9/1/2017
# author: zhihui.luo@ingenic.com
#
#
####################################################

bit_width=(8 16 24)
fl_type1=(3 11 19)
fl_type2=(4 12 20)
origin_type=(LUT_BIT_LEVEL_004 LUT_BIT_LEVEL_001 DCT_LUT_6 DCT_LUT_6_PLUS AREAS)
approximate_type=(LUT_BIT_LEVEL_004_quan LUT_BIT_LEVEL_001_quan DCT_LUT_6_quan DCT_LUT_6_PLUS_quan AREAS_quan)
lstm_type=(tanh_diy sigmoid_diy sigmoid_tanh_diy)

lstm_length=${#lstm_type[@]}
app_length=${#approximate_type[@]}
bit_length=${#bit_width[@]}
lstm_index=0
app_index=0
bit_index=0

SCORE_90=100
RECALL_90=100
SCORE_80=100
RECALL_80=100
SCORE_70=100
RECALL_70=100
EER=100
SCORE=100

function LookEER()
{
    grep "EER between" log_eva
    BINGO=$?
    if [ $BINGO -eq 0 ]
    then
	var=$(ps -ef | grep "EER between" log_eva)
	SCORE=${var##*:}
	var=$(ps -ef | grep "EER between" log_eva)
	var=${var#*:}
	EER=${var%and*}
    else
	EER=NAN
	SCORE=NAN
    fi
    
    if [[ $(echo "$EER == 100" | bc) -eq 1 || $(echo "$SCORE == 100" | bc) -eq 1 ]]
    then
	lstm_index=100
	app_index=100
	bit_index=100
	echo "ERROR: Please check your program."
    fi
}

function LookSCORE90()
{
    grep "90 percent precision score" log_eva
    BINGO=$?
    if [ $BINGO -eq 0 ]
    then
	var=$(ps -ef | grep "90 percent precision score" log_eva)
	RECALL_90=${var##*:}
	var=$(ps -ef | grep "90 percent precision score" log_eva)
	var=${var#*:}
	SCORE_90=${var%,*}
    else
	RECALL_90=NAN
	SCORE_90=NAN
    fi
    
    if [[ $(echo "$SCORE_90 == 100" | bc) -eq 1 || $(echo "$RECALL_90 == 100" | bc) -eq 1 ]]
    then
	lstm_index=100
	app_index=100
	bit_index=100
	echo "ERROR: Please check your program."
    fi
}

function LookSCORE80()
{
    grep "80 percent precision score" log_eva
    BINGO=$?
    if [ $BINGO -eq 0 ]
    then
	var=$(ps -ef | grep "80 percent precision score" log_eva)
	RECALL_80=${var##*:}
	var=$(ps -ef | grep "80 percent precision score" log_eva)
	var=${var#*:}
	SCORE_80=${var%,*}
    else
	RECALL_80=NAN
	SCORE_80=NAN
    fi
    
    if [[ $(echo "$SCORE_80 == 100" | bc) -eq 1 || $(echo "$RECALL_80 == 100" | bc) -eq 1 ]]
    then
	lstm_index=100
	app_index=100
	bit_index=100
	echo "ERROR: Please check your program."
    fi
}

function LookSCORE70()
{
    grep "70 percent precision score" log_eva
    BINGO=$?
    if [ $BINGO -eq 0 ]
    then
	var=$(ps -ef | grep "70 percent precision score" log_eva)
	RECALL_70=${var##*:}
	var=$(ps -ef | grep "70 percent precision score" log_eva)
	var=${var#*:}
	SCORE_70=${var%,*}
    else
	RECALL_70=NAN
	SCORE_70=NAN
    fi
    
    if [[ $(echo "$SCORE_70 == 100" | bc) -eq 1 || $(echo "$RECALL_70 == 100" | bc) -eq 1 ]]
    then
	lstm_index=100
	app_index=100
	bit_index=100
	echo "ERROR: Please check your program."
    fi
}

rm -i result.txt
printf "%-20s %-25s %-10s %-10s %15s %10s %15s %10s %15s %10s %10s %10s\n" LSTM_DIY_TYPE APPROXIMATE_TYPE BIT_WIDTH FRACTION SCORE_90 RECALL SCORE_80 RECALL SCORE_70 RECALL REE SCORE >> result.txt
while(( $lstm_index<$lstm_length ))
do
    app_index=0
    while(( $app_index<$app_length ))
    do
	./run.sh ${lstm_type[$lstm_index]} ${origin_type[$app_index]} 32 23
	LookEER
	LookSCORE90
	LookSCORE80
	LookSCORE70
	printf "%-20s %-30s %-10d %-10d %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f\n" ${lstm_type[$lstm_index]} ${origin_type[$app_index]} 32 23 $SCORE_90 $RECALL_90 $SCORE_80 $RECALL_80 $SCORE_70 $RECALL_70 $EER $SCORE >> result.txt
	if [ $app_index -gt 3 ]
	then
	    bit_index=0
	    while(( $bit_index<$bit_length ))
	    do
		./run.sh ${lstm_type[$lstm_index]} ${approximate_type[$app_index]} ${bit_width[$bit_index]} ${fl_type2[$bit_index]}
		LookEER
		LookSCORE90
		LookSCORE80
		LookSCORE70
		printf "%-20s %-30s %-10d %-10d %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f\n" ${lstm_type[$lstm_index]} ${approximate_type[$app_index]} ${bit_width[$bit_index]} ${fl_type2[$bit_index]} $SCORE_90 $RECALL_90 $SCORE_80 $RECALL_80 $SCORE_70 $RECALL_70 $EER $SCORE >> result.txt
		let "bit_index++"
	    done
	    echo "=====================================" >> result.txt
	else
	    bit_index=0
	    while(( $bit_index<$bit_length ))
	    do
		./run.sh ${lstm_type[$lstm_index]} ${approximate_type[$app_index]} ${bit_width[$bit_index]} ${fl_type1[$bit_index]}
		LookEER
		LookSCORE90
		LookSCORE80
		LookSCORE70
		printf "%-20s %-30s %-10d %-10d %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f\n" ${lstm_type[$lstm_index]} ${approximate_type[$app_index]} ${bit_width[$bit_index]} ${fl_type1[$bit_index]} $SCORE_90 $RECALL_90 $SCORE_80 $RECALL_80 $SCORE_70 $RECALL_70 $EER $SCORE >> result.txt
		let "bit_index++"
	    done
	    echo "=====================================" >> result.txt
	fi
	let "app_index++"
    done
    let "lstm_index++"
done