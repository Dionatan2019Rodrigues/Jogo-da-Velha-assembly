#*******************************************************************************
#
# Autor(es): Dionatan Rodrigues e Mateus Quadros
# e-mail: dionatanrodrigues351@gmail.com
# Descrição: 
#
#
#
#
#
#
#*******************************************************************************


#        1         2         3         4         5         6         7         8
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#           M     O                 #

.data
	tabuleiro: .asciiz "[   ]" #0
	user: .asciiz "[ O ]"	   #1
	cpu: .asciiz "[ X ]"	   #2
	enter: .asciiz  "\n"
	line: .asciiz  "Digite a linha: "
	column: .asciiz  "Digite a coluna: "
	jogadorVence: .asciiz  "|USUARIO VENCEU|"
	cpuVence: .asciiz  "|COMPUTADOR VENCEU|"
	empate: .asciiz  "|EMPATE| "
	
	
	mat:
 	  .align 2
 	  .space 36 #aloca 9 espacos no array
 	  
 	jogando: .space 4

.text
# *** Mapa de registradores ***
# $s0 <- 4
# $s1 <- 3
# $s2 <- 1
# $s3 <- 2
# $s7 <- condicional detecta fim


	main:
		sw $zero,jogando
		jal atribui_mat
		fam:
		
		while:
			jal input_jogada
			fij:
			
			#jal maquina_input
			#fmi:
		
			jal print_tabuleiro
			fpt:
			
			jal detecta_fim
			fdf:
		
		
		beq $s7,$zero,while
		
		bgt $s7,$s2,maqVence
			li $v0,4 #imprime user venceu
			la $a0, jogadorVence
			syscall
		maqVence:
		
	
	
	li $v0, 10
	syscall 
	
	atribui_mat:
		move $t0,$zero
		li $t1,36
		
		beq $t0,$t1, termina
			sw $zero,mat($t1)
			addi $t0,$t0,4
		termina:
	j fam
	
	detecta_fim:
		move $t0,$zero
		li $t1,36
		lw $t7,jogando
		
		for:
			beq $t0,$t1, finish
			#VITORIA EM LINHAS
			lw $t2,mat($t0)
			addi $t3,$t0,4
			lw $t4,mat($t3)
			addi $t5,$t0,8
			lw $t6,mat($t5)
			beq $t2,$zero,nada
			 bne $t2,$t4, nada
			  bne $t2,$t6, nada
			 	bne $t7,$zero,maqJoga
			 		move $s7,$s2 #USER JOGANDO
			 		j nada
			 	maqJoga:	
			 		li $s3,2
			 		move $s7,$s3 #maquina jogando
			 nada: 
			
			addi $t0,$t0,12
		j for
		finish:
		
		move $t0,$zero
		li $t1,12
		fore:
			beq $t0,$t1, finishe
			#VITORIA EM COLUNAS
			lw $t2,mat($t0)
			addi $t3,$t0,12
			lw $t4,mat($t3)
			addi $t5,$t0,24
			lw $t6,mat($t5)
			beq $t2,$zero,never
			 bne $t2,$t4, never
			  bne $t2,$t6, never
			 	bne $t7,$zero,maquiJoga
			 		move $s7,$s2 #USER JOGANDO
			 		j never
			 	maquiJoga:	
			 		li $s3,2
			 		move $s7,$s3 #maquina jogando
			 never: 
			
			addi $t0,$t0,4
		j fore
		finishe:
		
		#DIAGONAL PRINCIPAL 
		move $t0,$zero
		lw $t2,mat($t0)
		addi $t3,$t0,16
		lw $t4,mat($t3)
		addi $t5,$t0,32
		lw $t6,mat($t5)
		beq $t2,$zero,note
		 bne $t2,$t4, note
		  bne $t2,$t6, note
		   bne $t7,$zero,maquiTesta
			move $s7,$s2 #USER JOGANDO
			 j note
		   maquiTesta:	
			 li $s3,2
			 move $s7,$s3 #maquina jogando
		note: 
		
		#DIAGONAL SECUNDARIA 
		move $t0,$zero
		addi $t0,$t0,8
		lw $t2,mat($t0)
		addi $t3,$t0,8
		lw $t4,mat($t3)
		addi $t5,$t0,16
		lw $t6,mat($t5)
		beq $t2,$zero,n
		 bne $t2,$t4, n
		  bne $t2,$t6, n
		   bne $t7,$zero,maquiUlt
			move $s7,$s2 #USER JOGANDO
			j n
		   maquiUlt:	
			 li $s3,2
			 move $s7,$s3 #maquina jogando
		n: 
		
		
		
	j fdf
	
	#maquina_input:
	#	li $t1,2
	#	addi $t1,$t1,3
	#	lw $t0,mat($t1)
		
		
	#	bgt $t0,$zero,saiMeio
	#		sw $t1,mat($t1)		#atribui na iesima posicao 
	#	saiMeio:
		
		
	
	#j fmi
		
	input_jogada:
		li $s0,4
		
		volta:
			li $v0,4 #imprime digite linha
			la $a0, line
			syscall
			li $v0,5
			syscall
			move $t0,$v0 #linha esta em t0
		ble $t0,$zero, volta
	  	  bge $t0,$s0, volta
	
		volver:
			li $v0,4 #imprime digite coluna
			la $a0, column
			syscall
			li $v0,5
			syscall
			move $t1,$v0 #coluna esta em t1
		ble $t1,$zero, volver
		  bge $t1,$s0, volver
		  
		move  $a0,$t0 #LINHA
		move  $a1,$t1 #COLUNA
		jal iesima_posicao
		fip:	
		
		move $t9,$a2 # $t9 recebe iesiema posicao
		lw $t7,mat($t9)
		move $t8,$t7 #recebe valor na iesima posicao
		
		bgt $t8,$zero,volta
			sw $s2,mat($t9)		#atribui na iesima posicao 
		
			
	j fij
		

	iesima_posicao:
		
		move $t1,$a0 #linha
		move $t3,$a1 #coluna
		li $s1, 3    #numero total de colunas
		li $s2, 1    #valor indicado para (jogadaUser)[O]
		
		#formula iesima posicao do vetorMatriz m[(TotalColunas*(linha-1))+coluna]
		subi $t6,$t1,1	        #(linha-1)
		mul $t4,$s1,$t6		#(TotalColunas*(linha-1))
			
		add $t5,$t4,$t3		#(TotalColunas*(linha-1))+coluna
		subi $t7,$t5,1		#-1 porque user digita coluna 1 em vez de 0
		mul $t2,$s0,$t7		#multiplica * 4 porque inteiro ocupa 4 bytes
		
		move $a2,$t2		#return ieseima posicao
	 j fip
		
	print_tabuleiro:
		move $t0, $zero
		li $t2, 36
		move $t6, $zero #contador quebra de linha
		li $t4, 3	#parada do contador
		
	
		loope:
		beq $t0,$t2, saiDoLoope
			
			lw $t3,mat($t0)
			bne $t3,$zero, continue #posicao tabuleiro vazia
				li $v0,4
				la $a0,tabuleiro
				syscall 
			continue:
			bne $t3,1, siga		#jogada usuario
				li $v0,4
				la $a0,user
				syscall 
			siga:
			bne $t3,2, frente	#jogada maquina
				li $v0,4
				la $a0,cpu
				syscall 
			frente:
			addi $t6,$t6,1
			bne $t6,$t4, vamos	#quebra de linha do tabuleiro
				move $t6, $zero
				li $v0,4
				la $a0,enter
				syscall 
			vamos:
			addi $t0,$t0,4
			j loope 
		saiDoLoope:
	j fpt
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
