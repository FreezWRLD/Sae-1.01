unit SatisfactIUTLogic;
{$codepage utf8} 
{$mode objfpc}{$H+}
interface
uses
  sysutils, objets, declarations,gestionEcran;

  procedure explorationEmplacement(var zone : _Zone); //Explore un emplacement aléatoire dans une zone donnée
  procedure jourSuivant(var date : _Date; var inventaire : _Inventaire; ensembleDeZones : _EnsembleDeZones); //Passe au jour suivant
  function GetDate(date : _Date):String; //Retourne la date sous forme de chaîne de caractères
  function InitZones():_EnsembleDeZones; //Initialise les zones avec leurs emplacements
  function InitDate():_Date; //Initialise la date de début du jeu
  procedure menuDeJeu();
  procedure choixmenudemarrage();

implementation
uses
 ihm;

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
  end;

  procedure InitInventaires(var zone : _Zone);
  var
    i:_TypeRessources;
  begin
    for i := Low(_TypeRessources) to High(_TypeRessources) do
    begin
      zone.inventaire.quantites[i] := 0;
    end;
  end;

  function InitZones():_EnsembleDeZones; //Initialise les zones avec leurs emplacements
  var
    i:_TypeZone;
    j :Integer;
  begin
    for i in _TypeZone do
    begin     
      InitZones[i].typeZone:=i;
      SetLength(InitZones[i].emplacements, 12); //Chaque zone a 12 emplacements
      InitInventaires(InitZones[i]);
      for j:=1 to Length(InitZones[i].emplacements)-1 do
      begin
        InitZones[i].emplacements[j].estDecouvert := False;
        InitZones[i].emplacements[j].gisement := RandomGisement();
      end;
    end;
    InitZones[base].emplacements[0].estDecouvert := True; //Le premier emplacement de la zone de base est toujours découvert
    InitZones[base].emplacements[0].batiment := DEFAULT_HUB; //Le premier emplacement de la zone de base contient toujours le hub
  end;

  function InitDate():_Date; //Initialise la date de début du jeu
  begin
    InitDate.jour:=_Jour(Random(31));
    InitDate.mois:=_Mois(Random(12));
    InitDate.annee:=_Annee(Random(2023));
  end;

  procedure menuDeJeu();
  var
    choix: integer;
  begin
  repeat
    cadrechoixmenu();
    readln(choix);
    case choix of
      1: menuConstruction(); // 1/ Construire un bâtiment
      2: menuProductionConstructeur(); // 2/ Changer la production
      // 3/ Améliorer un bâtiment
      // 4/ Explorer la zone
      //4 : explorationEmplacement(JZones[ZoneActuelle]);
      // 5/ Changer de zone
      // 6/ Transférer des ressources
      // 7/ Passer la journée 
      //7: jourSuivant(JDate, JInventaire, JZones);
      // 8/ Missions
      9: afficherWiki(); // 9/ Wiki
      0: ecranDemarrage(); // 0/ Quitter la partie
    end;
  until choix in[0..9];
  end;

  procedure choixmenudemarrage();
  var 
    choix: Integer;
  begin
    readln(choix);
    repeat                   // Choix du menu jusqu'a que le choix soit égale à 1 ou 2
      case choix of
        1:histoire();
        2:  
      end;
    until (choix=1) OR (choix=2);
  end; 

  end.