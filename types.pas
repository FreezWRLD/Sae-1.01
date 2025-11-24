type
  Niveau = 1 .. 3;
  Jour = 1 .. 31;
  Mois = 1 .. 12;



    emplacement = record                                    //Une carte à jouer
      estDecouvert : Boolean;
      typeGisement : Gisement;
      batiment : Batiement;
      end;

    Batiment = record                                    //Une carte à jouer
      typeProduction : enumBatiment;
      niveau : Niveau;
      batiment : Batiement;
      end;

    emplacement = record                                    //Une carte à jouer
      estDecouvert : Boolean;
      typeGisement : Gisement;
      batiment : Batiement;
      end;
