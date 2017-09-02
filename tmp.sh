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

echo $EER
echo $SCORE

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

echo $SCORE_90
echo $RECALL_90

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

echo $SCORE_80
echo $RECALL_80

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

echo $SCORE_70
echo $RECALL_70
rm -i result.txt
printf "%-20s %-25s %-10s %-10s %15s %10s %15s %10s %15s %10s %10s %10s\n" LSTM_DIY_TYPE APPROXIMATE_TYPE BIT_WIDTH FRACTION SCORE_90 RECALL SCORE_80 RECALL SCORE_70 RECALL REE SCORE >> result.txt
printf "%-20s %-30s %-10d %-10d %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f %-1.10f\n" sigmoid_tanh_diy LUT_BIT_LEVEL_004_quan 32 23 $SCORE_90 $RECALL_90 $SCORE_80 $RECALL_80 $SCORE_70 $RECALL_70 $EER $SCORE >> result.txt