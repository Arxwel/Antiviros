with p_virus; use p_virus;
with p_fenbase; use p_fenbase;
with forms ; use forms;
with p_esiut; use p_esiut;

package p_vuegraph is

procedure FenetreChoix (f : in out p_Piece_IO.file_type; V : in out TV_Virus);
--{f ouvert, f-=<>, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de saisi de niveau, qui initialise un vecteur V avec
                                                      --les donnees de f pour le niveau saisi}
function Color (C: in T_Piece) return FL_PD_COL;
--{} => {Renvoie la couleur en FL_PD_COL correspondant a la Couleur T_Piece fournie}

procedure FenetrePartie(V : in out TV_Virus);
--{V initialise, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de Partie avec les donnees de V }
end p_vuegraph;

