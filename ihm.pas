unit ihm;
{$codepage utf8} 
{$mode objfpc}{$H+}

interface
uses
  SysUtils, gestionEcran, declarations, SatisfactIUTLogic, joueur;

  procedure ecranDemarrage();
  procedure ecranJeu();
  // Dans la section interface, après les autres déclarations de procédures
  procedure Afficher(element: String);
  procedure AfficherEmplacementZone(zone : _Zone);
  procedure afficherMenuTransfertQuantite(quantiteMax: integer);
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
    attendre(1000);
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
    dessinerCadreXY(75,32,125,38,simple,white,black); // Dessine le cadre pour le menu
    deplacerCurseurXY(88,34);
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
      ': '+intToStr(GetProductionEnergie()),
      ': '+intToStr(GetCoutEnergie())
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

  procedure afficherZoneActuelle();
  begin
    deplacerCurseurXY(78,2);
    couleurTexte(15);
    write('ZONE ACTUELLE : ', ZoneActuelle);
  end;

  procedure afficherDate();
  begin
    deplacerCurseurXY(153,2);
    couleurTexte(15);
    write('DATE : ', GetDate(JDate));
  end;

  procedure AfficherEmplacement1(x : integer; y : integer; emplacement : _Emplacement);
  const 
    largeurCadre = 60;
  begin
    if emplacement.estDecouvert = True then
    begin
      if emplacement.batiment.nom <> VIDE then
      begin
        dessinerCadreXY(x, y, x + L_EMPLACEMENT, y + 6, simple, LightBlue, Black);
        deplacerCurseurXY(x+7, y+2);
        write('Batiment : ', emplacement.batiment.nom);
        deplacerCurseurXY(x+7, y+4);
        write('Niveau : ', emplacement.batiment.niveau);
        if emplacement.batiment.ressourceProduite <> Aucune then
        begin
          deplacerCurseurXY(x+40, y+2);
          write('Production : ', emplacement.batiment.ressourceProduite);
        end;
        // Ajout de l'affichage de la pureté du gisement si c'est une mine
        if (emplacement.batiment.nom = MINE) and emplacement.gisement.existe then
        begin
          deplacerCurseurXY(x+40, y+4);
          write('Pureté : ', emplacement.gisement.mineraiPurete);
        end;
      end
      else
      begin
        if emplacement.gisement.existe then
        begin
          dessinerCadreXY(x, y, x + L_EMPLACEMENT, y + 6, simple, Brown, Black);
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

  procedure afficherConstruireBatiment();
  begin
    effacerTexteMenu();
      afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
        'Sélectionnez un emplacement'
      ]);
      cadrechoixmenu();
  end;

  procedure afficherConstructionReussie();
  begin
    effacerTexteMenu();
    couleurTexte(2);
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Construction réussie !',
      '',
      'Appuyez sur une touche pour continuer...'
    ]);
  end;

  procedure afficherConstructionImpossible(raison: String);
  begin
    effacerTexteMenu();
    couleurTexte(4);
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Construction impossible !',
      '',
      raison,
      '',
      'Appuyez sur une touche pour continuer...'
    ]);
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

  procedure afficherMenuTransfertZone();
  begin
    effacerTexteMenu();
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Vers quelle zone ?',
      '  1/ Base',
      '  2/ Rocheux',
      '  3/ Forêt Nordique',
      '  4/ Volcanique',
      '  5/ Désertique',
      '  0/ Retour au menu principal'
    ]);
    cadrechoixmenu();
  end;

  procedure afficherMenuTransfertRessource(page: integer);
  begin
    couleurTexte(15);
    effacerTexteMenu();
    if (page = 1) then 
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Quelle ressource transférer ?',
      '  1/ Minerai de cuivre',
      '  2/ Minerai de fer',
      '  3/ Calcaire',
      '  4/ Charbon',
      '  5/ Lingots de cuivre',
      '  6/ Autres'
    ]);
    if (page = 2) then 
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Quelle ressource transférer ?',
      '  1/ Lingots de fer',
      '  2/ Cables de cuivre',
      '  3/ Plaques de fer',
      '  4/ Tuyaux en fer',
      '  5/ Sacs de béton',
      '  6/ Autres'
    ]);
    if (page = 3) then 
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Quelle ressource transférer ?',
      '  1/ Acier',
      '  2/ Plaques renforcées',
      '  3/ Poutres industrielles',
      '  4/ Fondations',
      '  5/ Autres'
    ]);
    cadrechoixmenu();
  end;

  procedure afficherMenuTransfertQuantite(quantiteMax: integer);
  begin
    effacerTexteMenu();
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Quelle quantité transférer ?',
      '(max=' + IntToStr(quantiteMax) + ')'
    ]);
    cadrechoixmenu();
  end;

  procedure afficherMenuWiki();
  begin
    effacerTexteInventaire();
    effacerTexteMenu();
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Que voulez-vous savoir ?',
      '  1/ Les bâtiments',
      '  2/ Les productions',
      '  0/ Retour au menu principal'
    ]);
    cadrechoixmenu();
  end;

  procedure afficherWikiBatiment();
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
  end;

  procedure afficherWikiProduction();
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
  end;

  procedure affichemenuDeJeu();
  begin
    deplacerCurseurXY(X_MENU_PRINCIPALE+10, 8);
    afficherMenuDeJeu();
  end;
  

  procedure ecranJeu();
    
    begin
    effacerEcran();
    cadrePrincip();
    afficherInventaire();
    afficherZoneActuelle();
    afficherDate();
    AfficherEmplacementZone(JZones[ZoneActuelle]);
    affichemenuDeJeu();
    menuDeJeu();
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
    ColorierZone(8,8,65,70,15);ColorierZone(8,8,79,86,15);ColorierZone(8,8,89,94,15);ColorierZone(8,8,109,114,15);ColorierZone(8,8,123,126,15); //Dessin de la ligne 15
    ColorierZone(8,8,63,66,16);ColorierZone(8,8,79,82,16);ColorierZone(8,8,85,86,16);ColorierZone(8,8,89,94,16);ColorierZone(8,8,109,114,16);ColorierZone(8,8,127,130,16); //Dessin de la ligne 16
    ColorierZone(8,8,59,62,17);ColorierZone(8,8,79,86,17);ColorierZone(8,8,89,94,17);ColorierZone(8,8,109,114,17);ColorierZone(8,8,131,134,17); //Dessin de la ligne 17
    ColorierZone(8,8,55,58,18);ColorierZone(8,8,135,138,18); //Dessin de la ligne 18
    ColorierZone(8,8,53,56,19);ColorierZone(8,8,137,138,19); //Dessin de la ligne 19
    ColorierZone(8,8,51,52,20);ColorierZone(8,8,137,138,20); //Dessin de la ligne 20
    ColorierZone(8,8,51,52,21);ColorierZone(8,8,67,116,21);ColorierZone(8,8,137,138,21); //Dessin de la ligne 21
    ColorierZone(8,8,51,52,22);ColorierZone(8,8,65,66,22);ColorierZone(8,8,117,118,22);ColorierZone(8,8,137,138,22); //Dessin de la ligne 22
    ColorierZone(8,8,51,52,23);ColorierZone(8,8,65,66,23);ColorierZone(8,8,79,80,23);ColorierZone(8,8,117,118,23);ColorierZone(8,8,137,138,23); //Dessin de la ligne 23
    ColorierZone(8,8,51,52,24);ColorierZone(8,8,65,66,24);ColorierZone(8,8,117,118,24);ColorierZone(8,8,133,144,24); //Dessin de la ligne 24
    ColorierZone(8,8,51,52,25);ColorierZone(8,8,65,80,25);ColorierZone(8,8,89,104,25);ColorierZone(8,8,113,118,25);ColorierZone(8,8,133,134,25);ColorierZone(8,8,143,144,25); //Dessin de la ligne 25
    ColorierZone(8,8,51,52,26);ColorierZone(8,8,65,66,26);ColorierZone(8,8,117,118,26);ColorierZone(8,8,133,134,26);ColorierZone(8,8,143,144,26); //Dessin de la ligne 26
    ColorierZone(8,8,51,52,27);ColorierZone(8,8,65,66,27);ColorierZone(8,8,69,70,27);ColorierZone(8,8,79,92,27);ColorierZone(8,8,95,104,27);ColorierZone(8,8,107,118,27);ColorierZone(8,8,133,134,27);ColorierZone(8,8,143,144,27); //Dessin de la ligne 27
    ColorierZone(8,8,51,52,28);ColorierZone(8,8,65,66,28);ColorierZone(8,8,117,118,28);ColorierZone(8,8,133,134,28);ColorierZone(8,8,143,144,28); //Dessin de la ligne 28
    ColorierZone(8,8,51,52,29);ColorierZone(8,8,57,104,29);ColorierZone(8,8,117,118,29);ColorierZone(8,8,133,134,29);ColorierZone(8,8,143,144,29); //Dessin de la ligne 29
    ColorierZone(8,8,51,52,30);ColorierZone(8,8,55,56,30);ColorierZone(8,8,105,106,30);ColorierZone(8,8,117,118,30);ColorierZone(8,8,133,134,30);ColorierZone(8,8,143,144,30); //Dessin de la ligne 30
    ColorierZone(8,8,51,52,31);ColorierZone(8,8,55,106,31);ColorierZone(8,8,113,114,31);ColorierZone(8,8,117,118,31);ColorierZone(8,8,133,134,31);ColorierZone(8,8,143,144,31); //Dessin de la ligne 31
    ColorierZone(8,8,51,52,32);ColorierZone(8,8,63,64,32);ColorierZone(8,8,69,70,32);ColorierZone(8,8,73,74,32);ColorierZone(8,8,83,84,32);ColorierZone(8,8,87,88,32);ColorierZone(8,8,101,104,32);ColorierZone(8,8,117,118,32);ColorierZone(8,8,127,146,32); //Dessin de la ligne 32
    ColorierZone(8,8,51,52,33);ColorierZone(8,8,63,64,33);ColorierZone(8,8,69,70,33);ColorierZone(8,8,73,74,33);ColorierZone(8,8,83,84,33);ColorierZone(8,8,87,88,33);ColorierZone(8,8,103,104,33);ColorierZone(8,8,113,118,33);ColorierZone(8,8,127,128,33);ColorierZone(8,8,145,146,33); //Dessin de la ligne 33
    ColorierZone(8,8,51,52,34);ColorierZone(8,8,63,64,34);ColorierZone(8,8,69,70,34);ColorierZone(8,8,73,74,34);ColorierZone(8,8,83,84,34);ColorierZone(8,8,87,88,34);ColorierZone(8,8,103,128,34);ColorierZone(8,8,145,146,34); //Dessin de la ligne 34
    ColorierZone(8,8,51,52,35);ColorierZone(8,8,63,64,35);ColorierZone(8,8,69,70,35);ColorierZone(8,8,73,74,35);ColorierZone(8,8,83,84,35);ColorierZone(8,8,87,88,35);ColorierZone(8,8,103,104,35);ColorierZone(8,8,109,110,35);ColorierZone(8,8,115,116,35);ColorierZone(8,8,121,122,35);ColorierZone(8,8,127,128,35);ColorierZone(8,8,139,146,35); //Dessin de la ligne 35
    ColorierZone(8,8,51,52,36);ColorierZone(8,8,63,64,36);ColorierZone(8,8,69,70,36);ColorierZone(8,8,73,74,36);ColorierZone(8,8,83,84,36);ColorierZone(8,8,87,88,36);ColorierZone(8,8,103,104,36);ColorierZone(8,8,109,110,36);ColorierZone(8,8,115,116,36);ColorierZone(8,8,121,122,36);ColorierZone(8,8,127,128,36);ColorierZone(8,8,139,146,36); //Dessin de la ligne 36
    ColorierZone(8,8,51,52,37);ColorierZone(8,8,63,64,37);ColorierZone(8,8,69,70,37);ColorierZone(8,8,73,74,37);ColorierZone(8,8,83,84,37);ColorierZone(8,8,87,88,37);ColorierZone(8,8,103,104,37);ColorierZone(8,8,109,110,37);ColorierZone(8,8,115,116,37);ColorierZone(8,8,121,122,37);ColorierZone(8,8,127,128,37);ColorierZone(8,8,139,140,37);ColorierZone(8,8,145,146,37); //Dessin de la ligne 37
    ColorierZone(8,8,51,52,38);ColorierZone(8,8,63,64,38);ColorierZone(8,8,69,70,38);ColorierZone(8,8,73,74,38);ColorierZone(8,8,83,84,38);ColorierZone(8,8,87,88,38);ColorierZone(8,8,103,104,38);ColorierZone(8,8,109,110,38);ColorierZone(8,8,115,116,38);ColorierZone(8,8,121,122,38);ColorierZone(8,8,127,128,38);ColorierZone(8,8,139,140,38);ColorierZone(8,8,145,146,38); //Dessin de la ligne 38
    ColorierZone(8,8,51,146,39); //Dessin de la ligne 39 
    attendre(500);
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

  procedure afficherHistoire();
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
  end;
    
    // Dans la section implementation, avant la procédure quitterIHM
  procedure Afficher(element: String);
  begin
    case element of
      'MenuDemarrage': afficherMenuDemarrage();
      'MenuConstruction': afficherMenuConstruction();
      'ConstruireBatiment': afficherConstruireBatiment();
      'ConstructionReussie': afficherConstructionReussie();
      'ConstructionImpossible_NonDecouvert': afficherConstructionImpossible('Emplacement non découvert');
      'ConstructionImpossible_Occupe': afficherConstructionImpossible('Emplacement occupé');
      'ConstructionImpossible_RessourcesInsuffisantes': afficherConstructionImpossible('Ressources insuffisantes');
      'ConstructionImpossible_PasDeGisement': afficherConstructionImpossible('Pas de gisement présent');
      'ConstructionImpossible_GisementPresent': afficherConstructionImpossible('Gisement présent sur cet emplacement');
      'MenuChangerProduction1': afficherMenuChangerProduction(1);
      'MenuChangerProduction2': afficherMenuChangerProduction(2);
      'MenuChangerDeZone': afficherMenuChangerDeZone();
      'MenuTransfertZone': afficherMenuTransfertZone();
      'MenuTransfertRessource1': afficherMenuTransfertRessource(1);
      'MenuTransfertRessource2': afficherMenuTransfertRessource(2);
      'MenuTransfertRessource3': afficherMenuTransfertRessource(3);
      'WikiBatiment': afficherWikiBatiment();
      'WikiProduction': afficherWikiProduction();
      'MenuWiki' : afficherMenuWiki();
      'MenuJeu': afficherMenuDeJeu();
      'Histoire': afficherHistoire();
      else
        effacerEcran();
        writeln('Élément d''affichage non reconnu : ', element);
    end;
  end;
end.