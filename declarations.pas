unit declarations;
{$codepage utf8}   
interface

const
  X_MENU_PRINCIPALE = 5;
  Y_MENU_PRINCIPALE = 27;
  L_MENU = 50;
  H_MENU = 12;

  X_INVENTAIRE = 5;
  Y_INVENTAIRE = 2;
  L_INVENTAIRE = 40;
  H_INVENTAIRE = 22;

  X_AFFICHAGE = 51;
  Y_AFFICHAGE = 1;
  L_AFFICHAGE = 148;
  H_AFFICHAGE = 38;

  X_CADRECHOIX = 40;
  Y_CADRECHOIX = 36;
  L_CADRECHOIX = 10; 
  H_CADRECHOIX = 3;
  
  L_EMPLACEMENT = 70;

  NOMBRE_MAX_GISEMENTS = 3;  // Nombre maximum de gisements par zone

type

  {types Simples}
  //Date
  _Jour = 1 .. 31;
  _Mois = 1 .. 12;
  _Annee = 2000 .. 2025;

  //Niveau de gisement
  _Purete = 1 .. 3;

  //Niveau de batiment
  _Niveau = 1 .. 3;

  _Message = array of UTF8string;
  

  {Types énumérés}
  _TypeRessources = (
    Cuivre, // 1
    Fer, // 2
    Calcaire, // 3
    Charbon, // 4
    LingotCuivre, // 5
    LingotFer, // 6
    CableCuivre, // 7
    PlaqueFer, // 8
    TuyauFer, // 9
    Beton, // 10
    Acier, // 11
    PlaqueRenforcee, // 12
    PoutreIndustrielle, // 13
    Fondation, // 14
    Aucune // 15
  );


  _TypeGisement = Cuivre .. Charbon;


  _TypeZone = (
    base,
    rocheux,
    foretNordique,
    volcanique,
    desertique
  );

  _TypeBatiment = (
    HUB,
    MINE,
    CONSTRUCTEUR,
    CENTRALE,
    ASCENSEUR_ORBITAL,
    VIDE
  );

  {Types Records}
  _Date = record
    jour : _Jour;
    mois : _Mois;
    annee : _Annee;
    end;

  _Inventaire = record
    quantites : array[_TypeRessources] of Integer;
    end;

  _Gisement = record
    existe : Boolean;
    typeGisement : _TypeGisement;
    mineraiPurete : _Purete;
    end;

  _Recette = array[_TypeRessources] of Integer;

  _Batiment = record
    nom : _TypeBatiment;
    niveau : _Niveau;
    ressourceProduite : _TypeRessources;
    quantiteProduite : Integer;
    recette : _Recette; 
    energieProduite : Integer;
    recetteMK2 : _Recette;
    recetteMK3 : _Recette;
    end;

  _Emplacement = record
    estDecouvert : Boolean;
    batiment : _Batiment;
    gisement : _Gisement;
    end;



  _Zone = record
    typeZone : _TypeZone;
    emplacements: Array of _Emplacement;
    inventaire : _Inventaire;
  end;

  _EnsembleDeZones = array[_TypeZone] of _Zone;
  _ListeDeBatiments = array[0..4] of _Batiment;

  const

  DEFAULT_HUB : _Batiment = (
    nom: _TypeBatiment.HUB;
    niveau: 1;
    ressourceProduite: _TypeRessources.Aucune;
    quantiteProduite: 0;
    recette: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    energieProduite: 200;
  );

  DEFAULT_MINE : _Batiment = (
    nom: _TypeBatiment.MINE;
    niveau: 1;
    ressourceProduite: _TypeRessources.Cuivre;
    quantiteProduite: 20;
    recette: (0,0,0,0,0,0,10,0,0,0,0,0,0,0,0);  // Plaques de fer (x10)
    energieProduite: -100;
    recetteMK2: (0,0,0,0,0,0,20,0,20,0,0,0,0,0,0);  // Plaques de fer (x20), Sacs de Béton (x20)
    recetteMK3: (0,0,0,0,0,0,20,0,0,20,0,0,0,0,0);  // Plaques de fer (x20), Acier (x20)
  );

  DEFAULT_CONSTRUCTEUR : _Batiment = (
    nom: _TypeBatiment.CONSTRUCTEUR;
    niveau: 1;
    ressourceProduite: _TypeRessources.LingotCuivre;
    quantiteProduite: 0;
    recette: (10,0,0,0,0,0,10,0,0,0,0,0,0,0,0);  // Câbles (x10), Plaques (x10)
    energieProduite: -200;
    recetteMK2: (20,0,0,0,0,0,20,0,20,0,0,0,0,0,0);  // Câbles (x20), Plaques (x20), Sacs de Béton (x20)
    recetteMK3: (20,0,0,0,0,0,20,0,0,20,0,0,0,0,0);  // Câbles (x20), Plaques (x20), Acier (x20)
  );

  DEFAULT_CENTRALE : _Batiment = (
    nom: _TypeBatiment.CENTRALE;
    niveau: 1;
    ressourceProduite: _TypeRessources.Aucune;
    quantiteProduite: 0;
    recette: (30,0,0,0,0,0,10,0,20,0,0,0,0,0,0);  // Câbles (x30), Plaques (x10), Béton (x20)
    energieProduite: 1200;
  );

  DEFAULT_ASCENSEUR_ORBITAL : _Batiment = (
    nom: _TypeBatiment.ASCENSEUR_ORBITAL;
    niveau: 1;
    ressourceProduite: _TypeRessources.Aucune;
    quantiteProduite: 0;
    recette: (200,0,0,0,0,0,200,0,200,0,0,0,0,0,0);  // Câbles (x200), Plaques (x200), Béton (x200)
    energieProduite: -1000;
  );

  DEFAULT_EMPLACEMENT_VIDE : _Emplacement = (
    estDecouvert: False;
    batiment: (
      nom: _TypeBatiment.VIDE;
      niveau: 1;
      ressourceProduite: _TypeRessources.Aucune;
      quantiteProduite: 0;
      recette: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
      energieProduite: 0;
    );
    gisement: (existe: False; typeGisement: Cuivre; mineraiPurete: 1;);
  );

implementation
  

  
end.
