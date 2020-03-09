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
			BEQ		INIT			;Si es asi se salta a la etiqueta GO que inicia el programa para calcular numeros aleatorios
INIT
			
			;		Definicion de variables y direcciones para generar aleatorios
			MOV		R1, #118       ;Semilla (letra v de mi apellido) en decimal,
			MOV		R2, #19 		;Contador de numeros restantes
			MOV		R0, #0X500     ;Direccion de memoria donde se guardan numeros aleatorios
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
			
			;Empieza	el codigo de verificacion de numeros primos
			MOV		R11,#0X500 	;Direccion de lectura donde estan los numeros aleatorios
			MOV		R12,#0X700 	;Direccion de escritura donde se guardaran los valores primos
			MOV		R1,#0
			MOV		R3,#1
			MOV		R5,#0
			
VERIFICANDO
			
			CMP		R5,#19     	;Se verifica si ya se han completado los 20 numeros
			BEQ		FINISH		;Si ha finalizado salta a la bandera de FINISH
			LDR		R13,[R11]		;Carga en R13 el valor actual de aleatorio
			CMP		R13,#0		;Si es 0 salta al branch NOPRIMO
			BEQ		NOPRIMO
			CMP		R13,#1		;Si es 1 salta al branch NOPRIMO
			BEQ		NOPRIMO
			MOV		R0, R13	     ;Dato de entrada al  que se desea calcular si es primo o no
			MOV		R2, #2         ;Numero divisor inicial
MAIN
			BL		PREDIVISION    ;Branch and Link a la etiqueta PREDIVISION
			CMP		R8, #0         ;Compara el resultado de la resta con 0
			BEQ		PRIMO        	;SI es igual salta a etiqueta NOPRIMO
			ADD		R2, R2, #1     ;De lo contrario aumenta el divisor inicial en 1
			CMP		R2, R0         ;Compara el Divisor con el dato de entrada
			BEQ		NOPRIMO        ;Si son iguales salta a etiqueta PRIMO
			B		MAIN           ;SI no entonces repite la funcion principal
PREDIVISION
			MOV		R8, R0         ;Copiar dato porque se va a operar
			B		DIVISION
DIVISION
			SUB		R8, R8, R2     ;Division por restas consecutivas
			CMP		R8, R2         ;Compara si el resultado de la resta es 0
			BPL		DIVISION       ;Repite DIVISION si no es 0
			MOV		PC, LR         ;Retorna al compare de la funcion principal
			END
PRIMO
			STR		R1,[R12]       ;Si es primo almacena en R12 el valor de 1
			ADD		R12, R12, #4
			ADD		R11, R11, #4
			ADD		R5,R5,#1
			
			B		VERIFICANDO    ;Salta a etiqueta VERIFICANDO
NOPRIMO
			STR		R3,[R12]       ;Si no es primo almacena en R12 el valor de 0
			ADD		R12, R12, #4
			ADD		R11, R11, #4
			ADD		R5,R5,#1
			B		VERIFICANDO    ;Salta a etiqueta FINISH
FINISH
			END
