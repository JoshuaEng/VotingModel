; Assumes verticles are exactly lined up

; Makes a visual location request for the first race
(P Find-First-Race

=goal>
	state			start-voting
	
==>

+visual-location>
	ISA			visual-location
	kind		text
	color		red
	screen-left lowest
	screen-y	lowest
	
	
=goal>
	state		attending-race-next-row
;	direction	right
)


; Deals with already voted entrance (basically don't do anything)
(P Deal-With-Already-Voted

=goal> 
	state			already-voted

==>

=goal> 
	state			find-next-race
)


; ------------------- These next productions find the race header and request a race in the same row



; Makes a visual location request for the race title
(P Find-Race-Title

=goal>
	state		find-next-race
	
=imaginal>
	race-group	=race-group
	
==>

+visual-location>
	ISA			visual-location
	kind		text
	group		=race-group
	
=imaginal>
	
=goal>
	state		attending-race-title

)

; Attend the race title
(P Attend-Race-Title

=goal>
	state		attending-race-title
	
=visual-location>
	ISA			visual-location	
	kind		text
	
?visual>
	state		free

==>

+visual>
	ISA			move-attention
	screen-pos	=visual-location
	
=visual-location>
	
=goal>
	state		find-race-same-row
	
)


; Makes a visual location request for the race header that is to the right, and nearest to this race header
(P Find-Race-Same-Row-Right

=goal>
	state		find-race-same-row
	direction	right
	
=visual>

=visual-location>
	screen-right	=current-right

=imaginal>
	
==>

+visual-location>
	ISA				visual-location
	kind			text
	color			red
	> screen-left	=current-right
;	> screen-bottom	=current-top
	screen-left		lowest
	:nearest		current-y
	
=imaginal>
	
=goal>
	state		attending-race-same-row

)

; Makes a visual location request for the race header that is to the left, and nearest to this race header
(P Find-Race-Same-Row-Right

=goal>
	state		find-race-same-row
	direction	left
	
=visual>

=visual-location>
	screen-right	=current-right

=imaginal>
	
==>

+visual-location>
	ISA				visual-location
	kind			text
	color			red
	< screen-left	=current-right
;	> screen-bottom	=current-top
	screen-left		greatest
	:nearest		current-y
	
=imaginal>
	
=goal>
	state		attending-race-same-row

)


;-------------------------------- These next productions either pass control to encoding if a race is found or move to the next row

; ; This production being called means that we have reached the end of a row, so we begin the process of finding the top race in the next row
(P Find-Race-Same-Row-No-Match

=goal>
	state		attending-race-same-row	
	
?visual-location>
	buffer		failure
	
==>

=goal>
	state		find-left-race

)

; ; We have found the next race within this row and so we pass control to encoding process
(P Attend-Race-Same-Row

=goal>
	state		attending-race-same-row	
		
=visual-location>
	ISA			visual-location
	kind		text

?visual>
	state		free
	
?imaginal>
	state		free
	
==>

+imaginal>
	race-group		none
	candidate-group	none
	party-group		none
	first-race-col	nil


+visual>
	ISA			move-attention
	screen-pos	=visual-location
	
=visual-location>

=goal>
	state		storing-race-group

)



(P Find-Left-Race

=goal>
	state		find-left-race

==>

+visual-location>
	ISA			visual-location
	screen-left	lowest
	color 		red
	<= screen-y	current
	screen-y	highest

=goal>
	state		attending-left-race

)



(P Attend-Left-Race

=goal>
	state		attending-left-race
	
=visual-location>
	ISA			visual-location	
	kind		text
	
?visual>
	state		free

==>

+visual>
	ISA			move-attention
	screen-pos	=visual-location
	
=goal>
	state		find-race-next-row
	
=visual-location>
	
)


; ;****************************************
; ; This production makes the visual location request for the leftmost race in the next row down
(P Find-Race-Next-Row

=goal>
	state 		find-race-next-row
	
=visual>

=visual-location>
	screen-left	=current-left

==>

; Order is very important here
+visual-location>
	ISA			visual-location
	kind		text
	= screen-left	=current-left
	> screen-y	current
	screen-y	lowest
	color		red
	
=goal>
	state		attending-race-next-row

)	


; ;****************************************
; ; We have found a race in the next row, so attend it and start encoding
(P Attend-Race-Next-Row

=goal>
	state		attending-race-next-row
	
?imaginal>
	state		free
	
?visual>
	state		free

=visual-location>
	ISA			visual-location	
	kind		text


==>

+imaginal>
	race-group		none
	candidate-group	none
	party-group		none
	first-race-col	true

+visual>
	ISA			move-attention
	screen-pos	=visual-location
	
=visual-location>
	ISA			visual-location	
	kind		text
	
=goal>
	state		storing-race-group
	anchor		=visual-location
	
)



; ;****************************************
; ; If there is nothing found when looking for a new row, we are at the bottom right corner of the ballet and there are no more races, 
; ; so we can end the mode
(P Find-Race-Next-Row-No-Match

=goal>
	state			attending-race-next-row

?visual-location>
	buffer			failure
		
==>

=goal>
	state  			end
	
)
