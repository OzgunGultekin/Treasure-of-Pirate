# Treasure-of-Pirate

Created a MIPS-based game called "Treasure of Pirate," Main character is a pirate, endeavors to amass riches in his treasure trove. On the game screen, various items such as gold, diamonds, coconuts, and bombs will descend from the top. The aim  for the player to collect a specific quantity of gold or diamonds to win and complete the game. Coconuts can be collected to replenish the character's health. However, if the pirate comes into contact with a certain amount of bombs, the game ends with a "Game Over" message.

## MATERIALS

***MIPS:***

MIPS is a RISC architecture known for its simplicity, efficiency, and performance. It offers a streamlined instruction set and excels in integer arithmetic. MIPS processors have a pipeline structure for faster execution and lower power consumption. It is widely used in embedded systems and computer architecture education.

## DESIGN & TIMELINE

In this part, designed each element as matrices. Diamond, gold, coconut, bomb elements falling from above were designed as a 3x3 matrix. The pirate character was created from a 5x3 matrix. Assigned color codes for each pixel of these matrices. In this way, created the necessary character and elements.

In the project, we first performed the background painting part. Then we determined the positions and pixel numbers of our hijacker. We have done pixel painting of the pirate in the matrix. Later, we repeated this process that we performed on the character for the elements falling from the top to the bottom. After obtaining the necessary materials, we wrote the necessary functions to move the character. Then we adjusted the movement of the elements and the loss and gain of life that the character will suffer when they collide with the game character.

## GamePlay

In this game:

- Gold is worth +1 treasure
- Diamond is worth +2 treasure
- Bomb is worth -1 health
- Coconut is worth +1 health

The game is won and over when the character reaches 20 treasures. At the same time, if the character's health drops below zero, the game is lost and ends. When the game is won, "You win. You filled your treasure." message appears. When the game is lost, the text "You are out of life. You lost the game" appears on the console.

## Images from the game

![Ekran görüntüsü 2024-03-18 213533](https://github.com/OzgunGultekin/Treasure-of-Pirate/assets/153070257/aee3e6c8-9f5c-4e28-8c8c-22dbb5409820)

![Ekran görüntüsü 2024-03-18 213549](https://github.com/OzgunGultekin/Treasure-of-Pirate/assets/153070257/691d4eb4-e92b-47ba-b632-605c997a9967)


