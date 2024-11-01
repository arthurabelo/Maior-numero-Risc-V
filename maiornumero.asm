.text
la s0, VETOR	# Carrega o endereço do vetor no registrador s0
la s1, SIZE	# Carrega o endereço de SIZE no registrador s1
la s2, MAIOR	# Carrega o endereço do MAIOR no registrador s2
li t0, 0	# Armazena o valor imediato zero o registrador t0, servindo como contador para o vetor

LOOP:
slli t1, t0, 2	# Faz shift lógico de 2 bits em t0 e armazena em t1 (O valor de t0 será "multiplicado por 4(tamanho da palavra)" para percorrer o vetor)
add t2, t1, s0	# Adiciona o resultado do shift com o endereço do vetor (captura o endereço relativo dentro do vetor) e armazena em t2
lw t3, 0(t2)	# Carrega o valor armazenado na memória no endereço contido em t2 em t3
lw t4, 0(s2)	# Carrega a palavra armazenada no endereço contido em s2 em t4
blt t4, t3, UPDATE_BIGGER	# Salta para UPDATE_BIGGER se o valor em t4(atual maior valor) for menor que o valor testado
jal INCREMENT_CHECK	# Chama a subrotina para incrementar o contador e verificar o maior valor e armazena o endereço de retorno

UPDATE_BIGGER:
sw t3, 0(s2) # Atualiza o maior na memoria
jal INCREMENT_CHECK	# Chama a subrotina para incrementar o contador e verificar o maior valor e armazena o endereço de retorno no registrador ra

INCREMENT_CHECK:
addi t0, t0, 1 # Incrementa o contador
lw t5, 0(s1)	# Carrega a palavra contida na memória no endereço que está armazenado em s1(SIZE) para o registador t5
blt t0, t5, LOOP	# Salta para LOOP se o "índice atual no vetor" for menor que SIZE, continuando a execução
li a7, 10	# Caso contrário, finaliza o programa armazenando o syscall 10(Exits the program with code 0) e chamando o ecall
ecall

.data
VETOR: .word 1, 3, 2
SIZE: .word 3
MAIOR: .word 0
