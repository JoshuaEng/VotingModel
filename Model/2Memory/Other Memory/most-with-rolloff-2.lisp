; DM only includes 70% of the ballot with roll-off activations 
; intentionally abstains for last 30% of the ballot

(add-dm

;****************************************
;****************************************

;Abstain Chunks (abstain from these races)
; last 30% of the ballot

;****************************************
;****************************************

(districtattorney ISA Abstain contest "districtattorney")
(countytreasurer ISA Abstain contest "countytreasurer")
(sheriff ISA Abstain contest "sheriff")
(countytaxassessor ISA Abstain contest "countytaxassessor")
(justiceofthepeace ISA Abstain contest "justiceofthepeace")
(countyjudge ISA Abstain contest "countyjudge")


;****************************************
;****************************************

;Candidate Chunks

;****************************************
;****************************************

(GordonBearce ISA Candidate name "GordonBearce" party "Rep" race "PresidentoftheUnitedStates")
;;
(CoreyDery ISA Candidate name "CoreyDery" party "Ind" race "UnitedStatesSenator")
;;
(RobertMettler ISA Candidate name "RobertMettler" party "Dem" race "UnitedStatesRepresentativeDistrict7")
;;
(RickStickles ISA Candidate name "RickStickles" party "Dem" race "Governor")
;;
(CassiePrincipe ISA Candidate name "CassiePrincipe" party "Dem" race "LieutenantGovernor")
;;
(RickOrgan ISA Candidate name "RickOrgan" party "Dem" race "AttorneyGeneral")
;;
(ThereseGustin ISA Candidate name "theresegustin" party "Ind" race "comptrollerofpublicaccounts")
;;
(EliseEllzey ISA Candidate name "eliseellzey" party "Dem" race "commissionerofgenerallandoffice")
;;
(PollyRylander ISA Candidate name "pollyrylander" party "Rep" race "commissionerofagriculture")
;;
(JillianBalas ISA Candidate name "jillianbalas" party "Rep" race "railroadcommissioner")
;;
(WesleySteven-Millette ISA Candidate name "wesleystevenmillette" party "Dem" race "statesenator")
;;
(SusanneRael ISA Candidate name "susannerael" party "Dem" race "stateRepresentativedistrict134")
;;
(PeterVarga ISA Candidate name "petervarga" party "Rep" race "memberstateboardofeducationdistrict2")
;;
(TimGrasty ISA Candidate name "timgrasty" party "Dem" race "presidingjudgetexassupremecourtplace2")
;;
(Party ISA VoteParty default "Dem")

)

; Chunk base-level activations for Abstain
;; abstain from last 30%
(sdp districtattorney :base-level 2.0)
(sdp countytreasurer :base-level 2.0)
(sdp sheriff :base-level 2.0)
(sdp countytaxassessor :base-level 2.0)
(sdp justiceofthepeace :base-level 2.0)
(sdp countyjudge :base-level 2.0)

; Chunk base-level activations for intended candidates
(sdp GordonBearce :base-level .6)
(sdp CoreyDery :base-level .6)
(sdp RobertMettler :base-level .6)

(sdp RickStickles :base-level .5)
(sdp CassiePrincipe :base-level .5)
(sdp RickOrgan :base-level .5)
(sdp ThereseGustin :base-level .5)

(sdp EliseEllzey :base-level .4)
(sdp PollyRylander :base-level .4)
(sdp JillianBalas :base-level .4)
(sdp WesleySteven-Millette :base-level .4)

(sdp SusanneRael :base-level .3)
(sdp PeterVarga :base-level .3)
(sdp TimGrasty :base-level .3)
;(sdp DerrickMelgar :base-level .3)


; default party chunk
(sdp Vote :base-level .8)



