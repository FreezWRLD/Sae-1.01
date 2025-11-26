unit SatisfactIUTLogic;
{$codepage utf8} 
{$mode objfpc}{$H+}
interface
uses
  sysutils, objets, declarations;

  procedure lancementDeJeu();

implementation

  procedure logicMenuDemarrage();
  var
    choix:string; //Variable de type entier saisit au clavier qui correspond au choix de l'utilisateur
  begin
    repeat                   // Choix du menu jusqu'a que le choix soit égale à 1 ou 2
      readln(choix);
      if (choix = '1') then afficherHistoire() else quitterIHM();
    until (choix='1') OR (choix='2');
  end;

  procedure lancementDeJeu();
  var
      choix:string; //Variable de type entier saisit au clavier qui correspond au choix de l'utilisateur
  begin
    //afficherEcranDemarrage();
    //affiche le titre
    afficherTitre();
    //affiche le menu 1 pour lancer histoire 2 pour quitter
    //si 1 : affiche l'histoire
    afficherMenuDemarrage();
    repeat                   // Choix du menu jusqu'a que le choix soit égale à 1 ou 2
        readln(choix);
        if (choix = '1') then begin afficherEcranJeu(); end else begin quitterIHM(); end;
    until (choix='1') OR (choix='2');
      // apres afficher histoire : afficher ecranJeu
      
  end;

  
  procedure explorationEmplacement(var zone : _Zone); //Explore un emplacement aléatoire dans une zone donnée
  var 
    i:Integer;
  begin
    i := Random(Length(zone.emplacements));
    if not zone.emplacements[i].estDecouvert then begin zone.emplacements[i].estDecouvert := True; end
    else
    begin explorationEmplacement(zone); //Relance la fonction si l'emplacement est déjà découvert
    end;
  end;

  procedure jourSuivant(var date : _Date; var inventaire : _Inventaire); //Passe au jour suivant
  var
    i:_TypeZone;
    j:Integer;
    ensembleDeZones:_EnsembleDeZones;
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

    for i in _TypeZone do
    begin
      for j:=0 to Length(ensembleDeZones[i].emplacements)-1 do
      begin
      {
        case ensembleDeZones[i].emplacements[j].batiment.nom of
          mine:
          begin
            ensembleDeZones[i].inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] := inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] + ((ensembleDeZones[i].emplacements[j].batiment.recette.RessourcesSortie * ensembleDeZones[i].emplacements[j].gisement.mineraiPurete) * ensembleDeZones[i].emplacements[j].batiment.niveau);
          end;
          constructeur:
          begin
            ensembleDeZones[i].inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] := inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] + (ensembleDeZones[i].emplacements[j].batiment.recette.RessourcesSortie * ensembleDeZones[i].emplacements[j].batiment.niveau);
          end;
          centrale:
          begin
            ensembleDeZones[i].inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] := inventaire.quantites[ensembleDeZones[i].emplacements[j].batiment.ressourceProduite] + (ensembleDeZones[i].emplacements[j].batiment.recette.RessourcesSortie)
          end;
          }
        end;
      end;
    end;

  function RandomGisement():_Gisement; //Génère 2 gisements aleatoires pour un emplacement (si gisement existe => random)
  begin
    if Random(1) = 1 then
    begin
      RandomGisement.existe:=True;
      RandomGisement.typeGisement:=_TypeGisement(Random(4));
      RandomGisement.mineraiPurete:=_Purete(Random(3));
    end
    else
    begin
      RandomGisement.existe:=False;
    end;
  end;

  function GetDate(date : _Date):String; //Retourne la date sous forme de chaîne de caractères
  begin 
    GetDate := intToStr(date.jour) + '/' + intToStr(date.mois) + '/' + intToStr(date.annee);
  end;

  {function InitZones():_EnsembleDeZones; //Initialise les zones avec leurs emplacements

  var
    i:_TypeZone;
  begin
    

    for i in _TypeZone do
    begin     
      
      InitZones[i].typeZone:=i;
      InitZones[i].emplacements:=(false,vide,RandomGisement()); 
      InitZones[i].inventaire:=[]; //Initialise les emplacements par défaut, non découverts, sans batiment et avec des gisements aléatoires
      
    end;}

  function InitDate():_Date; //Initialise la date de début du jeu
  begin
    InitDate.jour:=_Jour(Random(31));
    InitDate.mois:=_Mois(Random(12));
    InitDate.annee:=_Annee(Random(2023));
  end;

  procedure InitInventaires(zone : _Zone);
  var
    i:_TypeRessources;
  begin
    for i in _TypeRessources do
    begin
      zone.inventaire.quantites[i]:=0;
    end;
  end;

  end.