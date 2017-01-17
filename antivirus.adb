with p_esiut; use p_esiut;
with p_virus; use p_virus;
use p_virus.p_Piece_IO;

procedure antivirus is

f : p_Piece_IO.file_type;
nb, pad : integer;
V : TV_Virus;
dp : string (1..2); 

begin

	Open(f, in_file, "Parties");
	ecrire("N° config ? : "); lire(nb);
	CreeVectVirus(f, nb, V);
	AfficheVectVirus(V);
	AfficheGrille(V);
ecrire(Possible(V,rouge,bd));
ecrire(Possible(V,jaune,hg));
ecrire(Possible(V,rouge,hg));

	While not Gueri(V) loop
		ecrire("N° pièce à déplacer ? : (0 à 8)"); lire(pad);
		if (pad > 8) or (pad < 0) then
			Raise EX_Piece;
		end if;
			
		ecrire("Direction du déplacement ? : (bg, hg, bd ou hd)"); lire(dp);

		if not ((dp = "bg") or (dp = "hg") or (dp = "bd") or (dp ="hd")) then
			Raise EX_Dir;
		end if;

		if Presente(V, T_Piece'Val(pad)) and then Possible(V, T_Piece'Val(pad), T_Direction'Value(dp)) then 
			Deplacement(V, T_Piece'Val(pad), T_Direction'Value(dp));
		else
			ecrire("error");
		end if;
			AfficheGrille(V);
	end loop; 
	Close(f);
exception 
			when Ex_Piece =>
							ecrire_ligne("La valeur de la pièce doit être comprise 0 et 8");
			when Ex_Dir =>
							ecrire_ligne("Le déplacement doit être : hg ou hd ou bg ou bd");
end antivirus;


