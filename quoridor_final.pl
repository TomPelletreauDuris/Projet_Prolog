%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Faits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

joueur_suivant(1, 2).
joueur_suivant(2, 1).

marqueJoueurInverse(1, 2).
marqueJoueurInverse(2, 1).

symbole(-2,'X').
symbole(-1,'_').
symbole(0,' ').
symbole(1,'1').
symbole(2,'2').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Programme principal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%.......................................
% début du jeu
%.......................................

% initialiser le plateau de départ
% (assert fait en gros conmme si on ajoutait une nouvelle instance à une DB)
initialiser :-
	asserta(plateau([[ 0,-1, 0,-1, 0,-1, 0,-1, 2,-1, 0,-1, 0,-1, 0,-1, 0],
					 [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
					 [ 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0],
					 [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
					 [ 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0],
					 [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
					 [ 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0],
					 [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
					 [ 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0],
					 [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
					 [ 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0],
					 [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
					 [ 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0],
					 [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
					 [ 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0,-1, 0],
					 [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],		 
					 [ 0,-1, 0,-1, 0,-1, 0,-1, 1,-1, 0,-1, 0,-1, 0,-1, 0]])),
	asserta(compteur1(1)),
	asserta(compteur2(1)).
	
% démarrer le jeu
run :-
	initialiser,
	jouer(1). % le joueur 1 joue en 1er
	
	
%.......................................	
% maj_compteur
%.......................................
% met à jour le compteur qui compte le nombre de murs placés

	
maj_compteur(1):-
	compteur1(A),
	B is A-1,
	asserta(compteur1(B)).


maj_compteur(2):-
	compteur2(A),
	B is A-1,
	asserta(compteur2(B)).
	


%.......................................	
% verif_compteur
%.......................................
% empêche de poser un mur si le compteur descend à 0. Ne fonctionne pas


verif_compteur(1):-
	compteur1(A),
	B is A,
	B>0.

verif_compteur(1):-
	compteur1(A),
	B is A,
	B=<0,
	write('Nombre de mur maximal déjà posé. Jouez plutôt votre pion.'),
	jouer(J).

verif_compteur(2):-
	compteur2(A),
	B is A,
	B>0.
	
verif_compteur(2):-
	compteur2(A),
	B is A,
	B=<0,
	write('Nombre de mur maximal déjà posé. Jouez plutôt votre pion.'),
	jouer(J).
	
	
%.......................................	
% jouer
%.......................................

jouer(J) :-
	plateau(P),
	not(gameOver(J, P)), % si le joueur J n'a pas encore perdu
	joueur_suivant(J, J2), % on change de joueur
	not(gameOver(J2,P)), % si l''adversaire n'a pas encore perdu non plus 
	afficherPlateau(P),
	format("Le joueur ~d joue",J),nl,
	%output_plateau(P),
	choisir_coup(P, C, J).
	%jouer(J2).
	
% à la fin du tour, on repart pour un tour avec l'autre joueur


%.......................................
% choisir_coup
%.......................................

choisir_coup(P,C,J) :-
	write('voulez-vous jouer un pion (ecrivez p) ou un mur (ecrivez m) ?'),
	read(C),
	jouer_coup(P,C,J,P2).
	


%.......................................
% jouer_coup
%.......................................
% applique le coup du joueur J pour le plateau P
% retourne le nouveau plateau dans P2

jouer_coup(P, m, J, P2) :-
	jouer_mur(P, J, P2).

jouer_coup(P, p, J, P2) :-
	jouer_pion(P, J, P2).
	
jouer_mur(P, J, P2) :-
	write('jouer un mur vertical (ecrivez v) ou horizontal (ecrivez h) ?'),
	read(S),
	write('abscisse du coup a jouer ?'),
	read(A),
	write('ordonnee du coup a jouer ?'),
	read(O),
	poser_mur(P,J,S,O,A,P2).

%jouer_mur(P, J, P2) :-
%	not(verif_compteur(J)),
%	write('Nombre de mur maximal deja pose. Jouez plutot votre pion.'),
%	jouer(J).	

jouer_pion(P, J, P2) :-
	write('colonne de la case a jouer ?'),
	read(Col),
	write('ligne de la case a jouer ?'),
	read(Lg),
	chercher_si_coup_possible(P, J, Col, Lg, P2).

% coup possible	

	% déplacement pas en ligne
chercher_si_coup_possible(P, J, Col, Lg, P3) :-
	coupsPossibles(P, J, ListeCoups),
	memberchk([Col,Lg], ListeCoups),
	% on remplace la case où il joue par le n° du joueur
	nth1(Lg, P, L),
	remplacer_element(L, Col, J, L2),
	remplacer_element(P, Lg, L2, P2),
	
	% on remplace par 0 la case que le joueur vient de quitter
	trouverCoord(P, J, 1, AncienneCol, AncienneLg),
	AncienneLg \= Lg, % on vérifie que le joueur ne se déplace pas en ligne
	nth1(AncienneLg, P, L3),
	remplacer_element(L3, AncienneCol, 0, L4),
	remplacer_element(P2, AncienneLg, L4, P3),
	asserta(plateau(P3)),
	format("Pion joue en (~d, ~d)",[Col,Lg]),nl,nl,
	joueur_suivant(J,J2),
	jouer(J2).
	
	% déplacement en ligne
chercher_si_coup_possible(P, J, Col, Lg, P3) :-
	coupsPossibles(P, J, ListeCoups),
	memberchk([Col,Lg], ListeCoups),
	% on remplace la case où il joue par le n° du joueur
	nth1(Lg, P, L),
	remplacer_element(L, Col, J, L2),
	remplacer_element(P, Lg, L2, P2),
	
	% on remplace par 0 la case que le joueur vient de quitter
	trouverCoord(P, J, 1, AncienneCol, AncienneLg),
	AncienneLg == Lg, % si le joueur se déplace en ligne, il ne faut pas re-remplacer la ligne
	remplacer_element(L2, AncienneCol, 0, L3),
	remplacer_element(P2, AncienneLg, L3, P3),
	asserta(plateau(P3)),
	format("Pion joue en (~d, ~d)",[Col,Lg]),nl,nl,
	joueur_suivant(J,J2),
	jouer(J2).

% coup impossible	
chercher_si_coup_possible(P, J, Col, Lg, P) :-
	coupsPossibles(P, J, ListeCoups),
	not(memberchk([Col,Lg], ListeCoups)),
	write("Ce coup n'est pas jouable."),nl,nl,
	jouer(J).
	
%.......................................
% casesVoisines
%.......................................
% Trouve les voisins de la case (X, Y) pour un décalage de D
% Retourne leurs coordonnées [XV, YV] dans ListeVoisins

% vérifie que la case existe
caseOk(X, Y) :-
	X>0, X=<17, Y>0, Y=<17.

% voisin de droite
caseVoisine(X, Y, D, XV, Y) :-
	XV is X+D,
	caseOk(XV, Y).

% voisin de gauche
caseVoisine(X, Y, D, XV, Y) :-
	XV is X-D,
	caseOk(XV, Y).

% voisin du haut
caseVoisine(X, Y, D, X, YV) :-
	YV is Y-D,
	caseOk(X, YV).

% voisin du bas
caseVoisine(X, Y, D, X, YV) :-
	YV is Y+D,
	caseOk(X, YV).

% tous les voisins
casesVoisines(X, Y, D, ListeVoisins) :-
	findall([XV, YV], caseVoisine(X, Y, D, XV, YV), ListeVoisins).


%.......................................
% caseVide
%.......................................
% Renvoie true si la case (X,Y) est vide pour un pion

caseVide(P, X, Y) :-
	nth1(Y, P, Lg),
	nth1(X, Lg, V),
	V == 0.
	
	
%.......................................
% caseOccupee
%.......................................
% Renvoie true si la case (X,Y) est occupée par l'adversaire de J

caseOccupee(P, J, X, Y) :-
	nth1(Y, P, Lg),
	nth1(X, Lg, V),
	marqueJoueurInverse(J, MarqueJoueur),
	V == MarqueJoueur.
	
	
%.......................................
% trouverCoord
%.......................................
% Trouver les coordonnées dans P de l'élément J
% Mettre N=1 car on n°te à partir de 1

trouverCoord(P, J, N, Col, Lg) :-
	nth1(N, P, L),
	memberchk(J, L),
	nth1(Lg, P, L),
	nth1(Col, L, J).
	
trouverCoord(P, J, N, Col, Lg) :-
	nth1(N, P, L),
	not(memberchk(J, L)),
	M is N+1,
	trouverCoord(P, J, M, Col, Lg).
	
	
%.......................................
% mur
%.......................................
% Renvoie true si il y a un mur entre les cases A et B

caseMur(P, X, Y) :-
	nth1(Y, P, Lg),
	nth1(X, Lg, V),
	V == -2.

% cases sur la même ligne
mur(P, XA, YA, XB, YA) :-
	XA < XB,
	X is XA+1,
	caseMur(P, X, YA).

mur(P, XA, YA, XB, YA) :-
	XA > XB,
	X is XB+1,
	caseMur(P, X, YA).
	
% cases sur la même colonne
mur(P, XA, YA, XA, YB) :-
	YA < YB,
	Y is YA+1,
	caseMur(P, XA, Y).
	
mur(P, XA, YA, XA, YB) :-
	YA > YB,
	Y is YB+1,
	caseMur(P, XA, Y).
	
	
	
	
%.......................................
% coupsPossibles
%.......................................
% Renvoie la liste ListeCoups des coups jouables par le joueur J sur le plateau P

% pas de pion adverse sur une case voisine
unCoupPossible(P, J, [XV, YV]) :-
	trouverCoord(P, J, 1, Col, Lg),
	casesVoisines(Col, Lg, 2, ListeVoisins),
	member([XV,YV], ListeVoisins),
	caseVide(P, XV, YV),
	not(mur(P, Col, Lg, XV, YV)).

% pion adverse sur un voisin de la même colonne
unCoupPossible(P, J, [XV2, YV2]) :-
	trouverCoord(P, J, 1, Col, Lg),
	casesVoisines(Col, Lg, 2, ListeVoisins),
	member([XV,YV], ListeVoisins),
	caseOccupee(P, J, XV, YV),
	not(mur(P, Col, Lg, XV, YV)),
	Col == XV,
	XV2 is Col,
	YV2 is YV+2,
	caseVide(P, XV2, YV2),
	not(mur(P, XV, YV, XV2, YV2)).
	
% pion adverse sur un voisin de la même ligne
unCoupPossible(P, J, [XV2, YV2]) :-
	trouverCoord(P, J, 1, Col, Lg),
	casesVoisines(Col, Lg, 2, ListeVoisins),
	member([XV,YV], ListeVoisins),
	caseOccupee(P, J, XV, YV),
	not(mur(P, Col, Lg, XV, YV)),
	Lg == YV,
	XV2 is XV+2,
	YV2 is Lg,
	caseVide(P, XV2, YV2),
	not(mur(P, XV, YV, XV2, YV2)).
	
coupsPossibles(P, J, ListeCoups) :-
	findall(CoordCoupPossible, unCoupPossible(P, J, CoordCoupPossible), ListeCoups).
	
	
%.......................................
% remplacer_element
%.......................................
% Remplace l'élt en position N par l'élt V dans une liste L
% Retourne le résultat dans la liste L2

remplacer_element(L, N, V, L2) :-
	remplacer_element2(L, N, V, L2).
	
remplacer_element2([_|T], 1, X, [X|T]).
remplacer_element2([H|T], I, X, [H|R]):-
	I > 0,
	I1 is I-1,
	remplacer_element2(T, I1, X, R).
	

%.......................................
% trouver_element
%.......................................
% Trouve l'élt en position N dans une liste L
% Retourne le résultat dans V

trouver_element(L, N, V) :-
	trouver_element2(L, N, 1, V).

trouver_element2( [], _N, _A, V) :-
	V = [], !,
	fail.

trouver_element2( [T|_Q], N, A, V) :-
	A = N,
	V = T.

trouver_element2( [_|Q], N, A, V) :-
	A1 is A+1,
	trouver_element2(Q, N, A1, V).
	
	
%.......................................
% poser_mur
%.......................................
% fonctions pour poser un mur et vérifier qu'il n'est posé sur aucun autre 


remplacer_element_tableau(Plateau, Ligne, Colonne, -2, Resultat):-
	trouver_element(Plateau, Ligne, Resultat_ligne),
	remplacer_element(Resultat_ligne, Colonne, -2, Ligne_modifiee),
	remplacer_element(Plateau, Ligne, Ligne_modifiee, Resultat).

remplacer_element_tableau_mur(Plateau, Ligne, Colonne, Resultat):-
	remplacer_element_tableau(Plateau, Ligne, Colonne, -2, Resultat).

trouver_element_tableau(Plateau, Ligne, Colonne, Resultat_element):-
	trouver_element(Plateau, Ligne, Resultat_ligne), 
	trouver_element(Resultat_ligne, Colonne, Resultat_element).

comparer_deux_symboles(Premier_symbole, Deuxieme_symbole):-
	Premier_symbole \== Deuxieme_symbole.

verifier_non_presence_element(Plateau, Ligne, Colonne, Symbole):-
	trouver_element_tableau(Plateau, Ligne, Colonne, Resultat_element), 
	comparer_deux_symboles(Resultat_element, Symbole).														
														 
verifier_non_presence_3_cases_horizontal(Plateau, Ligne, Colonne):-
	verifier_non_presence_element(Plateau, Ligne, Colonne, -2),
	verifier_non_presence_element(Plateau, Ligne, Colonne, 0),
	verifier_non_presence_element(Plateau, Ligne, Colonne, 1),
	verifier_non_presence_element(Plateau, Ligne, Colonne, 2),
	Droite is Colonne + 1,
	verifier_non_presence_element(Plateau, Ligne, Droite, -2),
	verifier_non_presence_element(Plateau, Ligne, Droite, 0),
	verifier_non_presence_element(Plateau, Ligne, Droite, 1),
	verifier_non_presence_element(Plateau, Ligne, Droite, 2),
	Droite_droite is Colonne + 2,
	verifier_non_presence_element(Plateau, Ligne, Droite_droite, -2),
	verifier_non_presence_element(Plateau, Ligne, Droite_droite, 0),
	verifier_non_presence_element(Plateau, Ligne, Droite_droite, 1),
	verifier_non_presence_element(Plateau, Ligne, Droite_droite, 2).

														 
verifier_non_presence_3_cases_vertical(Plateau, Ligne, Colonne):-
	verifier_non_presence_element(Plateau, Ligne, Colonne, -2),
	verifier_non_presence_element(Plateau, Ligne, Colonne, 0),
	verifier_non_presence_element(Plateau, Ligne, Colonne, 1),
	verifier_non_presence_element(Plateau, Ligne, Colonne, 2),
	Haut is Colonne + 1,
	verifier_non_presence_element(Plateau, Haut, Colonne, -2),
	verifier_non_presence_element(Plateau, Haut, Colonne, 0),
	verifier_non_presence_element(Plateau, Haut, Colonne, 1),
	verifier_non_presence_element(Plateau, Haut, Colonne, 2),
	Haut_haut is Colonne + 2,
	verifier_non_presence_element(Plateau, Haut_haut, Colonne, -2),
	verifier_non_presence_element(Plateau, Haut_haut, Colonne, 0),
	verifier_non_presence_element(Plateau, Haut_haut, Colonne, 1),
	verifier_non_presence_element(Plateau, Haut_haut, Colonne, 2).
		
remplacer_element_mur_3_cases_horizontal(Plateau, Ligne, Colonne, Resultat3):-
	remplacer_element_tableau_mur(Plateau, Ligne, Colonne, Resultat1),
	Droite is Colonne + 1,
	remplacer_element_tableau_mur(Resultat1, Ligne, Droite, Resultat2),
	Droite_droite is Colonne + 2,
	remplacer_element_tableau_mur(Resultat2, Ligne, Droite_droite, Resultat3).
														   
remplacer_element_mur_3_cases_vertical(Plateau, Ligne, Colonne, Resultat3):-
	remplacer_element_tableau_mur(Plateau, Ligne, Colonne, Resultat1),
	Haut is Ligne + 1,
	remplacer_element_tableau_mur(Resultat1, Haut, Colonne, Resultat2),
	Haut_haut is Ligne + 2,
	remplacer_element_tableau_mur(Resultat2, Haut_haut, Colonne, Resultat3).

jouer_mur_horizontal(Plateau, Joueur, Ligne, Colonne, Resultat3):-
	verifier_non_presence_3_cases_horizontal(Plateau, Ligne, Colonne),
	remplacer_element_mur_3_cases_horizontal(Plateau, Ligne, Colonne, Resultat3),
	format("mur place en (~d,~d) , (~d,~d) et (~d,~d)",[Colonne,Ligne,Colonne+1,Ligne,Colonne+2,Ligne]),nl,nl,
	joueur_suivant(Joueur,J2),
	maj_compteur(Joueur),
	asserta(plateau(Resultat3)),
	jouer(J2).
																				 
jouer_mur_horizontal(Plateau, Joueur, Ligne, Colonne, Resultat3):-
	not(verifier_non_presence_3_cases_horizontal(Plateau, Ligne, Colonne)),
	write("Impossible de placer le mur"),nl,nl,
	jouer(Joueur). % si le mur n'est pas valide, le joueur rejoue
		

jouer_mur_vertical(Plateau, Joueur, Ligne, Colonne, Resultat3):-
	verifier_non_presence_3_cases_vertical(Plateau, Ligne, Colonne),
	remplacer_element_mur_3_cases_vertical(Plateau, Ligne, Colonne, Resultat3),
	format("mur place en (~d,~d) , (~d,~d) et (~d,~d)",[Colonne,Ligne,Colonne,Ligne+1,Colonne,Ligne+2]),nl,nl,
	joueur_suivant(Joueur,J2),
	maj_compteur(Joueur),
	asserta(plateau(Resultat3)),
	jouer(J2).
									 
jouer_mur_vertical(Plateau, Joueur, Ligne, Colonne, Resultat3):-
	not(verifier_non_presence_3_cases_vertical(Plateau, Ligne, Colonne)),
	write("Impossible de placer le mur"),nl,nl,
	jouer(Joueur). % si le mur n'est pas valide, le joueur rejoue
									 
																 
									 
poser_mur(Plateau, Joueur, h, Ligne, Colonne, Resultat):-
	jouer_mur_horizontal(Plateau, Joueur, Ligne, Colonne, Resultat).
									 
poser_mur(Plateau, Joueur, v, Ligne, Colonne, Resultat):-
	jouer_mur_vertical(Plateau, Joueur, Ligne, Colonne, Resultat).						 


	
%.......................................
% afficherPlateau
%.......................................
% permet d'afficher le plateau

afficherPlateau(P) :-
	write('    1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7'),nl,
	forall( between(1,9,X), (write(X), write('- |'), nth1(X, P, Lg), forall( between(1,17,Y), (nth1(Y, Lg, Case), symbole(Case, S), write(S),write('|'))),nl,write('-------------------------------------'),nl )),
	forall( between(10,17,X), (M is mod(X,10), write(M), write('- |'), nth1(X, P, Lg), forall( between(1,17,Y), (nth1(Y, Lg, Case), symbole(Case, S), write(S),write('|'))),nl,write('-------------------------------------'),nl )).
	
	
%.......................................
% gameOver
%.......................................

%Le joueur 2 a perdu <=> Le joueur 1 a atteint la ligne 1
gameOver(2, P) :-
	trouverCoord(P,1,N,Col,Lg),
	Lg==1,
	write("Le joueur 1 a gagne !"),nl,nl.

%Le joueur 1 a perdu <=> Le joueur 2 a atteint la ligne 17
gameOver(1, P) :-
	trouverCoord(P,2,N,Col,Lg),
	Lg==17,
	write("Le joueur 2 a gagne !"),nl,nl.