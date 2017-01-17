with p_vuegraph; use p_vuegraph;
with p_fenbase; use p_fenbase;
with p_esiut; use p_esiut;
with p_virus; use p_virus;
use p_virus.p_Piece_IO;
procedure avgraphique is

f : p_Piece_IO.file_type;
V : TV_Virus;

begin
	Open(f, in_file, "Parties"); -- Ouverture du Fichier Parties
	InitialiserFenetres; -- Initialisation du mode graphique
	reset(f, in_file);  -- Réinitialisation de la tête de lecture du fichier
	
	FenetreChoix(f,V); -- Affichage fenêtre Choix de Partie
	FenetrePartie(V); -- Démarrage de la Partie
	-- AfficheGrille(V);

	Close(f); -- Fermeture de f
end avgraphique;

