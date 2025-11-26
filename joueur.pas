unit Joueur;

{$mode objfpc}{$H+}

interface
uses
  SysUtils, SatisfactIUTLogic, declarations, objets;

var
  JZones : _EnsembleDeZones ;
  JDate : _Date;
  JInventaire : _Inventaire;
  ZoneActuelle : _TypeZone;  // Zone actuelle du joueur

// Initialise toutes les zones du joueur
procedure initialiserZones;
  
implementation

procedure initialiserZones;
var
  i: Integer;
  emplacementVide: _Emplacement;
  gisementFer: _Gisement;
begin
  // Initialisation de l'emplacement vide
  emplacementVide.estDecouvert := False;
  emplacementVide.batiment := DEFAULT_HUB; // Valeur par défaut
  emplacementVide.gisement.existe := False;

  // Initialisation du gisement de fer
  gisementFer.existe := True;
  gisementFer.typeGisement := fer; // Correction: doit être de type _TypeGisement
  gisementFer.mineraiPurete := 1; // Pureté de base

  // Initialisation de la zone de base
  JZones[base].typeZone := base;
  SetLength(JZones[base].emplacements, 10);

  // Premier emplacement : Hub
  JZones[base].emplacements[0].estDecouvert := True;
  JZones[base].emplacements[0].batiment := DEFAULT_HUB;
  JZones[base].emplacements[0].batiment.niveau := 1;
  
  // Emplacements 1 et 2 : Gisements de fer
  for i := 1 to 2 do
  begin
    JZones[base].emplacements[i].estDecouvert := True;
    JZones[base].emplacements[i].gisement := gisementFer;
  end;
  
  // Autres emplacements : vides
  for i := 3 to 9 do
  begin
    JZones[base].emplacements[i] := emplacementVide;
  end;
  
  // Initialisation de l'inventaire de la zone de base
  for i := 0 to Ord(High(_TypeRessources)) do
    JZones[base].inventaire.quantites[_TypeRessources(i)] := 0;

  // Initialisation de la date
  JDate := InitDate();
  
  // Définir la zone de départ (base)
  ZoneActuelle := base;
  JInventaire := JZones[base].inventaire;
end;

end.