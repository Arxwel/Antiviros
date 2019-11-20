with p_esiut; use p_esiut;
with p_virus; use p_virus;
use p_virus.p_Piece_IO;

procedure antivirus is

f : p_Piece_IO.file_type;
nb,pad : integer;
dp : String(1..2);
V : TV_Virus; 

begin

	Open(f, in_file, "data/Parties"); -- Ouverture du Fichier contenant les différents niveaux
	ecrire("N° config ? : "); lire(nb); -- Lecture du Numéro de Niveau désiré
	CreeVectVirus(f, nb, V);  -- Création du vecteur contenant les pièces du niveau et leur emplacement
	 --AfficheVectVirus(V); -- Affichage des valeurs du vecteur
	AfficheGrille(V); -- Affichage d'une grille de jeu avec les données du Vecteur

	While not Gueri(V) loop -- Permettre de faire plusieurs déplacements dans une partie
		ecrire("N° pièce à déplacer ? : (0 à 8)"); lire(pad); -- Lecture du Numéro de Pièce à déplacer
		if (pad > 8) or (pad < 0) then -- On vérifie que le numéro de pièce saisi est valide
			Raise EX_Piece;		-- Si non déclenchement d'une exception
		end if;
			
		ecrire("Direction du déplacement ? : (bg, hg, bd ou hd)"); lire(dp); -- Lecture du type de déplacement désiré pour la pièce

		if not ((dp = "bg") or (dp = "hg") or (dp = "bd") or (dp ="hd")) then -- On vérifie que le déplacement saisi existe bien
			Raise EX_Dir; -- Si non déclenchement d'une exception
		end if;

		if Presente(V, T_Piece'Val(pad)) and then Possible(V, T_Piece'Val(pad), T_Direction'Value(dp)) then -- On teste si la pièce existe bien dans la grille
																						-- Et que le déplacement est possible
			Deplacement(V, T_Piece'Val(pad), T_Direction'Value(dp)); -- Si oui on effectue le déplacement
		else
			A_la_ligne;
			ecrire_ligne("Erreur, pièce inexistante dans la grille ou le déplacement est impossible"); -- Si non Message d'erreur
		end if;
			AfficheGrille(V); -- Affichage de la grille de jeu après déplacement
	end loop;
	A_la_ligne;
	ecrire_ligne("Vous avez gagné!"); 
	Close(f); -- Fermeture du Fichier de Niveaux
exception -- Traitement des exceptions
			when Ex_Piece =>
							ecrire_ligne("La valeur de la pièce doit être comprise 0 et 8");
			when Ex_Dir =>
							ecrire_ligne("Le déplacement doit être : hg ou hd ou bg ou bd");
end antivirus;


