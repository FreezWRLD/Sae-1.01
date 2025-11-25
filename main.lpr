program main;
{$mode objfpc}{$H+}
{$codepage utf8} 
uses
  sysutils, types, gestionEcran, ihm, objets, SatisfactIUTLogic, constantes, logic;

begin
  effacerEtColorierEcran(Black);
  // ----------------------------------------
  // LES FONCTIONS A APPERLER POUR LES TESTER :
  afficherBatiment( (120 - 70) div 2, 5,hub);
  effacerEcran();
  //menuDeJeu();
  //afficherEcranDemarrage();
  //afficherInventaire();
  //afficherEcranJeu();
  lancementDeJeu();

  // ----------------------------------------
  readln;
end.
 

end.