			MOV		R0, #0X300	;Se almacena en R0 la direccion de memoria 0x300 donde estara guardada la peticion
			MOV		R1, #0XF0		;Se almacena en R1 el valor de la peticion
			STR		R1, [R0]		;Se almacena en memoria la peticion
			LDR		R2, [R0]		;Se carga en registro de la peticion
			CMP		R2, #0XF0		;Se compara si la peticion ya fue echa
			BEQ		RESP			;Si es asi se salta a la etiqueta RESP
			
RESP
			MOV		R2, #0X304	;Se almaacena en R0 la direccion de memoria 0x304 donde estara guardada la respuesta
			MOV		R3, #0XFF		;Se almacena en R3 el valor 0xFF correspondiente a la respuesta
			STR		R3, [R2]		;Se almacena en memoria la respuesta
			LDR		R4, [R2]		;Se carga en registro la respuesta
			CMP		R4, #0XFF		;Se compara si la respuesta es igual a 0xFF
			BEQ		INIT			;Si es asi se salta a la etiqueta INIT que inicia el programa para calcular numeros aleatorios
INIT
			
			;		Definicion de variables y direcciones para generar aleatorios
			MOV		R1, #118       ;Semilla (letra v de mi apellido) en decimal,
			MOV		R2, #19 		;Contador de numeros restantes
			MOV		R0, #0X304     ;Direccion de memoria donde se guardan numeros aleatorios
			MOV		R9, #255		;Valor decimal para delimitar a 8 bits posteriormente
			
GEN
			AND		R8,R1,#128     ;Extraccion del bit 8 y su corrimiento
			LSR		R8,R8,#7
			
			AND		R6,R1,#32      ;Extraccion del bit 6 y su corrimiento
			LSR		R6,R6,#5
			
			AND		R5,R1,#16      ;Extraccion del bit 5 y su corrimiento
			LSR		R5,R5,#4
			
			AND		R4,R1,#8  	;Extraccion del bit 4 y su corrimiento
			LSR		R4,R4,#3
			
			EOR		R5,R5,R4		;Xor para obtener el bit medioaleatorio
			EOR		R6,R6,R5
			EOR		R8,R8,R6
			
			LSL		R8,R8,#31		;Integracion del nuevo bit al numero anterior
			LSR		R1,R1,#1
			ORR		R1,R1,R8
			
			AND		R1,R1,R9 		;Almacenamiento en memoria apartir de 0x200
			STR		R1, [R0]
			
			ADD		R0,R0,#4   	;Se actualiza la nueva direccion de memoria
			
			CMP		R2,#0		;Se verifica si ya se han completado los 20 numeros
			BEQ		FIN1
			SUB		r2,r2,#1
			B		GEN
			
FIN1   		;Finaliza la generacion de numeros aleatorios
			
			
			MOV		R0, #0X500	;En R0 esta la Direccion de memoria donde se almacenara el inicio de la cadena de caracteres
			;En		las siguientes lineas de codigo se almacenan los valores en decimal de cada
			;caracter	de la palabra Claude Shannon
			MOV		R1, #67 ;C
			MOV		R2, #108 ;l
			MOV		R3, #97 ;a
			MOV		R4, #117 ;u
			MOV		R5, #100 ;d
			STR		R1,[R0, #0]!
			STR		R2,[R0, #4]!
			STR		R3,[R0, #4]!
			STR		R4,[R0, #4]!
			STR		R5,[R0, #4]!
			MOV		R1, #101 ;e
			MOV		R2, #00 ;
			MOV		R3, #83 ;S
			MOV		R4, #104 ;h
			MOV		R5, #97 ;a
			STR		R1,[R0, #0]!
			STR		R2,[R0, #4]!
			STR		R3,[R0, #4]!
			STR		R4,[R0, #4]!
			STR		R5,[R0, #4]!
			MOV		R1, #110 ;n
			MOV		R2, #110 ;n
			MOV		R3, #111 ;o
			MOV		R4, #110 ;n
			
			STR		R1,[R0, #0]!
			STR		R2,[R0, #4]!
			STR		R3,[R0, #4]!
			STR		R4,[R0, #4]!
			
			MOV		R6,#23		;Se almacena en R6 el valor de 23d, utilizado para encriptar
			MOV		R9,#13		;Contador que determinara el final de la palabra
			MOV		R1, #0X620	;Espacio de memoria donde se guardaran los valores encriptados
			MOV		R13,#0X304	;Espacio de memoria donde inician los valores aleatorios almacenados
			MOV		R0, #0X500	;Espacio de memoria donde se encuentran los valores de los caracteres de Claude Shannon
ENCRIPTAR
			CMP		R9, #0		;Se compara si la longitud de la cadena es igual a 0
			BEQ		DESENCRIPTAR	;Si lo es entonces significa que ya se encripto toda la cadena y se salta a la etiqueta DESENCRIPTAR
			LDR		R4, [R0]		;Se carga el caracter ubicado en la direccion de memoria que contiene el registro R0
			ADD		R3, R4, #23	;Se almacena en R3 el resultado de la suma del caracter con 23d
			LDR		R6, [R13]		;Se carga el caracter ubicado en la direccion de memoria que contiene el registro R13
			
			EOR		R4, R3, R6	;Se almacena en R4 en resultado del xor entre El resultado de la suma anterior y la clave encriptada
			STR		R4, [R1]		;Se sobreescribe el dato de R4 producto del xor en la direccion de memoria que se encuentra en R1
			
			ADD		R0, R0, #4	;Se aumenta en 4 la posicion de memoria para continuar con el siguiente caracter
			ADD		R1, R1, #4	;Se aumenta en 4 la posicion de memoria para continuar con el siguiente caracter
			ADD		R13, R13, #4	;Se aumenta en 4 la posicion de memoria para continuar con el siguiente caracter
			
			SUB		R9, R9, #1	;Se disminuye en 1 la longitud de la cadena por que ya acabamos con un  caracter
			B		ENCRIPTAR		;Se repite el proceso en ENCRIPTAR
DESENCRIPTAR
			MOV		R11, #0X620 	;Direccion inicial de los valores encriptados
			MOV		R1,  #0X700	;Direccion donde se almaceran los valores desencriptados
			MOV		R2,  #0X304
			MOV		R0,  #13
			B		LOOP			;Salto al LOOP de Desencriptacion
LOOP
			CMP		R0, #0		;Se compara si la longitud de la cadena es igual a 0
			BEQ		FINISH		;Si lo es termina la ejecucion del programa porque ya se desencripto todos los caracteres
			LDR		R4, [R11]		;Se carga en R4 el caracter encriptado encriptada
			LDR		R5, [R2]
			EOR		R3, R4, R5	;Se aplica xor entre el caracter encriptado y la clave privada y se almacena en R3
			SUB		R4, R3, #23	;Se resta al valor en R3 el numero 19d
			STR		R4, [R1,#4]!	;Se almacena el resultado anterior en R4 con la direccion correspondiente de valores desencriptados
			SUB		R0, R0, #1	;Se disminuye en 1 la longitud de la cadena por que ya acabamos con un  caracter
			ADD		R11,R11,#4	;Se aumenta en 4 la posicion de memoria del caracter encriptado para continuar con el siguiente caracter
			ADD		R2,R2,#4		;Se aumenta en 4 la posicion de memoria del valor aleatorio
			B		LOOP			;Se repite el proceso del LOOP
FINISH							;Etiqueta que indica fin de la ejecucion del programa
			END		;FIN del programa
