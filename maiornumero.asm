.text
la s0, VETOR	# Carrega o endereço do vetor no registrador s0
la s1, SIZE	# Carrega o endereço de SIZE no registrador s1
la s2, MAIOR	# Carrega o endereço do MAIOR no registrador s2
li t0, 0	# Armazena o valor imediato zero no registrador t0, servindo como contador para o vetor

li a7, 4
la a0, prompt
ecall	# Imprime o texto para digitar o tamanho do vetor

li a7, 5
la, a0, buffer
ecall	# Input para capturar tamanho do vetor
sw a0, 0(s1)

INPUT_VETOR:
li a7, 4
la a0, msg
ecall	# Imprime o texto para digitar os elementos do vetor

li a7, 5
la, a0, buffer
ecall	# Input para capturar elementos do vetor
slli t1, t0, 2	# Faz shift lógico de 2 bits em t0 e armazena em t1 (O valor de t0 será "multiplicado por 4(tamanho da palavra)" para percorrer o vetor)
add t2, t1, s0	# Adiciona o resultado do shift com o endereço do vetor (captura o endereço relativo dentro do vetor) e armazena em t2
sw a0, 0(t2)
addi t0, t0, 1 # Incrementa o contador
lw t5, 0(s1)	# Carrega a palavra contida na memória no endereço que está armazenado em s1(SIZE) para o registador t5
blt t0, t5, INPUT_VETOR	# Salta para INPUT_VETOR se ainda houver números a serem inseridos no vetor

li t0, 0	# Reinicia contador para percorrer novamnete o vetor
LOOP:
slli t1, t0, 2	# Faz shift lógico de 2 bits em t0 e armazena em t1 (O valor de t0 será "multiplicado por 4(tamanho da palavra)" para avançar o ponteiro do vetor)
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
li a7, 4	# Print string
la a0, res
ecall
li a7, 1	# Print int
lw a0, 0(s2)	# Imprime o maior número
ecall
li a7, 10	# Finaliza o programa armazenando o syscall 10(Exits the program with code 0) e chamando o ecall
ecall

.data
VETOR: .space 64 # Reservando 16 espaços para o vetor
SIZE: .word 0
MAIOR: .word 0
prompt: .asciz "Digite o tamanho do vetor: "
msg: .asciz "Digite o elemento do vetor: "
res: .asciz "O maior número é: "
buffer: .space 100	# Reserva 25 espaços para as entradas do usuário
