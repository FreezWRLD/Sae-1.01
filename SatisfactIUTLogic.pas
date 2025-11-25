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

  _Gisement = record
    typeGisement : _TypeGisement
    end;

  _Recette = record
    quantites : array[_TypeRessources] of Integer;
    end;

  _Emplacement = record
    estDecouvert : Boolean;
    batiement : typeBatiment;
    gisement : Gisement;
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
    nom : String;
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
  );

  _TypeBatiment = (
    hub,
    mine,
    constructeur,
    centrale,
    ascenseurOrbital
  );

  _TypeEmplacement = (
    vide,
    gisement,
    batiment
  );



  
end.