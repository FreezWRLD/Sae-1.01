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
    tz: _TypeZone;
    i: Integer;
    emplacementVide: _Emplacement;
  begin
    // Initialisation de l'emplacement vide
    emplacementVide.estDecouvert := False;
    emplacementVide.batiment := DEFAULT_HUB; // Valeur par défaut, sera écrasée
    emplacementVide.gisement.existe := False;

    // Initialisation de chaque type de zone
    for tz := Low(_TypeZone) to High(_TypeZone) do
    begin
      // Initialisation de la zone
      JZones[tz].typeZone := tz;
      
      // Initialisation des emplacements (10 par défaut)
      SetLength(JZones[tz].emplacements, 10);
      for i := 0 to High(JZones[tz].emplacements) do
      begin
        JZones[tz].emplacements[i] := emplacementVide;
      end;
      
      // Initialisation de l'inventaire vide
      for i := 0 to Ord(High(_TypeRessources)) do
      begin
        JZones[tz].inventaire.quantites[_TypeRessources(i)] := 0;
      end;
    end;
    
    // Configuration spécifique pour la zone de base
    with JZones[base] do
    begin
      // Découverte de la zone de base
      emplacements[0].estDecouvert := True;
      
      // Ajout du hub dans la première case
      emplacements[0].batiment := DEFAULT_HUB;
      emplacements[0].batiment.niveau := 1; // Niveau initial du hub
      
      // Découverte de la zone rocheuse adjacente
      JZones[rocheux].emplacements[0].estDecouvert := True;
    end;
    
    // Initialisation de la date
    JDate := InitDate();
    
    // Initialisation de l'inventaire
    JInventaire := JZones[base].inventaire;
    
    // Définir la zone de départ (base)
    ZoneActuelle := base;
  end;

  

end.