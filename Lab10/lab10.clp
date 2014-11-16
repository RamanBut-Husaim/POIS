;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
		  
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then TRUE 
       else FALSE))

(deffunction ask-for-an-age (?question ?min-value ?max-value)
	(printout t ?question)
	(bind ?answer (read))
	(while (not (integerp ?answer)) do
		(printout t ?question)
		(bind ?answer (read)))
	(if (not (and (> ?answer ?min-value) (< ?answer ?max-value)))
		then 
			(printout t "The age is invalid" crlf)
			(reset))
	?answer)

;; ---------------- RULES FOR TRAINING ----------------------------------------
	
(defrule specify-the-age "Determines the person age"
    (system start)
	=>
	(bind ?response (ask-for-an-age "What is your age? (16-80)" 16 80))
	(assert (age ?response)))

(defrule specify-the-sex "Determines the person sex"
	(system start)
	=>
	(bind ?response (ask-question "What is your sex? (male/female)" male female))
	(assert (the person sex is ?response)))

(defrule specify-the-place-type "Determines the place type"
	(system start)
	=>
	(bind ?response (ask-question "Where do you want to listen to music? (home/road/work/party)" home road work party))
	(assert (the place is ?response)))

(defrule specify-the-vocal-type "Determines the vocal type"
	(system start)
	=>
	(bind ?response (ask-question "What vocal type do you prefer? (operatic/usual/growling)" operatic usual growling))
	(assert (the vocal type is ?response)))	
	
;; ----------------------------------------------------------------------------

;; ----------------- AGE CATEGORY ---------------------------------------------

(defrule age-category-male-old "Male Old"
	(age ?age)
	(the person sex is male)
	=> 
	(if (>= ?age 60)
		then (assert (the age category is old))))

(defrule age-category-female-old "Female Old"
	(age ?age)
	(the person sex is female)
	=> 
	(if (>= ?age 55)
		then (assert (the age category is old))))

(defrule age-category-male-middle "Male middle-aged"
	(age ?age)
	(the person sex is male)
	=>
	(if (and (>= ?age 30) (< ?age 60))
		then (assert (the age category is middle))))

(defrule age-category-female-middle "Female middle-aged"
	(age ?age)
	(the person sex is female)
	=>
	(if (and (>= ?age 25) (< ?age 55))
		then (assert (the age category is middle))))

(defrule age-category-male-young "Male young"
	(age ?age)
	(the person sex is male)
	=> 
	(if (< ?age 30)
		then (assert (the age category is young))))

(defrule age-category-female-young "Female young"
	(age ?age)
	(the person sex is female)
	=> 
	(if (< ?age 25)
		then (assert (the age category is young))))

;; -----------------------------------------------------------------------------

;; -------------------------------------- MELODY -------------------------------
(defrule melody-ultrahigh-female "ULTRA-HIGH female"
	(the person sex is female)
	(the place is home)
	(or (the vocal type is operatic) (the vocal type is usual))
	=> 
	(assert (the melody is ultra-high)))

(defrule melody-ultrahigh-male "ULTRA-HIGH male"
	(the person sex is male)
	(the place is home)
	(the vocal type is operatic)
	=> 
	(assert (the melody is ultra-high)))
	
(defrule melody-high-female "HIGH female"
	(the person sex is female)
	(the place is work)
	(or (the vocal type is operatic) (the vocal type is usual))
	=> 
	(assert (the melody is high)))

(defrule melody-high-male "HIGH male"
	(the person sex is male)
	(the place is work)
	(the vocal type is operatic)
	=> 
	(assert (the melody is high)))
	
(defrule melody-medium-male-work "MEDIUM male"
	(the person sex is male)
	(the place is work)
	(the vocal type is usual)
	=> 
	(assert (the melody is medium)))

(defrule melody-medium-male-road "MEDIUM male"
	(the person sex is male)
	(the place is road)
	(or (the vocal type is operatic) (the vocal type is usual) (the vocal type is growling))
	=> 
	(assert (the melody is medium)))

(defrule melody-medium-female "MEDIUM female"
	(the person sex is female)
	(the place is road)
	(or (the vocal type is operatic) (the vocal type is usual))
	=> 
	(assert (the melody is medium)))
	
(defrule melody-low-home "LOW Home"
	(the place is home)
	(the vocal type is growling)
	=>
	(assert (the melody is low)))

(defrule melody-low-work "LOW Work"
	(the place is work)
	(the vocal type is growling)
	=>
	(assert (the melody is low)))

(defrule melody-low-party "LOW Party"
	(the place is party)
	=>
	(assert (the melody is low)))

(defrule melody-low-female "LOW female"
	(the place is road)
	(the person sex is female)
	(the vocal type is growling)
	=>
	(assert (the melody is low)))
	
;; -----------------------------------------------------------------------------

;; ----------------------CONCENTRATION------------------------------------------
(defrule concentration-high-old "HIGH old"
	(the age category is old)
	(or (the place is home) (the place is work))
	=>
	(assert (the concentration is high)))

(defrule concentration-high-home "HIGH home"
	(or (the age category is middle) (the age category is young))
	(the place is home)
	=>
	(assert (the concentration is high)))

(defrule concentration-medium-old "MEDIUM old"
	(the age category is old)
	(or (the place is road))
	=>
	(assert (the concentration is medium)))

(defrule concentration-medium-middle "MEDIUM middle-aged"
	(the age category is middle)
	(or (the place is road) (the place is work))
	=>
	(assert (the concentration is medium)))
	
(defrule concentration-medium-young "MEDIUM young"
	(the age category is young)
	(the place is work)
	=>
	(assert (the concentration is medium)))

(defrule concentration-low-old "LOW old"
	(the age category is old)
	(the place is party)
	=>
	(assert (the concentration is low)))
	
(defrule concentration-low-middle "LOW middle-aged"
	(the age category is middle)
	(the place is party)
	=>
	(assert (the concentration is low)))
	
(defrule concentration-low-young "LOW young"
	(the age category is young)
	(or (the place is party) (the place is road))
	=>
	(assert (the concentration is low)))

;; -----------------------------------------------------------------------------

;; ----------------------------------GENRE--------------------------------------

(defrule genre-classical "Classical music"
	(the melody is ultra-high)
	(the concentration is high)
	=>
	(assert (the genre is classical)))

(defrule genre-new-age "New age"
	(or (the melody is ultra-high) (the melody is high))
	(the concentration is high)
	=>
	(assert (the genre is new-age)))

(defrule genre-hard-rock-1 "Hard rock"
	(the melody is high)
	(or (the concentration is high) (the concentration is medium))
	=>
	(assert (the genre is hard-rock)))

(defrule genre-hard-rock-2 "Hard rock"
	(the melody is medium)
	(the concentration is medium)
	=>
	(assert (the genre is hard-rock)))
	
(defrule genre-heavy-metal "Heavy metal"
	(or (the melody is high) (the melody is medium))
	(the concentration is medium)
	=>
	(assert (the genre is heavy-metal)))
	
(defrule genre-progressive-metal "Progressive metal"
	(the melody is ultra-high)
	(or (the concentration is medium) (the concentration is high))
	=>
	(assert (the genre is progressive-metal)))

(defrule genre-symphonic-metal "Symphonic metal"
	(or (the melody is ultra-high) (the melody is high))
	(the concentration is medium)
	=>
	(assert (the genre is symphonic-metal)))

(defrule genre-thrash-metal "Thrash metal"
	(or (the melody is high) (the melody is low) (the melody is medium))
	(the concentration is low)
	=>
	(assert (the genre is thrash-metal)))

(defrule genre-death-metal "Death metal"
	(the melody is low)
	(the concentration is low)
	=>
	(assert (the genre is death-metal)))
	
(defrule genre-folk-metal "Folk metal"
	(or (the melody is high) (the melody is ultra-high))
	(or (the concentration is low) (the concentration is medium))
	=>
	(assert (the genre is folk-metal)))
	
;; -----------------------------------------------------------------------------

;; ---------------------------MUSICIAN------------------------------------------

(defrule musician-wagner "Wagner"
	(the genre is classical)
	=>
	(printout t "It will be great for you to listen to Wagner (classical)" crlf)
	(assert (the musician is Wagner)))

(defrule musician-chaikovsky "Chaikovsky"
	(the genre is classical)
	=>
	(printout t "It will be great for you to listen to Chaikovsky (classical)" crlf)
	(assert (the musician is Chaikovsky)))
	
(defrule musician-kitaro "Kitaro"
	(the genre is new-age)
	=>
	(printout t "It will be great for you to listen to Kitaro (New Age)" crlf)
	(assert (the musician is Kitaro)))

(defrule musician-enya "Enya"
	(the genre is new-age)
	=>
	(printout t "It will be great for you to listen to Enya (New Age)" crlf)
	(assert (the musician is Enya)))
	
(defrule musician-ac-dc "AC/DC"
	(the genre is hard-rock)
	=>
	(printout t "It will be great for you to listen to AC/DC (Hard Rock)" crlf)
	(assert (the musician is AC-DC)))
	
(defrule musician-guns-n-roses "Guns'n'Roses"
	(or (the genre is hard-rock) (the genre is heavy-metal))
	=>
	(printout t "It will be great for you to listen to Guns'n'Roses (Hard Rock/Heavy Metal)" crlf)
	(assert (the musician is Guns-N-Roses)))

(defrule musician-iron-maiden "Iron Maiden"
	(the genre is heavy-metal)
	=>
	(printout t "It will be great for you to listen to Iron Maiden (Heavy Metal)" crlf)
	(assert (the musician is Iron-Maiden)))
	
(defrule musician-judas-priest "Judas Priest"
	(or (the genre is heavy-metal) (the genre is hard-rock))
	=>
	(printout t "It will be great for you to listen to Judas Priest (Heavy Metal/Hard Rock)" crlf)
	(assert (the musician is Judas-Priest)))
	
(defrule musician-royal-hunt "Royal Hunt"
	(or (the genre is progressive-metal) (the genre is hard-rock))
	=>
	(printout t "It will be great for you to listen to Royal Hunt (Progressive Metal/Hard Rock)" crlf)
	(assert (the musician is Royal-Hunt)))

(defrule musician-ayreon "Ayreon"
	(the genre is progressive-metal)
	=>
	(printout t "It will be great for you to listen to Ayreon (Progressive Metal)" crlf)
	(assert (the musician is Ayreon)))

(defrule musician-anthrax "Anthrax"
	(the genre is thrash-metal)
	=>
	(printout t "It will be great for you to listen to Anthrax (Thrash Metal)" crlf)
	(assert (the musician is Anthrax)))
	
(defrule musician-kreator "Kreator"
	(the genre is thrash-metal)
	=>
	(printout t "It will be great for you to listen to Kreator (Thrash Metal)" crlf)
	(assert (the musician is Kreator)))

(defrule musician-dark-tranquillity "Dark Tranquillity"
	(the genre is death-metal)
	=>
	(printout t "It will be great for you to listen to Dark Tranquillity (Melodic Death Metal)" crlf)
	(assert (the musician is Dark-Tranquillity)))

(defrule musician-insomnium "Insomnium"
	(the genre is death-metal)
	=>
	(printout t "It will be great for you to listen to Insomnium (Melodic Death Metal)" crlf)
	(assert (the musician is Insomnium)))
	
(defrule musician-therion "Therion"
	(the genre is symphonic-metal)
	=>
	(printout t "It will be great for you to listen to Therion (Symphonic Metal)" crlf)
	(assert (the musician is Therion)))
	
(defrule musician-nightwish "Nightwish"
	(the genre is symphonic-metal)
	=>
	(printout t "It will be great for you to listen to Nightwish (Symphonic Metal)" crlf)
	(assert (the musician is Nightwish)))
	
(defrule musician-korpiklaani "Korpiklaani"
	(the genre is folk-metal)
	=>
	(printout t "It will be great for you to listen to Korpiklaani (Folk Metal)" crlf)
	(assert (the musician is Korpiklaani)))
	
(defrule musician-in-extremo "In Extremo"
	(the genre is folk-metal)
	=>
	(printout t "It will be great for you to listen to In Extremo (Folk Metal)" crlf)
	(assert (the musician is In-Extremo)))

;; -----------------------------------------------------------------------------
	
(defrule start-the-program
	=>
	(printout t "--------------------------" crlf)
	(printout t "Music for the trip program" crlf)
	(printout t "--------------------------" crlf)
	(assert (system start)))