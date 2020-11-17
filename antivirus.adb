with p_esiut; use p_esiut;
with p_virus; use p_virus;
use p_virus.p_Piece_IO;

procedure antivirus is

	f : p_Piece_IO.file_type;
	nb, pad : integer;
	dp : String(1..2);
	V : TV_Virus;

begin
	ecrire(ASCII.ESC & "[2J");
	Open(f, in_file, "data/Parties");
	ecrire("N° config ? : "); lire(nb);
	CreeVectVirus(f, nb, V);
	AfficheGrille(V);
	While not Gueri(V) loop
		ecrire("N° pièce à déplacer ? : (0 à 8)"); lire(pad);
		while (pad > 8) or (pad < 0) loop
			ecrire_ligne("La valeur de la pièce doit être comprise 0 et 8");
			ecrire("N° pièce à déplacer ? : (0 à 8)"); lire(pad);
		end loop;

		ecrire("Direction du déplacement ? : (bg, hg, bd ou hd)"); lire(dp);
		while not ((dp = "bg") or (dp = "hg") or (dp = "bd") or (dp ="hd")) loop
			ecrire_ligne("Le déplacement doit être : hg ou hd ou bg ou bd");
			ecrire("Direction du déplacement ? : (bg, hg, bd ou hd)"); lire(dp);
		end loop;

		if Presente(V, T_Piece'Val(pad)) and then Possible(V, T_Piece'Val(pad), T_Direction'Value(dp)) then -- On teste si la pièce existe bien dans la grille
			-- Et que le déplacement est possible
			Deplacement(V, T_Piece'Val(pad), T_Direction'Value(dp)); -- Si oui on effectue le déplacement
			ecrire(ASCII.ESC & "[2J");
			AfficheGrille(V); -- Affichage de la grille de jeu après déplacement
		else
			A_la_ligne;
			if not Presente(V, T_Piece'Val(pad)) then
				ecrire_ligne("Erreur, pièce inexistante dans la grille.");
			else
				ecrire_ligne("Erreur, le déplacement est impossible.");
			end if;
		end if;
	end loop;
	A_la_ligne;
	ecrire_ligne("Vous avez gagné!");
	Close(f); -- Fermeture du Fichier de Niveaux

end antivirus;
