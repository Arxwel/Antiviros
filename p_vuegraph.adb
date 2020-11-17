package body p_vuegraph is

	procedure FenetreAccueil(AC : out TR_Fenetre; Rej : out boolean) is
		--{} => {Créé une fenetre d'accueil avec l'option jouer, affichage de scores, l'affichage des règles et un bouton quitter}
		Bout:String(1..3):="   ";
		FRG, FTopScore : TR_Fenetre;
		quitter :boolean := false;
	begin
		------------------------------- Création des différents Widgets de la fenêtre ----------------------------------------------------
		AC:=DebutFenetre("Antiviros",400,400); --Création Fenêtre
		AjouterBoutonImage(AC, "Fond", " ", 0,0,400,400);
		AjouterTexte(AC, "CPR", "Copyright 2017 RAKOTOMALALA & PASDELOUP", 40,400,350,30);
		ChangerEtatBouton(AC,"Fond", arret); -- Affichage d'une image de fond
		ChangerImageBouton(AC,"Fond",ihome);
		AjouterBoutonRond(AC,"BoJ","",70,119,99,99); -- CRéation d'un Bouton "Jouer"
		AjouterBoutonRond(AC,"BoS","",70,312,99,99); -- CRéation d'un Bouton "Score"
		AjouterBoutonRond(AC,"BoR","",263,119,99,99); -- CRéation d'un Bouton "Règle"
		AjouterBoutonRond(AC,"BoQ","",263,312,99,99); -- CRéation d'un Bouton "Quitter"
		ChangerCouleurFond(AC,"BoJ", Color(vert));
		ChangerCouleurFond(AC,"BoS", Color(bleu));
		ChangerCouleurFond(AC,"BoR", FL_PALEGREEN);
		ChangerCouleurFond(AC,"BoQ", Color(jaune));
		AjouterTexte(AC, "Val", " Jouer", 79,158,50,20);
		AjouterTexte(AC, "Sco", "Score", 80,351,50,20);
		AjouterTexte(AC, "Reg", "Regles", 272,158,50,21);
		AjouterTexte(AC, "Qui", "Quitter", 272,351,50,21);
		ChangerCouleurFond(AC,"Val", Color(vert));
		ChangerCouleurFond(AC,"Sco", Color(bleu));
		ChangerCouleurFond(AC,"Reg", FL_PALEGREEN);
		ChangerCouleurFond(AC,"Qui", Color(jaune));
		FinFenetre(AC);
		--------------------------------------- Fin Création des Widgets ---------------------------------------------------------------------

		MontrerFenetre(AC);

		---------------------------------------- Gestion des Interactions --------------------------------------------------------------------
		While not quitter loop
			Bout := AttendreBouton(AC); -- On stocke le nom du bouton sur lequel l'utilisateur appuie

			if Bout = "BoQ" then --Si il appuie "Quitter"
			quitter:= true;	-- On quitte la boucle de partie
			elsif Bout = "BoR" then -- Si il appuie sur "Règles"
			FenetreRegles(FRG);
			MontrerFenetre(FRG);
			if AttendreBouton(FRG) = "FI" then
				CacherFenetre(FRG);
			end if;
			elsif Bout = "BoS" then -- Si il appuie sur "Derniers Scores"
			FenetreTopScore(FTopScore);
			MontrerFenetre(FTopScore);
			if AttendreBouton(FTopScore) = "FI" then
				CacherFenetre(FTopScore);
			end if;
			elsif Bout = "BoJ" then --Si il appuie sur "Jouer" Ouvre la fenêtre de choix de niveau
				Rej:= true;
				quitter:=true;
			end if;
		end loop;
		----------------------------------------------------- Fin des Interactions ---------------------------------------------------------
		CacherFenetre(AC);
	end FenetreAccueil;


	procedure FenetreChoix (f : in out p_Piece_IO.file_type; V : in out TV_Virus; NivChoisi: out String) is
		--{f ouvert, f-=<>, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de saisi de niveau, qui initialise un vecteur V avec
		--les donnees de f pour le niveau saisi}
		FSaisieChoix : TR_Fenetre;
	begin
		------------------------------- Création des différents Widgets de la fenêtre --------------------------------------------------------
		FSaisieChoix:=DebutFenetre("Choix Niveau",400,70); --Création Fenêtre
		AjouterChamp(FSaisieChoix,"ChampNiv","Niveau (1-20)","",100,10,280,30); --Création d'un champ de Saisie
		AjouterBouton(FSaisieChoix,"BoutonValider","Valider",100,50,70,30); -- CRéation d'un Bouton "Valider"
		AjouterTexteAscenseur(FSaisieChoix, "Alert", "", " ",180,50,200,55);
		FinFenetre(FSaisieChoix);
		--------------------------------------- Fin Création des Widgets ---------------------------------------------------------------------


		MontrerFenetre(FSaisieChoix);

		---------------------------------------- Gestion des Interactions --------------------------------------------------------------------
		loop
		begin
			While AttendreBouton(FSaisieChoix) /= "BoutonValider" loop
				ecrire(" ");
			end loop;

			CreeVectVirus(f, integer'value(consulterContenu(FSaisieChoix, "ChampNiv")), V); -- Création du Vecteur avec les données du Niveau Saisi

			if (integer'value(consulterContenu(FSaisieChoix, "ChampNiv")) <10 ) then -- Récupération du niveau pour le fichier de scores
				NivChoisi:= ' ' & consulterContenu(FSaisieChoix, "ChampNiv");
			else
				NivChoisi:=consulterContenu(FSaisieChoix, "ChampNiv");
			end if;
			exit;
			exception
				When Constraint_Error =>
				ChangerContenu(FSaisieChoix,"Alert","Vous n'avez pas saisi un" & nline & "entier valide!");
				When End_Error =>
				ChangerContenu(FSaisieChoix,"Alert","Le nombre saisi est trop" & nline & "grand!");
			end;
		end loop;
		----------------------------------------------------- Fin des Interactions ---------------------------------------------------------
		CacherFenetre(FSaisieChoix);
	end FenetreChoix;

	------------------------------------------------------------------------------------------

	function Color ( C: in T_Piece) return FL_PD_COL is
		--{} => {Renvoie la couleur en FL_PD_COL correspondant a la Couleur T_Piece fournie}
	begin
		case C is
			when rouge      => return FL_RED;
			when turquoise  => return FL_CYAN;
			when orange     => return FL_DARKORANGE;
			when rose       => return FL_MAGENTA;
			when marron     => return FL_DARKTOMATO;
			when bleu       => return FL_DODGERBLUE;
			when violet     => return FL_DARKVIOLET;
			when vert       => return FL_GREEN;
			when jaune      => return FL_YELLOW;
			when blanc      => return FL_WHITE;
			when others     => return FL_INACTIVE;
		end case;
	end Color;

	procedure GenGrille (V: in TV_Virus; FPartie: out TR_Fenetre; SCR: in String) is
		-- {} => {Génère une grille dans la fenêtre de l'interface graphique}
		nombout : string(1..2);
		S: string(1..1);
		X,Y :integer;

	begin
		------------------------------- Création des différents Widgets de l'interface --------------------------------------------------------
		FPartie:=DebutFenetre("Partie : Antiviros",700,400);
		AjouterBoutonImage(FPartie, "Fond", " " ,0,0,800,500); -- Ajout d'une image de fond
		ChangerImageBouton(FPartie,"Fond",ibgd);
		AjouterHorloge(FPartie,"HO","",492,173,75,72);
		AjouterBoutonImage(FPartie, "HG", "", 570, 173, 35, 35); --Création d'un bouton de direction avec image
		ChangerImageBouton(FPartie,"HG",ihg);
		AjouterBoutonImage(FPartie, "HD", "", 610, 173, 35, 35);
		ChangerImageBouton(FPartie,"HD",ihd);
		AjouterBoutonImage(FPartie, "BG", "", 570, 209, 35, 35);
		ChangerImageBouton(FPartie,"BG",ibg);
		AjouterBoutonImage(FPartie, "BD", "", 610, 209, 35, 35);
		ChangerImageBouton(FPartie,"BD",ibd);
		AjouterBouton(FPartie, "FI", "Quitter", 625, 10, 50, 50);
		AjouterBouton(FPartie, "RG", "Regles", 570, 10, 50, 50);
		AjouterBouton(FPartie, "DS", "Derniers Scores", 570, 70, 108, 50);
		AjouterBouton(FPartie, "SA", " ", 500, 10, 60,60);
		ChangerEtatBouton(FPartie,"SA", arret);
		AjouterTexteAscenseur(FPartie,"ME", " ", " " , 450, 250, 230, 100);
		AjouterTexteAscenseur(FPartie,"SC", "Score", " ", 450,360,35,20);
		ChangerCouleurFond(FPartie,"ME",FL_COL1);
		ChangerCouleurFond(FPartie,"SC",FL_COL1);
		ChangerEtatBouton(FPartie,"Fond", arret);

		ChangerContenu(FPartie,"SC",SCR);
		------------------------------- Fin Création des différents Widgets de l'interface -----------------------------------------------------

		for i in T_Lig'range loop
			Y:=30+(i-1)*50;
			for j in T_Col'range loop
				nombout := T_Col'image(j)(2..2) & Integer'image(i)(2..2);
				X:=20+((T_Col'Pos(j) mod 64)-1)*50;
				AjouterBoutonRond(FPartie, nombout, " ", X, Y, 60, 60); --Création des boutons grille
				if ((i mod 2 = 0) and ((T_Col'Pos(j) mod 64) mod 2 /= 0)) or ((i mod 2 /=0 ) and ((T_Col'Pos(j) mod 64) mod 2 =0)) then --Suppression des Cases interdites
					nombout := T_Col'image(j)(2..2) & Integer'image(i)(2..2);
					CacherElem(FPartie,nombout); -- On les rend invisibles
					ChangerEtatBouton(FPartie, nombout, arret);
					elsif V(i,j)=vide or V(i,j)=blanc then
						ChangerEtatBouton(FPartie, nombout, arret);
					end if;
				end loop;
			end loop;
			for i in V'range(1) loop
				for j in V'range(2) loop
					S:=Character'image(j)(2..2);
					ChangerCouleurFond(FPartie,S(1..1) & Integer'image(i)(2..2),Color(V(i,j))); -- On colore en fonction des données de V
				end loop;
			end loop;
			FinFenetre(FPartie);
		end GenGrille;


		procedure RefreshGrille(v : in TV_Virus; FPartie : in out TR_Fenetre) is
			--{aucune case de v n'est vide} => {a mis a jour les couleurs des boutons de la fenetre Jeu en fonction de ce qu'il y a dans V}
			j:character;
			nombout:string(1..2);
		begin --MajAffichage

			for i in v'range(1) loop
				if 0 = i mod 2 then
					j := T_col'succ(v'first(2));
				else
					j := v'first(2);
				end if;
				while j <= v'last(2) loop
					nombout := T_Col'image(j)(2..2) & Integer'image(i)(2..2);
					ChangerCouleurFond(FPartie,nombout,Color(v(i,j)));
					if v(i,j)=blanc or v(i,j)=vide then
						ChangerEtatBouton(FPartie, nombout, arret);
					else
						ChangerEtatBouton(FPartie, nombout, marche);
					end if;

					if j/= T_col'succ(v'last(2)) then
						j := T_col'succ(j);
						if j/= T_col'succ(v'last(2)) then
							j := T_col'succ(j);
						end if;
					end if;
				end loop;
			end loop;
		end RefreshGrille;


		------------------------------------------------------------------------------------------

		procedure FenetreSP (Pseudo: out String) is
			--{} => {Création et gestion de la fenetre de Saisie de pseudo}
			FSP : TR_Fenetre;
			P : Unbounded_String;
		begin
			FSP:=DebutFenetre("Saisie Pseudo",400,70); --Création Fenêtre
			AjouterChamp(FSP,"Pseudo","Votre Pseudo" & nline & "(10 chars max)","",100,10,280,30); --Création d'un champ de Saisie
			AjouterBouton(FSP,"BoutonValider","Valider",100,50,70,30); -- CRéation d'un Bouton "Valider"
			AjouterTexteAscenseur(FSP, "Alert2", "", " ",180,50,200,50);
			FinFenetre(FSP);

			MontrerFenetre(FSP); --Affichage de la fenetre
			loop
			begin
				if AttendreBouton(FSP) = "BoutonValider" then
					P:= To_Unbounded_String(consulterContenu(FSP, "Pseudo"));

					if(Length(P) = 0) then
						ChangerContenu(FSP,"Alert2","Le pseudo doit comporter au" & nline & "moins un caractere !");
						elsif(Length(P) > 10) then
							ChangerContenu(FSP,"Alert2","Le pseudo saisi est trop" & nline & "grand !");
						else
							for i in 1..10-Length(P) loop
								Append(P, " ");
							end loop ;
							Pseudo := To_String(P);
							exit;
						end if;
					end if;
				end;
			end loop;

			CacherFenetre(FSP);
		end FenetreSP;

		procedure TopScore (SCR: in String; Niv : in String) is
			--{} => { Ecrit dans un fichier le score de l'utilisateur avec son pseudo et le niveau joué}
			Pseudo: String(1..10);
			f: p_score_IO.file_type;
			s: TR_Score;
		begin
			open(f, append_file, fscore);
			s.score := Natural'value(SCR);
			s.niveau := Natural'value(Niv);
			FenetreSP(Pseudo);
			s.pseudo := Pseudo;
			write(f,s);
			close(f);
			exception
				when Name_Error =>
				ecrire_ligne("Fichier de score non trouvé. Création...");
				create(f, out_file, fscore);
				s.score := Natural'value(SCR);
				s.niveau := Natural'value(Niv);
				FenetreSP(Pseudo);
				s.pseudo := Pseudo;
				write(f,s);
				close(f);
			end TopScore;

			------------------------------------------------------------------------------------------

			procedure FenetreRegles(FRG: out TR_Fenetre) is
				-- {} => {Crée une fenêtre qui affiche les règles du jeu}

			begin
				FRG:=DebutFenetre("Regles",500,300);
				AjouterBoutonImage(FRG,"ME", " " , 0, 0,500, 299);
				ChangerEtatBouton(FRG,"ME", arret);
				ChangerImageBouton(FRG,"ME",irg);
				AjouterBouton(FRG, "FI", "Retour au Jeu", 170, 302, 150, 30);
				FinFenetre(FRG);

			end FenetreRegles;

			------------------------------------------------------------------------------------------

			procedure FenetreTopScore(FTopScore : out TR_Fenetre) is
				--{f créé et rempli} => {Crée une fenêtre avec les trois derniers scores saisis}
				f: p_score_IO.file_type;
				SC:TR_score;
				str_pseudo: Unbounded_String:= To_Unbounded_String ("") ;
				str_score: Unbounded_String:= To_Unbounded_String ("") ;
				str_niveau: Unbounded_String:= To_Unbounded_String ("") ;
			begin
				FTopScore:=DebutFenetre("Liste de Scores",259,400);
				AjouterTexte(FTopScore,"LEGP","PSEUDO",2,2,85,20);
				AjouterTexte(FTopScore,"LEGS","SCORE",87,2,85,20);
				AjouterTexte(FTopScore,"LEGN","Niveau",172,2,85,20);
				AjouterTexteAscenseur(FTopScore,"APseudo", " ", ""  , 2, 20,85, 370);
				AjouterTexteAscenseur(FTopScore,"AScore", " ", ""  , 87, 20,85, 370);
				AjouterTexteAscenseur(FTopScore,"ANiveau", " ", ""  , 172, 20,85, 370);
				ChangerEtatBouton(FTopScore,"Fond", arret);
				AjouterBouton(FTopScore, "FI", "Retour au Jeu", 50, 400, 150, 30);
				FinFenetre(FTopScore);
				open(f, in_file, fscore);
				while not end_of_file(f) loop
					read(f,SC);
					str_pseudo := str_pseudo & To_Unbounded_String(SC.pseudo & nline);
					str_score := str_score & To_Unbounded_String(Natural'image(SC.score) & nline);
					str_niveau := str_niveau & To_Unbounded_String(Natural'image(SC.niveau) & nline);
				end loop;
				close(f);
				ChangerContenu(FTopScore,"APseudo", To_String(str_pseudo));
				ChangerContenu(FTopScore,"AScore", To_String(str_score));
				ChangerContenu(FTopScore,"ANiveau", To_String(str_niveau));
			end FenetreTopScore;

			------------------------------------------------------------------------------------------

			procedure FenetreRes(FRe: out TR_Fenetre;HeureDeb, HeureFin : in Time) is
				-- {} => {Crée une fenêtre de fin de jeu}

			begin
				FRe:=DebutFenetre("Bravo !",200,100);
				AjouterTexte(FRe,"VI", "Victoire en" & natural'image(natural(HeureFin-HeureDeb)) & "secondes !", 45, 40,100, 50); -- Affiche un message de victoire
				AjouterBouton(FRe, "FI", "Quitter", 105, 90, 60, 30);
				AjouterBouton(FRe, "RE", "Rejouer", 35, 90, 60, 30); -- Bouton permettant de relancer une partie
				AjouterTexteAscenseur(FRe,"SC", "Score", " ", 75,2,35,20); -- Affichage du score
				ChangerCouleurFond(FRe,"SC",FL_COL1);
				FinFenetre(FRe);
			end FenetreRes;

			------------------------------------------------------------------------------------------

			procedure FenetrePartie(V : in out TV_Virus; Rejouer:out boolean; Niv: in String) is
				--{V initialise, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de Partie avec les donnees de V }
				FPartie, FPartie2, FRG, FRe, FTopScore : TR_Fenetre;
				Id : T_Lig;
				Jd : T_Col;
				Dir: T_direction;
				BT_Coul : String(1..2);
				SCR : integer:=0;
				Current : T_Piece := vide;
				HeureDeb,HeureFin : Time;
			begin
				GenGrille(V,FPartie,Integer'image(0));
				MontrerFenetre(FPartie);
				HeureDeb:= clock;
				While not Gueri(V) loop -- La partie continue tant qu'on a pas gagné ou quitté
					BT_Coul := AttendreBouton(FPartie); -- On stocke le nom du bouton sur lequel l'utilisateur appuie
					if BT_Coul = "FI" then --Si il appuie "Quitter"
					Rejouer:= false;
					exit;		-- On quitte la boucle de partie
					elsif BT_Coul = "RG" then -- Si il appuie sur "Règles"
					FenetreRegles(FRG);  -- On ouvre la fenetre de Règle
					MontrerFenetre(FRG);
					if AttendreBouton(FRG) = "FI" then
						CacherFenetre(FRG);
					end if;
					elsif BT_Coul = "DS" then -- Si il appuie sur "Derniers Scores"
					FenetreTopScore(FTopScore); -- Ouvre la Fenetre des 3 derniers scores
					MontrerFenetre(FTopScore);
					if AttendreBouton(FTopScore) = "FI" then
						CacherFenetre(FTopScore);
					end if;
					elsif (BT_Coul = "HG") or (BT_Coul = "HD") or (BT_Coul = "BG") or (BT_Coul = "BD") then
						if (Current = vide) then
							ChangerContenu(FPartie,"ME","Selectionnez d'abord une piece"); -- On affiche un message
						else
							Dir := T_direction'value(BT_Coul); -- On récupère la valeur de la direction
							if Possible(V, Current, Dir) then -- On vérifie si le déplacement est possible
								deplacement(V, Current, Dir); -- si oui on effectue le déplacement
								SCR := SCR+1; -- Incrémentation du score
								RefreshGrille(V,FPartie);
							else
								SCR := SCR+2; -- Incrémentation du score
								ChangerContenu(FPartie,"ME","Deplacement impossible (+2)"); -- Si déplacement impossible affichage d'un message
							end if;
							ChangerContenu(FPartie,"SC",Integer'Image(SCR));
						end if;
					else -- Si il appuie sur un bouton de couleur
						Jd := BT_Coul(1); -- On récupère les coordonnées du bouton
						Id := T_Lig'value(BT_Coul(2..2));
						Current := V(Id,Jd); -- On met à jour la couleur actuelle
						ChangerCouleurFond(FPartie,"SA", Color(Current));
					end if;
				end loop;
				If Gueri(V) then -- Si on sort de la boucle partie car on a gagné
					HeureFin:= clock;
					FenetreRes(FRe,HeureDeb,HeureFin); -- Affichage de la fenetre Resultat
					ChangerContenu(FRe, "SC", Integer'Image(SCR)); --On affiche le score dans le TexteAscenceur
					MontrerFenetre(FRe);
					TopScore(Integer'Image(SCR), Niv); -- Ecriture du Score dans le fichier
					if AttendreBouton(FRe) = "FI" then
						CacherFenetre(FRe);
						Rejouer := false;
					else
						Rejouer := true;
						CacherFenetre(FRe);
					end if;
				end if;
				CacherFenetre(FPartie);
			end FenetrePartie;

		end p_vuegraph;
