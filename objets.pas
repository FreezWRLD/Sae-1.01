unit objets;
{$codepage utf8} 
interface

uses types;

  // Fonction pour initialiser une recette vide
  function InitRecette: _Recette;
  
  // Fonction pour créer une recette simple avec une seule ressource
  function CreerRecette(ressource: _TypeRessources; quantite: Integer): _Recette;
const
  // Déclaration des constantes de bâtiments
  hub: _Batiment = (
    batiment: _TypeBatiment.hub;
    niveau: 1;
    ressourceProduite: _TypeRessources.resMineraiCuivre;
    mineraiPurete: 1;
    recette1: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    recette2: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    recette3: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    coutEnegrie: 0;
  );

  mine: _Batiment = (
    batiment: _TypeBatiment.mine;
    niveau: 1;
    ressourceProduite: _TypeRessources.resMineraiCuivre;
    mineraiPurete: 1;
    recette1: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    recette2: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    recette3: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    coutEnegrie: 0;
  );

  constructeur: _Batiment = (
    batiment: _TypeBatiment.constructeur;
    niveau: 1;
    ressourceProduite: _TypeRessources.resLingotCuivre;
    mineraiPurete: 1;
    recette1: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    recette2: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    recette3: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    coutEnegrie: 0;
  );

  centrale: _Batiment = (
    batiment: _TypeBatiment.centrale;
    niveau: 1;
    ressourceProduite: _TypeRessources.resAcier;
    mineraiPurete: 1;
    recette1: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    recette2: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    recette3: (quantites: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    coutEnegrie: 0;
  );

implementation

function InitRecette: _Recette;
var
  i: _TypeRessources;
begin
  for i := Low(_TypeRessources) to High(_TypeRessources) do
    InitRecette.quantites[i] := 0;
end;

function CreerRecette(ressource: _TypeRessources; quantite: Integer): _Recette;
begin
  CreerRecette := InitRecette();
  CreerRecette.quantites[ressource] := quantite;
end;

initialization
  // Initialisation des recettes pour chaque bâtiment
  
  // Hub
  hub.recette1 := CreerRecette(_TypeRessources.resCableCuivre, 10);
  
  // Mine
  mine.recette1 := CreerRecette(_TypeRessources.resMineraiCuivre, 10);
  
  // Constructeur
  constructeur.recette1 := CreerRecette(_TypeRessources.resMineraiCuivre, 10);
  constructeur.recette2 := CreerRecette(_TypeRessources.resLingotFer, 10);
  
  // Centrale
  centrale.recette1 := CreerRecette(_TypeRessources.resLingotFer, 10);
  centrale.recette2 := CreerRecette(_TypeRessources.resBeton, 10);

end.