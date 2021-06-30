# Projet_Prolog
Prolog est un langage de programmation logique. Le projet a pour but de mettre en place un ensemble de règles de logique formelle permettant de créer un environnement virtuel de jeu du Quoridor. 

# Quoridor

Quoridor est un jeu à information complète et parfaite de stratégie combinatoire
pouvant se jouer à 2 ou 4 joueurs. C’est un jeu de tour par tour se jouant sur un plateau de
9x9 cases séparées par des couloirs, ou corridor, où sont encastrables des murs permettant
de bloquer le passage du (ou des) joueur(s) adverse(s). Notre but est de proposer un
environnement virtuel de jeu.

# Règles

L’ensemble des règles que l’on peut définir sont les suivantes :

● Chaque joueur commence avec son pion sur la case du milieu d’un bord. Si le
jeu se fait à 2, sur deux bords opposés, si c’est à 4, sur les 4 bords du
plateau.

● Le jeu comporte 20 murs qui sont répartis en début de partie entre les
joueurs. 10 chacun pour un jeu à 2 joueurs, 5 chacun pour un jeu à 4 joueurs.

● A chaque tour, le joueur peut soit déplacer son pion soit placer un mur dans la
limite de sa réserve personnelle.

● Un pion peut se déplacer sur 4 cases différentes : en haut, en bas, à droite et
à gauche.

● Un mur fait la longueur de 2 cases, il ne peut donc pas être placé le long de 3
cases, en diagonale ou sur les bords. Un mur bloque un pion.

● Un joueur ne peut pas bloquer complètement le passage à un autre joueur.

● Dans le cas où deux pions se juxtaposent et ne sont pas séparés par un mur,
un pion peut “sauter” par dessus l’autre pion et ainsi profiter d’un déplacement
de 2 cases
