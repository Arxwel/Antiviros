with p_virus; use p_virus;
with p_fenbase; use p_fenbase;
with forms ; use forms;
with p_esiut; use p_esiut;

package p_vuegraph is

procedure FenetreChoix (f : in out p_Piece_IO.file_type; V : in out TV_Virus);
function Color ( C: in T_Piece) return FL_PD_COL;
procedure FenetrePartie(V : in out TV_Virus);
end p_vuegraph;

