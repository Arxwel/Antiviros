with p_virus; use p_virus;
with p_fenbase; use p_fenbase;
with forms ; use forms;
with p_esiut; use p_esiut;
with text_io; use text_io;

package p_vuegraph is

procedure FenetreChoix (f : in out p_Piece_IO.file_type; V : in out TV_Virus; NivChoisi: out String);
--{f ouvert, f-=<>, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de saisi de niveau, qui initialise un vecteur V avec
                                                      --les donnees de f pour le niveau saisi}
function Color (C: in T_Piece) return FL_PD_COL;
--{} => {Renvoie la couleur en FL_PD_COL correspondant a la Couleur T_Piece fournie}

function Corrigation (P : in integer) return integer;
-- {} => {Retourne une valeur de P qui correspond mieux à la situation}

procedure FenetreRegles (FRG: out TR_Fenetre);
-- {} => {Crée une fenêtre qui affiche les règles du jeu}

procedure FenetreSP (Pseudo: out String);
--{} => {Création et gestion de la fenetre de Saisie de pseudo}

procedure FenetreTopScore(FTopScore : out TR_Fenetre);
--{f créé et rempli} => {Crée une fenêtre avec les trois derniers scores} 

procedure TopScore (SCR: in String; Niv: in String);
--{fichier déjà créé} => { Ecrit dans un fichier le score de l'utilisateur avec son pseudo et le niveau joué}

procedure FenetreRes(FRe: out TR_Fenetre);
-- {} => {Crée une fenêtre de fin de jeu}

procedure GenGrille (V: in TV_Virus; FPartie: out TR_Fenetre; SCR: in String);
-- {} => {Génère une grille dans la fenêtre de l'interface graphique}

procedure FenetrePartie(V : in out TV_Virus; Rejouer:out boolean; Niv:in String);
--{V initialise, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de Partie avec les donnees de V }
end p_vuegraph;

