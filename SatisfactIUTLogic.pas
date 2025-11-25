unit SatisfactIUTLogic;
{$codepage utf8} 
interface
type

  {types Simples}
  //Date
  _Jour = 1 .. 31;
  _Mois = 1 .. 12;
  _Annee = 2020 .. 2025;

  //Niveau de gisement
  _Purete = 1 .. 3;

  //Niveau de batiment
  _Niveau = 1 .. 3;

  {Types énumérés}
  _TypeRessources = (
    MineraiCuivre,
    MineraiFer,
    Calcaire,
    Charbon,
    LingotCuivre,
    LingotFer,
    CableCuivre,
    PlaqueFer,
    TuyauFer,
    Beton,
    Acier,
    PlaqueRenforcee,
    PoutreIndustrielle,
    Fondation,
    Energie
  );

  _TypeGisement = (
    gisementCuivre,
    gisementFer,
    gisementCalcaire,
    gisementCharbon
  );

  _TypeZone = (
    base,
    rocheux,
    foretNordique,
    volcanique,
    desertique
  );

  _TypeBatiment = (
    hub,
    mine,
    constructeur,
    centrale,
    ascenseurOrbital,
    vide
  );

  _TypeEmplacement = (
    vide,
    gisement,
    batiment
  );

  {Types Records}
  _Date = record
    jour : Jour;
    mois : Mois;
    annee : Annee;
    end;

  _Inventaire = record
    quantites : array[_TypeRessources] of Integer;
    end;

  _Emplacement = record
    estDecouvert : Boolean;
    batiment : _TypeBatiment;
    gisement : _Gisement;
    end;

  _Gisement = record
    existe : Boolean;
    typeGisement : _TypeGisement;
    mineraiPurete : _Purete;
    end;

  _Recettes = record
    RessourcesEntree : array[_TypeRessources] of Integer;
    RessourcesSortie : array[_TypeRessources] of Integer;
    quantiteProduite : Integer;
    end;

  _Batiment = record
    batiment : _TypeBatiment;
    niveau : _Niveau;
    ressourceProduite : _TypeRessources;
    recette : _Recette; 
    coutEnegrie : Integer;
    end;

  _Zone = record
    typeZone : _TypeZone;
    emplacements: Array of _Emplacement;
    inventaire : _Inventaire;
  end;




  
implementation

  
  procedure explorationEmplacement(var zone : _Zone); //Explore un emplacement aléatoire dans une zone donnée
  var 
    i:Integer;
  begin
    i := Random(Length(zone.emplacements));
    if not zone.emplacements[i].estDecouvert then
      zone.emplacements[i].estDecouvert := True;
    else
    begin
      explorationEmplacement(zone); //Relance la fonction si l'emplacement est déjà découvert
    end;
  end;

  procedure jourSuivant(var date : _Date; var inventaire : _Inventaire); //Passe au jour suivant
  begin
    if date.jour < 31 then
      date.jour := date.jour + 1
    else
    begin
      date.jour := 1;
      if date.mois < 12 then
        date.mois := date.mois + 1
      else
      begin
        date.mois := 1;
        date.annee := date.annee + 1;
      end;
    end;

    for i in _TypeZone do
    begin
      for j:=0 to Length(zones[i].emplacements)-1 do
      begin
        case zones[i].emplacements[j].batiment of
          mine:
          begin
            zone[i].inventaire.quantites[zones[i].emplacements[j].batiment.ressourceProduite] := inventaire.quantites[zones[i].emplacements[j].batiment.ressourceProduite] + ((zones[i].emplacements[j].batiment.recette.production * zones[i].emplacement[j].gisement.mineraiPurete) * zones[i].emplacements[j].batiment.niveau);
          end;
          constructeur:
          begin
            zone[i].inventaire.quantites[zones[i].emplacements[j].batiment.ressourceProduite] := inventaire.quantites[zones[i].emplacements[j].batiment.ressourceProduite] + (zones[i].emplacements[j].batiment.recette.production * zones[i].emplacements[j].batiment.niveau);
          end;
          centrale:
          begin
            zone[i].inventaire.quantites[zones[i].emplacements[j].batiment.ressourceProduite] := inventaire.quantites[zones[i].emplacements[j].batiment.ressourceProduite] + (zones[i].emplacements[j].batiment.recette.production)
          end;
          
        end;
      end;
    end;
  end;

  function RandomGisement():_Gisement; //Génère 2 gisements aleatoires pour un emplacement (si gisement existe => random)
  begin
    if Random(1) = 1 then
    begin
      RandomGisement.existe:=True;
      RandomGisement.typeGisement:=_TypeGisement(Random(4));
      RandomGisement.mineraiPurete:=_Purete(Random(3));
    end
    else
    begin
      RandomGisement.existe:=False;
    end;
  end;

  function GetDate(date : _Date):String; //Retourne la date sous forme de chaîne de caractères
  begin 
    GetDate := IntToStr(date.jour) + '/' + IntToStr(date.mois) + '/' + IntToStr(date.annee);
  end;

  function InitZones():array[_TypeZone] of _Zone; //Initialise les zones avec leurs emplacements
  begin
    InitZones:=[];

    for i in _TypeZone do
    begin     
      InitZones[i].typeZone:=i;
      InitZones[i].emplacements:=[False,vide,RandomGisement()]; 
      InitZones[i].inventaire:=[]; //Initialise les emplacements par défaut, non découverts, sans batiment et avec des gisements aléatoires
    end;
  end;

  function InitDate():_Date; //Initialise la date de début du jeu
  begin
    InitDate.jour:=_Jour(Random(1,31));
    InitDate.mois:=_Mois(Random(1,12));
    InitDate.annee:=_Annee(Random(2020,2023));
  end;

  function InitRecette: _Recette;
var
  i: _TypeRessources;
begin
  for i := Low(_TypeRessources) to High(_TypeRessources) do
    InitRecette.quantites[i] := 0;
end;

end.