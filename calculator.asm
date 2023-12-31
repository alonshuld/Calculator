; template for programs
.model small
.stack 100h
.data
;;;;;;;;;print number variables;;;;;;;;;
print_ans_ip			dw	?
num_sfarot			dw	0
dig				dw	?
TEN				dw	10
number_to_print		dw	?

;;;;;;;;;mul variables;;;;;;;;;
mul_ip			dw	?
mul_multiplier		dw	?
mul_multiplied		dw	?
mul_ans			dw	?
 
;;;;;;;;;div variables;;;;;;;;;
div_ip 			dw	?
div_divisor		dw	?
div_divided		dw	?
div_ans			dw	?

;;;;;;;;;mod varibles;;;;;;;;;
mod_ip 			dw	?
mod_divisor 		dw 	?
mod_divided 		dw 	?

;;;;;;;EquationSolver;;;;;;;
number1 			dw	0
number2 			dw 	0 
hazaraEquationSolver 	dw 	0

;;;;;;;;BadInputChecker;;;;;;;
flagPeoplotBad 		dw 	0

;;;;;;;;;;Getinput;;;;;;;;
get_input_ip 		dw 	?
get_input_offset 	dw 	?
number 			dw 	?
digit 			db 	0
equation_max_len 	db 	100  ;65000 
number_len  		db 	?
equation 			db 	100 dup('=')

;;;;;;;;;PolishEquation;;;;;;;;
formula			db 	100 dup('=')
y 				dw 	0
error 			db 	?

;;;;;;;;;messages;;;;;;;;;;
show_message_ip 	dw 	?
show_message_offset 	dw 	?
get_equation_msg 	db 	"Please enter an equation. Enter to end\n$"
get_number_error_msg 	db 	"Wrong number. Please try again\n$"
get_print_msg 		db 	"\nThe answer is:$"
bad_msg 			db 	"\nBad input$"

;;;;;;peolot;;;;;;;;
peola 			db	0
z 				dw 	0
priorX 			dw 	0
hazaraPolish 		dw 	0

;;;;;;;;;sograim;;;;;;;;
poteahAgol 		dw 	40
sogerAgol 			dw 	41
hazaraSograimChecker 	dw 	0

;;;;;;;;CharChecker;;;;;;;;
hazaraCharChecker 	dw 	0
FlagCharChecker 	dw 	0

.code

mov ax,@data
mov ds, ax

;here your program starts
mov bx,0
mov si,0
push offset get_equation_msg
call show_message
push offset equation_max_len 

call get_input

call CharChecker
cmp FlagCharChecker,0
je badTohnitFinish

call sograimChecker
cmp flagPeoplotBad,1
je badTohnitFinish

call polishequation

call EquationSolver

cmp flagPeoplotBad,1
je badTohnitFinish

push offset get_print_msg
call show_message

call print_NUMBER
jmp finishofall

badTohnitFinish:
push offset bad_msg
call  show_message
finishofall:
;here your program ends

mov ah,4ch
mov al,0
int 21h

;here your sub-programs start
CharChecker:
;this function checks if there is an invalid char or we try to divide by zero, if it does the flag wont turn on
pop hazaraCharChecker 
mov bx,0
startOfTheLoop:
cmp equation[bx],'0'
jae nineChecker
jmp PriorChekcer
nineChecker:
cmp equation[bx],'9'
jbe toNumsCheck
jmp PriorChekcer
backToStart:
inc bx
cmp equation[bx],13
je goodFinishChecker
jmp startOfTheLoop
PriorChekcer:
cmp equation[bx],'/'
je testOfZero
cmp equation[bx],'*'
je backToStart
cmp equation[bx],'+'
je backToStart
cmp equation[bx],'-'
je backToStart
cmp equation[bx],'('
je backToStart
cmp equation[bx],')'
je backToStart
jmp badFinish
goodFinishChecker:
mov FlagCharChecker,1
badFinish:
push hazaraCharChecker 
ret
testOfZero:
cmp equation[bx+1],'0'
je badFinish
jmp backToStart
toNumsCheck:
cmp equation[bx+1],'0'
jae nineCheckerSecondNum
jmp backToStart
nineCheckerSecondNum:
cmp equation[bx+1],'9'
jbe badFinish
jmp backToStart
sograimChecker:
;this function checks that for every '(' there is a ')' if it is the flag turns on
pop hazaraSograimChecker
mov si,0
startSograimChecker : 
mov al,equation[si]
cmp al,13
JE sofSograimChecker
mov bl,al
cmp bx,poteahAgol
JE pushpoteahAgol
jmp sAgoll 
pushpoteahAgol : push poteahAgol

sAgoll:
cmp bx,sogerAgol
JE popSogerAgol
inc si
jmp startSograimChecker
popSogerAgol: 
cmp sp,256
jnb badsof
pop ax
cmp ax,40
jne sofSograimChecker
inc si
jmp startSograimChecker
jmp sofsofi
sofSograimChecker:
cmp sp,256
jne badSof
jmp sofsofi
badSof:
jmp sofTohnitSograim
sofsofi:
push hazaraSograimChecker
ret
EquationSolver:
;this function solves the equation from her polish notation version
pop hazaraEquationSolver
mov sp,256
mov bx,0 
solverStart:
cmp formula[bx],'='
je sofSolver
mov cl, formula[bx]
mov digit,cl
call check_digit
cmp error,0
jne peolaSolver
mov al,formula[bx]
mov ah,0 
push ax
inc bx
jmp solverStart

peolaSolver:
cmp sp,252
ja badAction
pop number2
SUB NUMBER2,'0'
pop number1
SUB NUMBER1,'0'
jmp ptira
badAction:
jmp sofTohnit
ptira:
cmp formula[bx],'+'
jne SolverHisor
mov ax,number2
add number1,ax
MOV AX,NUMBER1
ADD AX,'0'
push AX
inc bx
jmp solverStart

SolverHisor:
cmp formula[bx],'-'
jne SolverKefel
mov ax,number2
sub number1,ax
MOV AX,NUMBER1
ADD AX,'0'
push AX
inc bx
jmp solverStart

SolverKefel:
cmp formula[bx],'*'
jne SolverHilok
mov ax,number1
push ax
mov ax,number2
push ax
call multiply
POP NUMBER1
MOV AX,NUMBER1
ADD AX,'0'
PUSH AX
inc bx
jmp solverStart

SolverHilok:
cmp formula[bx],'/'
push number1
push number2
call divide
POP NUMBER1
MOV AX,NUMBER1
ADD AX,'0'
PUSH AX
inc bx
jmp solverStart


sofSolver:
push hazaraEquationSolver
ret

polishequation:
;this function puts the equation in polish notation into formula
pop hazaraPolish
mov priorx,0
mov bx,0
mov si,0
bodekequation:
mov al,equation[bx]
cmp al,'('
je pushpoteh

cmp equation[bx],13
je shora2

cmp al,')'
je popSoger

ifNum:
mov digit,al
call check_digit
cmp error,0
jne mamshih
mov formula[si],al
inc si
inc bx
jmp bodekequation
mamshih:
mov peola,al
call check_peola
cmp error,0
jne shora15
call sederPeolot
cmp sp,256
je shora143
pop y
cmp y,'('
jNe mahnisPeola
PUSH Y
JMP SHORA143
mahnisPeola:
call sederPeolot_y
mov CX,Z
cmp cx,priorx
jNae hemsheh
mov CX,Y
mov formula[si],CL
inc si
JMP SHORA143
hemsheh:
PUSH Y
shora143:
mov ah,0
push ax
inc bx
jmp bodekequation
shora15:
inc bx
jmp bodekequation
sofBodekEquation: shora2: cmp sp,256
jne bodekifmahsanitreika
push hazaraPolish
ret
bodekifmahsanitreika:
pop y
mov dx,y
mov dh,0
mov formula[si],dl
inc si
cmp sp,256
jne bodekifmahsanitreika
push hazaraPolish
ret
pushpoteh:
mov ah,0
push ax
jmp nextNum
nextNum:
inc bx
jmp bodekequation
popSoger:
pop y
cmp y,'('
jne notpoteah
jmp ifNum

notpoteah:
mov dx,y
mov formula[si],dl
inc si
jmp popSoger

check_digit:
cmp digit,'0'
jb not_digit
cmp digit,'9'
ja not_digit
mov error,0
ret
not_digit:
mov error,1
ret

check_peola:
cmp peola,'*'
jb not_peola
cmp peola,'/'
ja not_peola
mov error,0
ret
not_peola:
mov error,1
ret
show_message:
;covered in class, this function prints the message that pushed in the offset
pop show_message_ip
pop show_message_offset
push ax
push dx

mov dx, show_message_offset
mov ah,9h
int 21h ;; INT 21H AH=9H

pop dx
pop ax
push show_message_ip
ret
get_input:
;this function covered in class, gets the input from the graphic board
pop get_input_ip
pop get_input_offset
push ax
push dx

mov dx, get_input_offset
mov ah,0Ah
int 21h ;; INT 21H AH=0AH

pop dx
pop ax
push get_input_ip
ret


sederPeolot:
cmp al,'+'
je tshova_1
cmp al,'-'
je tshova_1
cmp al,'*'
je tshova_2
cmp al,'/'
je tshova_2
tshova_1:
mov priorx,1
ret
tshova_2:
mov priorx,2
ret
sederPeolot_y:
cmp Y,'+'
je tshova_11
cmp Y,'-'
je tshova_11
cmp Y,'*'
je tshova_22
cmp Y,'/'
je tshova_22
tshova_11:
mov z,1
ret
tshova_22:
mov z,2
ret

;;;;;;;;;mul;;;;;;;;;
multiply:
;covered in homework, multiply with both of the number from the stack segment
pop mul_ip
pop mul_multiplied
pop mul_multiplier
push cx
mov cx, 0
mul_while: cmp mul_multiplier,0
je mul_end
add cx, mul_multiplied
dec mul_multiplier
jmp mul_while
mul_end:
mov mul_ans, cx
pop cx 
push mul_ans
push mul_ip
ret


;;;;;;;;;div;;;;;;;;;
divide:
;covered in homework, divide with both of the number from the stack segment
pop div_ip
pop div_divisor
pop div_divided
push dx
mov dx,div_divisor
mov div_ans,0
div_while: cmp div_divided,dx
jb div_end
inc div_ans
sub div_divided,dx
jmp div_while
div_end: 
pop dx
push div_ans
push div_ip
ret

;;;;;;;;;mod;;;;;;;;;
modulo:
;covered in homework, modulo with both of the number from the stack segment
pop mod_ip
pop mod_divisor
pop mod_divided
push dx
mov dx, mod_divisor
mod_while: cmp mod_divided, dx
jb mod_end
sub mod_divided, dx
jmp mod_while
mod_end:
pop dx
push mod_divided
push mod_ip
ret

;;;;;;;;;print ans;;;;;;;;;
print_number:
;print the numbers to the graphic board
pop print_ans_ip
pop number_to_print
SUB NUMBER_TO_PRINT,'0'
push ax
push bx
push dx

;if the answer is zero we print zero
print_ans_if_1: cmp number_to_print,0
jne print_ans_if_2
mov al,48 ;'0'
mov ah,14
int 10h
;in 2's complement above 32768 means a negative number
jmp print_ans_while_2_end
print_ans_if_2: cmp number_to_print, 32768
jb positive
mov al, 45 ;'-'
mov ah, 14
int 10h
not number_to_print
inc number_to_print
;covered in homework
positive: cmp number_to_print,0
je positive_end
push number_to_print
push TEN
call modulo
push number_to_print
push TEN
call divide
pop number_to_print
inc num_sfarot
jmp positive
positive_end:
print_ans_while_2: cmp num_sfarot, 0
je print_ans_while_2_end
pop dig
add dig, '0'
mov ax, dig
mov ah, 14
int 10h
dec num_sfarot
jmp print_ans_while_2
print_ans_while_2_end:
pop dx
pop bx
pop ax
push print_ans_ip
ret
sofTohnit:
mov flagPeoplotBad,1
jmp sofSolver
sofTohnitSograim:
mov flagPeoplotBad,1
jmp sofSofi

; here your sub-programs end
end
