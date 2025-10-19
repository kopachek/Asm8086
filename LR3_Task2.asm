.model small
.stack 100h
.data
BUFF_SIZE EQU 200d

prompt1 db "Enter the string: $"
prompt2 db "Enter the word: $"
prompt_final db "Result: $"
buffer db BUFF_SIZE dup('0')       
buffer_wrd db BUFF_SIZE dup('0')
               
err_msg db "Input error.$"
newline db 0dh,0ah,"$"
.code
start:
mov ax, @data
mov ds, ax
mov dx, offset prompt1
mov ah, 9h
int 21h 
mov [buffer], BUFF_SIZE - 1
mov byte ptr [buffer + 1], 0
mov dx, offset buffer
mov ah, 0ah
int 21h
mov al, [buffer + 1]
cmp al, 0
JE input_error         
mov ah, 0
add al, 2
mov si, ax         
mov [buffer + si], 24h
lea dx, newline
mov ah, 9h
int 21h
lea dx, buffer+2
int 21h   
lea dx, newline
int 21h

lea dx, prompt2
int 21h
mov [buffer_wrd], BUFF_SIZE - 1
lea dx, buffer_wrd
mov ah, 0ah
int 21h
mov al, [buffer_wrd + 1]
cmp al, 0
JE input_error         
mov ah, 0
add al, 2
mov si, ax         
mov [buffer_wrd + si], 24h
lea dx, newline
mov ah, 9h
int 21h
lea dx, buffer_wrd+2
int 21h   
lea dx, newline
int 21h 

lea si, buffer + 2
lea di, buffer_wrd + 2 

start_loop:   
cmp [si], 24h
JE done
mov al, [si]
mov ah, [di] 
cmp ah, al
JE match
inc si
JMP start_loop

match:
inc si
inc di
mov ah, [si]
mov al, [di]
cmp al, 24h
JNE start_loop
cmp ah, 20h
JNE start_loop 
inc si
mov di, si; save next word start in di
JMP find_after_next

find_after_next:
inc si
mov al, [si]
cmp al, 24h
JE str_end
cmp al, 20h
JNE find_after_next
inc si
JMP remove_loop

str_end:
mov [di], 24h
JMP done

remove_loop:
mov ah, [si]
mov [di], ah 
mov al, [si]
cmp al, 24h
JE str_end
inc di
inc si
JMP remove_loop

done:
mov ah, 9h
lea dx, prompt_final
int 21h
lea dx, newline
int 21h
lea dx, buffer+2
int 21h
mov ah, 4ch
int 21h

input_error:
mov ah, 9h
lea dx, newline
int 21h
lea dx, err_msg
int 21h
mov ah, 4ch
int 21h
end start


