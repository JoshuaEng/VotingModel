;;;  -*- mode: LISP; Syntax: COMMON-LISP;  Base: 10 -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 
;;; Author      : Mike Byrne [and others]
;;; Copyright   : (c) 2016 Mike Byrne
;;; Address     : Department of Psychology 
;;;             : Rice University
;;;             : Houston, TX 77005
;;;             : byrne@rice.edu
;;; 
;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 
;;; Filename    : VG-Random-RetrieveParty-Party.lisp
;;; Version     : r1
;;; 
;;; Description : Model of voting on virtual VoteBox DRE.
;;;             : Performs a random search
;;;             : Uses a retrieve-based memory strategy to search candidates by party
;;;             : If initial retrieval fails, performs a random search by party
;;;            
;;; Bugs        : * None known
;;;
;;; To do       : * 
;;; ----- History -----
;;; 2019.1.31   Xianni Wang
;;;				: * updated screen learning code
;;;				: * removed clear-finsts production
;;; 2018.9.5    Xianni Wang
;;;				: * added defparameter and !eval! functions to log strategies for simulation
;;; 2018.5.19   Xianni Wang
;;;				: * added two more activation levels 
;;;				: * added candidate chunks and abstain chunks
;;; 2018.4.25   Xianni Wang
;;;				: * removed unnecessary imaginal buffers
;;; 2018.4.24   Xianni Wang
;;;				: * added Clear-Finsts production
;;; 2018.4.14   Xianni Wang
;;;				: * adjusted the format
;;; 2018.4.8 Xianni Wang
;;;				: * adapted file with studying model
;;; 2018.2.26 Xianni Wang
;;;				: * created file 
;;;				: * tested, model works!
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; General Docs:
;;;
;;; This model does a random search down the list of party until it finds the
;;; one that matches a name in memory.
;;;
;;;

;****************************************
;****************************************
;start to vote
;****************************************
;****************************************


;****************************************
;Put the visual location somewhere on the screen

(P Select-Choice_Locate-Contest-Description

=goal>
	ISA       MakeVote
	state     ready-to-make-choice
	

=imaginal>
	race-group  =val1
	
?visual-location>
	state     free

==>

=imaginal>

+visual-location>
	ISA       visual-location
	kind      text
	group     =val1

=goal>
	state     found-contest-description
	
!eval! (setf current-strat 'retrieval)

)

;****************************************
;Attend some visual location

(P Select-Choice_Attend-Contest-Description

=goal>
	ISA       MakeVote
	state     found-contest-description
	

=visual-location>
	ISA       visual-location
	kind      text
	group     =val1

?visual>
	state     free

==>

+visual>
	ISA          move-attention
	screen-pos   =visual-location

=goal>
	state     attended-contest-description

)

;****************************************
; the following two productions check if model should abstain from contest
(P check-contest

=goal>
	ISA       MakeVote
	state     attended-contest-description
	

=visual>
	ISA       text
	value     =textVal

?retrieval>
	state     free

=imaginal>

==>

+retrieval>
	ISA      Abstain
	contest  =textVal

=imaginal> ; encoding contest in imaginal buffer for a later check if it goes past end state
	ISA      MakeVote
	race     =textVal 

=goal>
	state    checking-contest

)

;****************************************
; Production that fires only if contest is one to abstain from

(P abstain

=goal>
	ISA     MakeVote
	state   checking-contest
	

=retrieval>
	ISA      Abstain
	contest  =this

==>

; sends to navigation production
=goal>
	ISA     MakeVote
	state   find-next-race
	

)

;****************************************

(P Select-Choice_Encode-Contest-Description

=goal>
	ISA       MakeVote
	state     checking-contest
	

?retrieval>
	buffer  failure

=imaginal>
	ISA    MakeVote
	race   =textVal

==>

=imaginal>

+retrieval>
	ISA     Candidate
	race    =textval  

=goal>
	state     encoded-contest-description

!output! ("Contest is: ~s" =textVal)
)

;****************************************
; Successful retrieval of candidate to vote for

(P Retrieval-Success

=goal> 
	ISA     MakeVote
	state   encoded-contest-description
	

=retrieval>
	ISA     Candidate
	race    =r
	party   =p
	
=imaginal>

==>

=retrieval>

=imaginal> ;moving the info in retrieval to imaginal buffer for later
	ISA      MakeVote
	race     =r
	party    =p

=goal>
	state   search-screen

!output! ("I'm voting for: ~s" =p)

)

;****************************************
;Read text randomly with no specific party in mind

(P Select-Choice_Search-Screen-Fastest

=goal>
	ISA     MakeVote
	state   search-screen
	

?visual-location>
	state   free

=imaginal>
	party-group  =val

==>

=imaginal>

+visual-location>
	ISA        visual-location
	kind       text
	group      =val
	:attended  nil

=goal>
	state    something-found

)

;****************************************
;Attend that party

(P Select-Choice_Attend-Search

=goal>
	ISA       MakeVote
	state     something-found
	

=visual-location>
	ISA       visual-location
	kind      text
	group     =val

?visual>
	state     free

==>

+visual>
	ISA          move-attention
	screen-pos   =visual-location

=goal>
	state      attending-something-found

)

;****************************************
;Search for that name in memory

(P Select-Choice_Encode-Search

=goal>
	ISA       MakeVote
	state     attending-something-found
	

=visual>
	ISA        text
	value      =val
	screen-pos =pos

?visual-location>
	state      free

==>

=visual>

=goal>
	state    encoded-search

!output! ("Looking at Party: ~s" =val)

)

;****************************************
;See if the name in the visual location matches
;any name in memory

(P Select-Choice_Imaginal-Match-Stop

=goal>
	ISA       MakeVote
	state     encoded-search
	

=imaginal>
	ISA      MakeVote
	party    =val

=visual> 
	ISA         text
	value       =val
	screen-pos  =pos

?visual-location>
	state     free

?manual>
	state     free

==>

=imaginal>

=visual>

+manual>
	ISA     move-cursor
	loc     =pos

=goal>
	state   moved-to-candidate

;!output! ("Matches party ~s"= val)

)

;****************************************

(P Select-Choice_Click-Candidate

=goal>
	ISA       MakeVote
	state     moved-to-candidate
	

?manual>
	state    free

==>

+manual>
	ISA    click-mouse

=goal>
	state     find-next-race
	

)

;****************************************
; don't match, search again
(P Select-Choice-No-Match

=goal>
	ISA       MakeVote
	state     encoded-search
	

?visual-location>
	state     free

==>

=goal>
	state    search-screen

)
;****************************************

; Productions that handle retrieval failure (i.e. when retrieval of candidate fails)
; VBP = Vote By Party

;****************************************
;; Model has read contest description but retrieval of candidate has failed

(P VBP-Retrieval-Fails

=goal>
	ISA     MakeVote
	state   encoded-contest-description
	

?retrieval>
	buffer   failure

==>

=goal>
	state   search-by-party

!output! ("Initial retrieval failure, voting by party")
!eval! (setf current-strat 'party)

)

;****************************************
;OR
; Initial retrieval worked but model looked at everything and retrieval match failed

(P VBP-Retrieval-Fails-after-searching

=goal>
	ISA 	MakeVote
	state 	something-found
	

?visual-location>
	buffer	failure 

==>

=goal>
	state	search-by-party

!output! ("Looked at everything and nothing retrieved-- voting by party")
!eval! (setf current-strat 'party)

)


;****************************************
;; restarts search from top

(P VBP-Select-Choice_Search-Screen-Fastest

=goal>
	ISA     MakeVote
	state   search-by-party
	

?retrieval>
	state   free

?visual-location>
	state   free

=imaginal>
	party-group  =val3

==>

=imaginal>

+visual-location>
	ISA        visual-location
	kind       text
	group      =val3
	:attended  nil
  
=goal>
	state    vbp-something-found
  
)

;****************************************
; looks at party
(P VBP-Select-Choice_Attend-Search

=goal>
	ISA     MakeVote
	state   vbp-something-found
	

=visual-location>
	ISA     visual-location
	kind    text
	group   =val3

?visual>
	state   free

==>

+visual>
	ISA         move-attention
	screen-pos  =visual-location

=goal>
	state     vbp-attending-something-found

)

;****************************************
; attended candidate matches our default party

(P VBP-Encode-Search-Match

=goal>
	ISA      MakeVote
	state    vbp-attending-something-found
	
	default  =party

=visual> 
	ISA         text
	value       =party
	screen-pos  =pos

?manual>
	state    free

==>

=visual>

+manual>
	ISA    move-cursor
	loc    =pos

=goal>
	state   moved-to-candidate

!output! ("Matches party ~s" =party)
)

;****************************************
; if default party and attended party don't match
(P VBP-No-Match-Next-Choice

=goal>
	ISA      MakeVote
	state    vbp-attending-something-found
	
	default  =party

=visual>
	ISA      text
	- value  =party
	value    =notparty

==>

=goal>
	state   search-by-party

!output! ("Party ~s does not match default" =notparty)
)

;****************************************

; if we reach bottom and nothing has been retrieved (no candidates match our default)
; abstain

(P VBP-bottom-of-list-fail

=goal>
	ISA     MakeVote
	state   vbp-something-found
	

?visual-location>
	buffer  failure

==>

=goal>
	state   find-next-race
	

!output! ("VBP reached bottom of list-- abstain from voting")
)


;Production Parameters
(spp Select-Choice_Imaginal-Match-Stop :u 1000)
(spp check-contest :u 1000)




