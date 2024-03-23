
segment .data
print_int_format: db        "%ld", 0
read_int_format: db         "%ld", 0
digit_temp:
    resb 2000     
sub_first_operand:
    resb 2000     
sub_second_operand:
    resb 2000     
mul_first_operand:
    resb 2000     
mul_second_operand:
    resb 2000     
zero:
    resb 2000     
one:
    resb 2000     
ten_operand:
    resb 2000     
minus_one:
    resb 2000     
mod_temp:
    resb 2000     
res:
    resb 2000     
temp:
    resb 2000     
temp2:
    resb 2000     
temp3:
    resb 2000  
first_operand:
    resb 2000     
second_operand:
    resb 2000     
div_first_operand:
    resb 2000     
div_second_operand:
    resb 2000     
idiv_first_operand:
    resb 2000     
idiv_second_operand:
    resb 2000     
div_temp:
    resb 2000   

segment .text

%macro first_of_function 0
    push r12
    push r14
    push r15
    push rbx
    push rbp
    push r13
%endmacro

%macro end_of_function 0
	pop r13
    pop rbp
    pop rbx
    pop r15
    pop r14
    pop r12
    ret
%endmacro


    global asm_main
    extern printf
    extern putchar
    extern puts
    extern gets
    extern scanf
    extern getchar


push_reg:
    pop r10
    push r12
    push r14
    push r15
    push rbx
    push rbp
    push r13
    sub rsp, 24
    push r10
    ret
pop_reg:
    pop r10
    add rsp, 24
    pop r13
    pop rbp
    pop rbx
    pop r15
    pop r14
    pop r12
    push r10
    ret

print_int:
    sub rsp, 8
    mov rsi, rdi
    mov rdi, print_int_format
    mov rax, 1
    call printf
    add rsp, 8
    ret


print_char:
    sub rsp, 8
    call putchar
    add rsp, 8
    ret


print_string:
    sub rsp, 8
    call puts
    add rsp, 8
    ret


print_nl:
    sub rsp, 8
    mov rdi, 10
    call putchar
    add rsp, 8
    ret


read_int:
    sub rsp, 8
    mov rsi, rsp
    mov rdi, read_int_format
    mov rax, 1
    call scanf
    mov rax, [rsp]
    add rsp, 8
    ret


read_char:
    sub rsp, 8
    call getchar
    add rsp, 8
    ret

my_div:
    first_of_function
sub rsp, 24
    push r12
    lea r12, div_first_operand
    call my_copy
    pop r12

    mov r13, r12
    lea r12, div_second_operand
    call my_copy
    lea r13, div_first_operand

    push r13
    lea r13, temp2
    call make_it_clear
    lea r13, temp3
    call make_it_clear
    mov r13, r14
    call make_it_clear
    pop r13

    call my_compare
    cmp r8, 0
    jl exit_div

    mov rax, 1
    mov [temp2], rax


div_inc_loop:
    call my_sub
    push r13
    mov r13, r14
    call my_compare
    pop r13
    cmp r8, 0
    jl div_continue
    push r13
    mov r13, r12
    call my_sl
    lea r13, temp2
    call my_sl
    pop r13
    jmp div_inc_loop

div_continue:
    push r13
    mov r13, r14
    call make_it_clear
    pop r13
div_loop:
    push r13
    push r12
    lea r13, temp2
    lea r12, temp3
    call my_compare
    pop r12
    pop r13
    cmp r8, 0
    je exit_div
    call my_compare
    cmp r8, 0
    jl divide
    push r14
    mov r14, r13
    call my_sub
    pop r14
    push r13
    pop r13
    push r13
    push r12
    mov r13, r14
    lea r12, temp2
    call my_add
    pop r12
    pop r13
divide:
    push r13
    mov r13, r12
    call my_sr
    lea r13, temp2
    call my_sr
    pop r13
    jmp div_loop



exit_div:
    add rsp, 24
end_of_function
my_add:
    first_of_function
sub rsp, 24
    mov rbp, 0
    mov rbx, 0
my_add_loop:
    clc
    mov r10, [r13]
    mov r11, [r12]
    cmp rbx, 0
    je without_carry
    mov rbx, 0
    stc
without_carry:
    adc r10, r11
    jnc continue
    mov rbx, 1
continue:
    mov [r14], r10
    add rbp, 1
    add r13, 8
    add r12, 8
    add r14, 8
    cmp rbp, 4
    jl my_add_loop
    add rsp, 24
end_of_function




my_negativate:
    first_of_function
sub rsp, 24
    mov r12, r13
    mov rbp, 0
neg_loop:
    mov r10, [r13]
    not r10
    mov [r13], r10
    add rbp, 1
    add r13, 8
    cmp rbp, 4
    jl neg_loop

    lea r13, temp
    call make_it_clear
    mov rbp, 1
    mov qword[temp], rbp
    mov r14, r12
    call my_add
    add rsp, 24
end_of_function

make_it_clear:
    first_of_function
sub rsp, 24
    mov r12, r13
    mov rbp, 0 ;index
zero_loop:
    xor r10, r10
    mov qword[r13], r10
    add rbp, 1
    add r13, 8
    cmp rbp, 4
    jl zero_loop
    add rsp, 24
end_of_function

my_sub:
    first_of_function
sub rsp, 24
    push r12
    lea r12, sub_first_operand
    call my_copy
    pop r12
    mov r13, r12
    lea r12, sub_second_operand
    call my_copy
    lea r13, sub_first_operand
    call my_negativate
    call my_add
    call my_negativate
    mov r13, r14
    call my_negativate
    add rsp, 24
end_of_function


my_mul:
    push rbx
    push rbp
    push r13
    push r12
    push r14
    push r15
    sub rsp, 32
    push r12
    lea r12, mul_first_operand
    call my_copy
    pop r12
    mov r13, r12
    lea r12, mul_second_operand
    call my_copy
    lea r13, mul_first_operand
    mov rbp, 0
    push r13
    mov r13, r14
    call make_it_clear
    pop r13

mul_outer_loop:
    push r12
    mov r12, [r12]
    mov rbx, 1

mul_inner_loop:
    mov r10, r12
    and r10, rbx
    push r12
    cmp r10, 0
    je continue_mul
    mov r12, r14
    call my_add
continue_mul:
    mov r12, r13
    push r14
    mov r14, r13
    call my_add
    pop r14
    pop r12
    sal rbx, 1
    cmp rbx, 0
    jne mul_inner_loop


    pop r12
    add rbp, 1
    add r12, 8
    cmp rbp, 4
    jl mul_outer_loop

    add rsp, 32
	pop r15
	pop r14
	pop r12
	pop r13
    pop rbp
    pop rbx
    ret



my_compare:
    first_of_function
sub rsp, 24
    
    mov rbp, [24 + r13]
    mov rbx, [24 + r12]
    cmp rbp, rbx
    jg pos_label
    jl neg_label

    mov rbp, [16 + r13]
    mov rbx, [16 + r12]
    cmp rbp, rbx
    jne not_equal

    mov rbp, [8 +r13]
    mov rbx, [8 +r12]
    cmp rbp, rbx
    jne not_equal

    mov rbp, [r13]
    mov rbx, [r12]
    cmp rbp, rbx
    je eq_label
    cmp rbp, rbx
    jne not_equal
    

not_equal:
    mov r10, rbp
    mov r11, rbx
    shr r10, 1
    shr r11, 1
    cmp r10, r11
    jg pos_label
    jl neg_label
    and rbp, 0x7FFF
    and rbx, 0x7FFF
    cmp rbp, rbx
    jg pos_label
    jl neg_label

pos_label:
    mov r8, 1
    jmp done_cmp
neg_label:
    mov r8, -1
    jmp done_cmp
eq_label:
    mov r8, 0
    jmp done_cmp
done_cmp:
    add rsp, 24
end_of_function



my_sr:
    first_of_function
sub rsp, 24


    mov rbp, 32
    mov r12, 0
    add r13, 32
shift_right_loop:
    add rbp, -8
    add r13, -8
    mov r10, [r13]
    mov r14, r12
    shl r14, 63
    mov r12, 0
    shr r10, 1
    adc r12, 0
    add r10, r14
    mov [r13], r10
    cmp rbp, 0
    jg shift_right_loop

    add rsp, 24
end_of_function




my_sl:
    first_of_function
sub rsp, 24


    mov rbp, 0
    mov r12, 0
shift_left_loop:
    mov r14, r12
    mov r10, [r13]
    mov r12, 0
    add r10, r10
    adc r12, 0
    add r10, r14
    mov [r13], r10
    mov rdx, 8
    add r13, rdx
    add rbp, rdx
    cmp rbp, 32
    jl shift_left_loop

    add rsp, 24
end_of_function



my_copy:
    first_of_function
sub rsp, 24
    mov rdx, 8
    mov rax, [r13]
    mov [r12], rax
    add r13, rdx
    add r12, rdx
    mov rax, [r13]
    mov [r12], rax
    add r13, rdx
    add r12, rdx
    mov rax, [r13]
    mov [r12], rax
    add r13, rdx
    add r12, rdx
    mov rax, [r13]
    mov [r12], rax

    add rsp, 24
end_of_function



my_mod:
    first_of_function
sub rsp, 24

    call my_idiv
    push r13
    mov r13, r14
    call my_mul
    pop r13
    mov r12, r14
    call my_sub

    add rsp, 24
end_of_function



my_idiv:
    first_of_function
sub rsp, 24

    push r12
    lea r12, idiv_first_operand
    call my_copy
    pop r12

    mov r13, r12
    lea r12, idiv_second_operand
    call my_copy
    lea r13, idiv_first_operand

    mov rax, 0
    inc rax
    push r13
    lea r13, zero
    call my_compare
    neg r8
    pop r13
    imul rax, r8
    cmp r8, 0
    jge skip_neg2
    push r13
    mov r13, r12
    call my_negativate
    pop r13
skip_neg2:
    push r12
    lea r12, zero
    call my_compare
    pop r12
    imul rax, r8
    cmp r8, 0
    jge skip_neg1
    call my_negativate
skip_neg1:

    mov rbp, rax
    call my_div
    cmp rbp, 0
skip_inc:
    mov r13, r14
    cmp rbp, 0
    jge skip_res_neg
    call my_negativate
skip_res_neg:

    add rsp, 24
end_of_function



read_number:
    first_of_function
sub rsp, 24

    call make_it_clear
    mov rbx, 1
loop_until_start:
    sub rsp, 8
    call read_char
    add rsp, 8
    mov rbp, rax
    cmp rbp, '0'
    jl not_digit_start
    cmp rbp, '9'
    jg not_digit_start
    jmp got_first_valid_digit

not_digit_start:
    cmp rbp, '-'
    je got_neg_sign
    cmp rbp, '+'
    je got_pos_sign
    jmp loop_until_start

got_neg_sign:
    mov rbx, -1
    jmp loop_until_start
got_pos_sign:
    mov rbx, 1
    jmp loop_until_start
got_first_valid_digit:
reading_digit_loop:
    add rbp, -48
    push r13
    lea r13, digit_temp
    call make_it_clear
    mov qword[digit_temp], rbp
    pop r13
    lea r12, ten_operand
    mov r14, r13
    call my_mul
    lea r12, digit_temp
    call my_add
    sub rsp, 8
    call read_char
    add rsp, 8
    mov rbp, rax
    cmp rbp, '9'
    jg reading_ended
    cmp rbp, '0'
    jl reading_ended
    jmp reading_digit_loop

reading_ended:
    cmp rbx, 0
    jge skip_read_res_neg
    call my_negativate
skip_read_res_neg:
    add rsp, 24
end_of_function




print_number:
    first_of_function
    sub rsp, 1032

    mov rbx, 0
    lea r12, zero
    call my_compare
    cmp r8, 0
    jl print_neg_int
    jg print_abs_int
    mov rdi, '0'
    sub rsp, 8
    call print_char
    add rsp, 8
    jmp printed
print_neg_int:
    mov rdi, '-'
    sub rsp, 8
    call print_char
    add rsp, 8
    call my_negativate
print_abs_int:
    lea r12, ten_operand
    lea r14, digit_temp
    call my_mod
    mov rbp, [digit_temp + 0]
    add rbp, 48
    push rbp
    add rbx, 1
    mov r14, r13
    call my_div
    lea r12, zero
    call my_compare
    cmp r8, 0
    jg print_abs_int

printing_digs:
    pop rbp
    mov rdi, rbp
    sub rsp, 8
    call print_char
    add rsp, 8
    sub rbx, 1
    cmp rbx, 0
    jg printing_digs
printed:
    add rsp, 1032
	end_of_function
    ret

asm_main:
	call push_reg
    lea r13, zero
    call make_it_clear
    lea r13, one
    call make_it_clear
    lea r13, minus_one
    call make_it_clear

    mov r13, 1
    mov [one], r13
    mov [minus_one], r13
    lea r13, minus_one
    call my_negativate
    lea r13, ten_operand
    call make_it_clear
    mov r13, 10
    mov [ten_operand], r13


major_next:
    sub rsp, 8
    call read_char
    add rsp, 8
    mov rbp, rax
    cmp rbp, 'q'
    je end
    mov rbp, rax
    lea r13, first_operand
    call read_number
    lea r13, second_operand
    call read_number
    mov rdx, rbp
    cmp rdx, '+'
    je my_addition
    cmp rdx, '-'
    je my_subtraction
    cmp rdx, '*'
    je my_multiplication
    cmp rdx, '/'
    je my_division
    cmp rdx, '%'
    je modulo

modulo:
    lea r13, first_operand
    lea r12, second_operand
    lea r14, res
    call my_mod
    lea r13, res
    call print_number
    mov rdi, 10
    sub rsp, 8
    call print_char
    add rsp, 8
    jmp major_next
my_addition:
    lea r13, first_operand
    lea r12, second_operand
    lea r14, res
    call my_add
    lea r13, res
    call print_number
    mov rdi, 10
    sub rsp, 8
    call print_char
    add rsp, 8
    jmp major_next
my_subtraction:
    lea r13, first_operand
    lea r12, second_operand
    lea r14, res
    call my_sub
    lea r13, res
    call print_number
    mov rdi, 10
    sub rsp, 8
    call print_char
    add rsp, 8
    jmp major_next
my_division:
    lea r13, first_operand
    lea r12, second_operand
    lea r14, res
    call my_idiv
    lea r13, res
    call print_number
    mov rdi, 10
    sub rsp, 8
    call print_char
    add rsp, 8
    jmp major_next
my_multiplication:
    lea r13, first_operand
    lea r12, second_operand
    lea r14, res
    call my_mul
    lea r13, res
    call print_number
    mov rdi, 10
    sub rsp, 8
    call print_char
    add rsp, 8
    jmp major_next

end:
    call pop_reg
    ret