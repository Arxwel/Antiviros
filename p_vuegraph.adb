package body p_vuegraph is

procedure FenetreChoix (f : in out p_Piece_IO.file_type; V : in out TV_Virus; NivChoisi: out String) is
--{f ouvert, f-=<>, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de saisi de niveau, qui initialise un vecteur V avec
--les donnees de f pour le niveau saisi}
FSaisieChoix : TR_Fenetre;
begin
	FSaisieChoix:=DebutFenetre("Choix Niveau",400,70); --Création Fenêtre
	AjouterChamp(FSaisieChoix,"ChampNiv","Niveau (1-20)","",100,10,280,30); --Création d'un champ de Saisie
	AjouterBouton(FSaisieChoix,"BoutonValider","Valider",100,50,70,30); -- CRéation d'un Bouton "Valider"
	FinFenetre(FSaisieChoix);

	MontrerFenetre(FSaisieChoix); --Affichage de la fenetre
	While AttendreBouton(FSaisieChoix) /= "BoutonValider" loop
		ecrire(" ");
	end loop;		

	CreeVectVirus(f, integer'value(consulterContenu(FSaisieChoix, "ChampNiv")), V); -- Création du Vecteur avec les données du Niveau Saisi
	
	if (integer'value(consulterContenu(FSaisieChoix, "ChampNiv")) <10 ) then -- Récupération du niveau pour le fichier de scores
		NivChoisi:= ' ' & consulterContenu(FSaisieChoix, "ChampNiv");
	else
		NivChoisi:=consulterContenu(FSaisieChoix, "ChampNiv");
	end if;

	CacherFenetre(FSaisieChoix);
end FenetreChoix;

------------------------------------------------------------------------------------------

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

------------------------------------------------------------------------------------------

function Corrigation (P : in integer) return integer is
-- {} => {Retourne une valeur de P qui correspond mieux à la situation}
begin
	if P = 65 then
		return 1;
	elsif P = 66 then
		return 2;
	elsif P = 67 then
		return 3;
	elsif P = 68 then
		return 4;
	elsif P = 69 then
		return 5;
	elsif P = 70 then
		return 6;
	else
		return 7;
	end if;
end Corrigation;

------------------------------------------------------------------------------------------

procedure GenGrille (V: in TV_Virus; FPartie: out TR_Fenetre; SCR: in String) is
-- {} => {Génère une grille dans la fenêtre de l'interface graphique}
nombout : string(1..2);
S: string(1..1);
X,Y :integer;

begin
		FPartie:=DebutFenetre("Partie : Antivirus",700,400);
		AjouterBouton(FPartie, "HG", "HG", 570, 173, 25, 25);
		AjouterBouton(FPartie, "HD", "HD", 600, 173, 25, 25);
		AjouterBouton(FPartie, "BG", "BG", 570, 206, 25, 25);
		AjouterBouton(FPartie, "BD", "BD", 600, 206, 25, 25);
		AjouterBouton(FPartie, "FI", "Quitter", 625, 10, 50, 50);
		AjouterBouton(FPartie, "RG", "Regles", 570, 10, 50, 50);
		AjouterBouton(FPartie, "DS", "Derniers Scores", 570, 70, 108, 50);
		AjouterTexteAscenseur(FPartie,"ME", " ", " " , 450, 250, 230, 100);
		AjouterTexteAscenseur(FPartie,"SC", "Score", " ", 450,360,35,20);
		ChangerContenu(FPartie, "SC", SCR);
		

		for i in T_Lig'range loop
			Y:=30+(i-1)*50;
			for j in T_Col'range loop
				nombout := T_Col'image(j)(2..2) & Integer'image(i)(2..2);	
				X:=20+(Corrigation(T_Col'Pos(j))-1)*50;
				AjouterBoutonRond(FPartie, nombout, " ", X, Y, 60, 60); --Création des boutons grille
				if ((i mod 2 = 0) and (Corrigation(T_Col'Pos(j)) mod 2 /= 0)) or ((i mod 2 /=0 ) and (Corrigation(T_Col'Pos(j)) mod 2 =0)) then --Suppression des Cases interdites
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

------------------------------------------------------------------------------------------

procedure FenetreSP (Pseudo: out String) is
--{} => {Création et gestion de la fenetre de Saisie de pseudo}
FSP : TR_Fenetre;
begin
	FSP:=DebutFenetre("Saisie Pseudo",400,70); --Création Fenêtre
	AjouterChamp(FSP,"Pseudo","Votre Pseudo","(3characters)",100,10,280,30); --Création d'un champ de Saisie
	AjouterBouton(FSP,"BoutonValider","Valider",100,50,70,30); -- CRéation d'un Bouton "Valider"
	FinFenetre(FSP);

	MontrerFenetre(FSP); --Affichage de la fenetre
	While AttendreBouton(FSP) /= "BoutonValider" loop
		ecrire(" ");
	end loop;		
	Pseudo:= consulterContenu(FSP, "Pseudo");
	CacherFenetre(FSP);
end FenetreSP;

procedure TopScore (SCR: in String; Niv : in String) is
--{} => { Ecrit dans un fichier le score de l'utilisateur avec son pseudo et le niveau joué}
Pseudo:String(1..3);
f: text_io.file_type;
begin
	Open(f, in_file, "score.data");
	FenetreSP(Pseudo);
	reset(f, append_file);
	Put(f, Pseudo & ' ');
	Put(f,SCR & ' ');
	Put_line(f, Niv);
	close(f);
end TopScore;

------------------------------------------------------------------------------------------

procedure FenetreRegles(FRG: out TR_Fenetre) is
-- {} => {Crée une fenêtre qui affiche les règles du jeu}

begin
	FRG:=DebutFenetre("Regles",500,300);
	AjouterTexteAscenseur(FRG,"ME", " ", " " , 0, 0,498, 285);
	ChangerContenu(FRG,"ME","Le  jeu  comporte  9  pieces  de  couleur:  la  piece  rouge  (le  virus  a" & character'val(10) &  "eliminer)  ainsi  que  8  pieces  mobiles de  couleurs  differentes (turquoise,"& character'val(10) & "orange, rose, marron, bleu, violet, vert et jaune)." & character'val(10) & character'val(10) & "Les pieces sont de taille et de formes differentes. Elles occupent 2 ou 3" & character'val(10) & "cases lorqu elles sont presentes sur la grille. Il existe egalement 2 petites" & character'val(10) & "pieces blanches qui occupent chacune une case et qui ne peuvent pas etre" & character'val(10) & "deplacees au cours de la partie. Elles genent donc les pieces de couleur" & character'val(10) & "dans leurs deplacements sur la grille." & character'val(10) & character'val(10) & "Les  pieces  de  couleur  se  deplacent  une  par  une 1 en  diagonale  (elles" & character'val(10) & "ne  peuvent  pas  se deplacer horizontalement  ni verticalement,  ni  pivoter)." & character'val(10) & "Il  y  a  donc  4  directions  possibles:  bas/gauche,  haut/gauche,  bas/droite" & character'val(10) & "et  haut/droite." & character'val(10) & character'val(10) &  "Pour  que  le deplacement soit possible, il faut que les cases de destination" & character'val(10) & "existent et soient libres.");
	AjouterBouton(FRG, "FI", "Quitter", 200, 295, 60, 30);
	FinFenetre(FRG);

end FenetreRegles;

------------------------------------------------------------------------------------------

procedure FenetreTopScore(FTopScore : out TR_Fenetre) is
--{f créé et rempli} => {Crée une fenêtre avec les trois derniers scores} 
f: text_io.file_type;
SC:String(1..10);
begin
	FTopScore:=DebutFenetre("TOP Score",500,300);
	AjouterTexteAscenseur(FTopScore,"AN", " ", ""  , 0, 0,200, 80);
	AjouterTexteAscenseur(FTopScore,"AN2", " ", " " , 0,90,290, 80);
	AjouterTexteAscenseur(FTopScore,"AN3", " ", " " , 0,180,380, 80);
	AjouterBouton(FTopScore, "FI", "Quitter", 0, 290, 50, 50);
	FinFenetre(FTopScore);
	Open(f, in_file, "score.data"); -- Ouverture du fichier contenant le score
	reset(f, in_file);
	get(f, SC);
	ChangerContenu(FTopScore,"AN",SC);
	get(f, SC);
	ChangerContenu(FTopScore,"AN2",SC);
	get(f, SC);
	ChangerContenu(FTopScore,"AN3",SC);
	close(f);
end FenetreTopScore;

------------------------------------------------------------------------------------------

procedure FenetreRes(FRe: out TR_Fenetre) is
-- {} => {Crée une fenêtre de fin de jeu}

begin
	FRe:=DebutFenetre("Regles",200,100);
	AjouterTexte(FRe,"VI", "VICTORY !" , 65, 40,100, 50); -- Affiche un message de victoire
	AjouterBouton(FRe, "FI", "Quitter", 75, 90, 60, 30);
	AjouterBouton(FRe, "RE", "Rejouer", 0, 90, 60, 30); -- Bouton permettant de relancer une partie
	AjouterTexteAscenseur(FRe,"SC", "Score", " ", 75,2,35,20); -- Affichage du score
	FinFenetre(FRe);
end FenetreRes;
	
------------------------------------------------------------------------------------------

procedure FenetrePartie(V : in out TV_Virus; Rejouer:out boolean; Niv: in String) is
--{V initialise, InitialiserFenetres a deja ete fait} => {Creation d'une fenetre de Partie avec les donnees de V }
FPartie, FRG, FRe, FTopScore : TR_Fenetre;
Id : T_Lig;
Jd : T_Col;
Dir: T_direction;
BT_Coul : String(1..2);
SCR : integer:=0;
begin
	GenGrille(V,FPartie,Integer'image(0));
	MontrerFenetre(FPartie);
	While not Gueri(V) loop -- La partie continue tant qu'on a pas gagné ou quitté
		BT_Coul := AttendreBouton(FPartie); -- On stocke le nom du bouton sur lequel l'utilisateur appuie
		if BT_Coul = "FI" then --Si il appuie "Quitter"
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
		elsif (BT_Coul = "HG") or (BT_Coul = "HD") or (BT_Coul = "BG") or (BT_Coul = "BD") then -- Si il appuie sur un bouton de direction sans avoir appuyé sur une couleur
			ChangerContenu(FPartie,"ME","Selectionnez d'abord une piece"); -- On affiche un message
		else -- Si il appuie sur un bouton de couleur
			Jd := BT_Coul(1); -- On récupère les coordonnées du bouton
			Id := T_Lig'value(BT_Coul(2..2));
			BT_Coul := AttendreBouton(FPartie); -- On attend l'appuie d'un bouton par l'utilisateur
			if (BT_Coul = "HG") or (BT_Coul = "HD") or (BT_Coul = "BG") or (BT_Coul = "BD") then -- Si le bouton est une direction
				Dir := T_direction'value(BT_Coul); -- On récupère la valeur de la direction
				If Possible(V, V(Id,Jd), Dir) then -- On vérifie si le déplacement est possible
					deplacement(V, V(Id, Jd), Dir); -- si oui on effectue le déplacement
					SCR := SCR+1; -- Incrémentation du score
					CacherFenetre(FPartie);
					GenGrille(V,FPartie,Integer'Image(SCR));
					MontrerFenetre(FPartie);
				else 
					ChangerContenu(FPartie,"ME","Deplacement impossible"); -- Si déplacement impossible affichage d'un message
				end if;
			else
				ChangerContenu(FPartie,"ME","Selectionnez une direction"); -- Si le bouton n'est pas une direction on affiche un message
			end if;
		end if;
	end loop;
	If Gueri(V) then -- Si on sort de la boucle partie car on a gagné
		FenetreRes(FRe); -- Affichage de la fenetre Resultat
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

