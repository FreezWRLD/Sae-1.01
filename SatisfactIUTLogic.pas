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

  _Batiment = record
    batiment : _TypeBatiment;
    niveau : _Niveau;
    ressourceProduite : _TypeRessources;
    production : Integer;  //Recette du batiment ex: 20 plaques de cuivres
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
  _Annee = 2020 .. 2025;

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
      RandomGisement.mineraiPurete:=_Purete(Random(3));
    end
    else
    begin
      RandomGisement.existe:=False;
    end;
  end;

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

  procedure jourSuivant(var date : _Date); //Passe au jour suivant
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

  function InitDate():_Date; //Initialise la date de début du jeu
  begin
    InitDate.jour:=_Jour(Random(1,31));
    InitDate.mois:=_Mois(Random(1,12));
    InitDate.annee:=_Annee(Random(2020,2025));
  end;

end.