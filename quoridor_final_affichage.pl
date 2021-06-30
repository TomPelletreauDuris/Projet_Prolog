%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Faits
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

joueur_suivant(1, 2).
joueur_suivant(2, 1).

marqueJoueurInverse(1, 2).
marqueJoueurInverse(2, 1).

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
	%creation de la fenetre
	new(D, window('Quoridor')),
	send(D, size, size(900,650)),
	affichage(D,1). % le joueur 1 joue en 1er
	%terminer.



%Ecrit sur la console quel a été le coup joué + enregistre le dernier coup dans sauve_coup
coup_joue(Joueur, Coup, Ligne, Colonne,D) :-
    format('Joueur ~w a joué son  ~w  en colonne ~d  et ligne ~d ~n',
           [Joueur,Coup,Ligne,Colonne]),
		   asserta(sauve_coup([Joueur,Coup,Ligne,Colonne])),
		jouer(Joueur,Coup,Ligne,Colonne,D,J2),
		affichage(D,J2).


affichage(D,J) :-
	%Chargement des images
	new(Iplt,image('plateau.gif')),
	new(Ip1,image('redPion.gif')),
	new(Ip2,image('greenPion.gif')),
	pionJoueur(J,JP),
	new(Ij,image(JP)),
	
	%Preparation affichage plateau
	new(BmpIplt,bitmap(Iplt)),
	
	%Preparation affichage Pion 1
	new(BmpP1,bitmap(Ip1)),
	positionPion1(Ap1,Bp1),
	coord(Ap1,Bp1,Xp1,Yp1),
	
	%Preparation affichage Pion 2
	new(BmpP2,bitmap(Ip2)),
	positionPion2(Ap2,Bp2),
	coord(Ap2,Bp2,Xp2,Yp2),

	%Preparation affichage Joueur en cours
	new(BmpJ,bitmap(Ij)),
	new(T, text('C\'est au tour de :')),
	
	%Preparation affichage des murs
	listePositionsMurs(L),
	
	%Disposition des éléments dans la fenetre
	affichageMurs(D,L),
	send(D,display,BmpIplt,point(10,10)),
	send(D,display,BmpP1,point(Xp1,Yp1)),
	send(D,display,BmpP2,point(Xp2,Yp2)),
	send(D,display,T,point(620,47)),
	send(D,display,BmpJ,point(725,37)),
	
	
	%Affichage gestion des saisies
	new(Lbl,label),
	send(D,display,Lbl,point(620,100)),
	%send(D, append, new(label)),    % Signale si l'input n'est pas int
	
	new(Coup,menu(coup, marked)),
	%send(D, append, new(Coup, menu(coup, marked))),
	send(Coup, append, pion),
    send(Coup, append, mursVerticaux),
	send(Coup, append, mursHorizontaux),
	send(Coup, layout, orientation:= vertical),
	send(D,display,Coup,point(620,150)),
	
	new(Ligne, text_item(ligne)),
	new(Colonne, text_item(colonne)),
    send(D, display, Ligne,point(620,250)),
    send(D, display, Colonne,point(620,280) ),
    send(Ligne, type, int),
	send(Colonne, type, int),

	%Bouton
	new(Btn,button(jouer, message(@prolog, coup_joue,
							J,
							Coup?selection,
                            Ligne?selection,
                            Colonne?selection,
				D))),

	send(D,display,Btn,point(650,320)),
	
	
	%creation de la fenetre
	send(D,open).

	
	
%.......................................	
% maj_compteur
%.......................................

maj_compteur(1):-
	compteur1(A),
	B is A-1,
	asserta(compteur1(B)).

maj_compteur(2):-
	compteur2(A),
	B is A-1,
	asserta(compteur2(B)).
	
verif_compteur(1):-
	compteur1(A),
	A>0.

verif_compteur(2):-
	compteur2(A),
	A>0.
	
	
%.......................................	
% jouer
%.......................................

jouer(J,C,Lg,Col,D,J2) :-
	plateau(P),
	not(gameOver(J, P,D)), % si le joueur J n'a pas encore perdu
	joueur_suivant(J, J3), % on change de joueur
	not(gameOver(J3,P,D)), % si l''adversaire n'a pas encore perdu non plus 
	format("Le joueur ~d joue",J),nl,
	jouer_coup(P,C,Lg,Col,J,P2,D,J2).
	
% à la fin du tour, on repart pour un tour avec l'autre joueur

	

%.......................................
% jouer_coup
%.......................................
% applique le coup du joueur J pour le plateau P
% retourne le nouveau plateau dans P2

jouer_coup(P, mursHorizontaux,Lg,Col, J, P2,D,J2) :-
	verif_compteur(J),
	jouer_mur_horizontal(P,J,Lg,Col,P2,D,J2),
	asserta(plateau(P2)),
	maj_compteur(J).

jouer_coup(P, mursVerticaux,Lg,Col, J, P2,D,J2) :-
	verif_compteur(J),
	jouer_mur_vertical(P,J,Lg,Col,P2,D,J2),
	asserta(plateau(P2)),
	maj_compteur(J).

jouer_coup(P, pion,Lg,Col, J, P2,D,J2) :-
	jouer_pion(P,Lg,Col, J, P2,D,J2).

jouer_pion(P,Lg,Col, J, P2,D,J2) :-
	chercher_si_coup_possible(P, J, Col, Lg, P2,D,J2).

% coup possible	

	% déplacement pas en ligne
chercher_si_coup_possible(P, J, Col, Lg, P3,D,J2) :-
	coupsPossibles(P, J, ListeCoups),
	memberchk([Col,Lg], ListeCoups),
	% on remplace la case où il joue par le n° du joueur
	nth1(Lg, P, L),
	remplacer_element(L, Col, J, L2),
	remplacer_element(P, Lg, L2, P2),
	%write(L2),
	
	% on remplace par 0 la case que le joueur vient de quitter
	trouverCoord(P, J, 1, AncienneCol, AncienneLg),
	AncienneLg \= Lg, % on vérifie que le joueur ne se déplace pas en ligne
	nth1(AncienneLg, P, L3),
	remplacer_element(L3, AncienneCol, 0, L4),
	remplacer_element(P2, AncienneLg, L4, P3),
	asserta(plateau(P3)),
	%write('lg quittee'),write(L4),
	format("Pion joue en (~d, ~d)",[Col,Lg]),nl,nl,
	joueur_suivant(J,J2).
	
	% déplacement en ligne
chercher_si_coup_possible(P, J, Col, Lg, P3,D,J2) :-
	coupsPossibles(P, J, ListeCoups),
	memberchk([Col,Lg], ListeCoups),
	% on remplace la case où il joue par le n° du joueur
	nth1(Lg, P, L),
	remplacer_element(L, Col, J, L2),
	remplacer_element(P, Lg, L2, P2),
	%write(L2),
	
	% on remplace par 0 la case que le joueur vient de quitter
	trouverCoord(P, J, 1, AncienneCol, AncienneLg),
	AncienneLg == Lg, % si le joueur se déplace en ligne, il ne faut pas re-remplacer la ligne
	remplacer_element(L2, AncienneCol, 0, L3),
	remplacer_element(P2, AncienneLg, L3, P3),
	asserta(plateau(P3)),
	%write('lg quittee'),write(L3),
	format("Pion joue en (~d, ~d)",[Col,Lg]),nl,nl,
	joueur_suivant(J,J2).

% coup impossible	
chercher_si_coup_possible(P, J, Col, Lg, P,D,J2) :-
	coupsPossibles(P, J, ListeCoups),
	not(memberchk([Col,Lg], ListeCoups)),
	write("Ce coup n'est pas jouable."),nl,nl,
	J2 is J.
	
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
% jouer_mur_horizontal / jouer_mur_vertical 
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

jouer_mur_horizontal(Plateau, Joueur, Ligne, Colonne, Resultat3,D,J2):-
	verifier_non_presence_3_cases_horizontal(Plateau, Ligne, Colonne),
	remplacer_element_mur_3_cases_horizontal(Plateau, Ligne, Colonne, Resultat3),
	format("mur place en (~d,~d) , (~d,~d) et (~d,~d)",[Colonne,Ligne,Colonne+1,Ligne,Colonne+2,Ligne]),nl,nl,
		joueur_suivant(Joueur,J2).
																				 
jouer_mur_horizontal(Plateau, Joueur, Ligne, Colonne, Resultat3,D,J2):-
	not(verifier_non_presence_3_cases_horizontal(Plateau, Ligne, Colonne)),
	write("Impossible de placer le mur"),nl,nl,
	J2 is Joueur. % si le mur n'est pas valide, le joueur rejoue
		

jouer_mur_vertical(Plateau, Joueur, Ligne, Colonne, Resultat3,D,J2):-
	verifier_non_presence_3_cases_vertical(Plateau, Ligne, Colonne),
	remplacer_element_mur_3_cases_vertical(Plateau, Ligne, Colonne, Resultat3),
	format("mur place en (~d,~d) , (~d,~d) et (~d,~d)",[Colonne,Ligne,Colonne,Ligne+1,Colonne,Ligne+2]),nl,nl,
		joueur_suivant(Joueur,J2).
									 
jouer_mur_vertical(Plateau, Joueur, Ligne, Colonne, Resultat3,D,J2):-
	not(verifier_non_presence_3_cases_vertical(Plateau, Ligne, Colonne)),
	write("Impossible de placer le mur"),nl,nl,
	J2 is Joueur. % si le mur n'est pas valide, le joueur rejoue


%.......................................
% gameOver
%.......................................

%Le joueur 2 a perdu <=> Le joueur 1 a atteint la ligne 1
gameOver(2, P, D) :-
	trouverCoord(P,1,N,Col,Lg),
	Lg==1,
	write("Le joueur 1 a gagne !"),
	send(D,destroy).

%Le joueur 1 a perdu <=> Le joueur 2 a atteint la ligne 17
gameOver(1, P, D) :-
	trouverCoord(P,2,N,Col,Lg),
	Lg==17,
	write("Le joueur 2 a gagne !"),
	send(D,destroy).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Interface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- encoding(utf8).

%nettoyer la console
cls:- write('\33\[2J').

% Import XPCE library
:- use_module(library(pce)).


%Files are in the Resources folder
:- pce_image_directory('resources/').

%:- use_modules(lists).

%:-write('Loading pictures... \n').
resource(wall,image,image('wall.jpg')).
resource(plateau,image,image('plateau.gif')).

%Player
resource(greenPion,image,image('greenPion.gif')).
resource(redPion,image,image('redPion.gif')).
resource(bluePion,image,image('bluePion.gif')).
resource(yellowPion,image,image('yellowPion.gif')).

%Calcul de la largueur et la longueur du tableau
plateauLongueur(Longueur):-plateau(MaListe),length(MaListe,Longueur).
plateauLargeur(Largeur):-plateau(MaListe),nth1(1,MaListe,L),length(L,Largeur).

%Position du pion 1
positionPion1(A,B):-plateau(MaListe),nth1(A,MaListe,Liste),nth1(B,Liste,1).

%position du pion 2
positionPion2(A,B):-plateau(MaListe),nth1(A,MaListe,Liste),nth1(B,Liste,2).

%position des murs
positionsMurs(A,B):-plateau(MaListe),nth1(A,MaListe,Liste),nth1(B,Liste,-2).
listePositionsMurs(Liste):- findall([A,B], positionsMurs(A,B), Liste).

%parcours de liste
parcoursListe(L,N) :-nth1(N,L,V),write(V),M is N+1,parcoursListe(L,M).

%affichage des murs:
affichageMurs(Fenetre,[[Am,Bm]|Q]):-
	coord(Am,Bm,Xm,Ym),
	%format('debug X  ~w Y ~w ~n', [Xm, Ym]),
	bitmapMur(Fenetre,Xm,Ym),
	affichageMurs(Fenetre,Q).
%affichageMurs(Fenetre,[Am,Bm]):-
	%coord(Am,Bm,Xm,Ym).
	%creationBitmap(Fenetre,Xm,Ym).
affichageMurs(_,[]).

bitmapMur(Fenetre,X,Y):-
	%format('debug X  ~w Y ~w ~n',[X, Y]),
	new(Im,image('wall.jpg')),
	new(BmpM,bitmap(Im)),
	send(Fenetre,display,BmpM,point(X,Y)).


%Joueurs et leurs pions.
pionJoueur(1,'redPion.gif').
pionJoueur(2,'greenPion.gif').

%coord(Xentrée, Yentrée, Xécran, Yécran) 
coord(1,1,47,57).
coord(1,2,81,59).
coord(1,3,111,57).
coord(1,4,145,59).
coord(1,5,175,57).
coord(1,6,209,59).
coord(1,7,239,57).
coord(1,8,273,59).
coord(1,9,301,57).
coord(1,10,337,59).
coord(1,11,365,57).
coord(1,12,401,59).
coord(1,13,429,57).
coord(1,14,465,59).
coord(1,15,493,57).
coord(1,16,529,59).
coord(1,17,557,57).

coord(2,1,50,91).
coord(2,2,81,91).
coord(2,3,114,91).
coord(2,4,145,91).
coord(2,5,178,91).
coord(2,6,209,91).
coord(2,7,242,91).
coord(2,8,273,91).
coord(2,9,304,91).
coord(2,10,337,91).
coord(2,11,368,91).
coord(2,12,401,91).
coord(2,13,432,91).
coord(2,14,465,91).
coord(2,15,496,91).
coord(2,17,529,91).
coord(2,18,560,91).

coord(3,1,47,121).
coord(3,2,81,123).
coord(3,3,111,121).
coord(3,4,145,123).
coord(3,5,175,121).
coord(3,6,209,123).
coord(3,7,239,121).
coord(3,8,273,123).
coord(3,9,301,121).
coord(3,10,337,123).
coord(3,11,365,121).
coord(3,12,401,123).
coord(3,13,429,121).
coord(3,14,465,123).
coord(3,15,493,121).
coord(3,16,529,123).
coord(3,17,557,121).

coord(4,1,50,155).
coord(4,2,81,155).
coord(4,3,114,155).
coord(4,4,145,155).
coord(4,5,178,155).
coord(4,6,209,155).
coord(4,7,242,155).
coord(4,8,273,155).
coord(4,9,304,155).
coord(4,10,337,155).
coord(4,11,368,155).
coord(4,12,401,155).
coord(4,13,432,155).
coord(4,14,465,155).
coord(4,15,496,155).
coord(4,16,529,155).
coord(4,17,560,155).

coord(5,1,47,185).
coord(5,2,81,187).
coord(5,3,111,185).
coord(5,4,145,187).
coord(5,5,175,185).
coord(5,6,209,187).
coord(5,7,239,185).
coord(5,8,273,187).
coord(5,9,301,185).
coord(5,10,337,187).
coord(5,11,365,185).
coord(5,12,401,187).
coord(5,13,429,185).
coord(5,14,465,187).
coord(5,15,493,185).
coord(5,16,529,187).
coord(5,17,557,185).

coord(6,1,50,219).
coord(6,2,81,219).
coord(6,3,114,219).
coord(6,4,145,219).
coord(6,5,178,219).
coord(6,6,209,219).
coord(6,7,242,219).
coord(6,8,273,219).
coord(6,9,304,219).
coord(6,10,337,219).
coord(6,11,368,219).
coord(6,12,401,219).
coord(6,13,432,219).
coord(6,14,465,219).
coord(6,15,496,219).
coord(6,16,529,219).
coord(6,17,560,219).

coord(7,1,47,249).
coord(7,2,81,251).
coord(7,3,111,249).
coord(7,4,145,251).
coord(7,5,175,249).
coord(7,6,209,251).
coord(7,7,239,249).
coord(7,8,273,251).
coord(7,9,301,249).
coord(7,10,337,251).
coord(7,11,365,249).
coord(7,12,401,251).
coord(7,13,429,249).
coord(7,14,465,251).
coord(7,15,493,249).
coord(7,16,529,251).
coord(7,17,557,249).

coord(8,1,50,283).
coord(8,2,81,283).
coord(8,3,114,283).
coord(8,4,145,283).
coord(8,5,178,283).
coord(8,6,209,283).
coord(8,7,242,283).
coord(8,8,273,283).
coord(8,9,304,283).
coord(8,10,337,283).
coord(8,11,368,283).
coord(8,12,401,283).
coord(8,13,432,283).
coord(8,14,465,283).
coord(8,15,496,283).
coord(8,16,529,283).
coord(8,17,560,283).

coord(9,1,47,313).
coord(9,2,81,315).
coord(9,3,111,313).
coord(9,4,145,315).
coord(9,5,175,313).
coord(9,6,209,315).
coord(9,7,239,313).
coord(9,8,273,315).
coord(9,9,301,313).
coord(9,10,337,315).
coord(9,11,365,313).
coord(9,12,401,315).
coord(9,13,429,313).
coord(9,14,465,315).
coord(9,15,493,313).
coord(9,16,529,315).
coord(9,17,557,313).

coord(10,1,50,347).
coord(10,2,81,347).
coord(10,3,114,347).
coord(10,4,145,347).
coord(10,5,178,347).
coord(10,6,209,347).
coord(10,7,242,347).
coord(10,8,273,347).
coord(10,9,304,347).
coord(10,10,337,347).
coord(10,11,368,347).
coord(10,12,401,347).
coord(10,13,432,347).
coord(10,14,465,347).
coord(10,15,496,347).
coord(10,16,529,347).
coord(10,17,560,347).

coord(11,1,47,377).
coord(11,2,81,379).
coord(11,3,111,377).
coord(11,4,145,379).
coord(11,5,175,377).
coord(11,6,209,379).
coord(11,7,239,377).
coord(11,8,273,379).
coord(11,9,301,377).
coord(11,10,337,379).
coord(11,11,365,377).
coord(11,12,401,379).
coord(11,13,429,377).
coord(11,14,465,379).
coord(11,15,493,377).
coord(11,16,529,379).
coord(11,17,557,377).

coord(12,1,50,411).
coord(12,2,81,411).
coord(12,3,114,411).
coord(12,4,145,411).
coord(12,5,178,411).
coord(12,6,209,411).
coord(12,7,242,411).
coord(12,8,273,411).
coord(12,9,304,411).
coord(12,10,337,411).
coord(12,11,368,411).
coord(12,12,401,411).
coord(12,13,432,411).
coord(12,14,465,411).
coord(12,15,496,411).
coord(12,16,529,411).
coord(12,17,560,411).

coord(13,1,47,441).
coord(13,2,81,443).
coord(13,3,111,441).
coord(13,4,145,443).
coord(13,5,175,441).
coord(13,6,209,443).
coord(13,7,239,441).
coord(13,8,273,443).
coord(13,9,301,441).
coord(13,10,337,443).
coord(13,11,365,441).
coord(13,12,401,443).
coord(13,13,429,441).
coord(13,14,465,443).
coord(13,15,493,441).
coord(13,16,529,443).
coord(13,17,557,441).

coord(14,1,50,475).
coord(14,2,81,475).
coord(14,3,114,475).
coord(14,4,145,475).
coord(14,5,178,475).
coord(14,6,209,475).
coord(14,7,242,475).
coord(14,8,273,475).
coord(14,9,304,475).
coord(14,10,337,475).
coord(14,11,368,475).
coord(14,12,401,475).
coord(14,13,432,475).
coord(14,14,465,475).
coord(14,15,496,475).
coord(14,16,529,475).
coord(14,17,560,475).

coord(15,1,47,505).
coord(15,2,81,507).
coord(15,3,111,505).
coord(15,4,145,507).
coord(15,5,175,505).
coord(15,6,209,507).
coord(15,7,239,505).
coord(15,8,273,507).
coord(15,9,301,505).
coord(15,10,337,507).
coord(15,11,365,505).
coord(15,12,401,507).
coord(15,13,429,505).
coord(15,14,465,507).
coord(15,15,493,505).
coord(15,16,529,507).
coord(15,17,557,505).

coord(16,1,50,539).
coord(16,2,81,539).
coord(16,3,114,539).
coord(16,4,145,539).
coord(16,5,178,539).
coord(16,6,209,539).
coord(16,7,242,539).
coord(16,8,273,539).
coord(16,9,304,539).
coord(16,10,337,539).
coord(16,11,368,539).
coord(16,12,401,539).
coord(16,13,432,539).
coord(16,14,465,539).
coord(16,15,496,539).
coord(16,16,529,539).
coord(16,17,560,539).

coord(17,1,47,567).
coord(17,2,81,569).
coord(17,3,111,567).
coord(17,4,145,569).
coord(17,5,175,567).
coord(17,6,209,569).
coord(17,7,239,567).
coord(17,8,273,569).
coord(17,9,301,567).
coord(17,10,337,569).
coord(17,11,365,567).
coord(17,12,401,569).
coord(17,13,429,567).
coord(17,14,465,569).
coord(17,15,493,567).
coord(17,16,529,569).
coord(17,17,557,567).

%Fin du ficher