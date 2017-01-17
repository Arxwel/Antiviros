package body p_vuegraph is

procedure FenetreChoix (f : in out p_Piece_IO.file_type; V : in out TV_Virus) is
----- Affichage fenêtre choix de partie
FSaisieChoix : TR_Fenetre;
begin
	FSaisieChoix:=DebutFenetre("Choix Niveau",400,70);
	AjouterChamp(FSaisieChoix,"ChampNiv","Votre Niveau","2",100,10,280,30);
	AjouterBouton(FSaisieChoix,"BoutonValider","valider",100,50,70,30);
	AjouterBouton(FSaisieChoix,"BoutonAnnuler","annuler",180,50,70,30);
	FinFenetre(FSaisieChoix);

	MontrerFenetre(FSaisieChoix);
	if AttendreBouton(FSaisieChoix) = "BoutonAnnuler" then
		CacherFenetre(FSaisieChoix);
	elsif  AttendreBouton(FSaisieChoix) = "BoutonValider" then
		CreeVectVirus(f, integer'value(consulterContenu(FSaisieChoix, "ChampNiv")), V);
		CacherFenetre(FSaisieChoix);
	end if;
end FenetreChoix;

function Color ( C: in T_Piece) return FL_PD_COL is
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
FPartie : TR_Fenetre;
interdit : integer := 1;
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
                        nombout := Integer'image(i)(2..2) & Integer'image(j)(2..2);
                        AjouterBoutonRond(FPartie, nombout, " ", (J-1)*60+60, (I-1)*65+68, 153, 153);
                end loop;
            end loop;
	for i in 1..7 loop
		for j in 1..7 loop
			if ((i mod 2 = 0) and (j mod 2 /=0)) or ((i mod 2 /=0) and ( j mod 2 =0)) then
				CacherElem(FPartie,Integer'image(i)(2..2) & Integer'image(j)(2..2));
				ChangerEtatBouton(FPartie, Integer'image(i)(2..2) & Integer'image(j)(2..2), marche); 		
               end if;
		end loop;
	end loop;
		for i in V'range(1) loop
			for j in V'range(2) loop
				if ((i mod 2 = 0) and (j mod 2 =0)) or ((i mod 2 /=0) and ( j mod 2 /=0)) then
				ChangerCouleurFond(FPartie, Integer'image(i)(2..2) & Integer'image(Character'Pos(j))(2..2),Color(V(i,j)));
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


