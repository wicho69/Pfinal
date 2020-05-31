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
GRAY equ 0x40 

START

    BANKSEL PORTA ;
    CLRF PORTA ;Init PORTA
    BANKSEL ANSEL ;
    CLRF ANSEL ;digital I/O
    CLRF ANSELH
    BANKSEL TRISA ;
    MOVLW d'255'
    MOVWF TRISA ;entrada 
    CLRF TRISB
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
    ;inicializa lcd 
    BCF PORTC,0	;reset 	;poner en ceros la pantalla	;modo comando
    MOVLW 0x01
    MOVWF PORTD
    
    BSF PORTC,1		;exec
    CALL time		;enable=1
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
    ;conversion a gray 
    MOVF PORTA,W ; del porta se manda a w y despues a gray
    MOVWF GRAY
    BCF STATUS,C ; se apaga bit carry del registro status.
    RRF GRAY ;rota 
    XORWF GRAY,F
    
    BCF PORTC,0		;datos mode=1	;modo de instrucciones=0
    CALL time
    
    MOVLW 0x80		;LCD position	;80 es en donde incia la primera linea del LCD ;0x80
    MOVWF PORTD
    CALL exec		;lo graba en el LCD poner en 1 bit de E
    
    BSF PORTC,0		;data mode
    CALL time
    
    MOVLW 'B'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'I'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'N'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'I'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'O'
    MOVWF PORTD
    CALL exec
    
    MOVLW ':'
    MOVWF PORTD
    CALL exec
    
    MOVLW ' '
    MOVWF PORTD
    CALL exec
    ;;;;;;;;
    BCF PORTC,0		;command mode	;modo de instruccion ; aqui esta en modo ins
    CALL time
    
    MOVLW 0x88		;LCD position	;te vas a la posicion que tu quieras del LCD
    MOVWF PORTD
    CALL exec
    
    BSF PORTC,0		;data mode
    CALL time
    ;;;;;;;;;;
    
    
   
    BTFSS PORTA,7 ; si ultima posicion tiene 1 
    CALL print0 ;sino
    BTFSC PORTA,7
    CALL print1
    
    BTFSS PORTA,6
    CALL print0
    BTFSC PORTA,6
    CALL print1
    
    BTFSS PORTA,5
    CALL print0
    BTFSC PORTA,5
    CALL print1
    
    BTFSS PORTA,4
    CALL print0
    BTFSC PORTA,4
    CALL print1
    
    BTFSS PORTA,3
    CALL print0
    BTFSC PORTA,3
    CALL print1
    
    BTFSS PORTA,2
    CALL print0
    BTFSC PORTA,2
    CALL print1
    
    BTFSS PORTA,1
    CALL print0
    BTFSC PORTA,1
    CALL print1
    
    BTFSS PORTA,0
    CALL print0
    BTFSC PORTA,0
    CALL print1
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    
    BCF PORTC,0		;command mode ;modo de instruccion
    CALL time
    
    MOVLW 0xC0		;LCD position	    ;C0, es en donde inicia el LCD, segunda linea
    MOVWF PORTD
    CALL exec

    BSF PORTC,0		;data mode
    CALL time
    
    
    MOVLW 'G'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'R'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTD
    CALL exec
   
    MOVLW 'Y'
    MOVWF PORTD
    CALL exec
    
    MOVLW ':'
    MOVWF PORTD
    CALL exec
   
    MOVLW ' '
    MOVWF PORTD
    CALL exec
   
      
    BCF PORTC,0		;command mode	;modo de instruccion
    CALL time
    
    MOVLW 0xC8		;LCD position
    MOVWF PORTD
    CALL exec ;prendes y apagas enable
    
    BSF PORTC,0		;data mode
    CALL time
    
    BTFSS GRAY,7
    CALL print0
    BTFSC GRAY,7
    CALL print1
    
    BTFSS GRAY,6
    CALL print0
    BTFSC GRAY,6
    CALL print1
    
    BTFSS GRAY,5
    CALL print0
    BTFSC GRAY,5
    CALL print1
    
    BTFSS GRAY,4
    CALL print0
    BTFSC GRAY,4
    CALL print1    
    
    BTFSS GRAY,3
    CALL print0
    BTFSC GRAY,3
    CALL print1
    
    BTFSS GRAY,2
    CALL print0
    BTFSC GRAY,2
    CALL print1
    
    BTFSS GRAY,1
    CALL print0
    BTFSC GRAY,1
    CALL print1
    
    BTFSS GRAY,0
    CALL print0
    BTFSC GRAY,0
    CALL print1    
      
    BCF PORTC,0		;command mode
    CALL time
    
    MOVLW 0x80		;LCD position
    MOVWF PORTD
    CALL exec
        
    GOTO INICIO


print0
    MOVLW 0x30 ;caracter 0 en asci
    MOVWF PORTD ;salida
    BSF PORTC,1		;exec e=1
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

    BSF PORTC,1		;exec	;enable=1
    CALL time
    BCF PORTC,1		;enable=0 se pone en 0 E
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
			
    END