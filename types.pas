type
  //Simples
  Niveau = 1 .. 3;
  Jour = 1 .. 31;
  Mois = 1 .. 12;
  Annee = 1000 .. 2025;

  //Types Enumerés
  TypeRessources = (
    mineraiDeCuivre,
    mineraiDeFer,
    calcaire,
    charbon,
    lingotDeCuivre,
    lingotDeFer,
    cablesDeCuivre,
    plaquesDeFer,
    tuyauEnFer,
    sacDeBeton,
    acier,
    plaquesRenforces,
    poutresIndustrielles,
    fondations
  );

  //Records
  TypeDate = record
    jour:Jour,
    mois:Mois,
    annee:Annee
    end;

  emplacement = record                                     //Une carte à jouer
    estDecouvert : Boolean;
    typeGisement : Gisement;
    typeBatiment : Batiement;
    end;

  Batiment = record                                    //Une carte à jouer
    typeProduction : enumBatiment;
    niveau : Niveau;
    batiment : Batiement;
    end;