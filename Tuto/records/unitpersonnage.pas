unit UnitPersonnage;
{$mode ObjFPC}{$H+}

interface

//Définition du type dans l'interface pour qu'il soit utilisable par d'autres unités
Type
  TStatut = (VIVANT,INCONSCIENT,MORT);

  TPersonnage = Record     //Type représentant un personnage
    Nom : string;         //Nom du personnage
    PV : integer;         //Nombre de points de vie du personnage
    Statut : TStatut;     //Statut du personnage
  end;



//Créateur de personnage
//entrée : le nom et les pv du personnage
//sortie : le personnage créé
function CreerPersonnage(nom : string; pv: integer): TPersonnage;

//Procédure de prise de dégat pour un personnage
//entrée-sortie : le personnage
//entrée : les dégats
procedure PrendreDegat(var personnage : TPersonnage; degat : integer);
       
//Transforme un personnage en chaine de caractères pour l'affichage
//entrée : le personnage
//sortie : la chaine de caractères
function PersonnageToString(personnage : TPersonnage) : string;







implementation
uses
    SysUtils;                     //Bibliothèque contenant la fonction IntToStr (convertir un integer en string)

//Créateur de personnage
//entrée : le nom et les pv du personnage
//sortie : le personnage créé
function CreerPersonnage(nom : string; pv: integer): TPersonnage;
begin
   CreerPersonnage.Nom := nom;
   CreerPersonnage.PV := pv;
   CreerPersonnage.Statut := VIVANT;
end;

//Procédure de prise de dégat pour un personnage
//entrée-sortie : le personnage
//entrée : les dégats
procedure PrendreDegat(var personnage : TPersonnage; degat : integer);
begin
     //Le personnage prend les dégats
     personnage.PV := personnage.PV-degat;
     //Si le personnage tombe à 0PV (ou moins)
     if(personnage.PV <= 0) then
     begin
       //On évite les PV négatifs...
       personnage.PV := 0;
       case(personnage.Statut) of
         VIVANT: personnage.Statut := INCONSCIENT;     //Si le personnage était vivant, il tombe inconscient
         INCONSCIENT: personnage.Statut := MORT;       //Si le personnage était déja inonscient, il meurt
       end;
     end;
end;

//Transforme un statut en une chaine de caractère
//entrée : le statut
//sortie : la chaine de caractère
//La fonction n'est pas dans l'interface car elle ne sert pas à l'extérieur de l'unité
function StatutToString(statut : TStatut) : string;
begin
      StatutToString:='';
      case(statut) of
        VIVANT : StatutToString := 'en vie';
        INCONSCIENT: StatutToString := 'dans les vapes';
        MORT : StatutToString := 'mort';
      end;
end;

//Transforme un personnage en chaine de caractères pour l'affichage
//entrée : le personnage
//sortie : la chaine de caractères
function PersonnageToString(personnage : TPersonnage) : string;
begin
     PersonnageToString := personnage.Nom+' ('+IntToStr(personnage.PV)+') - '+StatutToString(Personnage.Statut);
end;

end.

