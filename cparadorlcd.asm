#include "p16F887.inc"   ; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
 	__CONFIG	_CONFIG1,	_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOR_OFF & _IESO_ON & _FCMEN_ON & _LVP_OFF 
 	__CONFIG	_CONFIG2,	_BOR40V & _WRT_OFF

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

    BCF PORTC,0		;reset
    MOVLW 0x01
    MOVWF PORTD
    
    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
  
    GOTO    START

MAIN_PROG CODE                      ; let linker place main program

START

i equ 0x30
j equ 0x31
K equ 0x34

X equ 0x32
Y equ 0x33

START

    BANKSEL PORTA ;
    CLRF PORTA ;Init PORTA
    BANKSEL ANSEL ;
    CLRF ANSEL ;digital I/O
    CLRF ANSELH
    BANKSEL TRISA ;
    MOVLW d'255'
    MOVWF TRISA 
    MOVLW b'00000011' ;dos 1 de entrada 
    MOVWF TRISB
    CLRF TRISC
    CLRF TRISD
    CLRF TRISE
    BCF STATUS,RP1
    BCF STATUS,RP0
    BCF PORTC,1
    BCF PORTC,0
    ;0x80	es en donde incia el primer rengon del LCD
    ;0xC0	es en donde incia el segundo renglon del LCD
INITLCD
    BCF PORTC,0		;reset
    MOVLW 0x01
    MOVWF PORTD
    
    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
    
    MOVLW 0x0C		;first line
    MOVWF PORTD
    
    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
         
    MOVLW 0x3C		;cursor mode
    MOVWF PORTD
    
    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
    

INICIO	  
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;BOTONES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    BTFSC PORTB, 0 ;port0 ;si hay 0 en la pos 0 del portb 
    CALL BTN1
    BTFSC PORTB, 1 ;port1 ; si hay 0 en el boton2
    CALL BTN2
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    BCF PORTC,0		;command mode	;modo de instrucciones
    CALL time
    
    MOVLW 0x80		;LCD position	;0x80 donde incia 1er renglon del LCD
    MOVWF PORTD
    CALL exec
    
    BSF PORTC,0		;data mode
    CALL time
    
    MOVLW 'A'
    MOVWF PORTD
    CALL exec
    
    MOVLW ':'
    MOVWF PORTD
    CALL exec
    
    BCF PORTC,0		;command mode	;modo de instrucciones
    CALL time
    
    MOVLW 0x82		;LCD position	;0x80 donde incia 1er renglon del LCD
    MOVWF PORTD
    CALL exec
    
    BSF PORTC,0		;data mode
    CALL time
    
    
    BTFSS X,7
    CALL print0
    BTFSC X,7
    CALL print1
    
    BTFSS X,6
    CALL print0
    BTFSC X,6
    CALL print1
    
    BTFSS X,5
    CALL print0
    BTFSC X,5
    CALL print1
    
    BTFSS X,4
    CALL print0
    BTFSC X,4
    CALL print1
    
    BTFSS X,3
    CALL print0
    BTFSC X,3
    CALL print1
    
    BTFSS X,2
    CALL print0
    BTFSC X,2
    CALL print1
    
    BTFSS X,1
    CALL print0
    BTFSC X,1
    CALL print1
    
    BTFSS X,0
    CALL print0
    BTFSC X,0
    CALL print1
    
    ;;;;;;;;;;;para el segundo renglon ;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    
    BCF PORTC,0		;command mode
    CALL time
    
    MOVLW 0xC0		;LCD position
    MOVWF PORTD
    CALL exec

    BSF PORTC,0		;data mode
    CALL time
    
    MOVLW 'B'
    MOVWF PORTD
    CALL exec
   
    
    MOVLW ':'
    MOVWF PORTD
    CALL exec
      
    BCF PORTC,0		;command mode
    CALL time
    
    MOVLW 0xC2		;LCD position
    MOVWF PORTD
    CALL exec
    
    BSF PORTC,0		;data mode
    CALL time
    
    BTFSS Y,7
    CALL print0
    BTFSC Y,7
    CALL print1
    
    BTFSS Y,6
    CALL print0
    BTFSC Y,6
    CALL print1
    
    BTFSS Y,5
    CALL print0
    BTFSC Y,5
    CALL print1
    
    BTFSS Y,4
    CALL print0
    BTFSC Y,4
    CALL print1    
    
    BTFSS Y,3
    CALL print0
    BTFSC Y,3
    CALL print1
    
    BTFSS Y,2
    CALL print0
    BTFSC Y,2
    CALL print1
    
    BTFSS Y,1
    CALL print0
    BTFSC Y,1
    CALL print1
    
    BTFSS Y,0
    CALL print0
    BTFSC Y,0
    CALL print1    
      
    MOVF X,0 ;mueves contenido del boton x el 1 a K
    MOVWF K
   MOVF Y,0 ;mueves contenido de boton 2 a w
   SUBWF K,1 ;K-W --- Se guarda en K
	
   BTFSS STATUS,Z ;preguntas si status z esta prendido, en0
   GOTO continua
   GOTO prendeled1; si status prende 
   GOTO INICIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;aqui va el codigo donde determina si es mayor, menor o igual ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
prendeled1
 CALL IGUAL    ;Prende el led que indica que son iguales K y Y
 BCF STATUS,Z ;apagas todo 
 BCF STATUS,C
 BCF STATUS,1
 GOTO INICIO
 
continua
 BTFSC STATUS,C	    ;pregunta si hay un cero en C
 GOTO continua2 ;no hay 0 
 GOTO prendeled2 ; si hay 0 en c 

prendeled2
CALL MENOR	    ;prende el led que indica que es menor el primer numero (i) que en W
 ;MOVLW d'0'
 ;MOVWF K
 GOTO INICIO
 
continua2
CALL MAYOR    ;prende el led que indica que es mayor el primer numero (i) que en W
 ;;;;;;;SE pone todo en ceros;;;;;
 BCF STATUS,Z
 BCF STATUS,C
 BCF STATUS,1
 ;MOVLW d'0'
 ;MOVWF K
 GOTO INICIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;aqui va el codigo donde imprimimos el signo;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAYOR
   BCF PORTC,0		;command mode
   CALL time
    
   MOVLW 0x8B		;LCD position
   MOVWF PORTD
   CALL exec

   BSF PORTC,0		;data mode
   CALL time
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;imprime el signo de mayor;;;;;;;;
   MOVLW  b'111110' ;mayor en asci 
   MOVWF PORTD
   CALL exec
   RETURN
   
 MENOR
   BCF PORTC,0		;command mode
   CALL time
    
   MOVLW 0x8B		;LCD position
   MOVWF PORTD
   CALL exec

   BSF PORTC,0		;data mode
   CALL time
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;imprime el signo de menor;;;;;;;;
   MOVLW b'111100' ;asci 60 en decimal
   MOVWF PORTD
   CALL exec
   RETURN
   
  IGUAL
   BCF PORTC,0		;command mode	;modo de instruccion
   CALL time
    
   MOVLW 0x8B		;LCD position	    -posicion en donde quieres que salga el signo-
   MOVWF PORTD
   CALL exec

   BSF PORTC,0		;data mode
   CALL time
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;imprime el signo de igual;;;;;;;;
   MOVLW b'00111101'       ;decimal = 61 equiv
   MOVWF PORTD
   CALL exec
   
   RETURN
     
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
print0
    MOVLW 0x30
    MOVWF PORTD
    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
    nop
    RETURN
    

print1
    MOVLW 0x31
    MOVWF PORTD
    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
    nop
    RETURN
    
    
    
exec

    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
    RETURN
    
time
    CLRF i
    MOVLW d'10'
    MOVWF j
ciclo    
    MOVLW d'80'
    MOVWF i
    DECFSZ i
    GOTO $-1
    DECFSZ j
    GOTO ciclo
    RETURN
    
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;;;;;;;;;;;;;;;BOTONES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
BTN1
    MOVF PORTA,0 ;mueves porta pos 0 a x y k
    MOVWF X
    MOVWF K
    ;MOVLW b'00000000' 
    ;MOVWF PORTA
RETURN

BTN2
    MOVF PORTA, 0
    MOVWF Y
    ;BSF STATUS,C ;C=1	------    si la resta da negativo, pondra en cero la C, el bit C = 0 ;si la resta da positiva, no le hara nada al bit C
   RETURN
    
			
    END