unit SatisfactIUTLogic;
{$codepage utf8} 
{$mode objfpc}{$H+}
interface
uses
  sysutils, declarations,gestionEcran, joueur;

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

  // Fonction pour obtenir la quantité produite selon le type de ressource
  function ObtenirQuantiteProduite(ressource: _TypeRessources): Integer;
  begin
    case ressource of
      LingotCuivre: ObtenirQuantiteProduite := 15;
      LingotFer: ObtenirQuantiteProduite := 15;
      CableCuivre: ObtenirQuantiteProduite := 5;
      PlaqueFer: ObtenirQuantiteProduite := 10;
      TuyauFer: ObtenirQuantiteProduite := 10;
      Beton: ObtenirQuantiteProduite := 5;
      Acier: ObtenirQuantiteProduite := 15;
      PlaqueRenforcee: ObtenirQuantiteProduite := 2;
      PoutreIndustrielle: ObtenirQuantiteProduite := 2;
      Fondation: ObtenirQuantiteProduite := 2;
      else ObtenirQuantiteProduite := 0; // Pour Aucune ou autres
    end;
  end;

  // Fonction pour obtenir les ressources nécessaires à la production
  function ObtenirRecetteNecessaire(ressource: _TypeRessources): _Recette;
  var
    res: _TypeRessources;
  begin
    // Initialisation explicite de toutes les cases du tableau à 0
    for res := Low(_TypeRessources) to High(_TypeRessources) do
      ObtenirRecetteNecessaire[res] := 0;
    
    case ressource of
      LingotCuivre: ObtenirRecetteNecessaire[Cuivre] := 30;
      LingotFer: ObtenirRecetteNecessaire[Fer] := 30;
      CableCuivre: ObtenirRecetteNecessaire[LingotCuivre] := 15;
      PlaqueFer: ObtenirRecetteNecessaire[LingotFer] := 60;
      TuyauFer: ObtenirRecetteNecessaire[LingotFer] := 30;
      Beton: ObtenirRecetteNecessaire[Calcaire] := 15;
      Acier:
      begin
        ObtenirRecetteNecessaire[Fer] := 30;
        ObtenirRecetteNecessaire[Charbon] := 15;
      end;
      PlaqueRenforcee:
      begin
        ObtenirRecetteNecessaire[PlaqueFer] := 20;
        ObtenirRecetteNecessaire[Acier] := 20;
      end;
      PoutreIndustrielle:
      begin
        ObtenirRecetteNecessaire[PlaqueFer] := 20;
        ObtenirRecetteNecessaire[Beton] := 15;
      end;
      Fondation: ObtenirRecetteNecessaire[Beton] := 30;
    end;
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

  procedure miseAJourInventaire(var zone : _Zone); // Passe au jour suivant
  var
    j: Integer;
    quantiteProduction: Integer;
    batiment: _Batiment;
    ressourcesNecessaires: _Recette;
    peutProduire: Boolean;
    energieEstSuffisante: Boolean;
  begin
    // Vérifier si l'énergie est suffisante
    energieEstSuffisante := (GetProductionEnergie >= GetCoutEnergie());
    
    // Parcourir tous les emplacements de la zone
    for j := 0 to High(zone.emplacements) do
    begin
      // Vérifier si l'emplacement contient un bâtiment productif
      if (zone.emplacements[j].batiment.nom <> VIDE) and 
        (zone.emplacements[j].batiment.nom <> HUB) and
        (zone.emplacements[j].batiment.quantiteProduite > 0) then
      begin
        batiment := zone.emplacements[j].batiment;
        peutProduire := True;
        
        // Vérifier que l'énergie est suffisante
        if not energieEstSuffisante then
        begin
          peutProduire := False;
        end;
        
        // Pour les CONSTRUCTEURS : vérifier les ressources nécessaires à la production
        if peutProduire and (batiment.nom = CONSTRUCTEUR) then
        begin
          ressourcesNecessaires := ObtenirRecetteNecessaire(batiment.ressourceProduite);
          
          // Vérifier si on a assez de ressources pour produire
          if not CompareInventaireAvecRecette(zone.inventaire, ressourcesNecessaires) then
          begin
            peutProduire := False;
          end
          else
          begin
            // Déduire les ressources nécessaires à la production
            DeduireInventaire(ressourcesNecessaires, zone.inventaire);
          end;
        end;
        
        // Si production possible, calculer et ajouter
        if peutProduire then
        begin
          // Calculer la production selon le type de bâtiment
          if batiment.nom = MINE then
          begin
            // MINE : production × niveau × pureté du gisement
            quantiteProduction := 
              batiment.quantiteProduite * 
              batiment.niveau * 
              zone.emplacements[j].gisement.mineraiPurete;
          end
          else
          begin
            // CONSTRUCTEUR : production × niveau
            quantiteProduction := 
              batiment.quantiteProduite * 
              batiment.niveau;
          end;
          
          // Ajouter la production à l'inventaire de la zone
          zone.inventaire.quantites[batiment.ressourceProduite] := 
            zone.inventaire.quantites[batiment.ressourceProduite] + quantiteProduction;
        end;
      end;
    end;
  end;

  procedure passerJournee(var date : _Date; var zone : _Zone); //Passe au jour suivant
  begin
    jourSuivant(date);
    miseAJourInventaire(zone);
  end;

  function RandomGisement():_Gisement; //Génère 1 gisement aléatoire pour un emplacement (existe aléatoirement)
  begin
    if Random(2) = 1 then
    begin
      RandomGisement.existe := True;
      RandomGisement.typeGisement := _TypeGisement(Random(4));
      RandomGisement.mineraiPurete := _Purete(Random(3)+1);
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
      SetLength(InitZones[i].emplacements, 10); //Chaque zone a 10 emplacements
      InitInventaires(InitZones[i]);
      
      // Initialisation de tous les emplacements comme non découverts et vides
      nbGisements := 0;
      for j := 0 to Length(InitZones[i].emplacements) - 1 do
      begin
        InitZones[i].emplacements[j].estDecouvert := False;
        InitZones[i].emplacements[j].batiment.nom := VIDE;
        InitZones[i].emplacements[j].batiment.niveau := 1;
        
        // On ne crée un gisement que si on en a moins que le maximum défini
        if (nbGisements < NOMBRE_MAX_GISEMENTS) then
        begin
          InitZones[i].emplacements[j].gisement := RandomGisement();
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


function ChoisirEmplacement(zone: _Zone): Integer;
var
  choix: string;
begin
repeat 
  AfficherEmplacementZone(zone);
  Afficher('ChoisirEmplacement');
  readln(choix);
until (choix = '1') or (choix = '2') or (choix = '3') or (choix = '4') or (choix = '5') or (choix = '6') or (choix = '7') or (choix = '8') or (choix = '9') or (choix = '10');
  ChoisirEmplacement := StrToInt(choix) - 1;
end;


  procedure AmeliorerBatiment();
  var
    emplacementSelectionne: Integer;
    batiment: _Batiment;
    recetteAmelioration: _Recette;
    peutAmeliorer: Boolean;
  begin
    emplacementSelectionne := ChoisirEmplacement(JZones[ZoneActuelle]);
    batiment := JZones[ZoneActuelle].emplacements[emplacementSelectionne].batiment;
    peutAmeliorer := False;
    
    // Vérifier que l'emplacement est découvert
    if JZones[ZoneActuelle].emplacements[emplacementSelectionne].estDecouvert then
    begin
      // Vérifier qu'il y a un bâtiment
      if batiment.nom <> VIDE then
      begin
        // Vérifier que c'est un bâtiment améliorable
        if (batiment.nom = MINE) or (batiment.nom = CONSTRUCTEUR) or 
          (batiment.nom = CENTRALE) or (batiment.nom = ASCENSEUR_ORBITAL) then
        begin
          // Vérifier que le niveau n'est pas déjà au maximum
          if batiment.niveau < 3 then
          begin
            // Déterminer la recette selon le niveau actuel
            if batiment.niveau = 1 then
              recetteAmelioration := batiment.recetteMK2
            else
              recetteAmelioration := batiment.recetteMK3;
            
            // Vérifier les ressources
            if CompareInventaireAvecRecette(JZones[ZoneActuelle].inventaire, recetteAmelioration) then
            begin
              peutAmeliorer := True;
            end;
          end;
        end;
      end;
    end;
    
    // Si toutes les vérifications sont passées, améliorer
    if peutAmeliorer then
    begin
      JZones[ZoneActuelle].emplacements[emplacementSelectionne].batiment.niveau := 
        JZones[ZoneActuelle].emplacements[emplacementSelectionne].batiment.niveau + 1;
      
      JZones[ZoneActuelle].emplacements[emplacementSelectionne].batiment.quantiteProduite := 
        JZones[ZoneActuelle].emplacements[emplacementSelectionne].batiment.quantiteProduite + 10;
      
      DeduireInventaire(recetteAmelioration, JZones[ZoneActuelle].inventaire);
    end;
    
    ecranJeu();
  end;


  // Change le type de production d'un bâtiment et met à jour la quantité produite
  procedure ChangerProduction(var batiment: _Batiment; ressource: _TypeRessources);
  begin
    batiment.ressourceProduite := ressource;
    batiment.quantiteProduite := ObtenirQuantiteProduite(ressource);
  end;

  // Permet au joueur de choisir une production parmi les options disponibles
  function ChoisirProduction(page: Integer): _TypeRessources;
  var 
    choix: string;
    productionChoisie: _TypeRessources;
    choixValide: Boolean;
  begin
    repeat
      choixValide := True;
      Afficher('MenuChangerProduction' + IntToStr(page));
      readln(choix);
      
      if page = 1 then 
      begin
        // Gestion de la page 1 : Productions de base
        case choix of
          '1': productionChoisie := LingotCuivre;
          '2': productionChoisie := LingotFer;
          '3': productionChoisie := CableCuivre;
          '4': productionChoisie := PlaqueFer;
          '5': productionChoisie := TuyauFer;
          '6': 
            begin
              productionChoisie := ChoisirProduction(2); // Page suivante
              choixValide := True;
            end;
          '0': 
            begin
              menuDeJeu();
              choixValide := False;
            end;
          else
            choixValide := False;
        end;
      end 
      else if page = 2 then
      begin
        // Gestion de la page 2 : Productions avancées
        case choix of
          '1': productionChoisie := Beton;
          '2': productionChoisie := Acier;
          '3': productionChoisie := PlaqueRenforcee;
          '4': productionChoisie := PoutreIndustrielle;
          '5': productionChoisie := Fondation;
          '6': 
            begin
              productionChoisie := ChoisirProduction(1); // Page précédente
              choixValide := True;
            end;
          '0': 
            begin
              menuDeJeu();
              choixValide := False;
            end;
          else
            choixValide := False;
        end;
      end
      else
      begin
        // Page invalide, retour à la page 1
        productionChoisie := ChoisirProduction(1);
      end;
      
    until choixValide and (choix <> '6'); // Continue tant que choix invalide ou navigation
    
    ChoisirProduction := productionChoisie;
  end;

  procedure menuChangerProduction();
  var
    emplacement: Integer;
    ressource: _TypeRessources;
  begin
    // Sélection de l'emplacement
    emplacement := ChoisirEmplacement(JZones[ZoneActuelle]);
    
    // Vérification que l'emplacement contient bien un constructeur
    if (emplacement >= 0) and (emplacement <= High(JZones[ZoneActuelle].emplacements)) and
       (JZones[ZoneActuelle].emplacements[emplacement].batiment.nom = CONSTRUCTEUR) then
    begin
      // Sélection de la ressource
      ressource := choisirProduction(1);
      
      // Application du changement
      changerProduction(JZones[ZoneActuelle].emplacements[emplacement].batiment, ressource);
          ecranJeu();
    end
    else menuDeJeu;
  end;

procedure ConstruireBatiment(batiment: _Batiment);
var
  zone: _Zone;
  emplacementSelectionne: Integer;
  peutConstruire: Boolean;
begin
  zone := JZones[ZoneActuelle];
  emplacementSelectionne := ChoisirEmplacement(zone);
  peutConstruire := False;
  
  // Vérifier que l'emplacement est découvert
  if zone.emplacements[emplacementSelectionne].estDecouvert then
  begin
    // Vérifier que l'emplacement est vide
    if zone.emplacements[emplacementSelectionne].batiment.nom = VIDE then
    begin
      // Vérifier les ressources
      if CompareInventaireAvecRecette(JZones[ZoneActuelle].inventaire, batiment.recette) then
      begin
        // Vérifier compatibilité gisement/bâtiment
        if batiment.nom = MINE then
        begin
          if zone.emplacements[emplacementSelectionne].gisement.existe then
            peutConstruire := True;
        end
        else
        begin
          if not zone.emplacements[emplacementSelectionne].gisement.existe then
            peutConstruire := True;
        end;
      end;
    end;
  end;
  
  // Si toutes les vérifications sont passées, construire
  if peutConstruire then
  begin
    // Construire le bâtiment
    JZones[ZoneActuelle].emplacements[emplacementSelectionne].batiment := batiment;
    
    // Cas spécial MINE : assigner la ressource du gisement
    if batiment.nom = MINE then
    begin
      JZones[ZoneActuelle].emplacements[emplacementSelectionne].batiment.ressourceProduite := 
        JZones[ZoneActuelle].emplacements[emplacementSelectionne].gisement.typeGisement;
    end;
    
    // Cas spécial CONSTRUCTEUR : choisir la production
    if batiment.nom = CONSTRUCTEUR then
    begin
      ChangerProduction(
        JZones[ZoneActuelle].emplacements[emplacementSelectionne].batiment, 
        ChoisirProduction(1)
      );
    end;
    
    // Déduire les ressources de construction
    DeduireInventaire(batiment.recette, JZones[ZoneActuelle].inventaire);
  end;
  
  ecranJeu();
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

  procedure menuAmeliorerBatiment();
  var 
    choix: string;
  begin
    repeat
      Afficher('MenuAmeliorerBatiment');
      readln(choix);
      case choix of 
        '1': AmeliorerBatiment();
        '0': menuDeJeu();
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
      '2': menuChangerProduction(); 
      
      // 3/ Améliorer un bâtiment
      '3': menuAmeliorerBatiment();
      
      // 4/ Explorer la zone
      '4': menuExplorer();

      // 5/ Changer de zone
      '5': menuChangerDeZone();

      // 6/ Transférer des ressources

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