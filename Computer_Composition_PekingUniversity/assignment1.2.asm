.data
msg_success:.asciiz "\r\nSuccess! Location: "
msg_fail:   .asciiz "\r\nFail!\r\n"
msg_exit:   .asciiz "\r\nProgram is exited.\r\n"
string_end: .asciiz "\r\n"
buf:        .space 100

            .text
            .globl main
main:       la $a0, buf          # address of input buffer  la: Load Address
            la $a1, 100          # set maximum number of characters to read
            li $v0, 8            # read string  li: Load Immediate
            syscall

get_input:  li $v0, 12           # read character
            syscall
            addi $t7, $0, 63     # '?' => exit
            sub $t6, $t7, $v0
            beq $t6, $0, exit
            add $t0, $0, $0
            la $s1, buf

find_loop:  lb $s0, 0($s1)        # sign-extends the byte into a 32-bit value
            sub $t1, $v0, $s0
            beq $t1, $0, success # t0 is answer to print
            addi $t0, $t0, 1
            slt $t3, $t0, $a1    # t0 < a1 then t3 = 1 else t3 = 0 ( a1 is maximum number of characters to read
            beq $t3, $0, fail    # already reach the end of characters
            addi $s1 $s1, 1      # ++
            j find_loop

success:    la $a0, msg_success
            li $v0, 4            # print msg_success
            syscall
            addi $a0, $t0, 1
            li $v0, 1            # print result integer
            syscall
            la $a0, string_end
            li $v0, 4            # print new line
            syscall
            j get_input

fail:       la $a0, msg_fail
            li $v0, 4
            syscall
            j get_input

exit:       la $a0, msg_exit
            li $v0, 4
            syscall