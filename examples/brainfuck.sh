NAME=brainfuck
rm -rf $NAME
mkdir $NAME
cd $NAME
git init

# Basics

EMPTY_TREE=$(git write-tree)

ERROR=$(git commit-tree -m "\"\\nrorrE\" putchar putchar putchar putchar putchar putchar" $EMPTY_TREE)

# Execute command

QUIT=$(git commit-tree -m "quit" $EMPTY_TREE)
LOOP_BACK=$(git commit-tree -m "[main-loop]" $EMPTY_TREE)

EXECUTE_CAB=$(git commit-tree -m "2 left read 1 add write 2 right read dup add right" -p $LOOP_BACK $EMPTY_TREE)
EXECUTE_OAB=$(git commit-tree -m "2 left read 1 sub write 2 right read dup add right" -p $LOOP_BACK $EMPTY_TREE)
EXECUTE_PLUS=$(git commit-tree -m "2 left read dup dup add left read 1 add write dup add right 2 right read dup add right" -p $LOOP_BACK $EMPTY_TREE)
EXECUTE_MINUS=$(git commit-tree -m "2 left read dup dup add left read 1 sub write dup add right 2 right read dup add right" -p $LOOP_BACK $EMPTY_TREE)
EXECUTE_DOT=$(git commit-tree -m "2 left read dup dup add left read putchar dup add right 2 right read dup add right" -p $LOOP_BACK $EMPTY_TREE)
EXECUTE_COMMA=$(git commit-tree -m "2 left read dup dup add left getchar write dup add right 2 right read dup add right" -p $LOOP_BACK $EMPTY_TREE)
EXECUTE_CSB=$(git commit-tree -m "quit  " $EMPTY_TREE)
EXECUTE_OSB=$(git commit-tree -m "quit " $EMPTY_TREE)

# Main loop

READ_TO_PC_DO_LOOP=$(git commit-tree -m "[pc-loop]" $EMPTY_TREE)
READ_TO_PC_FINISH=$(git commit-tree -m "1 left write 1 left read 1 add write 1 right read 1 left" -p $QUIT -p $EXECUTE_CAB -p $EXECUTE_OAB -p $EXECUTE_PLUS -p $EXECUTE_MINUS -p $EXECUTE_DOT -p $EXECUTE_COMMA -p $EXECUTE_OSB -p $EXECUTE_CSB $EMPTY_TREE)
READ_TO_PC=$(git commit-tree -m "2 left read" -p $READ_TO_PC_FINISH -p $READ_TO_PC_DO_LOOP $EMPTY_TREE)
git tag pc-loop $READ_TO_PC
MAIN=$(git commit-tree -m "read" -p $READ_TO_PC $EMPTY_TREE)
git tag main-loop $MAIN

# Reading the input program and writing it to the tape

READ_BACK_DO_LOOP=$(git commit-tree -m "[read-back]" $EMPTY_TREE)
READ_BACK_FINISH=$(git commit-tree -m "2 right" -p $MAIN $EMPTY_TREE)
READ_BACK=$(git commit-tree -m "2 left read" -p $READ_BACK_FINISH -p $READ_BACK_DO_LOOP $EMPTY_TREE)
git tag read-back $READ_BACK

WRITE=$(git commit-tree -m "write 2 right dup sub right [read-loop]" $EMPTY_TREE)

READ_CAB=$(git commit-tree -m "1" -p $WRITE $EMPTY_TREE)
READ_OAB=$(git commit-tree -m "2" -p $WRITE $EMPTY_TREE)
READ_PLUS=$(git commit-tree -m "3" -p $WRITE $EMPTY_TREE)
READ_MINUS=$(git commit-tree -m "4" -p $WRITE $EMPTY_TREE)
READ_DOT=$(git commit-tree -m "5" -p $WRITE $EMPTY_TREE)
READ_COMMA=$(git commit-tree -m "6" -p $WRITE $EMPTY_TREE)
READ_OSB=$(git commit-tree -m "7" -p $WRITE $EMPTY_TREE)
READ_CSB=$(git commit-tree -m "8" -p $WRITE $EMPTY_TREE)

IGNORE=$(git commit-tree -m "[read-loop]" $EMPTY_TREE)
DECODE8=$(git commit-tree -m "dup \"]\" sub" -p $READ_CSB -p $IGNORE $EMPTY_TREE)
DECODE7=$(git commit-tree -m "dup \"[\" sub" -p $READ_OSB -p $DECODE8 $EMPTY_TREE)
DECODE6=$(git commit-tree -m "dup \",\" sub" -p $READ_COMMA -p $DECODE7 $EMPTY_TREE)
DECODE5=$(git commit-tree -m "dup \".\" sub" -p $READ_DOT -p $DECODE6 $EMPTY_TREE)
DECODE4=$(git commit-tree -m "dup \"-\" sub" -p $READ_MINUS -p $DECODE5 $EMPTY_TREE)
DECODE3=$(git commit-tree -m "dup \"+\" sub" -p $READ_PLUS -p $DECODE4 $EMPTY_TREE)
DECODE2=$(git commit-tree -m "dup \"<\" sub" -p $READ_OAB -p $DECODE3 $EMPTY_TREE)
DECODE1=$(git commit-tree -m "dup \">\" sub" -p $READ_CAB -p $DECODE2 $EMPTY_TREE)
GETCHAR=$(git commit-tree -m "getchar dup" -p $READ_BACK -p $DECODE1 $EMPTY_TREE)
git tag read-loop $GETCHAR

SETUP=$(git commit-tree -m "100 write 2 right 2 write 4 right" -p $GETCHAR $EMPTY_TREE)
git reset $SETUP
