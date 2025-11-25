unit SatisfactIUTLogic;

interface

  
implementation
type
  {Types Records}
  _Date = record
    jour : Jour,
    mois : Mois,
    annee : Annee,
    end;

  _Recette = record
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
    end;

  _Batiment = record
    batiment : _TypeBatiment;
    niveau : _Niveau;
    ressourceProduite : _TypeRessources;
    mineraiPurete : _Purete,              // SI MINERAI
    recette1 : _recette;  //Recette du batiment ex: 20 plaques de cuivres
    recette2 : _recette;
    recette3 : _recette;
    coutEnegrie : Integer;
    end;

  _Zone = record
    typeZone : _TypeZone;
    emplacements: Array of _Emplacement;
  end;

  {types Simples}
  //Date
  _Jour = 1 .. 31;
  _Mois = 1 .. 12;
  _Annee = 1000 .. 2025;

  //Niveau de gisement
  _Purete = 1 .. 3;

  //Niveau de batiment
  _Niveau = 1 .. 3;

  {Types énumérés}
  _TypeRessources = (
    resMineraiCuivre,
    resMineraiFer,
    resCalcaire,
    resCharbon,
    resLingotCuivre,
    resLingotFer,
    resCableCuivre,
    resPlaqueFer,
    resTuyauFer,
    resBeton,
    resAcier,
    resPlaqueRenforcee,
    resPoutreIndustrielle,
    resFondation
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
  
  function RandomGisement():_Gisement; //Génère 2 gisements aleatoires pour un emplacement (si gisement existe => random)
  begin
    if Random(1) = 1 then
    begin
      RandomGisement.existe:=True;
      RandomGisement.typeGisement:=_TypeGisement(Random(4));
    end
    else
    begin
      RandomGisement.existe:=False;
    end;
  end;

  procedure exploration(var zone : _Zone);
  var 
    i:Integer;
  begin
    i := Random(Length(zone.emplacements));
    if not zone.emplacements[i].estDecouvert then
      zone.emplacements[i].estDecouvert := True;
    else
    begin
      exploration(zone);
    end;
  end;

  function InitZones():array[_TypeZone] of _Zone; //Initialise les zones avec leurs emplacements
  var 
    zoneDeBase:_Zone;
  begin
    InitZones:=[];

    for i in _TypeZone do
    begin     
      InitZones[i].typeZone:=i;
      InitZones[i].emplacements:=[False,vide,RandomGisement()]; //Initialise les emplacements par défaut, non découverts, sans batiment et avec des gisements aléatoires
    end;
  end;
end.