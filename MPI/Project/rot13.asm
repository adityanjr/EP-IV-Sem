.model small
.stack 256
.data

var db 26 dup(?) 
ee db 'Invalid String !$'
msg db 'Enter String : $'
msgen db 'After Encryption : $'
count db 0

.code
main proc


mov ax,@data
mov ds,ax

start:
mov dl,10
mov ah,2
int 21h

mov count,0

lea dx,msg
mov ah,9
int 21h

lea si,var       ;array 1st index
                 
lb:
   mov ah,1
   int 21h
   cmp al,13     ;"Enter" ascii code
   je outside
   mov [si],al   ;al to array "si" index
   inc si
   inc count
   jmp lb

outside:
      mov bl,'$'    ;ending array 
      mov [si],bl
      
call encrypt



mov dl,10
mov ah,2
int 21h


lea dx,msgen
mov ah,9
int 21h
	
lea dx,var
mov ah,9
int 21h

mov dl,10
mov ah,2
int 21h

jmp start	

eror:
lea dx,ee
mov ah,9
int 21h

mov dl,10
mov ah,2
int 21h

jmp start


	
	
main endp

encrypt proc

	  lea si,var

starting:	  
	  mov bl,[si]
	  cmp bl,65
	  jge upperabc

	  cmp bl,97
	  jge lowerabc
	  
	  jmp eror
	  
upperabc:


cmp bl,97
jge lowerabc
cmp bl,90
jg eror
jle en

en:
	
	mov bl,[si]
	cmp bl,77
	jg enn
	add bl,13
	mov [si],bl
	inc si 
	dec count
	cmp count,0
	jg starting
	je ll
	
enn:
	sub bl,13
	mov [si],bl
	inc si 
	dec count
	cmp count,0
	jg starting
	je ll
	
	
lowerabc:
cmp bl,122
jg eror
jle en1

en1:
	
	mov bl,[si]
	cmp bl,109
	jg enn1
	add bl,13
	mov [si],bl
	inc si 
	dec count
	cmp count,0
	jg starting
	je ll
	
enn1:
	sub bl,13
	mov [si],bl
	inc si 
	dec count
	cmp count,0
	jg starting
	je ll

	
ll:
	
ret
encrypt endp

end main