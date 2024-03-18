#-------------------------------------------------------------------
#	PROJECT TITLE: Treasure of Pirate
#	
#	PROJECT MEMBERS: Ali Özgün Gültekin
#			 Büşra Bektaş
#			 Alaettin Ayberk Esen							
#--------------------------------------------------------------------
# Bitmap Display Configuration:                                     
# Width in pixels: 8  					
# Height in pixels: 8 
# Display width in pixels: 256 
# Display height in pixels: 512 
# Base Address: 0x10008000 ($gp)
#--------------------------------------------------------------------
# The aim of this game is to fill the treasury by collecting gold from above.
# If the bombs falling from above touch the character, the character will lose life.
# Coconuts can be collected to increase health. The game will be won after collecting a certain number of gold.
# If the health drops below 0, the game will be "Game Over".
#--------------------------------------------------------------------
# At game:
# "A" to go right
# "D" to go left
#You can use the keyboard keys.					   
#--------------------------------------------------------------------
#	Gold 1 Valuable
#       Diamond 2 Valuable
#	Bomb takes 1 life.
#       Coconat bring 1 health.
# 	Game End at 20 Valuable.
# 	If health is below 0, the game is over.				
#--------------------------------------------------------------------
.eqv BASE_ADDRESS 0x10008000

.eqv pirate_color $s1
.eqv pirate_pos $s2
.eqv health $s6
.eqv trasure $s7 

.eqv SLEEP 100

.data

win_text: .asciiz "You Win. You filled your treasure"
lose_text: .asciiz  "You're out of life. You lost the game." 
#PIRATE
pirate_colors: .word 0x000000, 0xF3D99B, 0xF3D99B, 0x994C00, 0xF3D99B, 0xF3D99B, 0x994C00, 0xF3D99B
pirate_coordinates: .word 0, 128, 252, 256, 260, 384, 508, 516   
pirate_pos: .word 7000

#GOLD
gold_color: .word 0xFFFF00, 0xFFFF00
gold_coordinates: .word 4,132
gold_pos: .word 0, 100,200, 300
#BOMB
bomb_colors: .word 0xFF0000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000
bomb_coordinates: .word 4,128,132,136,256,260,264
bomb_pos: .word 44

#DIAMOND
diamond_colors: .word 0xCCFFFF, 0xCCFFFF, 0xCCFFFF, 0xCCFFFF, 0xCCFFFF 
diamond_coordinates: .word 4,128,132,136,260
diamond_pos: .word 88

#COCONAT
coconat_colors: .word 0x663300, 0x663300, 0x663300, 0x663300, 0xFFFFFF, 0x663300,0x663300,0x663300,0x663300
coconat_coordinates: .word 0,4,8,128,132,136,256,260,264
coconat_pos: .word 56

.text

.globl main
main: 

	li 	pirate_pos, 7000	
	li 	health, 3
	li	trasure, 0		
			
game:
	li $t8, 0 
	li $t1, 8192
	li $t2, 0xFFCC00	
	
printBackGround:
	sw $t2, BASE_ADDRESS($t8) 
	addi $t8,$t8,4
bne $t8,$t1,printBackGround


jal keyboard_input
jal updating_gold 
jal updating_bomb
jal updating_diamond
jal updating_coconat

jal rendering_pirate
jal rendering_gold
jal rendering_bomb
jal rendering_diamond
jal rendering_coconat

	li $v0, 32 
	li $a0, SLEEP 
	syscall
	
beq $s7,20,game_win
beq $s6,0,game_over

j game
	
game_win:

			
		li $v0,	4
		la $a0, win_text
		syscall
		li $v0, 10
		syscall
		jr $ra
		
game_over:	
		
		li $v0,	4
		la $a0, lose_text
		syscall
		li $v0, 10	
		syscall
		jr $ra
updating_gold : 
	li $t9,12 

	update_next_gold:

		la $t0, gold_pos($t9) 
		lw $t0, 0($t0) 

			srl $t1, $t0,7 
			bgt $t1, 128, new_pos_gold
			 
			addi $t0, $t0, 256 
			j update_gold
		
		new_pos_gold:
			li $v0, 42 
			li $a0, 0
			li $a1, 3
			
			
			syscall
			beq $a0,0, zero_pos
			beq $a0,1, one_pos
			beq $a0,2, two_pos
			beq $a0,3, three_pos
		zero_pos:
			li $t0,0
			j update_gold
		one_pos:
			li $t0,100
			j update_gold
		two_pos:
			li $t0,200
			j update_gold
		three_pos:
			li $t0,300
			j update_gold
		update_gold:
			sw $t0,gold_pos($t9) 
	
	addi $t9,$t9,-4
	bgez $t9,update_next_gold
	
	jr $ra

rendering_gold:
	li $t9,12 

	render_next_gold:
	la $t1, gold_pos($t9)
	lw $t1, 0($t1) 
	addi $t1, $t1,BASE_ADDRESS 
	
	li $t8,4 
	render_gold:
	
		la $t5, gold_color
		add $t5, $t5, $t8 
		lw $t5, 0($t5)
	
		lw $t0, gold_coordinates($t8) 
		add $t0,$t0,$t1
	
		lw $t2, 0($t0)
	
		beq $t2, 0xF3D99B , gold_col_detected
		beq $t2, 0x000001 , gold_col_detected
		beq $t2, 0x994C00 , gold_col_detected
		
		j gold_col_end
	gold_col_detected:
		
		li $t2,0 
		sw $t2, gold_pos($t9)
		addi $s7, $s7, 1
		j gold_render_end 
	gold_col_end:
	
		sw $t5, 0($t0) 
		addi $t8,$t8,-4 
		bgez $t8, render_gold
	gold_render_end:

	addi $t9,$t9,-4
	bgez $t9,render_next_gold
	
	jr $ra
	
updating_bomb: 
	li $t9,0

	update_next_bomb:

		la $t0, bomb_pos($t9) 
		lw $t0, 0($t0) 

			srl $t1, $t0,7 
			bgt $t1, 128, new_pos_bomb
			 
			addi $t0, $t0, 256 
			j update_bomb
		
		new_pos_bomb:
			li $v0, 42 
			li $a0, 0
			li $a1, 3
			
			
			syscall
			beq $a0,0, zero_pos_bomb
			beq $a0,1, one_pos_bomb
			beq $a0,2, two_pos_bomb
			beq $a0,3, three_pos_bomb
		zero_pos_bomb:
			li $t0,4
			j update_bomb
		one_pos_bomb:
			li $t0,32
			j update_bomb
		two_pos_bomb:
			li $t0,72
			j update_bomb
		three_pos_bomb:
			li $t0,112
			j update_bomb
		update_bomb:
			sw $t0,bomb_pos($t9) 
	
	addi $t9,$t9,-4
	bgez $t9,update_next_bomb
	
	jr $ra

rendering_bomb:
	li $t9,0 
	
	render_next_bomb:
	la $t1, bomb_pos($t9)
	lw $t1, 0($t1) 
	addi $t1, $t1,BASE_ADDRESS 
	
	li $t8,24 
	render_bomb:
	
		la $t5, bomb_colors($t8)
		add $t5, $t5, $t8 
		lw $t5, 0($t5)
	
		lw $t0, bomb_coordinates($t8) 
		add $t0,$t0,$t1

		lw $t2, 0($t0)
	
		beq $t2, 0xF3D99B , bomb_col_detected
		beq $t2, 0x000001 , bomb_col_detected
		beq $t2, 0x994C00 , bomb_col_detected
		
		j bomb_col_end
	bomb_col_detected:
		
		li $t2,0 
		sw $t2, bomb_pos($t9)
		addi $s6, $s6, -1
		j bomb_render_end 
	bomb_col_end:
	
		sw $t5, 0($t0) 
		addi $t8,$t8,-4 
		bgez $t8, render_bomb
	bomb_render_end:

	addi $t9,$t9,-4
	bgez $t9,render_next_bomb
	
	jr $ra	
	
updating_diamond: 
	li $t9,0

	update_next_diamond:

		la $t0, diamond_pos($t9) 
		lw $t0, 0($t0) 

			srl $t1, $t0,7 
			bgt $t1, 128, new_pos_diamond
			 
			addi $t0, $t0, 256 
			j update_diamond
		
		new_pos_diamond:
			li $v0, 42 
			li $a0, 0
			li $a1, 3
			
			syscall
			beq $a0,0, zero_pos_diamond
			beq $a0,1, one_pos_diamond
			beq $a0,2, two_pos_diamond
			beq $a0,3, three_pos_diamond
		zero_pos_diamond:
			li $t0,8
			j update_diamond
		one_pos_diamond:
			li $t0,24
			j update_diamond
		two_pos_diamond:
			li $t0,60
			j update_diamond
		three_pos_diamond:
			li $t0,104
			j update_diamond
		update_diamond:
			sw $t0,diamond_pos($t9) 
	
	addi $t9,$t9,-4
	bgez $t9,update_next_diamond
	
	jr $ra

rendering_diamond:
	li $t9,0 
	
	render_next_diamond:
	la $t1, diamond_pos($t9)
	lw $t1, 0($t1) 
	addi $t1,$t1,BASE_ADDRESS 
	
	li $t8,16
	render_diamond:
	
		la $t5, diamond_colors
		add $t5, $t5, $t8 
		lw $t5, 0($t5)
	
		lw $t0, diamond_coordinates($t8) 
		add $t0,$t0,$t1

		lw $t2, 0($t0)
	
		beq $t2, 0xF3D99B , diamond_col_detected
		beq $t2, 0x000001 , diamond_col_detected
		beq $t2, 0x994C00 , diamond_col_detected
		
		j diamond_col_end
	diamond_col_detected:
		
		li $t2,0 
		sw $t2, diamond_pos($t9)
		addi $s7, $s7, 2
		j diamond_render_end 
	diamond_col_end:
	
		sw $t5, 0($t0) 
		addi $t8,$t8,-4 
		bgez $t8, render_diamond
	diamond_render_end:

	addi $t9,$t9,-4
	bgez $t9,render_next_diamond
	
	jr $ra	
	updating_coconat: 
	li $t9,0

	update_next_coconat:

		la $t0, coconat_pos($t9) 
		lw $t0, 0($t0) 

			srl $t1, $t0,7 
			bgt $t1, 128, new_pos_coconat
			 
			addi $t0, $t0, 256 
			j update_coconat
		
		new_pos_coconat:
			li $v0, 42 
			li $a0, 0
			li $a1, 3
			
			syscall
			beq $a0,0, zero_pos_coconat
			beq $a0,1, one_pos_coconat
			beq $a0,2, two_pos_coconat
			beq $a0,3, three_pos_coconat
		zero_pos_coconat:
			li $t0,12
			j update_coconat
		one_pos_coconat:
			li $t0,28
			j update_coconat
		two_pos_coconat:
			li $t0,68
			j update_coconat
		three_pos_coconat:
			li $t0,108
			j update_coconat
		update_coconat:
			sw $t0,coconat_pos($t9) 
	
	addi $t9,$t9,-4
	bgez $t9,update_next_coconat
	
	jr $ra

rendering_coconat:
	li $t9,0 
	
	render_next_coconat:
	la $t1, coconat_pos($t9)
	lw $t1, 0($t1) 
	addi $t1,$t1,BASE_ADDRESS 
	
	li $t8,32
	render_coconat:
	
		la $t5, coconat_colors
		add $t5, $t5, $t8 
		lw $t5, 0($t5)
	
		lw $t0, coconat_coordinates($t8) 
		add $t0,$t0,$t1

		lw $t2, 0($t0)
	
		beq $t2, 0xF3D99B , coconat_col_detected
		beq $t2, 0x000001 , coconat_col_detected
		beq $t2, 0x994C00 , coconat_col_detected
		
		j coconat_col_end
	coconat_col_detected:
		
		li $t2,0 
		sw $t2, coconat_pos($t9)
		addi $s6, $s6, 1
		j coconat_render_end 
	coconat_col_end:
	
		sw $t5, 0($t0) 
		addi $t8,$t8,-4 
		bgez $t8, render_coconat
	coconat_render_end:

	addi $t9,$t9,-4
	bgez $t9,render_next_coconat
	jr $ra	
	
keyboard_input: 

	li $t9, 0xffff0000 
	lw $t8, 0($t9) 
	bne $t8, 1,end

	lw $t0, 4($t9) 
	beq $t0, 97, pressed_a 
	beq $t0, 100, pressed_d
	j end
	pressed_a:			
		addi pirate_pos,pirate_pos,-4
		
		j end
		
	pressed_d: 
		addi pirate_pos,pirate_pos,4 
		
		j end
	end:
	jr $ra
	
rendering_pirate:

addi $t1, pirate_pos, BASE_ADDRESS

li $t0, 0x000001  
sw $t0, 0($t1)  
sw $t0, 508($t1)
sw $t0, 516($t1)

li $t2, 0xF3D99B 
sw $t2, 128($t1) 
sw $t2, 252($t1)
sw $t2, 260($t1)

li $t3, 0x994C00
sw $t3, 256($t1)
sw $t3, 384($t1)
jr $ra
