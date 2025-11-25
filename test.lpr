program test; //Utiliser ce fichier pour tester vos programmes
{$codepage utf8} 
uses
  sysutils, types, gestionEcran, ihm, objets;

begin
  effacerEtColorierEcran(Black);
  // ----------------------------------------
  // LES FONCTIONS A APPERLER POUR LES TESTER :
  afficherBatiment( (120 - 70) div 2, 5,hub);
  effacerEcran();
  ecranDemarrage();



  // ----------------------------------------
  readln;
end.

