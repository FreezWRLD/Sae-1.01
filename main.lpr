program main;
{$mode objfpc}{$H+}
{$codepage utf8} 
uses
  sysutils, declarations, gestionEcran, ihm, objets, SatisfactIUTLogic;

begin
  effacerEtColorierEcran(Black);
  // ----------------------------------------
  // LES FONCTIONS A APPERLER POUR LES TESTER :
  lancementDeJeu();

  // ----------------------------------------
  readln;
end.
 

end.