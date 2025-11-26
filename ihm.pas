unit ihm;
{$codepage utf8} 
{$mode objfpc}{$H+}

interface
uses
  SysUtils, gestionEcran, declarations, SatisfactIUTLogic, joueur;

  procedure ecranDemarrage();
  procedure afficherBatiment(x, y: integer; unBatiment: _Batiment);
  procedure afficherEmplacement(x, y: integer; const emplacement: _Emplacement);
  
implementation
  //Affichage d'un message de fin
  procedure quitterIHM();
    begin
      effacerEcran();
      dessinerCadreXY(31,13,88,15, double, white, black);
      deplacerCurseurXY(56,14);
      writeln('AU REVOIR');
      readln;
    end;

  procedure afficheLigneParLigne(x, y: integer; message: _Message);
    var
      i: integer;
    begin
      for i := 0 to High(message) do
      begin
        deplacerCurseurXY(x, y+i);
        writeln(message[i]);
      end;
    end;

  procedure effacerZoneDeTexte(x, y, largeur, hauteur: integer);
    var
      i: integer;
      lignesVides: _Message;
    begin
      SetLength(lignesVides, hauteur);
      for i := 0 to hauteur - 1 do
        lignesVides[i] := StringOfChar(' ', largeur);
      
      afficheLigneParLigne(x, y, lignesVides);
    end;
  
  procedure cadrechoixmenu();
  begin
    couleurTexte(15);
    dessinerCadreXY(40,36,49,38,simple,white,black);
    deplacerCurseurXY(44,37);
  end;

  procedure afficherMenuPrincipale();
    begin
      couleurTexte(15);
      effacerZoneDeTexte(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, L_MENU-X_MENU_PRINCIPALE, H_MENU);
      afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
        'Que voulez-vous faire ?',
        '  1/ Construire un bâtiment',
        '  2/ Changer la production',
        '  3/ Améliorer un bâtiment',
        '  4/ Explorer la zone',
        '  5/ Changer de zone',
        '  6/ Transférer des ressources',
        '  7/ Passer la journée',
        '  8/ Missions',
        '  9/ Wiki',
        '  0/ Quitter la partie'
      ]);
      cadrechoixmenu();
    end;

  procedure menuRessourcesPage1();
    begin
      couleurTexte(15);
      effacerZoneDeTexte(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, L_MENU-X_MENU_PRINCIPALE, H_MENU);
      afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
        '1/ Lingots de fer',
        '2/ Câbles de cuivre',
        '3/ Plaques de fer',
        '4/ Tuyaux en fer',
        '5/ Sacs de Béton',
        '6/ Autres'
      ]);
      cadrechoixmenu();
    end;

  procedure menuRessourcesPage2();
    begin
      couleurTexte(15);
      effacerZoneDeTexte(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, L_MENU-X_MENU_PRINCIPALE, H_MENU);
      afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
        '1/ Acier ',
        '2/ Plaques renforcecées',
        '3/ Poutres industrielles',
        '4/ Fondations',
        '5/ Autres'
      ]);
      cadrechoixmenu();
    end;


  procedure menuConstruction();
    var
      choix:integer;
    begin
    repeat
      couleurTexte(15);
      effacerZoneDeTexte(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, L_MENU-X_MENU_PRINCIPALE, H_MENU);
      afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
        'Quel bâtiment voulez-vous construire ?',
        '  1/ Construire une mine',
        '  2/ Construire un constructeur',
        '  3/ Construire une centrale',
        '  4/ Construire l''ascenseur orbital'
      ]);
      cadrechoixmenu();
      readln(choix);
    until choix in [1..4];
    end;

  procedure menuProductionConstructeur();
  begin
    couleurTexte(15);
    effacerZoneDeTexte(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, L_MENU-X_MENU_PRINCIPALE, H_MENU);
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Que doit produire le constructeur ?',
      '  1/ Lingots de cuivre',
      '  2/ Lingots de fer',
      '  3/ Cables de cuivre',
      '  4/ Plaques de fer',
      '  5/ Tuyaux en fer',
      '  6/ Autres'
    ]);
    cadrechoixmenu();
  end;

  procedure afficherInventaire();
  begin
    deplacerCurseurXY(14,2);
    couleurTexte(15);
    write('INVENTAIRE DE LA ZONE');
    deplacerCurseurXY(X_MENU_PRINCIPALE,5);
    couleurTexte(9);
    write('Marza''Coin                   : '{,valeurMarzaCoin()});
    couleurTexte(4);
    afficheLigneParLigne(X_MENU_PRINCIPALE,7,[
      'Production d''électricité',
      'Consommation d''électricité'
    ]);
    afficheLigneParLigne(34,7,[
      ': '{+valeurprodelec},
      ': '{+valeurconselec}
    ]);
    couleurTexte(15);
    afficheLigneParLigne(X_MENU_PRINCIPALE, 10, [
      'Minerai de cuivre',
      'Minerai de fer',
      'Calcaire',
      'Charbon',
      'Lingots de cuivre',
      'Lingots de fer',
      'Cables de cuivre',
      'Plaques de fer',
      'Tuyaux en fer',
      'Sacs de béton',
      'Acier',
      'Plaques renforcées',
      'Poutres industrielles',
      'Fondations'
    ]);
    afficheLigneParLigne(34,10,[
      ': '{+valeurmineraidecuivre},
      ': '{+valeurmineraidefer},
      ': '{+valeurcalcaire},
      ': '{+valeurcharbon},
      ': '{+valeurlingotsdecuivre},
      ': '{+valeurlingotsdefer},
      ': '{+valeurcablesdecuivre},
      ': '{+valeurplaquesdefer},
      ': '{+valeurtuyauxdefer},
      ': '{+valeursacsdebeton},
      ': '{+valeuracier},
      ': '{+valeurplaquesrenforcees},
      ': '{+valeurpoutresindustrielles},
      ': '{+valeurfondations}
    ]);
  end;

  procedure menuDeJeu();
  var
    choix: integer;
  begin
    deplacerCurseurXY(X_MENU_PRINCIPALE+10, 8);
    repeat
      afficherMenuPrincipale();
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
      // 9/ Wiki
      // 0/ Quitter la partie
    
      end;
    until choix in [1..10];
    end;

  

  // Fonction pour afficher un bâtiment dans un cadre formaté
// x, y : position du coin supérieur gauche du cadre
procedure afficherBatiment(x, y: integer; unBatiment: _Batiment);
  var
    largeurCadre: integer;
  begin
    largeurCadre := 70; // Largeur du cadre
    
    // Dessin du cadre
    dessinerCadreXY(x, y, x + largeurCadre, y + 6, simple, White, Black);

    deplacerCurseurXY(x + 6, y + 2);
    write('BATIMENT   : ', unBatiment.nom); 

    if unBatiment.nom <> hub then begin
      deplacerCurseurXY(x + 6, y + 3);
      write('NIVEAU     : ', unBatiment.niveau);
    end;

    if unBatiment.nom <> hub then begin
      deplacerCurseurXY(x + 6, y + 4);
      write('RESSOURCE  : ', unBatiment.ressourceProduite);
    end;

    if unBatiment.nom <> hub then begin
      deplacerCurseurXY(x + 6, y + 5);
      write('ENERGIE    : ', unBatiment.coutEnegrie);
    end;

  end;

  // Affiche un emplacement selon son état (découvert/non découvert) et son contenu
  procedure afficherEmplacement(x, y: integer; const emplacement: _Emplacement);
  var
    largeurCadre: integer;
    couleurCadre: word;
  begin
    largeurCadre := 70; // Même largeur que pour les bâtiments
    
    // Détermination de la couleur du cadre selon l'état et le contenu de l'emplacement
    if emplacement.estDecouvert then
    begin
      if (emplacement.batiment.nom = VIDE) and (not emplacement.gisement.existe) then
      begin
        // Emplacement vide découvert - fond blanc
        dessinerCadreXY(x, y, x + 70, y + 6, simple, White, Black);
        deplacerCurseurXY(x + (largeurCadre - Length('EMPLACEMENT VIDE')) div 2, y + 3);
        write('EMPLACEMENT VIDE');
      end
      else
      begin
        if emplacement.batiment.nom <> VIDE then
        begin
          // Bâtiment - contour blanc
          dessinerCadreXY(x, y, x + 70, y + 6, simple, White, Black);
          deplacerCurseurXY(x + 6, y + 2);
          write('BATIMENT    : ', emplacement.batiment.nom);
          deplacerCurseurXY(x + 6, y + 4);
          if (emplacement.batiment.nom = mine) or (emplacement.batiment.nom = constructeur) then
          write('NIVEAU      : ', emplacement.batiment.niveau);
        end
        else if emplacement.gisement.existe then
        begin
          // Gisement non exploité - marron
          dessinerCadreXY(x, y, x + 70, y + 6, simple, Brown, Black);
          deplacerCurseurXY(x + 6, y + 2);
          write('GISEMENT NON EXPLOITÉ');
          deplacerCurseurXY(x + 6, y + 4);
          write('MINERAI   : ', emplacement.gisement.typeGisement);
          deplacerCurseurXY(x + 41, y + 2);
          write('PURETE : ', emplacement.gisement.mineraiPurete);
        end;
      end;
    end
    else
    begin
      // Emplacement non découvert - gris clair
      dessinerCadreXY(x, y, x + 70, y + 6, simple, DarkGray, Black);
      deplacerCurseurXY(x + (largeurCadre - Length('EMPLACEMENT NON DECOUVERT')) div 2, y + 3);
      write('EMPLACEMENT NON DECOUVERT');
    end;
  end;

{if emplacement.estDecouvert then
begin
  if (emplacement.batiment.nom = VIDE) and (not emplacement.gisement.existe) then
  begin
    // Afficher emplacement vide
    // Exemple : Form1.Canvas.TextOut(x, y, 'Vide');
  end
  else
  begin
    if emplacement.batiment.nom <> VIDE then
    begin
      // Afficher le bâtiment
      // Exemple : Form1.Canvas.TextOut(x, y, 'Bâtiment: ' + GetBatimentNom(emplacement.batiment.nom));
    end
    else if emplacement.gisement.existe then
    begin
      // Afficher le gisement
      // Exemple : Form1.Canvas.TextOut(x, y, 'Gisement: ' + GetGisementType(emplacement.gisement.typeGisement));
    end;
  end;
end;}



















  procedure ecranJeu();
    
    begin
    dessinerCadreXY(0,0,L_MENU,39,simple,white,black);
    dessinerCadreXY(50,0,199,39,simple,white,black);
    afficherInventaire();
    menuDeJeu();
    
    end;

  procedure ecranDemarrage();
  var
    choix:integer=0; //Variable de type entier saisit au clavier qui correspond au choix de l'utilisateur
  begin
    
    ColorierZone(15,15,40,45,1);
    couleurTexte(6);
    deplacerCurseurXY(0,9);
    writeln('                   _________________________________________________________________________________________________________________________________________________________');
    writeln('                  |\________________________________________________________________________________________________________________________________________________________\');
    writeln('                  \|________________________________________________________________________________________________________________________________________________________|');
    writeln();
    writeln();
    writeln('                              ________  ________  _________  ___  ________  ________ ________  ________ _________           ___          ___  ___  ___  _________');
    writeln('                             |\   ____\|\   __  \|\___   ___\\  \|\   ____\|\  _____\\   __  \|\   ____\\___   ___\        |\  \        |\  \|\  \|\  \|\___   ___\');
    writeln('                             \ \  \___|\ \  \|\  \|___ \  \_\ \  \ \  \___|\ \  \__/\ \  \|\  \ \  \___\|___ \  \_|        \ \  \       \ \  \ \  \\\  \|___ \  \_|');
    writeln('                              \ \  \___ \ \  \_\  \   \ \  \ \ \  \ \  \____\ \  \__ \ \  \_\  \ \  \       \ \  \          \ \  \       \ \  \ \  \\\  \   \ \  \');
    writeln('                               \ \_____  \ \   __  \   \ \  \ \ \  \ \_____  \ \   __\\ \   __  \ \  \       \ \  \          \|__|        \ \  \ \  \\\  \   \ \  \');
    writeln('                                \|____|\  \ \  \ \  \   \ \  \ \ \  \|____|\  \ \  \_| \ \  \ \  \ \  \       \ \  \                       \ \  \ \  \\\  \   \ \  \');
    writeln('                                      \ \  \ \  \ \  \   \ \  \ \ \  \    \ \  \ \  \   \ \  \ \  \ \  \_____  \ \  \                       \ \  \ \       \   \ \  \');
    writeln('                                   ____\_\  \ \__\ \__\   \ \__\ \ \__\____\_\  \ \__\   \ \__\ \__\ \_______\  \ \__\                       \ \__\ \_______\   \ \__\');
    writeln('                                  |\_________\|__|\|__|    \|__|  \|__|\_________\|__|    \|__|\|__|\|_______|   \|__|                        \|__|\|_______|    \|__|');
    writeln('                                  \|_________|                        \|_________|');
    writeln();
    writeln();
    writeln('                        _________________________________________________________________________________________________________________________________________________________');
    writeln('                       |\________________________________________________________________________________________________________________________________________________________\');
    writeln('                       \|________________________________________________________________________________________________________________________________________________________|');
    writeln();
    writeln();
    writeln();
    writeln('                                                                                < Appuyez sur une touche pour continuer >');
    readln();
    dessinerCadreXY(75,32,125,38,simple,white,black); //au niveau du texte "appuyez sur une touche pour continuer" // Dessine le cadre pour le menu
    
    deplacerCurseurXY(88,34); // Crée le menu
    write('Menu principal');
    deplacerCurseurXY(88,35);
    write('1/ Commencer la partie');
    deplacerCurseurXY(88,36);
    writeln('2/ Quitter');
    
    
    readln(choix);
    repeat                   // Choix du menu jusqu'a que le choix soit égale à 1 ou 2
      case choix of
        1:
        begin
          effacerEcran();
          couleurTexte(15);
          affichageCentre('Dans une réalité. pas si alternative que ça.',3);
          affichageCentre('2024 : une année particulièrement compliquée.',5);
          affichageCentre('Suite à un mouvement de grève encore jamais vu (les Gilets Verts) pas moins de douze gouvernements',6);
          affichageCentre('se sont succédé entre janvier et mars. Oui, douze. En trois mois.',7);
          affichageCentre('L''instabilité économique provoquée par ces changements politiques incessants a plongé le pays dans',9);
          affichageCentre('une ère de chaos. Et ce qui devait arriver... arriva. Privée de toute subvention de l''État, la direc',10);
          affichageCentre('tion de l''IUT de Dijon a dû se rendre à l''évidence : à défaut d''avoir un budget, il allait falloir',11);
          affichageCentre('utiliser la seule ressource encore abondante et peu coûteuse... vous, les étudiant(e)s.',12);
          affichageCentre('Le 30 avril 2024, la direction dévoile alors une stratégie de redressement financier pour le moins',14);
          affichageCentre('novatrice : Envoyer les étudiant(e)s coloniser dautres planètes et y construire des usines de pro',15);
          affichageCentre('duction automatisées. Un moyen simple (et étonnamment peu onéreux) d''obtenir rapidement les ressour',16);
          affichageCentre('ces nécessaires à la survie de l''établissement.',17);
          affichageCentre('C''est ainsi que, le 15 septembre 2024, vous embarquez pour un voyage à destination de Mars, à bord',19);
          affichageCentre('d''une fusée baptisée "Maëlle", fièrement assemblée lors d''une SAE du département GMP. Avec pour',20);
          affichageCentre('seul(e)s compagnons la Lune, le ciel, et une check-list de sécurité rédigée par Franck Deher,',21);
          affichageCentre('vous atteignez (contre toute attente) la surface martienne sans le moindre incident majeur.',22);
          affichageCentre('Maintenant, il est temps de vous mettre au travail. L''IUT a besoin de vous !',24);
          affichageCentre('< Appuyez sur une touche pour continuer >',32);
        readln();
        effacerEcran();
        ecranJeu();
        end;
        2:  
      end;
    until (choix=1) OR (choix=2);
  end;  

  

  
end.