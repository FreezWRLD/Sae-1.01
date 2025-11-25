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
    nom: _TypeBatiment.hub;
    niveau: 1;
    ressourceProduite: _TypeRessources.MineraiCuivre;
    recette: (RessourcesEntree: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    coutEnegrie: 0;
  );

  mine: _Batiment = (
    nom: _TypeBatiment.mine;
    niveau: 1;
    ressourceProduite: _TypeRessources.MineraiCuivre;
    recette: (RessourcesEntree: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    coutEnegrie: 0;
  );

  constructeur: _Batiment = (
    nom: _TypeBatiment.constructeur;
    niveau: 1;
    ressourceProduite: _TypeRessources.LingotCuivre;
    recette: (RessourcesEntree: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    coutEnegrie: 0;
  );

  centrale: _Batiment = (
    nom: _TypeBatiment.centrale;
    niveau: 1;
    ressourceProduite: _TypeRessources.Acier;
    recette: (RessourcesEntree: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
    coutEnegrie: 0;
  );

implementation

function InitRecette: _Recette;
var
  i: _TypeRessources;
begin
  for i := Low(_TypeRessources) to High(_TypeRessources) do
    InitRecette.RessourcesEntree[i] := 0;
end;

function CreerRecette(ressource: _TypeRessources; quantite: Integer): _Recette;
begin
  CreerRecette := InitRecette();
  CreerRecette.RessourcesEntree[ressource] := quantite;
end;
{
initialization
  // Initialisation des recettes pour chaque bâtiment
  
  // Hub
  hub.recette := CreerRecette(_TypeRessources.resCableCuivre, 10);
  
  // Mine
  mine.recette := CreerRecette(_TypeRessources.MineraiCuivre, 10);
  
  // Constructeur
  constructeur.recette := CreerRecette(_TypeRessources.MineraiCuivre, 10);
  constructeur.recette2 := CreerRecette(_TypeRessources.resLingotFer, 10);
  
  // Centrale
  centrale.recette := CreerRecette(_TypeRessources.resLingotFer, 10);
  centrale.recette2 := CreerRecette(_TypeRessources.resBeton, 10);
}
end.