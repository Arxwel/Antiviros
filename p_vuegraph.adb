package body p_vuegraph is

procedure FenetreChoix (f : in out p_Piece_IO.file_type; V : in out TV_Virus) is
--{f ouvert, f-=<>, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de saisi de niveau, qui initialise un vecteur V avec
--les donnees de f pour le niveau saisi}
FSaisieChoix : TR_Fenetre;
begin
	FSaisieChoix:=DebutFenetre("Choix Niveau",400,70); --Création Fenêtre
	AjouterChamp(FSaisieChoix,"ChampNiv","Votre Niveau","2",100,10,280,30); --Création d'un champ de Saisie
	AjouterBouton(FSaisieChoix,"BoutonValider","valider",100,50,70,30); -- CRéation d'un Bouton "Valider"
	AjouterBouton(FSaisieChoix,"BoutonAnnuler","annuler",180,50,70,30); -- Création d'un Bouton "Annuler"
	FinFenetre(FSaisieChoix);

	MontrerFenetre(FSaisieChoix); --Affichage de la fenetre
	if AttendreBouton(FSaisieChoix) = "BoutonAnnuler" then
		CacherFenetre(FSaisieChoix);
	elsif  AttendreBouton(FSaisieChoix) = "BoutonValider" then
		CreeVectVirus(f, integer'value(consulterContenu(FSaisieChoix, "ChampNiv")), V); -- Création du Vecteur avec les données du Niveau Saisi
		CacherFenetre(FSaisieChoix);
	end if;
end FenetreChoix;

function Color ( C: in T_Piece) return FL_PD_COL is
--{} => {Renvoie la couleur en FL_PD_COL correspondant a la Couleur T_Piece fournie}
begin

	if C = rouge then
		return FL_RED;
	elsif C = turquoise then
		return FL_CYAN;
	elsif C = orange then
		return FL_DARKORANGE;
	elsif C = rose then
		return FL_MAGENTA;
	elsif C = marron then
		return FL_DARKTOMATO;
	elsif C = bleu then
		return FL_DODGERBLUE;
	elsif C = violet then
		return FL_DARKVIOLET;
	elsif C = vert then
		return FL_CHARTREUSE;
	elsif C = jaune then
		return FL_YELLOW;
	elsif C = blanc then
		return FL_WHITE;
	else
		return FL_INACTIVE;
	end if;
end Color;

procedure FenetrePartie(V : in out TV_Virus) is
--{V initialise, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de Partie avec les donnees de V }

FPartie : TR_Fenetre;
nombout : string(1..2);

begin
	FPartie:=DebutFenetre("Partie : Antivirus",800,800);
	AjouterBouton(FPartie, "Haut_Gauche", "HG", 720, 233, 25, 25);
	AjouterBouton(FPartie, "Haut_Droit", "HD", 750, 233, 25, 25);
	AjouterBouton(FPartie, "Bas_Gauche", "BG", 720, 266, 25, 25);
	AjouterBouton(FPartie, "Bas_Droite", "BD", 750, 266, 25, 25);
	AjouterBouton(FPartie, "BoutonQuitter", "Quitter", 725, 10, 50, 50);
	AfficheGrille(V);
	for i in 1..7 loop
		for j in 1..7 loop
			nombout := Character'image(Character'Val(j)) & Integer'image(i)(2..2);
			AjouterBoutonRond(FPartie, nombout, nombout, (J-1)*60+60, (I-1)*65+68, 153, 153); --Création des boutons grille
		end loop;
	end loop;
	for i in 1..7 loop
		for j in 1..7 loop
			if ((i mod 2 = 0) and (j mod 2 /=0)) or ((i mod 2 /=0) and ( j mod 2 =0)) then --Suppression des Cases interdites
				CacherElem(FPartie,Character'image(Character'Val(j)) & Integer'image(i)(2..2)); -- On les rend invisibles
				ChangerEtatBouton(FPartie, Character'image(Character'Val(j)) & Integer'image(i)(2..2), arret); 	-- On les rend non cliquables
			end if;
		end loop;
	end loop;
		for i in V'range(1) loop
			for j in V'range(2) loop
				if ((i mod 2 = 0) and (j mod 2 =0)) or ((i mod 2 /=0) and ( j mod 2 /=0)) then -- Pour toutes les cases non interdites
					ChangerCouleurFond(FPartie, Character'image(Character'Val(j)) & Integer'image(i)(2..2),Color(V(i,j))); -- On colore en fonction des données de V
				end if;
			end loop;
		end loop;
			

	FinFenetre(FPartie);
	MontrerFenetre(FPartie);
	While AttendreBouton(FPartie) /= "BoutonQuitter" loop
	ecrire(" ");
	CacherFenetre(FPartie);
	end loop;
end FenetrePartie;

end p_vuegraph;
