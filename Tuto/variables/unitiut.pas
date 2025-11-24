//On utilise une unité qui sera en charge de gérer la ou les valeurs stockées
//Il peut y avoir plusieurs unité qui stockent des valeurs comme cela
unit UnitIUT;
{$mode ObjFPC}{$H+}

interface
//!!! NE PAS DECLARER DE VARIABLE DANS L'INTERFACE, C'EST UNE MAUVAISE PRATIQUE !!!

   
//Procédure servant à initialiser les variables
procedure InitialisationIUT();
          
//Getter : fonction servant à accéder à la valeur de la variable
//Ne peut pas être utilisée pour modifier cette variable
function GetNomEtablissement() : string;
       
//Setter : procédure servant à modifier la valeur de la variable
//entrée : la nouvelle valeur
procedure SetNomEtablissement(nouveauNom : string);
 
//Getter : fonction servant à accéder à la valeur de la variable
//Ne peut pas être utilisée pour modifier cette variable
function GetNombreEtudiant() : integer;
     
//Setter : procédure servant à modifier la valeur de la variable
//entrée : la nouvelle valeur
procedure SetNombreEtudiant(nouveauNombre : integer);










implementation
//Variables servant à stocker les valeurs qui nous intéressent
var
  nomEtablissement : string;
  nombreEtudiants : integer;


//Procédure servant à initialiser les variables
procedure InitialisationIUT();
begin
  nomEtablissement := 'Non defini';
  nombreEtudiants := 0;
end;

//Getter : fonction servant à accéder à la valeur de la variable
//Ne peut pas être utilisée pour modifier cette variable
function GetNomEtablissement() : string;
begin
  GetNomEtablissement := nomEtablissement;
end;

//Setter : procédure servant à modifier la valeur de la variable
//entrée : la nouvelle valeur
procedure SetNomEtablissement(nouveauNom : string);
begin
  nomEtablissement := nouveauNom;
end;
  
//Getter : fonction servant à accéder à la valeur de la variable
//Ne peut pas être utilisée pour modifier cette variable
function GetNombreEtudiant() : integer;
begin
  GetNombreEtudiant := nombreEtudiants;
end;

//Setter : procédure servant à modifier la valeur de la variable
//entrée : la nouvelle valeur
procedure SetNombreEtudiant(nouveauNombre : integer);
begin
  if(nouveauNombre >= 0) then nombreEtudiants := nouveauNombre;
end;

end.

