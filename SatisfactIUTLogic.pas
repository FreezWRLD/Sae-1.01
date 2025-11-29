unit SatisfactIUTLogic;
{$codepage utf8} 
{$mode objfpc}{$H+}
interface
uses
  sysutils, objets, declarations,gestionEcran, joueur;

  procedure explorationEmplacement(var zone : _Zone); //Explore un emplacement aléatoire dans une zone donnée
  procedure jourSuivant(var date : _Date; var inventaire : _Inventaire; ensembleDeZones : _EnsembleDeZones); //Passe au jour suivant
  function GetDate(date : _Date):String; //Retourne la date sous forme de chaîne de caractères
  function InitZones():_EnsembleDeZones; //Initialise les zones avec leurs emplacements
  function InitDate():_Date; //Initialise la date de début du jeu
  procedure menuDeJeu();
  procedure menuDemarrage();
  procedure initialiserJeu(var JDate : _Date; var ZoneActuelle : _TypeZone; var JZones : _EnsembleDeZones);
  procedure InitInventaires(var zone : _Zone);
  function GetProductionEnergie(): integer;
  function GetCoutEnergie(): integer;
implementation
uses
 ihm;

  procedure initialiserJeu(var JDate : _Date; var ZoneActuelle : _TypeZone; var JZones : _EnsembleDeZones);
  begin
    JZones := InitZones();
    JDate := InitDate();
    ZoneActuelle := base;
  end;

  procedure explorationEmplacement(var zone : _Zone); //Explore un emplacement aléatoire dans une zone donnée
  var 
    i:Integer;
    j:Integer; // Déclaration de la variable j
  begin
    i := Random(Length(zone.emplacements));
    if not zone.emplacements[i].estDecouvert then begin zone.emplacements[i].estDecouvert := True; end
    else
    begin explorationEmplacement(zone); //Relance la fonction si l'emplacement est déjà découvert
    end;

  end;

  procedure jourSuivant(var date : _Date; var inventaire : _Inventaire; ensembleDeZones : _EnsembleDeZones); //Passe au jour suivant
  var
    i:_TypeZone;
    j:Integer;
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

    for i := Low(_TypeZone) to High(_TypeZone) do
    begin
      for j:=0 to Length(ensembleDeZones[i].emplacements)-1 do
      begin
        case ensembleDeZones[i].emplacements[j].batiment.nom of
          mine:
          begin
            inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] := inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] + ((ensembleDeZones[i].emplacements[j].batiment.recette.quantiteProduite * ensembleDeZones[i].emplacements[j].gisement.mineraiPurete) * ensembleDeZones[i].emplacements[j].batiment.niveau);
          end;
          constructeur:
          begin
            inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] := inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] + (ensembleDeZones[i].emplacements[j].batiment.recette.quantiteProduite * ensembleDeZones[i].emplacements[j].batiment.niveau);
          end;
          centrale:
          begin
            inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] := inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] + (ensembleDeZones[i].emplacements[j].batiment.recette.quantiteProduite);
          end;
        end;
      end;
    end;
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
    j :Integer;
  begin
    for i in _TypeZone do
    begin     
      InitZones[i].typeZone := i;
      SetLength(InitZones[i].emplacements, 12); //Chaque zone a 12 emplacements
      InitInventaires(InitZones[i]);
      
      // Initialisation de tous les emplacements comme non découverts et vides
      for j := 0 to Length(InitZones[i].emplacements) - 1 do
      begin
        InitZones[i].emplacements[j].estDecouvert := False;
        InitZones[i].emplacements[j].batiment.nom := VIDE;
        InitZones[i].emplacements[j].batiment.niveau := 1;
        InitZones[i].emplacements[j].gisement := RandomGisement();
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
  
// Fonction pour sélectionner un emplacement
{function selectionnerEmplacement: _Emplacement;
var
  choix: integer;
  zone: _Zone;
begin
  zone := JZones[ZoneActuelle];
  repeat
    AfficherEmplacementZone(zone);  // Affiche la zone actuelle
    //writeln('Sélectionnez un emplacement (2-10) ou 0 pour annuler :');
    //writeln('(L''emplacement 1 est réservé au Hub)');
    readln(choix);
    
    if choix = 0 then
    begin
      // Retourne un emplacement vide si annulation
      selectionnerEmplacement.estDecouvert := False;
      exit;
    end;
      
    if (choix >= 2) and (choix <= 10) then
    begin
      if zone.emplacements[choix-1].estDecouvert then
        exit(zone.emplacements[choix-1])
      else
        writeln('Cet emplacement n''est pas encore découvert !');
    end
    else if choix = 1 then
      writeln('L''emplacement 1 est réservé au Hub !')
    else
      writeln('Choix invalide. Veuillez choisir un nombre entre 2 et 10.');
  until false;
end;}

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
        if zone.emplacements[choix-1].gisement.existe then
        begin
          if batiment.nom = MINE then
          begin
            zone.emplacements[choix-1].batiment := batiment;
            zone.emplacements[choix-1].batiment.ressourceProduite := zone.emplacements[choix-1].gisement.typeGisement;
          end;
        end
        else
        begin
          if batiment.nom <> MINE then
          begin
            zone.emplacements[choix-1].batiment := batiment;
          end;
        end;
      end;
    end;
  end;
  afficherEmplacementZone(zone);
  menuDeJeu();
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
        else 
          writeln('Option non valide');
      end;
    until choix = 0;
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
      case choix of 
      //1:changerProductionConstructeur(LingotCuivre);
      //2:changerProductionConstructeur(LingotFer);
      //3:changerProductionConstructeur(CableCuivre);
      //4:changerProductionConstructeur(PlaqueFer);
      //5:changerProductionConstructeur(TuyauFer);
      6:if page=1 then menuChangerProduction(2) else menuChangerProduction(1);
      0:menuDeJeu();
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
    AfficherEmplacementZone(JZones[ZoneActuelle]);
    menuDeJeu();
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
    until choix in [0 .. 5];
    //writeln(ZoneActuelle);
    //readln;
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
      7: jourSuivant(JDate, JZones[ZoneActuelle].inventaire, JZones);

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