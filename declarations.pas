unit declarations;
{$codepage utf8}   
interface

const
  X_MENU_PRINCIPALE = 5;
  Y_MENU_PRINCIPALE = 27;
  L_MENU = 50;
  H_MENU = 12;
  
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

  _Message = array of string;
  

  {Types énumérés}
  _TypeRessources = (
    Cuivre,
    Fer,
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
    gisementCharbon,
    gisementVide
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

  _Recette = record
    RessourcesEntree : array[_TypeRessources] of Integer;
    RessourcesSortie : _TypeRessources;
    quantiteProduite : Integer;
    end;

  _Production = record
    RessourcesSortie : array[_TypeRessources] of Integer;
    quantiteProduite : Integer;
    end;

  _Batiment = record
    nom : _TypeBatiment;
    niveau : _Niveau;
    ressourceProduite : _TypeRessources;
    recette : _Recette; 
    coutEnegrie : Integer;
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
    ressourceProduite: _TypeRessources.Energie;
    recette: (RessourcesEntree: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0); RessourcesSortie: _TypeRessources.Energie; quantiteProduite: 200;);
    coutEnegrie: 0;
  );

  DEFAULT_MINE : _Batiment = (
    nom: _TypeBatiment.MINE;
    niveau: 1;
    ressourceProduite: _TypeRessources.Cuivre;
    recette: (RessourcesEntree: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0); RessourcesSortie: _TypeRessources.Cuivre; quantiteProduite: 20;);
    coutEnegrie: 20;
  );

  DEFAULT_CONSTRUCTEUR : _Batiment = (
    nom: _TypeBatiment.CONSTRUCTEUR;
    niveau: 1;
    ressourceProduite: _TypeRessources.LingotCuivre;
    recette: (RessourcesEntree: (20,0,0,0,0,0,0,0,0,0,0,0,0,0,0); RessourcesSortie: _TypeRessources.LingotCuivre; quantiteProduite: 10;);
    coutEnegrie: 30;
  );

  DEFAULT_CENTRALE : _Batiment = (
    nom: _TypeBatiment.CENTRALE;
    niveau: 1;
    ressourceProduite: _TypeRessources.Energie;
    recette: (RessourcesEntree: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0); RessourcesSortie: _TypeRessources.Energie; quantiteProduite: 100;);
    coutEnegrie: -100;
  );

  DEFAULT_ASCENSEUR_ORBITAL : _Batiment = (
    nom: _TypeBatiment.ASCENSEUR_ORBITAL;
    niveau: 1;
    ressourceProduite: _TypeRessources.Energie;
    recette: (RessourcesEntree: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0); RessourcesSortie: _TypeRessources.Energie; quantiteProduite: 0;);
    coutEnegrie: 300;
  );

  DEFAULT_EMPLACEMENT_VIDE : _Emplacement = (
    estDecouvert: False;
    batiment: (
      nom: _TypeBatiment.VIDE;
      niveau: 1;
      ressourceProduite: _TypeRessources.Energie;
      recette: (RessourcesEntree: (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0); RessourcesSortie: _TypeRessources.Energie; quantiteProduite: 0;);
      coutEnegrie: 0;
    );
    gisement: (existe: False; typeGisement: Cuivre; mineraiPurete: 1;);
  );

implementation
  

  
end.
