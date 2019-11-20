with p_vuegraph; use p_vuegraph;
with p_fenbase; use p_fenbase;
with p_esiut; use p_esiut;
with p_virus; use p_virus;
use p_virus.p_Piece_IO;
procedure avgraphique is
F4 : TR_Fenetre;
f : p_Piece_IO.file_type;
V : TV_Virus;
Rej : boolean := false;
Niv:String(1..2);
begin
	InitialiserFenetres; -- Initialisation du mode graphique
	FenetreAccueil(F4,Rej);

	Open(f, in_file, fparties); -- Ouverture du Fichier Parties
	-- reset(f, in_file);
			While Rej loop
				FenetreChoix(f,V,Niv); -- Affichage fenêtre Choix de Partie
	
				FenetrePartie(V,Rej,Niv); -- Démarrage de la Partie
				end loop;
			Close(f); -- Fermeture de f
			
end avgraphique;

