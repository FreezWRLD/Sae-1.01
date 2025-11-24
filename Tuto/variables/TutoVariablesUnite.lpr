//But du tuto : mémoriser une information pour la garder durant l'exécution du programme
//En pouvant y accéder (lire ou modifier) depuis plusieurs endroit de votre programme   
program TutoVariablesUnite;
{$mode objfpc}{$H+}
uses UnitIUT;

begin
  
  //On initialise les variables (au début du programme, ou au début d'une partie...)
  InitialisationIUT();

  //On peut lire les valeurs
  writeln('Nom de l''etablissement : ',GetNomEtablissement());
  writeln('Nombre d''etudiants     : ',GetNombreEtudiant());
  writeln;

  //On peut modifier les valeurs
  SetNomEtablissement('IUT de Dijon, departement informatique');
  SetNombreEtudiant(300);

  writeln('Nom de l''etablissement : ',GetNomEtablissement());
  writeln('Nombre d''etudiants     : ',GetNombreEtudiant());

  readln;
end.   