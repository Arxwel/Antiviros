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
		ecrire("Direction du déplacement ? : (bg, hg, bd ou hd)"); lire(dp);
		if Presente(V, T_Piece'Val(pad)) and then Possible(V, T_Piece'Val(pad), T_Direction'Value(dp)) then 
			Deplacement(V, T_Piece'Val(pad), T_Direction'Value(dp));
		end if;
			AfficheGrille(V);
	end loop; 

	Close(f);
exception 
		when Constraint_Error =>
							ecrire_ligne("T'es con, il faut que ça soit entre 0 et 8");
end antivirus;


