%include 'yasmmac.inc'
;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*
org 100h 
;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*
section .kodas 
;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*
KodoPradzia:
;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*
macPutString 'Brigita Kasperaviciute 1 kursas 2 grupe','$'
macNewLine
   mov di, [DuomFailasNuskaitymui]
   mov bx, 82h
   call gaukFailoVarda
   gaukFailoVarda:
   FailoVardoGavimas:
   mov dl, [es:bx]
   inc bx
   cmp dl, ' '
   jbe baikDarba
   mov DuomFailasNuskaitymui[di], dl
   inc di
   jmp FailoVardoGavimas
   baikDarba:
   mov byte DuomFailasNuskaitymui[di], 0
 
    mov dx, DuomFailasNuskaitymui
    call procFOpenForReading
    mov dx, bufferis
    mov cx,50000
    call procFRead

   macPutString 'Iveskite failo varda rezultatui isvesti', crlf, '$'
   mov al, 254                  
   mov dx, FileForOutput      
   call procGetStr   
   macNewLine      
   
   mov dx, FileForOutput
   call procFCreateOrTruncate 
   mov dx,FileForOutput
   call procFOpenForWriting 
   mov [Holder], bx
   mov di,0
   mov bp,di
   xor bx,bx
   
LaukuPavadinimai:
   mov dl,[bufferis+di]
   mov al,dl
   mov bx,[Holder]
   call procFPutChar
   inc di
   mov bp,di
   cmp dl,10
   je PirmaNaujaEilute
   jmp LaukuPavadinimai

PirmaNaujaEilute:
   dec di
   mov bp,di
   jmp NaujaEilute

Pradzia:
xor ax,ax
mov di, bp; naujos eilutes koordinates patalpinimas
beginLoop:
mov dl, [bufferis+di]
inc di
cmp dl,59 ; ar ; ??
je antrasLaukas
jmp beginLoop

antrasLaukas:
mov dl,[bufferis+di]
cmp dl, 85 ; jei U tai sok i kita eilute
je NaujaEilute
cmp dl,86 ; jei V tai sok i kita eilute
je NaujaEilute
inc di

cmp dl, 59 ; ar ; ??
je TreciasLaukas

jmp antrasLaukas

TreciasLaukas:
   mov dl,[bufferis+di]
   inc di
   cmp dl,49 ; 1
   je Pridek1
   cmp dl,50 ; 2
   je Pridek2
   cmp dl,51 ; 3 ...
   je Pridek3
   cmp dl,52
   je Pridek4
   cmp dl,53
   je Pridek5
   cmp dl,54
   je Pridek6
   cmp dl,55
   je Pridek7
   cmp dl,56
   je Pridek8
   cmp dl,57
   je Pridek9

Atgal:
cmp dl,59; ar naujas laukas?
je PatikrinkAX
jmp TreciasLaukas

PatikrinkAX:
cmp ax,7
je KetvirtasLaukas 
jmp NaujaEilute

KetvirtasLaukas:
inc di
mov dl,[bufferis+di]
cmp dl, 59
je PenktasLaukas
jmp KetvirtasLaukas

PenktasLaukas:
inc di
mov dl,[bufferis+di]
cmp dl, 59
je SestasLaukas
jmp PenktasLaukas
;*;Veiksmai 6 lauke su realiais skaiciais vyksta;*;
SestasLaukas:
    xor ax,ax
    xor si,si
    inc di
    mov dl,[bufferis+di]; bufferis+di nurodo arba ant -, arba ant pirmo skaitmens 
    mov [BufferSkaitmenims+si],dl
    cmp dl,45 ;jei neigiamas pereik prie naujos eilutes
    je NeigiamasSkaicius
    inc di
    inc di
    inc si
    mov dl,[bufferis+di]
    mov [BufferSkaitmenims+si],dl
    inc di
    inc si
    mov dl,[bufferis+di]
    mov [BufferSkaitmenims+si],dl
   lea dx, [BufferSkaitmenims] ;parse R number into N number
   call procParseInt16
   cmp ax, 234
   jb NaujaEilute 
   cmp ax, 450
   jg NaujaEilute
   jmp RezultatuRasymasFaile
   ;;;;;;;;;;;;;;;;;;
   NeigiamasSkaicius: ;6 lauke neig sk
    inc di
    mov dl,[bufferis+di]; bufferis+di nurodo ant pirmo skaitmens 
    mov [BufferSkaitmenims+si],dl
    inc di
    inc di
    inc si
    mov dl,[bufferis+di]
    mov [BufferSkaitmenims+si],dl
    inc di
    inc si
    mov dl,[bufferis+di]
    mov [BufferSkaitmenims+si],dl
   lea dx, [BufferSkaitmenims] ;parse R number into N number
   call procParseInt16
   cmp ax, 234
   jb NaujaEilute 
   cmp ax, 450
   jg NaujaEilute
   jmp RezultatuRasymasFaile
   ;;;;;;;;;;;;;;;;;
RezultatuRasymasFaile:
   mov dl,[bufferis+bp]
   mov al,dl
   mov bx,[Holder]
   call procFPutChar
   inc bp
   cmp dl, 10
   je Pradzia
   cmp dl, 0
   je Pabaiga
   jmp RezultatuRasymasFaile
NaujaEilute:
   mov dl,[bufferis+di]
   inc di
   mov bp,di
   cmp dl, 10
   je Pradzia
   cmp dl,0; ar jau failo pabaiga??
   je Pabaiga
   jmp NaujaEilute
;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*
;*;Veiksmai su AX;*;
Pridek1:
   add ax,1
   jmp Atgal
Pridek2:
   add ax,2
   jmp Atgal
Pridek3:
   add ax,3
   jmp Atgal
Pridek4:
   add ax,4
   jmp Atgal
Pridek5:
   add ax,5
   jmp Atgal
Pridek6:
   add ax,6
   jmp Atgal
Pridek7:
   add ax,7
   jmp Atgal
Pridek8:
   add ax,8
   jmp Atgal
Pridek9:
   add ax,9
   jmp Atgal
;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*
Pabaiga:
exit
;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*;*
%include 'yasmlib.asm'

 section .Duomenys 
    DuomFailasNuskaitymui:
    times 254 dw 00
    bufferis:
    times 45000 db 0
    Atmintiesbufferis:
    times 15000 db 0
    BufferSkaitmenims:
    times 1000 db 000
    FileForOutput:
    times 254 dw 00
    Holder:
    times 100 db 00

section .bss