program main;
{$mode objfpc}{$H+}
{$codepage utf8} 
uses
  sysutils, declarations, gestionEcran, ihm, objets, SatisfactIUTLogic;

var
  i: Integer;
  batiments: _ListeDeBatiments;
  emplacementVide, emplacementNonDecouvert, emplacementBatiment, emplacementGisement: _Emplacement;
  JZones : _EnsembleDeZones ;
  JDate : _Date;
  JInventaire : _Inventaire;
  ZoneActuelle : _TypeZone;  // Zone actuelle du joueur

begin
  // Initialisation des variables du joueur
  Randomize();
  initialiserJeu(JDate, ZoneActuelle, JZones);
  writeln(GetDate(JDate));
  readln;

  {// Création d'un emplacement vide découvert
  emplacementVide.estDecouvert := True;
  emplacementVide.batiment.nom := VIDE;
  emplacementVide.gisement.existe := False;
  
  // Création d'un emplacement non découvert
  emplacementNonDecouvert.estDecouvert := False;
  
  // Création d'un emplacement avec un bâtiment (HUB)
  emplacementBatiment.estDecouvert := True;
  emplacementBatiment.batiment := DEFAULT_HUB;
  emplacementBatiment.gisement.existe := False;
  
  // Création d'un emplacement avec un gisement de fer niveau 2
  emplacementGisement.estDecouvert := True;
  emplacementGisement.batiment.nom := VIDE;
  emplacementGisement.gisement.existe := True;
  emplacementGisement.gisement.typeGisement := Fer;
  emplacementGisement.gisement.mineraiPurete := 2;
  
  // Affichage des différents types d'emplacements
  // 1. Emplacement vide découvert
  afficherEmplacement(10, 5, emplacementVide);
  
  // 2. Emplacement non découvert
  afficherEmplacement(10, 12, emplacementNonDecouvert);
  
  // 3. Emplacement avec un bâtiment (HUB)
  afficherEmplacement(10, 19, emplacementBatiment);
  
  // 4. Emplacement avec un gisement de fer niveau 2
  afficherEmplacement(10, 26, emplacementGisement);
  
  // Attente de l'utilisateur avant de quitter
  readln;
  ecranDemarrage();
end.
begin
  ecranDemarrage();
  readln}
end.