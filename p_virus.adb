package body p_virus is


--------------- Creation et Affichage de la grille

procedure CreeVectVirus (f : in out file_type; nb : in integer; V :out TV_Virus) is
-- {f (ouvert) contient des configurations initiales,
-- toutes les configurations se terminent par la position du virus rouge}
-- => {V a ete initialise par lecture dans f de la partie de numero nb}

piece : TR_Piece;
config:integer:=1;  --Compteur de Configurations
-- reset(f, in_file); -- f ouvert mais f- /= <> 
begin

	for i in V'range(1) loop		--Initialisation du Vecteur à vide
		for j in V'range(2) loop
			V(i,j) := vide;
		end loop;
	end loop;	
	
	reset(f, in_file);	-- réinitialisation de la tête de lecture

	if not end_of_file(f) then	-- on teste si le vecteur est vide 
		read(f,piece);
		while config < nb loop	-- on avance jusqu'à la configuration désirée
			if piece.couleur = T_Piece'value("rouge") then -- On compte les Configurations. On sait qu'on arrive à la fin d'une quand on rencontre une pièce rouge
				read(f,piece); -- On saute la deuxième sous-pièce rouge
				config:= config+1; -- On incrémente le compteur
			end if;
			read(f,piece);
		end loop;


		while piece.couleur /= T_Piece'value("rouge") loop	-- on remplit la grille avec les pièces de la config
			V(piece.ligne, piece.colonne):= piece.couleur;
			read(f,piece);
		end loop;
		V(piece.ligne, piece.colonne):=piece.couleur; -- On rajoute les deux pièces rouges qui n'ont pas été prises en compte par la boucle
		read(f,piece);
		V(piece.ligne, piece.colonne):=piece.couleur;
	else	-- si le fichier est vide
		ecrire("Fichier vide");
	end if;
end CreeVectVirus;

----------------------------------------------------------------------------------

procedure AfficheVectVirus (V : in TV_Virus) is
-- {} => {Les valeurs du vecteur V sont affichees sur une ligne}
begin

--for j in V'range(2) loop
--		if j = 'B' or j= 'D' or j= 'F' then
--			i:=V'first(1)+1;
--		else
--			i:=V'first(1);
--		end if;
--		while i<=7 loop
--			ecrire(T_Piece'image(V(i,j))); ecrire(",");
--			i:=i+2;
--		end loop;
--	end loop;

	for i in V'range(1) loop
		for j in V'range(2) loop
			ecrire(T_Piece'image(V(i,j))); ecrire(" ");  -- Affichage sur une ligne du contenu du vecteur, séparé par un espace
		end loop;
	A_la_ligne;
	end loop;
end AfficheVectVirus;


----------------------------------------------------------------------------------

function Pos2 (Coul : in T_Piece; Lig: in T_Lig; Col: in T_Col) return String is
--{} => {Retourne la position d'un T_piece en String sauf Cas particuliers : Retourne "B" pour Blanc, "." pour Vide et " " pour case inexistante}
S : String(1..3);

begin

	if Coul = blanc then
		return "B";
	else
		if Coul = vide then -- On traite les "deux" cas de cases vides
			if (Character'Pos(Col) mod 2 = 0 and Lig mod 2 /=0) or (Character'Pos(Col) mod 2 /=0 and Lig mod 2 =0) then -- Permet de mettre un caractère espace pour les cases interdites
					return " "; 
			else
					return "."; -- Si la case n'est pas une case interdite mais est vide, on met un point.
			end if;
		else
			S:= " " & Image(T_Piece'Pos(Coul)); -- Le T_Piece'Pos ajoutant un espace avant la valeur, on utilise une string intermédiaire pour le supprimer
			return S(3..3);
		end if;
	end if;

end Pos2;

	
		


---------------------------------------------------------------------------------


procedure AfficheGrille (V : in TV_Virus) is
-- {} => {Le contenu du vecteur V est affiche dans une grille symbolisee
-- Les colonnes sont numerotees de A a G et les lignes sont numerotees de 1 a 7.
-- Dans chaque case : 	. = case vide
--			un chiffre = numero de la couleur de la piece presente dans la case
--			le caractere 'B' = piece blanche fixe
-- 			rien = pas une case}

begin

	ecrire_ligne(" \  A B C D E F G");
	ecrire("  \ =============");
	for a in T_Lig'range loop  -- On parcourt le vecteur ligne par ligne
		A_la_ligne;
	  	ecrire(a); ecrire("|");
		for j in T_col'range loop -- Pour chaque ligne on écrit le contenu par colonne
			 ecrire(" ");ecrire(Pos2(V(a,j), a, j));
		end loop;
	end loop;
end AfficheGrille;

----------------------------------------------------------------------------------


----------------- Fonctions et procedures pour le jeu

function Gueri (V : in TV_Virus) return Boolean is
-- {} => {resultat = la piece rouge est prete a sortir (coin haut gauche)}
begin
	return (V(1,'A')=rouge);  -- Si un bout de la pièce rouge est à la coordonnée (1,A), alors la partie est gagnée
end Gueri;

----------------------------------------------------------------------------------

function Presente (V : in TV_Virus; Coul : in T_Piece) return Boolean is
-- {} => {resultat =  la piece de couleur Coul appartient a V}
begin
	if not (Coul = blanc or Coul = vide) then -- On traite seulement les pièces qui peuvent être déplacées		
		for i in V'range(1) loop -- On traverse tout le vecteur à la recherche de la pièce
			for j in V'range(2) loop
				if V(i,j) = Coul then -- Si elle est trouvée, on sort de la boucle et retourne "True
					return true;
				end if;
			end loop;
		end loop;
	end if;
		return false; -- Si la pièce n'a pas été trouvée on retourne false

end Presente;

------------------------------------------------------------------------------------

function Possible (V : in TV_Virus; Coul : in T_Piece; Dir : in T_Direction) return Boolean is
---- {P appartient a la grille V} => {resultat = vrai si la piece de couleur Coul peut etre 
----                                             deplacee dans la direction Dir}
continue: boolean;
newi, i: integer:= V'first(1);
newj, j :character;
begin
	continue:=true;	-- Si on ne rencontre pas de souci, le déplacement est possible
	while continue and i in V'range(1) loop -- On traverse tout le vecteur et sortira au moindre problème par rapport au déplacement
		j:=V'first(2);
		while continue and j in V'range(2) loop
			if V(i,j)=Coul then -- Dès que la pièce est trouvée, on regarde pour la direction désirée si le déplacement est possible
				if Dir=hd then
					newi:= i-1; newj:= T_Col'succ(j);
				elsif Dir=bg then
					newi:= i+1; newj:= T_Col'pred(j);
				elsif Dir=hg then
					newi:= i-1; newj:= T_Col'pred(j);
				elsif Dir=bd then
					newi:= i+1; newj:= T_Col'succ(j);
				end if;
				continue:=(newi in T_Lig and newj in T_Col) and then (((V(newi,newj))=vide) or (V(newi,newj)=Coul)); -- Le déplacement est possible seulement si les cases d'accueil sont vides ou contiennent un morceau 
																	--de la pièce à déplacer et si l'on ne sort pas de la grille.
			end if;
			j:= Character'succ(j); -- Incrémentation
		end loop;
		i:=i+1; -- Incrémentation
	end loop;
	return continue;
			
end possible;

----------------------------------------------------------------------------------

procedure Deplacement(V : in out TV_Virus; Coul : in T_Piece; Dir :in T_Direction) is
-- {la piece de couleur Coul peut etre deplacee dans la direction Dir} 
--                                        => {V a ete mis a jour suite au deplacement}

begin
		
	if dir=hg then
		for i in V'range(1) loop
			for j in reverse V'range(2) loop -- Afin d'éviter les conflits entre plusieurs sous-pièces
				if V(i,j) = Coul then  -- On cherche toutes les sous-pièces de la pièce que l'on souhaite déplacer
					V(i,j):=vide;  -- Une fois trouvées, on met leurs anciens emplacements à vide
					V(i-1,T_Col'pred(j)):=Coul; -- Et on met à jour leurs nouveaux emplacements
				end if;
			end loop;
		end loop;
	elsif dir=bg then
		for i in reverse V'range(1) loop
			for j in V'range(2) loop
				if V(i,j) = Coul then
					V(i,j):=vide;
					V(i+1,T_Col'pred(j)):=Coul;
				end if;
			end loop;
		end loop;
	elsif dir=bd then
		for i in reverse V'range(1) loop
			for j in V'range(2) loop
				if V(i,j) = Coul then
					V(i,j):=vide;
					V(i+1,T_Col'succ(j)):=Coul;
				end if;
			end loop;
		end loop;
	else
		for i in V'range(1) loop
			for j in reverse V'range(2) loop
				if V(i,j) = Coul then 
					V(i,j):=vide;
					V(i-1,T_Col'succ(j)):=Coul;
				end if;
			end loop;
		end loop;
	end if;

end Deplacement;
	

end p_virus;
