unit SatisfactIUTLogic;
{$codepage utf8} 
{$mode objfpc}{$H+}
interface
uses
  sysutils, objets, declarations,gestionEcran, joueur;

  // Fonctions utilitaires
  function GetDate(date: _Date): String;
  function GetProductionEnergie(): integer;
  function GetCoutEnergie(): integer;

  // Procédures principales
  procedure initialiserJeu(var JDate: _Date; var ZoneActuelle: _TypeZone; var JZones: _EnsembleDeZones);
  procedure menuDemarrage();
  procedure menuDeJeu();

implementation
uses
 ihm;


  procedure explorationEmplacement(var zone : _Zone); //Explore un emplacement aléatoire dans une zone donnée
  var 
    i, nbEmplacementsLibres, compteur: Integer;
  begin
    // Compter les emplacements non découverts
    nbEmplacementsLibres := 0;
    for i := 0 to High(zone.emplacements) do
    begin
      if not zone.emplacements[i].estDecouvert then
        nbEmplacementsLibres := nbEmplacementsLibres + 1;
    end;
    
    // S'il reste des emplacements à découvrir
    if nbEmplacementsLibres > 0 then
    begin
      // Choisir un nombre aléatoire entre 1 et le nombre d'emplacements libres
      nbEmplacementsLibres := Random(nbEmplacementsLibres) + 1;
      compteur := 0;
      
      // Parcourir les emplacements jusqu'à trouver le n-ième emplacement non découvert
      for i := 0 to High(zone.emplacements) do
      begin
        if not zone.emplacements[i].estDecouvert then
        begin
          compteur := compteur + 1;
          if compteur = nbEmplacementsLibres then
          begin
            zone.emplacements[i].estDecouvert := True;
            Break; // On sort de la boucle une fois l'emplacement trouvé
          end;
        end;
      end;
    end;
  end;

  procedure jourSuivant(var date : _Date);
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

  procedure miseAJourInventaire(var zone : _Zone); //Passe au jour suivant
  var
    j: Integer;
    ressource: _TypeRessources;
  begin
    // Parcourir seulement les emplacements de la zone donnée
    for j := 0 to High(zone.emplacements) do
    begin
      // Vérifier si l'emplacement contient un bâtiment
      if zone.emplacements[j].batiment.nom <> VIDE then
      begin
        ressource := zone.emplacements[j].batiment.ressourceProduite;
          // Ajouter la production à l'inventaire 
          zone.inventaire.quantites[ressource] := 
            zone.inventaire.quantites[ressource] + 
            (zone.emplacements[j].batiment.quantiteProduite * 
            zone.emplacements[j].batiment.niveau);
      end;
    end;
  end;

  procedure passerJournee(var date : _Date; var zone : _Zone); //Passe au jour suivant
  begin
    jourSuivant(date);
    miseAJourInventaire(zone);
  end;

  {function setMine(minerai : _TypeRessources):_Batiment;
  begin
    
  end;

  procedure ConstructionSurEmplacement(var emplacement : _Emplacement; batiment : _Batiment);
  begin
    if emplacement.estDecouvert then
    begin
      case batiment of
        Mine :
        begin
          emplacement.batiment := setMine();
        end;
    end;
  end;}

  function RandomGisement():_Gisement; //Génère 1 gisement aléatoire pour un emplacement (existe aléatoirement)
  begin
    if Random(2) = 1 then
    begin
      RandomGisement.existe := True;
      RandomGisement.typeGisement := _TypeGisement(Random(4));
      RandomGisement.mineraiPurete := _Purete(Random(3));
    end
    else
    begin
      RandomGisement.existe := False;
    end;
  end;

  function GetDate(date : _Date):String; //Retourne la date sous forme de chaîne de caractères
  begin 
    GetDate := intToStr(date.jour) + '/' + intToStr(date.mois) + '/' + intToStr(date.annee);
    GetDate := Format('%.2d/%.2d/%.4d', [date.jour, date.mois, date.annee])
  end;

  procedure InitInventaires(var zone : _Zone);
  var
    i:_TypeRessources;
  begin
    for i := Low(_TypeRessources) to High(_TypeRessources) do
    begin
      zone.inventaire.quantites[i] := 0;
    end;
    // Cas particulier
    zone.inventaire.quantites[CableCuivre] := 100;
    zone.inventaire.quantites[PlaqueFer] := 100;
    zone.inventaire.quantites[Beton] := 20;
  end;

  function InitZones():_EnsembleDeZones; //Initialise les zones avec leurs emplacements
  var
    i:_TypeZone;
    j, nbGisements: Integer;
  begin
    for i in _TypeZone do
    begin     
      InitZones[i].typeZone := i;
      SetLength(InitZones[i].emplacements, 12); //Chaque zone a 12 emplacements
      InitInventaires(InitZones[i]);
      
      // Initialisation de tous les emplacements comme non découverts et vides
      nbGisements := 0;
      for j := 0 to Length(InitZones[i].emplacements) - 1 do
      begin
        InitZones[i].emplacements[j].estDecouvert := False;
        InitZones[i].emplacements[j].batiment.nom := VIDE;
        InitZones[i].emplacements[j].batiment.niveau := 1;
        
        // On ne crée un gisement que si on en a moins que le maximum défini
        if (nbGisements < NOMBRE_MAX_GISEMENTS) and (Random(2) = 1) then
        begin
          InitZones[i].emplacements[j].gisement.existe := True;
          InitZones[i].emplacements[j].gisement.typeGisement := _TypeGisement(Random(4));
          InitZones[i].emplacements[j].gisement.mineraiPurete := _Purete(Random(3));
          nbGisements := nbGisements + 1;
        end
        else
          InitZones[i].emplacements[j].gisement.existe := False;
      end;
    end;
    InitZones[base].emplacements[0].estDecouvert := True; //Le premier emplacement de la zone de base est toujours découvert
    InitZones[base].emplacements[0].batiment := DEFAULT_HUB; //Le premier emplacement de la zone de base contient toujours le hub
    InitZones[base].emplacements[1].estDecouvert := True;
    InitZones[base].emplacements[2].estDecouvert := True;
  end;

  function InitDate():_Date; //Initialise la date de début du jeu
  begin
    InitDate.jour:=_Jour(Random(31));
    InitDate.mois:=_Mois(Random(12));
    InitDate.annee:=_Annee(Random(25)+2000);
  end;

  procedure initialiserJeu(var JDate : _Date; var ZoneActuelle : _TypeZone; var JZones : _EnsembleDeZones);
  begin
    JZones := InitZones();
    JDate := InitDate();
    ZoneActuelle := base;
  end;
  
  function CompareInventaireAvecRecette(inventaire : _Inventaire; recette : _Recette) : Boolean;
  var
    i : _TypeRessources;
  begin
    for i := Low(_TypeRessources) to High(_TypeRessources) do
      if inventaire.quantites[i] < recette[i] then
        Exit(False);
    CompareInventaireAvecRecette := True;
  end;

  procedure DeduireInventaire( recette : _Recette; var inventaire : _Inventaire);
  var 
    i : _TypeRessources;
  begin
    for i := Low(_TypeRessources) to High(_TypeRessources) do
      inventaire.quantites[i] := inventaire.quantites[i] - recette[i];
  end;

function GetProductionEnergie(): integer;
var 
  total : integer;
  j : Integer;
begin
  total := 0;
  for j := Low(JZones[ZoneActuelle].emplacements) to High(JZones[ZoneActuelle].emplacements) do
  begin
    if JZones[ZoneActuelle].emplacements[j].batiment.energieProduite > 0 then
      total := total + JZones[ZoneActuelle].emplacements[j].batiment.energieProduite;
  end;
  GetProductionEnergie := total;
end;

function GetCoutEnergie(): integer;
var 
  total : integer;
  j : Integer;
begin
  total := 0;
  for j := Low(JZones[ZoneActuelle].emplacements) to High(JZones[ZoneActuelle].emplacements) do
  begin
    if JZones[ZoneActuelle].emplacements[j].batiment.energieProduite < 0 then
      total := total + JZones[ZoneActuelle].emplacements[j].batiment.energieProduite;
  end;
  GetCoutEnergie := total;
end;


procedure ConstruireBatiment(batiment: _Batiment);
var
  choix: integer;
  zone: _Zone;
begin
  zone := JZones[ZoneActuelle];
  AfficherEmplacementZone(zone);
  afficherConstruireBatiment();
  readln(choix);

  if (choix >= 2) and (choix <= 10) then
  begin
    if zone.emplacements[choix-1].estDecouvert then
    begin
      if zone.emplacements[choix-1].batiment.nom = VIDE then
      begin
        // Vérifier si on a les ressources nécessaires
        if CompareInventaireAvecRecette(JZones[ZoneActuelle].inventaire, batiment.recette) then
        begin
          // Pour une mine, vérifier qu'il y a un gisement
          if (batiment.nom = MINE) then
          begin
            if zone.emplacements[choix-1].gisement.existe then
            begin
              zone.emplacements[choix-1].batiment := batiment;
              zone.emplacements[choix-1].batiment.ressourceProduite := zone.emplacements[choix-1].gisement.typeGisement;
              zone.emplacements[choix-1].batiment.quantiteProduite := batiment.quantiteProduite;
              DeduireInventaire(batiment.recette, JZones[ZoneActuelle].inventaire);
            end
          end
          // Pour les autres bâtiments, vérifier qu'il n'y a pas de gisement
          else if not zone.emplacements[choix-1].gisement.existe then
          begin
            zone.emplacements[choix-1].batiment := batiment;
            DeduireInventaire(batiment.recette, JZones[ZoneActuelle].inventaire);
          end
        end
        else
        begin
          if batiment.nom <> MINE then
          begin
            zone.emplacements[choix-1].batiment := batiment;
            DeduireInventaire(batiment.recette, JZones[ZoneActuelle].inventaire);
          end;
        end;
      end;
    end;
  end;
  ecranJeu();
end;





  // 1 -> Menu construction
  procedure menuConstruction();
  var 
    choix: integer;
  begin
    repeat
      afficherMenuConstruction();
      readln(choix);
      case choix of 
        1: ConstruireBatiment(DEFAULT_MINE);
        2: ConstruireBatiment(DEFAULT_CONSTRUCTEUR);
        3: ConstruireBatiment(DEFAULT_CENTRALE);
        4: ConstruireBatiment(DEFAULT_ASCENSEUR_ORBITAL);
        0: menuDeJeu();
      end;
    until choix in [0..4];
      //writeln(ZoneActuelle);
      //readln;
    end;

  procedure menuChangerProduction(page:integer);
  var 
    choix: integer;
  begin
    repeat
    afficherMenuChangerProduction(page);
    readln(choix);
      if page = 1 then begin
        case choix of 
          //1:changerProductionConstructeur(LingotCuivre);
          //2:changerProductionConstructeur(LingotFer);
          //3:changerProductionConstructeur(CableCuivre);
          //4:changerProductionConstructeur(PlaqueFer);
          //5:changerProductionConstructeur(TuyauFer);
          6:menuChangerProduction(2);
          0:menuDeJeu();
        end;
      end else begin
        case choix of 
          //1:changerProductionConstructeur(Beton);
          //2:changerProductionConstructeur(Acier);
          //3:changerProductionConstructeur(PlaqueRenforcee);
          //4:changerProductionConstructeur(PoutreIndustrielle);
          //5:changerProductionConstructeur(Fondation);
          6:menuChangerProduction(1);
          0:menuDeJeu();
        end;
      end;
    until choix in [0..6];
  end;


  procedure menuAmeliorerBatiement();
  var 
    choix: integer;
  begin
    repeat
    //afficherMenuAmeliorerBatiement();
    readln(choix);
      case choix of 
      0:menuDeJeu();
      end;
    until choix in [0..1];
  end;


  // 4 -> Lancer une exploration
  procedure menuExplorer();
  begin
    explorationEmplacement(JZones[ZoneActuelle]);
    passerJournee(JDate, JZones[ZoneActuelle]);
    ecranJeu();
  end;


  // 5 -> Logique du menu changer de zone
  procedure menuChangerDeZone();
  var 
    i:_TypeZone;
    choix: integer;
  begin
    repeat
    afficherMenuChangerDeZone();
    readln(choix);
      case choix of 
      1:ZoneActuelle:=base;
      2:ZoneActuelle:=rocheux;
      3:ZoneActuelle:=foretNordique;
      4:ZoneActuelle:=volcanique;
      5:ZoneActuelle:=desertique;
      0:menuDeJeu();
      end;
      ecranJeu();
    until choix in [0 .. 5];
    //writeln(ZoneActuelle);
    //readln;
  end;

  procedure menuPasserJournee();
  begin
    passerJournee(JDate, JZones[ZoneActuelle]);
    ecranJeu();
  end;


  procedure menuDeJeu();
  var
    choix: integer;
  begin
  repeat
    afficherMenuDeJeu();
    readln(choix);
    case choix of
      // 1/ Construire un bâtiment
      1: menuConstruction(); 
      
      // 2/ Changer la production
      2: menuChangerProduction(1); 
      
      // 3/ Améliorer un bâtiment
      3: menuAmeliorerBatiement();
      
      // 4/ Explorer la zone
      4: menuExplorer();

      // 5/ Changer de zone
      5: menuChangerDeZone();

      // 6/ Transférer des ressources

      // 7/ Passer la journée 
      7: menuPasserJournee();

      // 8/ Missions

      // 9/ Wiki
      9: afficherWiki(); 

      // 0/ Quitter la partie
      0: menuDemarrage(); 
    end;
  until choix in[0..9];
  end;

  procedure menuDemarrage();
  var 
    choix: Integer;
  begin
    repeat
    ecranDemarrage();
    readln(choix);
      case choix of
        1: 
      begin 
        histoire(); 
        ecranJeu(); 
        end;
        2:quitterIHM();
      end;
    until choix in[1..2];
  end; 

  end.