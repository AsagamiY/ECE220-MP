;This programe is wrote to solve the machine problem 1 by Aslan Rimmen
        .ORIG x3000
; @SUBROUTINE PRINT_SLOT
PRINT_SLOT  

        ST R0,SAVE_R0
        ST R1,SAVE_R1
        ST R2,SAVE_R2
        ST R3,SAVE_R3
        ST R4,SAVE_R4
        ST R5,SAVE_R5
        ST R6,SAVE_R6
        ST R7,SAVE_R7

        LEA R0,TIMETABLE         ;GET R0 for output time(former part)    
        ADD R0,R1,R0
        ADD R0,R1,R0
        ADD R0,R1,R0            ;each time string contained 3 bits
        PUTS                    ;output time
        LEA R0,SUBT            
        PUTS                    ;output ":00" postfix   

        LD  R0,SAVE_R0
        LD  R1,SAVE_R1
        LD  R2,SAVE_R2
        LD  R3,SAVE_R3
        LD  R4,SAVE_R4
        LD  R5,SAVE_R5
        LD  R6,SAVE_R6
        LD  R7,SAVE_R7

        RET

; @SUBROUTINE   PRINT_CENTERED
PRINT_CENTERED

        ST R0,SAVE_R0
        ST R1,SAVE_R1
        ST R2,SAVE_R2
        ST R3,SAVE_R3
        ST R4,SAVE_R4
        ST R5,SAVE_R5
        ST R6,SAVE_R6
        ST R7,SAVE_R7

        AND R0,R0,#0     ;initialize for output
        ADD R3,R1,#0             ;R3 is used to search the string
        AND R2,R2,#0             ;R2 is used to count the length of the string

;loop of counting length start here
COUNT_LEN       
        LDR R4,R3,#0     ;test if the string is end
        BRz CROSSROAD            ;branch to next step
        ADD R3,R3,#1
        ADD R2,R2,#1
        BRnzp COUNT_LEN
;R2 stored the length of string

;determine if the length is longer than 6, if it is, cut it to 6.
CROSSROAD       
        ADD R5,R2,#0
        ADD R5,R5,#-6
        BRzp PROCES1
        BR OUTPUT_READY

;this is used to ensure that there is only 6 characters in the output
PROCES1         
        AND R2,R2,#0
        ADD R2,R2,#6    ;cut to 6

;get ready for output
OUTPUT_READY       
        AND R5,R5,#0            ;initialize R5 as a down counter (1)
        ADD R5,R5,#6            ;initialize R5 as a down counter
        LEA R3,LEADING_Z        ;get R3 for locating how many leading zeros are there
        ADD R3,R3,R2            ;R3 points to the addr of the numer of leading zeros
        LDR R4,R3,#0
        BRnz O_M                 ;branch to output main string

;loop to output leading 0s
O_LEAD           
        LEA R0,SPACE             ;output leading zeros
        PUTS
        ADD R5,R5,#-1            ;downcounter
        ADD R4,R4,#-1            ;downcounter-leading zeros
        BRnz O_M                 ;finish output leading 0s
        BR O_LEAD

;output main string
O_M      
        LDR R0,R1,#0
        BRz O_M_E                ;determine if the main string is finished
        OUT                      ;output one character once
        ADD R5,R5,#-1            ;continue the down counter
        BRnz SUB_END             ;if output is over (downcounter to 0)
        ADD R1,R1,#1             ;next character
        LDR R6,R1,#0
        BR O_M

O_M_E   LEA R3,POST_Z        ;get R3 for locating how many post zeros are there
        ADD R3,R3,R2
        LDR R4,R3,#0
        BRnz SUB_END                 ;branch to output main string if no post_0

;loop to output post 0s
O_POST  
        LEA R0,SPACE             ;output post zeros
        PUTS
        ADD R5,R5,#-1
        BRnz SUB_END
        ADD R4,R4,#-1
        BR O_POST

SUB_END        
        LD  R0,SAVE_R0
        LD  R1,SAVE_R1
        LD  R2,SAVE_R2
        LD  R3,SAVE_R3
        LD  R4,SAVE_R4
        LD  R5,SAVE_R5
        LD  R6,SAVE_R6
        LD  R7,SAVE_R7
        RET

;table for @PRINT_SLOT
SUBT    .STRINGZ ":00 "         ;This is intend to save space "5 x 15 = 75" with a postfix
TIMETABLE   .STRINGZ "07"       ;This is the table of times, did not use a look-up table for it is simpler 
            .STRINGZ "08"
            .STRINGZ "09"
            .STRINGZ "10"
            .STRINGZ "11"
            .STRINGZ "12"
            .STRINGZ "13"
            .STRINGZ "14"
            .STRINGZ "15"
            .STRINGZ "16"
            .STRINGZ "17"
            .STRINGZ "18"
            .STRINGZ "19"
            .STRINGZ "20"
            .STRINGZ "21"
            .STRINGZ "22"

;table for @PRINT_CENTERED
LEADING_Z       
        .FILL #3        ;This table stored the number of spaces for leading zeros
        .FILL #2        
        .FILL #2
        .FILL #1
        .FILL #1
        .FILL #0
        .FILL #0
;I find that using strings to save spaces for each condition have a problem in retrieval
;I did not want to use a look up table right now
;this table also used in the down couter to make sure that the length of the output string is 6 characters long
;below are the same
POST_Z          
        .FILL #3        ;This table stored the number of spaces for POSTFIX zeros
        .FILL #3        
        .FILL #2
        .FILL #2
        .FILL #1
        .FILL #1
        .FILL #0
SPACE   .STRINGZ " " 

;this is used to save value in the registers

SAVE_R0 .BLKW #1
SAVE_R1 .BLKW #1
SAVE_R2 .BLKW #1
SAVE_R3 .BLKW #1
SAVE_R4 .BLKW #1
SAVE_R5 .BLKW #1
SAVE_R6 .BLKW #1
SAVE_R7 .BLKW #1

.END

