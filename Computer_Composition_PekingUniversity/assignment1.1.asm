.data
upper_word:     .asciiz
            "Alpha ","Bravo ","China ","Delta ","Echo ","Foxtrot ",
            "Golf ","Hotel ","India ","Juliet ","Kilo ","Lima ",
            "Mary ","November ","Oscar ","Paper ","Quebec ","Research ",
            "Sierra ","Tango ","Uniform ","Victor ","Whisky ","X-ray ",
            "Yankee ","Zulu "
upperword_offset:  .word
            0,7,14,21,28,34,43,49,56,63,71,
            77,83,89,99,106,113,121,131,
            139,146,155,163,171,178,186
lower_word:     .asciiz
            "alpha ","bravo ","china ","delta ","echo ","foxtrot ",
            "golf ","hotel ","india ","juliet ","kilo ","lima ",
            "mary ","november ","oscar ","paper ","quebec ","research ",
            "sierra ","tango ","uniform ","victor ","whisky ","x-ray ",
            "yankee ","zulu "
lower_offset:  .word
            0,7,14,21,28,34,43,49,56,63,71,
            77,83,89,99,106,113,121,131,
            139,146,155,163,171,178,186
number:     .asciiz
            "zero ", "First ", "Second ", "Third ", "Fourth ",
            "Fifth ", "Sixth ", "Seventh ","Eighth ","Ninth "
number_offset:   .word
            0,6,13,21,28,36,43,50,59,67
exit_str: .asciiz "#Program is stopped#"

            .text
            .globl main
main:       li $v0, 12 # read input
            syscall
            sub $t1, $v0, 63 # '?' assic is 63
            beqz $t1, exit
            sub $t1, $v0, 48 # '0'
            slt $s0, $t1, $0 # if t1 < 0 then s0 = 1
            bnez $s0, others

            # is number?
            sub $t2, $t1, 10 # number
            slt $s1, $t2, $0 # if t2 < 0 then s1 = 1
            bnez $s1, getnumber

            # is capital?
            sub $t2, $v0, 91
            slt $s3, $t2, $0 # if v0 <= 'Z' then s3 = 1
            sub $t3, $v0, 64 
            sgt $s4, $t3, $0 # if v0 >='A' then s4 = 1
            and $s0, $s3, $s4 # if s3 == 1 && s4 == 1 
            bnez $s0, getupperword

            # is lower case?
            sub $t2, $v0, 123
            slt $s3, $t2, $0 # if v0 <= 'z' then s3 = 1
            sub $t3, $v0, 96 
            sgt $s4, $t3, $0 # if v0 >= 'a' then s4 = 1
            and $s0, $s3, $s4
            bnez $s0, getlowerword
            j others

getnumber:     add $t2, $t2, 10
            sll $t2, $t2, 2
            la $s0, number_offset
            add $s0, $s0, $t2
            lw $s1, ($s0)
            la $a0, number
            add $a0, $a0, $s1
            li $v0, 4
            syscall
            j main

            # upper case word
getupperword:   sub $t3, $t3, 1
            sll $t3, $t3, 2
            la $s0, upperword_offset
            add $s0, $s0, $t3
            lw $s1, ($s0)
            la $a0, upper_word
            add $a0, $s1, $a0
            li $v0, 4
            syscall
            j main

            # lower case word
getlowerword:   sub $t3, $t3, 1
            sll $t3, $t3, 2
            la $s0, lower_offset
            add $s0, $s0, $t3
            lw $s1, ($s0)
            la $a0, lower_word
            add $a0, $s1, $a0
            li $v0, 4
            syscall
            j main

others:     and $a0, $0, $0
            add $a0, $a0, 42 # '*'
            li $v0, 11 # print result
            syscall
            j main

exit:       
	    add $a0, $0, '\n'
	    li $v0, 11
    	    syscall
            la $a0, exit_str
	    li $v0, 4 # exit
            syscall
