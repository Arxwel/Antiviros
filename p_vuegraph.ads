with p_virus; use p_virus;
with p_fenbase; use p_fenbase;
with ada.calendar; use ada.calendar;
with forms ; use forms;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with p_esiut; use p_esiut;
package p_vuegraph is

datadir    : Constant String := "data";                    -- Répertoire données
imgdir     : Constant String := "img";                     -- Répertoire images

fscore     : Constant String := datadir & "/score.data";  -- Fichier de score
fparties   : Constant String := datadir & "/Parties";     -- Fichier de Configuration des Parties

ihg        : Constant String := imgdir & "/HG.xpm";       -- Flèche Haut-Gauche
ihd        : Constant String := imgdir & "/HD.xpm";       -- Flèche Haut-Droit
ibd        : Constant String := imgdir & "/BD.xpm";       -- Flèche Bas-Droit
ibg        : Constant String := imgdir & "/BG.xpm";       -- Flèche Bas-Gauche

irg        : Constant String := imgdir & "/RG.xpm";       -- Image Règles
ibgd       : Constant String := imgdir & "/FondHex.xpm";  -- Fond pour différentes interfaces
ihome      : Constant String := imgdir & "/anti.xpm";     -- Ecran d'accueil
ivoid      : Constant String := imgdir & "/vide.xpm";     -- Fond pour bouton vide

nline      : Constant Character := Character'val(10);     -- Retour à la ligne

type TR_score is record
  pseudo : String(1..10);
  score  : natural;
  niveau : natural;
end record;

type tv_score is array (integer range <>) of TR_score;

package p_score_IO is new sequential_IO (TR_score); use p_score_IO;

procedure FenetreChoix (f : in out p_Piece_IO.file_type; V : in out TV_Virus; NivChoisi: out String);
--{f ouvert, f-=<>, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de saisi de niveau, qui initialise un vecteur V avec
                                                      --les donnees de f pour le niveau saisi}
procedure FenetreAccueil(AC : out TR_Fenetre ; Rej : out boolean);
--{} => {Créé une fenetre d'accueil avec l'option jouer, affichage de scores, l'affichage des règles et un bouton quitter}

function Color (C: in T_Piece) return FL_PD_COL;
--{} => {Renvoie la couleur en FL_PD_COL correspondant a la Couleur T_Piece fournie}

procedure FenetreRegles (FRG: out TR_Fenetre);
-- {} => {Crée une fenêtre qui affiche les règles du jeu}

procedure FenetreSP (Pseudo: out String);
--{} => {Création et gestion de la fenetre de Saisie de pseudo}

procedure FenetreTopScore(FTopScore : out TR_Fenetre);
--{f créé et rempli} => {Crée une fenêtre avec les trois derniers scores} 

procedure TopScore (SCR: in String; Niv: in String);
--{fichier déjà créé} => { Ecrit dans un fichier le score de l'utilisateur avec son pseudo et le niveau joué}

procedure FenetreRes(FRe: out TR_Fenetre;HeureDeb, HeureFin : in Time);
-- {} => {Crée une fenêtre de fin de jeu}

procedure GenGrille (V: in TV_Virus; FPartie: out TR_Fenetre; SCR: in String);
-- {} => {Génère une grille dans la fenêtre de l'interface graphique}

procedure RefreshGrille(v : in TV_Virus; FPartie : in out TR_Fenetre);

procedure FenetrePartie(V : in out TV_Virus; Rejouer:out boolean; Niv:in String);
--{V initialise, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de Partie avec les donnees de V }
end p_vuegraph;
