with p_vuegraph; use p_vuegraph;
with p_fenbase; use p_fenbase;
with p_esiut; use p_esiut;
with p_virus; use p_virus;
use p_virus.p_Piece_IO;
procedure avgraphique is

f : p_Piece_IO.file_type;
V : TV_Virus;
Rej : boolean := true;
Niv:String(1..2);
begin
	Open(f, in_file, "Parties"); -- Ouverture du Fichier Parties
	InitialiserFenetres; -- Initialisation du mode graphique
	While Rej loop
		FenetreChoix(f,V,Niv); -- Affichage fenêtre Choix de Partie
	
		FenetrePartie(V,Rej,Niv); -- Démarrage de la Partie
		-- AfficheGrille(V);
	end loop;
	Close(f); -- Fermeture de f
end avgraphique;

