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
    production: integer;
  begin
    // Parcourir seulement les emplacements de la zone donnée
    for j := 0 to High(zone.emplacements) do
    begin
      // Vérifier si l'emplacement contient un bâtiment
      if zone.emplacements[j].batiment.nom <> VIDE then
      begin
        if zone.emplacements[j].batiment.nom = MINE then
        begin
          if zone.emplacements[j].gisement.existe then
          begin
            production := zone.emplacements[j].batiment.quantiteProduite * 
              zone.emplacements[j].batiment.niveau * 
              zone.emplacements[j].gisement.mineraiPurete;
          end
          else
            production := 0;
        end
        else
          production := zone.emplacements[j].batiment.quantiteProduite * 
            zone.emplacements[j].batiment.niveau;
          
        ressource := zone.emplacements[j].batiment.ressourceProduite;
          // Ajouter la production à l'inventaire 
          zone.inventaire.quantites[ressource] := 
            zone.inventaire.quantites[ressource] + production;
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
    InitDate.jour:=_Jour(Random(30)+1);
    InitDate.mois:=_Mois(Random(11)+1);
    InitDate.annee:=_Annee(Random(25)+2000);
  end;

  procedure initialiserJeu(var JDate : _Date; var ZoneActuelle : _TypeZone; var JZones : _EnsembleDeZones);
  begin
    randomize();
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
  GetCoutEnergie := -total;
end;


procedure ConstruireBatiment(batiment: _Batiment);
var
  choix: string;
  zone: _Zone;
begin
  zone := JZones[ZoneActuelle];
  AfficherEmplacementZone(zone);
  Afficher('ConstruireBatiment');
  readln(choix);

    if zone.emplacements[StrToInt(choix)-1].estDecouvert then
    begin
      if zone.emplacements[StrToInt(choix)-1].batiment.nom = VIDE then
      begin
        // Vérifier si on a les ressources nécessaires
        if CompareInventaireAvecRecette(JZones[ZoneActuelle].inventaire, batiment.recette) then
        begin
          // Pour une mine, vérifier qu'il y a un gisement
          if (batiment.nom = MINE) then
          begin
            if zone.emplacements[StrToInt(choix)-1].gisement.existe then
            begin
              zone.emplacements[StrToInt(choix)-1].batiment := batiment;
              zone.emplacements[StrToInt(choix)-1].batiment.ressourceProduite := zone.emplacements[StrToInt(choix)-1].gisement.typeGisement;
              zone.emplacements[StrToInt(choix)-1].batiment.quantiteProduite := batiment.quantiteProduite;
              DeduireInventaire(batiment.recette, JZones[ZoneActuelle].inventaire);
            end
          end
          // Pour les autres bâtiments, vérifier qu'il n'y a pas de gisement
          else if not zone.emplacements[StrToInt(choix)-1].gisement.existe then
          begin
            zone.emplacements[StrToInt(choix)-1].batiment := batiment;
            DeduireInventaire(batiment.recette, JZones[ZoneActuelle].inventaire);
          end
        end
        else
        begin
          if batiment.nom <> MINE then
          begin
            zone.emplacements[StrToInt(choix)-1].batiment := batiment;
            DeduireInventaire(batiment.recette, JZones[ZoneActuelle].inventaire);
          end;
        end;
      end;
    end;
  ecranJeu();
end;

  procedure AmeliorerBatiment(emplacement : _Emplacement);
  var
    choix: string;
  begin
    readln(choix);
    if (StrToInt(choix)>=2) and (StrToInt(choix)<=10) and (emplacement.estDecouvert) and (emplacement.batiment.nom <> VIDE) then
      begin
        if CompareInventaireAvecRecette(JZones[ZoneActuelle].inventaire, emplacement.batiment.recette) then
        begin
          emplacement.batiment.niveau := emplacement.batiment.niveau + 1;
          emplacement.batiment.quantiteProduite := emplacement.batiment.quantiteProduite + 10;
        DeduireInventaire(emplacement.batiment.recette, JZones[ZoneActuelle].inventaire);
        end;
      end;
  end;
    



  // 1 -> Menu construction
  procedure menuConstruction();
  var 
    choix: string;
  begin
    repeat
      Afficher('MenuConstruction');
      readln(choix);
      case choix of 
        '1': ConstruireBatiment(DEFAULT_MINE);
        '2': ConstruireBatiment(DEFAULT_CONSTRUCTEUR);
        '3': ConstruireBatiment(DEFAULT_CENTRALE);
        '4': ConstruireBatiment(DEFAULT_ASCENSEUR_ORBITAL);
        '0': menuDeJeu();
      end;
    until (choix = '0') OR (choix = '1') OR (choix = '2') OR (choix = '3') OR (choix = '4');
    end;

  // Sous-programmes pour changer la production du constructeur
  procedure changerProductionConstructeur(ressource: _TypeRessources);
  var
    i: integer;
  begin
    for i := 0 to High(JZones[ZoneActuelle].emplacements) do
    begin
      if JZones[ZoneActuelle].emplacements[i].batiment.nom = CONSTRUCTEUR then
        JZones[ZoneActuelle].emplacements[i].batiment.ressourceProduite := ressource;
    end;
  end;

  procedure changerProductionPage1(choix: string);
  begin
    case choix of
      '1': changerProductionConstructeur(LingotCuivre);
      '2': changerProductionConstructeur(LingotFer);
      '3': changerProductionConstructeur(CableCuivre);
      '4': changerProductionConstructeur(PlaqueFer);
      '5': changerProductionConstructeur(TuyauFer);
    end;
  end;

  procedure changerProductionPage2(choix: string);
  begin
    case choix of
      '1': changerProductionConstructeur(Beton);
      '2': changerProductionConstructeur(Acier);
      '3': changerProductionConstructeur(PlaqueRenforcee);
      '4': changerProductionConstructeur(PoutreIndustrielle);
      '5': changerProductionConstructeur(Fondation);
    end;
  end;

  procedure menuChangerProduction(page:integer);
  var 
    choix: string;
  begin
    repeat
    Afficher('MenuChangerProduction'+ IntToStr(page));
    readln(choix);
      if page = 1 then begin
        if StrToInt(choix) in [1..5] then 
        begin
          changerProductionPage1(choix);
          ecranJeu();
        end;
        case choix of 
          '6': menuChangerProduction(2);
          '0': menuDeJeu();
        end;
      end else begin
        if StrToInt(choix) in [1..5] then 
        begin
          changerProductionPage2(choix);
          ecranJeu();
        end;
        case choix of 
          '6': menuChangerProduction(1);
          '0': menuDeJeu();
        end;
      end;
    until (choix = '0') OR (choix = '6');
  end;


  procedure menuAmeliorerBatiement();
  var 
    choix: string;
  begin
    repeat
    //Afficher('MenuAmeliorerBatiement');
    readln(choix);
      case choix of 
      '0':menuDeJeu();
      end;
    until choix = '0';
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
    choix: string;
  begin
    repeat
    Afficher('MenuChangerDeZone');
    readln(choix);
      case choix of 
      '1':ZoneActuelle:=base;
      '2':ZoneActuelle:=rocheux;
      '3':ZoneActuelle:=foretNordique;
      '4':ZoneActuelle:=volcanique;
      '5':ZoneActuelle:=desertique;
      '0':menuDeJeu();
      end;
      ecranJeu();
    until (choix = '0') OR (choix = '1') OR (choix = '2') OR (choix = '3') OR (choix = '4') OR (choix = '5');
  end;

  procedure menuPasserJournee();
  begin
    passerJournee(JDate, JZones[ZoneActuelle]);
    ecranJeu();
  end;

  procedure menuWiki();
  var 
    choix: string;
  begin
  repeat
    Afficher('MenuWiki');
    readln(choix);
      case choix of 
      '1':Afficher('WikiBatiment');
      '2':Afficher('WikiProduction');
      '0':ecranJeu();
    end;
    menuWiki();
  until (choix = '0') OR (choix = '1') OR (choix = '2');
  end;

  // Procédures pour transférer les ressources
  procedure transfererRessource(ressource: _TypeRessources; quantite: integer; zoneDestination: _TypeZone);
  begin
    if JZones[ZoneActuelle].inventaire.quantites[ressource] >= quantite then
    begin
      JZones[ZoneActuelle].inventaire.quantites[ressource] := 
        JZones[ZoneActuelle].inventaire.quantites[ressource] - quantite;
      JZones[zoneDestination].inventaire.quantites[ressource] := 
        JZones[zoneDestination].inventaire.quantites[ressource] + quantite;
    end;
  end;

  procedure transfererPage1(choix: string; zoneDestination: _TypeZone; quantite: integer);
  begin
    case choix of
      '1': transfererRessource(Cuivre, quantite, zoneDestination);
      '2': transfererRessource(Fer, quantite, zoneDestination);
      '3': transfererRessource(Calcaire, quantite, zoneDestination);
      '4': transfererRessource(Charbon, quantite, zoneDestination);
      '5': transfererRessource(LingotCuivre, quantite, zoneDestination);
    end;
  end;

  procedure transfererPage2(choix: string; zoneDestination: _TypeZone; quantite: integer);
  begin
    case choix of
      '1': transfererRessource(LingotFer, quantite, zoneDestination);
      '2': transfererRessource(CableCuivre, quantite, zoneDestination);
      '3': transfererRessource(PlaqueFer, quantite, zoneDestination);
      '4': transfererRessource(TuyauFer, quantite, zoneDestination);
      '5': transfererRessource(Beton, quantite, zoneDestination);
    end;
  end;

  procedure transfererPage3(choix: string; zoneDestination: _TypeZone; quantite: integer);
  begin
    case choix of
      '1': transfererRessource(Acier, quantite, zoneDestination);
      '2': transfererRessource(PlaqueRenforcee, quantite, zoneDestination);
      '3': transfererRessource(PoutreIndustrielle, quantite, zoneDestination);
      '4': transfererRessource(Fondation, quantite, zoneDestination);
    end;
  end;

  function obtenirRessourceTransfert(page: integer; choix: string): _TypeRessources;
  begin
    case page of
      1: begin
        case choix of
          '1': Result := Cuivre;
          '2': Result := Fer;
          '3': Result := Calcaire;
          '4': Result := Charbon;
          '5': Result := LingotCuivre;
          else Result := Aucune;
        end;
      end;
      2: begin
        case choix of
          '1': Result := LingotFer;
          '2': Result := CableCuivre;
          '3': Result := PlaqueFer;
          '4': Result := TuyauFer;
          '5': Result := Beton;
          else Result := Aucune;
        end;
      end;
      3: begin
        case choix of
          '1': Result := Acier;
          '2': Result := PlaqueRenforcee;
          '3': Result := PoutreIndustrielle;
          '4': Result := Fondation;
          else Result := Aucune;
        end;
      end;
      else Result := Aucune;
    end;
  end;

  procedure menuTransfererRessource();
  var
    choixZone: string;
    choixRessource: string;
    choixQuantite: string;
    zoneDestination: _TypeZone;
    ressource: _TypeRessources;
    quantite: integer;
    quantiteMax: integer;
    pageRessource: integer;
  begin
    // Étape 1 : Choisir la zone de destination
    repeat
      Afficher('MenuTransfertZone');
      readln(choixZone);
      case choixZone of
        '1': zoneDestination := base;
        '2': zoneDestination := rocheux;
        '3': zoneDestination := foretNordique;
        '4': zoneDestination := volcanique;
        '5': zoneDestination := desertique;
        '0': begin menuDeJeu(); Exit; end;
      end;
    until (choixZone = '1') or (choixZone = '2') or (choixZone = '3') or (choixZone = '4') or (choixZone = '5');

    // Étape 2 : Choisir la ressource à transférer
    pageRessource := 1;
    repeat
      Afficher('MenuTransfertRessource' + IntToStr(pageRessource));
      readln(choixRessource);
      
      if pageRessource = 1 then begin
        if (choixRessource = '1') or (choixRessource = '2') or (choixRessource = '3') or (choixRessource = '4') or (choixRessource = '5') then begin
          ressource := obtenirRessourceTransfert(1, choixRessource);
          break;
        end;
        if choixRessource = '6' then
          pageRessource := 2
        else if choixRessource = '0' then begin
          menuDeJeu();
          Exit;
        end;
      end
      else if pageRessource = 2 then begin
        if (choixRessource = '1') or (choixRessource = '2') or (choixRessource = '3') or (choixRessource = '4') or (choixRessource = '5') then begin
          ressource := obtenirRessourceTransfert(2, choixRessource);
          break;
        end;
        if choixRessource = '6' then
          pageRessource := 3
        else if choixRessource = '0' then begin
          menuDeJeu();
          Exit;
        end;
      end
      else if pageRessource = 3 then begin
        if (choixRessource = '1') or (choixRessource = '2') or (choixRessource = '3') or (choixRessource = '4') then begin
          ressource := obtenirRessourceTransfert(3, choixRessource);
          break;
        end;
        if choixRessource = '5' then
          pageRessource := 1
        else if choixRessource = '0' then begin
          menuDeJeu();
          Exit;
        end;
      end;
    until false;

    // Étape 3 : Demander la quantité à transférer
    quantiteMax := JZones[ZoneActuelle].inventaire.quantites[ressource];
    afficherMenuTransfertQuantite(quantiteMax);
    readln(choixQuantite);
    
    if TryStrToInt(choixQuantite, quantite) and (quantite > 0) and (quantite <= quantiteMax) then
    begin
      if pageRessource = 1 then
        transfererPage1(choixRessource, zoneDestination, quantite)
      else if pageRessource = 2 then
        transfererPage2(choixRessource, zoneDestination, quantite)
      else if pageRessource = 3 then
        transfererPage3(choixRessource, zoneDestination, quantite);
    end;
    
    ecranJeu();
  end;

  procedure menuDeJeu();
  var
    choix: string;
  begin
  repeat
    Afficher('MenuJeu');
    readln(choix);
    case choix of
      // 1/ Construire un bâtiment
      '1': menuConstruction(); 
      
      // 2/ Changer la production
      '2': menuChangerProduction(1); 
      
      // 3/ Améliorer un bâtiment
      '3': menuAmeliorerBatiement();
      
      // 4/ Explorer la zone
      '4': menuExplorer();

      // 5/ Changer de zone
      '5': menuChangerDeZone();

      // 6/ Transférer des ressources
      '6': menuTransfererRessource();

      // 7/ Passer la journée 
      '7': menuPasserJournee();

      // 8/ Missions

      // 9/ Wiki
      '9': menuWiki();

      // 0/ Quitter la partie
      '0': menuDemarrage(); 
    end;
  until (choix = '0') OR (choix = '1') OR (choix = '2') OR (choix = '3') OR (choix = '4') OR (choix = '5') OR (choix = '7') OR (choix = '9');
  end;

  procedure menuDemarrage();
  var 
    choix: string;
  begin
    repeat
    ecranDemarrage();
    readln(choix);
      case choix of
        '1': 
      begin 
        Afficher('Histoire');
        ecranJeu(); 
        end;
        '2':quitterIHM();
      end;
    until (choix = '1') or (choix = '2');
  end; 

  end.