unit ihm;
{$codepage utf8} 
{$mode objfpc}{$H+}

interface
uses
  SysUtils, gestionEcran, declarations, SatisfactIUTLogic, joueur;

  procedure ecranDemarrage();
  procedure histoire();
  procedure ecranJeu();
  
  procedure afficherMenuDeJeu();
  
  procedure afficherMenuConstruction();
  procedure afficherMenuChangerProduction(page:integer);
  procedure afficherWiki();

  procedure AfficherEmplacementZone(zone : _Zone);
  procedure AfficherEmplacement1(x : integer; y : integer; emplacement : _Emplacement);
  procedure afficherMenuChangerDeZone();
  procedure afficherMenuDemarrage();
  procedure quitterIHM();
implementation

  //Affichage d'un message de fin
  procedure quitterIHM();
  var
    x,y,x2,y2,xtext,ytext : integer;
  begin
    effacerEcran();
    x := (199 div 2 ) - 15 ;
    y := (39 div 2 ) - 2 ;
    x2 := (199 div 2 ) + 15;
    y2 := (39 div 2 ) + 2;
    xtext := x + (32-Length('AU REVOIR')) div 2;
    ytext := y + 2;
    dessinerCadreXY(x, y, x2, y2, double, white, black);
    deplacerCurseurXY(xtext, ytext);
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

  procedure effacerTexteMenu();
  begin
    effacerZoneDeTexte(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, L_MENU-X_MENU_PRINCIPALE, H_MENU);
  end;

  procedure effacerTexteInventaire();
  begin
    effacerZoneDeTexte(X_INVENTAIRE,Y_INVENTAIRE,L_INVENTAIRE,H_INVENTAIRE);
  end;

  procedure effacerTexteAffichage();
  begin
    effacerZoneDeTexte(X_AFFICHAGE,Y_AFFICHAGE,L_AFFICHAGE,H_AFFICHAGE);
  end;

  procedure effacerTexteCadreChoix();
  begin
    effacerZoneDeTexte(X_CADRECHOIX,Y_CADRECHOIX,L_CADRECHOIX,H_CADRECHOIX);
  end;

  procedure cadrechoixmenu();
  begin
    effacerTexteCadreChoix();
    couleurTexte(15);
    dessinerCadreXY(40,36,49,38,simple,white,black);
    deplacerCurseurXY(44,37);
  end;

  procedure afficherMenuDemarrage();
  begin
    dessinerCadreXY(75,32,125,38,simple,white,black); //au niveau du texte "appuyez sur une touche pour continuer" // Dessine le cadre pour le menu
    deplacerCurseurXY(88,34); // Crée le menu
    afficheLigneParLigne(88,34, [
      'Menu principal',
      '1/ Commencer la partie',
      '2/ Quitter'
    ]);
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
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[Cuivre]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[Fer]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[Calcaire]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[Charbon]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[LingotCuivre]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[LingotFer]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[CableCuivre]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[PlaqueFer]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[TuyauFer]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[Beton]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[Acier]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[PlaqueRenforcee]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[PoutreIndustrielle]),
      ': '+intToStr(JZones[ZoneActuelle].inventaire.quantites[Fondation])
    ]);
  end;

  procedure AfficherEmplacement1(x : integer; y : integer; emplacement : _Emplacement);
  const 
    largeurCadre = 60;
  begin
    if emplacement.estDecouvert = True then
    begin
      if emplacement.batiment.nom <> VIDE then
      begin
        dessinerCadreXY(x, y, x + L_EMPLACEMENT, y + 6, simple, White, Black);
        deplacerCurseurXY(x+10, y+2);
        write('Batiment : ', emplacement.batiment.nom);
        deplacerCurseurXY(x+10, y+4);
        write('Niveau : ', emplacement.batiment.niveau);
        deplacerCurseurXY(x+30, y+2);
        write('Production : ', emplacement.batiment.ressourceProduite);
      end
      else
      begin
        if emplacement.gisement.existe then
        begin
          dessinerCadreXY(x, y, x + L_EMPLACEMENT, y + 6, simple, White, Black);
          deplacerCurseurXY(x+10, y+2);
          write('Gisement non exploité : ', emplacement.gisement.typeGisement);
          deplacerCurseurXY(x+10, y+4);
          write('Purete : ', emplacement.gisement.mineraiPurete);
        end
        else
        begin
          dessinerCadreXY(x, y, x + L_EMPLACEMENT, y + 6, simple, White, Black);
          deplacerCurseurXY(x + (L_EMPLACEMENT - Length('EMPLACEMENT VIDE')) div 2, y + 3);
          write('EMPLACEMENT VIDE');
        end;
      end;
    end
    else
    begin
      dessinerCadreXY(x, y, x + L_EMPLACEMENT, y + 6, simple, DarkGray, Black);
      deplacerCurseurXY(x + (L_EMPLACEMENT - Length('EMPLACEMENT NON DECOUVERT')) div 2, y + 3);
      write('EMPLACEMENT NON DECOUVERT');
    end;
  end;

  procedure AfficherEmplacementZone(zone : _Zone);
  var 
    x, y : integer;
  begin
    x := L_MENU+2;
    y := 4;
    
    for i := 0 to 4 do
    begin
      AfficherEmplacement1(x,y,zone.emplacements[i]);
      y := y+7;
    end;

    x := L_MENU +2 + L_EMPLACEMENT +5;
    y := 4;

    for i := 5 to 9 do
    begin
      AfficherEmplacement1(x,y,zone.emplacements[i]);
      y := y+7;
    end;
  end;

  procedure cadrePrincip();
  begin
    dessinerCadreXY(0,0,L_MENU,39,simple,white,black);
    dessinerCadreXY(50,0,199,39,simple,white,black);
  end;

  procedure afficherMenuDeJeu();
    begin
      couleurTexte(15);
      effacerTexteMenu();
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


  procedure afficherMenuConstruction();
    begin
      couleurTexte(15);
      effacerTexteMenu();
      afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
        'Quel bâtiment voulez-vous construire ?',
        '  1/ Construire une mine',
        '  2/ Construire un constructeur',
        '  3/ Construire une centrale',
        '  4/ Construire l''ascenseur orbital'
      ]);
      cadrechoixmenu();
    end;

  procedure afficherMenuChangerProduction(page:integer);
  begin
    couleurTexte(15);
    effacerTexteMenu();
    if (page = 1) then 
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Que doit produire le constructeur ?',
      '  1/ Lingots de cuivre',
      '  2/ Lingots de fer',
      '  3/ Cables de cuivre',
      '  4/ Plaques de fer',
      '  5/ Tuyaux en fer',
      '  6/ Autres'
    ]);
    if (page = 2) then 
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Que doit produire le constructeur ?',
      '  1/ Sacs de béton',
      '  2/ Acier',
      '  3/ Plaques renforcées',
      '  4/ Poutres industrielles',
      '  5/ Fondations',
      '  6/ Autres'
    ]);
    cadrechoixmenu();
  end;

  procedure afficherMenuChangerDeZone();
  begin
    effacerTexteMenu();
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Quelle zone voulez-vous visiter ?',
      '  1/ Base',
      '  2/ Rocheux',
      '  3/ Forêt Nordique',
      '  4/ Volcanique',
      '  5/ Désertique',
      '  0/ Retour au menu principal'
    ]);
    cadrechoixmenu();
  end;

  procedure wikibat();
  begin
    effacerTexteAffichage();
    afficheLigneParLigne(65,5,[
      'Mine Mk.',
      '   - Coût de construction : Plaques de fer (x10)',
      '   - Energie consommée : 100',
      '   - Coût d''amélioration niv 2 : Plaques de fer (x20) / Sacs de Béton (x20)',
      '   - Coût d''amélioration niv 3 : Plaques de fer (x20) / Acier (x20)',
      '',
      'Constructeur',
      '   - Coût de construction : Cables de cuivre (x10) / Plaques de fer (x10)',
      '   - Energie consommée : 200',
      '   - Coût d''amélioration niv 2 : Plaques de fer (x20) / Sacs de Béton (x20)',
      '   - Coût d''amélioration niv 3 : Plaques de fer (x20) / Acier (x20)',
      '',
      'HUB',
      '   - Energie consommée : 100',
      '',
      'Centrale électrique',
      '   - Coût de construction : Cables de cuivre (x30) / Plaques de fer (x10) / Sacs de Béton (x20)',
      '   - Energie produite : 1200',
      '',
      'Ascenseur orbital',
      '   - Coût de construction : Cables de cuivre (x200) / Plaques de fer (x200) / Sacs de Béton (x200)',
      '   - Energie consommée : 1000'
    ]);
    afficherWiki();
  end;

  procedure wikiprod();
  begin
    effacerTexteAffichage();
    afficheLigneParLigne(55,4,[
      'Lingots de cuivre',
      '   - Quantité produite par lot : 15',
      '   - Ressources nécessaires : Minerai de cuivre (x30)',
      '',
      '',
      'Lingots de fer',
      '   - Quantité produite par lot : 15',
      '   - Ressources nécessaires : Minerai de fer (x30)',
      '',
      '',
      'Cables de cuivre',
      '   - Quantité produite par lot : 5',
      '   - Ressources nécessaires : Lingots de cuivre (x15)',
      '',
      '',
      'Plaques de fer',
      '   - Quantité produite par lot : 10',
      '   - Ressources nécessaires : Lingots de fer (x60)',
      '',
      '',
      'Tuyaux en fer',
      '   - Quantité produite par lot : 10',
      '   - Ressources nécessaires : Lingots de fer (x30)',
      '',
      '',
      'Sacs de Béton',
      '   - Quantité produite par lot : 5',
      '   - Ressources nécessaires : Calcaire (x15)',
      '',
      '',
      'Acier',
      '   - Quantité produite par lot : 15',
      '   - Ressources nécessaires : Minerai de fer (x30) / Charbon (x15)'
    ]);
    afficheLigneParLigne(120,4,[
      'Plaques renforcées',
      '   - Quantité produite par lot : 2',
      '   - Ressources nécessaires : Plaques de fer (x20) / Acier (x20)',
      '',
      '',
      'Poutres industrielles',
      '   - Quantité produite par lot : 2',
      '   - Ressources nécessaires : Plaques de fer (x20) / Sacs de Béton (x15)',
      '',
      '',
      'Fondations',
      '   - Quantité produite par lot : 2',
      '   - Ressources nécessaires : Sacs de Béton (x30)'
    ]);
    afficherWiki();
  end;

  procedure afficherWiki();
  var
    choix:Integer; //Correspondant au choix de l'utilisateur dans le menu wiki
  begin
    effacerTexteInventaire();
    effacerTexteMenu();
    afficheLigneParLigne(X_MENU_PRINCIPALE,Y_MENU_PRINCIPALE,[
      'Que veux-tu faire ?',
      '  1/ Voir la liste des bâtiments',
      '  2/ Voir la liste des productions',
      '  3/ Quitter le wiki'
    ]);
    cadrechoixmenu();
    readln(choix);
    repeat
    case choix of
      1:wikibat();
      2:wikiprod();
      3:ecranJeu();
    end;
  until (choix=1)OR(choix=2)OR(choix=3);
  end;

  procedure affichemenuDeJeu();
  begin
    deplacerCurseurXY(X_MENU_PRINCIPALE+10, 8);
    afficherMenuDeJeu();
    menuDeJeu();
  end;
  

  procedure ecranJeu();
    
    begin
    effacerEcran();
    cadrePrincip();
    afficherInventaire();
    AfficherEmplacementZone(JZones[ZoneActuelle]);
    affichemenuDeJeu();
    end;

  procedure dessin();
  begin
    effacerEcran();
    ColorierZone(7,7,59,69,0);ColorierZone(7,7,110,119,0); //Dessin de la ligne 0
    ColorierZone(7,7,59,68,1);ColorierZone(7,7,111,120,1); //Dessin de la ligne 1
    ColorierZone(7,7,59,66,2);ColorierZone(7,7,113,120,2); //Dessin de la ligne 2
    ColorierZone(7,7,59,68,3);ColorierZone(7,7,114,121,3); //Dessin de la ligne 3
    ColorierZone(7,7,61,70,4);ColorierZone(7,7,113,122,4); //Dessin de la ligne 4
    ColorierZone(7,7,65,71,5);ColorierZone(8,8,111,126,5); //Dessin de la ligne 5
    ColorierZone(7,7,67,72,6);ColorierZone(8,8,111,112,6); ColorierZone(8,8,115,116,6);ColorierZone(8,8,121,122,6);ColorierZone(8,8,125,126,6); //Dessin de la ligne 6
    ColorierZone(7,7,65,72,7);ColorierZone(8,8,113,124,7); //Dessin de la ligne 7
    ColorierZone(7,7,65,71,8);ColorierZone(8,8,95,98,8);ColorierZone(8,8,113,114,8);ColorierZone(8,8,123,124,8); //Dessin de la ligne 8
    ColorierZone(7,7,65,70,9);ColorierZone(8,8,91,94,9);ColorierZone(8,8,99,102,9);ColorierZone(8,8,113,114,9);ColorierZone(8,8,123,124,9); //Dessin de la ligne 9
    ColorierZone(8,8,65,72,10);ColorierZone(8,8,87,90,10);ColorierZone(8,8,103,106,10);ColorierZone(8,8,113,114,10);ColorierZone(8,8,123,124,10); //Dessin de la ligne 10
    ColorierZone(8,8,65,66,11);ColorierZone(8,8,71,72,11);ColorierZone(8,8,83,86,11);ColorierZone(8,8,107,110,11);ColorierZone(8,8,113,114,11);ColorierZone(8,8,123,124,11); //Dessin de la ligne 11
    ColorierZone(8,8,65,66,12);ColorierZone(8,8,71,72,12);ColorierZone(8,8,79,82,12);ColorierZone(8,8,111,114,12);ColorierZone(8,8,123,124,12); //Dessin de la ligne 12
    ColorierZone(8,8,65,66,13);ColorierZone(8,8,71,72,13);ColorierZone(8,8,75,78,13);ColorierZone(8,8,115,118,13);ColorierZone(8,8,123,124,13); //Dessin de la ligne 13
    ColorierZone(8,8,65,66,14);ColorierZone(8,8,71,74,14);ColorierZone(8,8,119,122,14);ColorierZone(8,8,123,124,14); //Dessin de la ligne 14
  end;  
    

  procedure logo();
  begin
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
  end;
  
  procedure ecranDemarrage();
  begin
    dessin();
    logo();
    afficherMenuDemarrage();
  end;

  procedure histoire();
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
  end;
    
end.