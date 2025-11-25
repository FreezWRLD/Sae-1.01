unit types;
{$codepage utf8}   
interface
  

type
  {types Simples}
  //Date
  _Jour = 1 .. 31;
  _Mois = 1 .. 12;
  _Annee = 2025 .. 2999;

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
    resFondation,
    resEnergie
  );

  _TypeGisement = (
    gisementCuivre,
    gisementFer,
    gisementCalcaire,
    gisementCharbon
  );

    { Convertir les gisements en ressources : function RessourceDuGisement(g : _TypeGisement) : _TypeRessources;
    begin
      case g of
        gisementCuivre:   Result := resMineraiCuivre;
        gisementFer:      Result := resMineraiFer;
        gisementCalcaire: Result := resCalcaire;
        gisementCharbon:  Result := resCharbon;
      end;
    end;}

  _TypeZone = (
    base,
    rocheux,
    foretNordique
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


  {Types Records}
  _Date = record
    jour : _Jour;
    mois : _Mois;
    annee : _Annee;
    end;

  _Gisement = record
    typeGisement : _TypeGisement
    end;

  _Recette = record
    quantites : array[_TypeRessources] of Integer;
    end;
    { Exemple de definition recette:
      var
        recetteConst : _Recette;
      begin
        recetteConst.quantites[CablesDeCuivre] := 10;
        recetteConst.quantites[PlaquesDeFer] := 10;
      end;}
_Batiment = record
    batiment : _TypeBatiment;
    niveau : _Niveau;
    ressourceProduite : _TypeRessources;
    mineraiPurete : _Purete;              // SI MINERAI
    recette1 : _recette;  //Recette du batiment ex: 20 plaques de cuivres
    recette2 : _recette;
    recette3 : _recette;
    coutEnegrie : Integer;
    end;

  _Emplacement = record
    estDecouvert : Boolean;
    batiement : _typeBatiment;
    gisement : _Gisement;
    end;

  

  _Zone = record
    nom : String;
    emplacements: Array of _Emplacement;
  end; 

implementation
  

  
end.
