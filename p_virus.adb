package body p_virus is


--------------- Creation et Affichage de la grille

procedure CreeVectVirus (f : in out file_type; nb : in integer; V :out TV_Virus) is
-- {f (ouvert) contient des configurations initiales,
-- toutes les configurations se terminent par la position du virus rouge}
-- => {V a ete initialise par lecture dans f de la partie de numero nb}

piece : TR_Piece;
config:integer:=1; 
 
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
			if piece.couleur = T_Piece'value("rouge") then -- On compte les Configurations
				read(f,piece);
				config:= config+1;
			end if;
			read(f,piece);
		end loop;


		while piece.couleur /= T_Piece'value("rouge") loop	-- on remplit la grille avec les pièces de la config
			V(piece.ligne, piece.colonne):= piece.couleur;
			read(f,piece);
		end loop;
		V(piece.ligne, piece.colonne):=piece.couleur;
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
		if Coul = vide then
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
	for a in T_Lig'range loop  -- On parcours le vecteur ligne par ligne
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
		for i in V'range(1) loop
			for j in V'range(2) loop
				if V(i,j) = Coul then
					return true;
				end if;
			end loop;
		end loop;
	end if;
		return false;

end Presente;

----------------------------------------------------------------------------------

function Libre (V : in TV_Virus; i : in T_Lig; j : in T_Col; Dir : in T_Direction) return boolean is
-- {} => {resultat = indique si la case n'est pas occupée pour le deplacement que l'on veut effectuer}
begin
	if dir=hg then
		return (not ((i = 1) or (j ='A'))) and then (V(i-1,T_Col'pred(j))=T_Piece'value("vide"));
	elsif dir=bg then
		return (not ((i = 7) or (j ='A'))) and then (V(i+1,T_Col'pred(j))=T_Piece'value("vide"));
	elsif dir=bd then
		return (not ((i = 7) or (j ='G'))) and then (V(i+1,T_Col'Succ(j))=T_Piece'value("vide"));
	else 
		return (not ((i = 1) or (j ='G'))) and then (V(i-1,T_Col'Succ(j))=T_Piece'value("vide"));
	end if;
end Libre;

----------------------------------------------------------------------------------

function Possible (V : in TV_Virus; Coul : in T_Piece; Dir : in T_Direction) return Boolean is
-- {P appartient a la grille V} => {resultat = vrai si la piece de couleur Coul peut etre 
--                                             deplacee dans la direction Dir}

begin
	for i in V'range(1) loop
		for j in V'range(2) loop
			if V(i,j) = Coul then	
				if not Libre(V, i, j, Dir) then  -- Si la case de destination n'est pas libre, on ne peut pas effectuer le déplacement
					return false;
				end if;
			end if;
		end loop;
	end loop;
	return true;

end Possible;

----------------------------------------------------------------------------------

procedure MAJ (V : in out TV_Virus; i: in T_Lig; j: in T_Col; Dir : in T_Direction) is
-- {le deplacement doit être possible et la couleur doit être presente} => {met à jour V après déplacement}
Vnew : TV_Virus;
begin
	if dir=hg then
		V(i-1,T_Col'pred(j)) := V(i,j);  -- On déplace le morceau de pièce sur la nouvelle case
		V(i,j) := vide;
	elsif dir=bg then
		V(i+1,T_Col'pred(j)) := V(i,j);
		V(i,j) := vide;
	elsif dir=bd then
		V(i+1,T_Col'succ(j)) := V(i,j);
		V(i,j) := vide;
	else
		V(i-1,T_Col'succ(j)) := V(i,j);
		V(i,j) := vide;
	end if;
end MAJ;

----------------------------------------------------------------------------------

procedure Deplacement(V : in out TV_Virus; Coul : in T_Piece; Dir :in T_Direction) is
-- {la piece de couleur Coul peut etre deplacee dans la direction Dir} 
--                                        => {V a ete mis a jour suite au deplacement}

begin
		for i in V'range(1) loop
			for j in V'range(2) loop
				if V(i,j) = Coul then
					MAJ(V,i,j,Dir);
				end if;
			end loop;
		end loop;

end Deplacement;
	

end p_virus;

