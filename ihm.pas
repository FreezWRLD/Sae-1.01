unit ihm;
{$codepage utf8} 
{$mode objfpc}{$H+}

interface
uses
  SysUtils, gestionEcran, declarations, SatisfactIUTLogic;

  procedure ecranDemarrage();
  
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
  
 

 procedure menu();
  var
    choix1,choix2,choix3,choix4,choix5,choix6:Integer;
  begin
  writeln('Que voulez-vous faire ?'); // Position à mettre (déplacercurseurXY)
  writeln('1/ Construire un bâtiment');
  writeln('2/ Changer la production');
  writeln('3/ Améliorer un bâtiment');
  writeln('4/ Explorer la zone');
  writeln('5/ Changer de zone');
  writeln('6/ Transférer des ressources');
  writeln('7/ Passer la journée');
  writeln('8/ Missions');
  writeln('9/ Wiki');
  writeln('0/ Quitter la partie');
    repeat
    readln(choix1);
      case choix1 of
        0:
        begin
          ecranDemarrage();
        end;
        1:
        begin
          //selectionEmplacement();
          writeln('Quel bâtiment voulez-vous construire ?');
          writeln('1/ Construire une mine');
          writeln('2/ Construire un constructeur');
          writeln('3/ Construire une centrale');
          writeln('4/ Construire l''ascenseur orbital');
          repeat
            readln(choix2);
            case choix2 of
              1:
              begin
                //construireMine();
              end;
              2:
              begin
                
              end;
              3:
              begin
                //construireCentrale();
              end;
              4:
              begin
                //construireAscenseurOrbital();
              end;
            end
          until (choix2>=1) AND (choix2<=4);
        end;
        2:
        begin
          writeln('Que doit produire le constructeur ?');
          writeln('1/ Lingots de cuivre');
          writeln('2/ Lingots de fer');
          writeln('3/ Cables de cuivre');
          writeln('4/ Plaques de fer');
          writeln('5/ Tuyaux en fer');
          writeln('6/ Autres');
          repeat
            readln(choix3);
            case choix3 of
              1:
              begin
                
              end;
              2:
              begin
                
              end;
              3:
              begin
                
              end;
              4:
              begin
                
              end;
              5:
              begin
                
              end;
              6:
              begin
                writeln('1/ Sacs de Béton');
                writeln('2/ Acier');
                writeln('3/ Plaques renforcées');
                writeln('4/ Poutres industrielles');
                writeln('5/ Fondations');
                writeln('6/ Quiter');
                repeat
                  readln(choix4);
                  case choix4 of
                    1: 
                    begin
                      
                    end;
                    2: 
                    begin
                      
                    end;
                    3: 
                    begin
                      
                    end;
                    4: 
                    begin
                      
                    end;
                    5: 
                    begin
                      
                    end;
                    6: 
                    begin
                      //ecranJeu();
                    end;
                  end;
                until (choix4>=1) AND (choix4<=6); 
              end;
            end;
          until (choix3>=1) AND (choix3<=6);
          readln(choix3);
          case choix3 of
            1: 
            begin
              
            end;
            2: 
            begin
              
            end;
            3: 
            begin
              
            end;
            4: 
            begin
              
            end;
            5: 
            begin
              
            end;
            6: 
            begin
              writeln('1/ Sacs de Béton');
              writeln('2/ Acier');
              writeln('3/ Plaques renforcées');
              writeln('4/ Poutres industrielles');
              writeln('5/ Fondations');
              writeln('6/ Quiter');
              readln(choix4);
              case choix4 of
                1: 
                begin
                  
                end;
                2: 
                begin
                  
                end;
                3: 
                begin
                  
                end;
                4: 
                begin
                  
                end;
                5: 
                begin
                  
                end;
                6: 
                begin
                  //ecranJeu();
                end;

              end;
            end;
          end;
        end;
        3: 
        begin
          //estBatiment();
        end;
        4: 
        begin
          //exploreZone();
        end;
        5: 
        begin
          writeln('Dans quelle zone voulez-vous aller ?');
          writeln('1/ Zone de départ');
          writeln('2/ Zone du désert rocheux');
          writeln('3/ Zone de la forêt nordique');
          repeat
            case choix5 of
              1: 
              begin
                //zonededepart();
              end;
              2: 
              begin
                // zonedudesertrocheux();
              end;
              3:
              begin
                //zonedelaforetnordique();
              end;
            end;
          until (choix5>=1) AND (choix5<=3);
        end;
        6: 
        begin
          writeln('Vers quelle zone ?');
          writeln('1/ Zone de départ');
          writeln('2/ Zone du désert rocheux');
          writeln('3/ Zone de la forêt nordique');
          repeat
            case choix6 of
              1: 
              begin
                
              end;
              2: 
              begin
                
              end;
              3: 
              begin
                
              end;
            end;
          until (choix6>=1) AND (choix6<=3);
        end;
        7: 
        begin
          
        end;
        8: 
        begin
          
        end;
        9: 
        begin
          
        end;
      end;
    until (choix1>=0) AND (choix1<=9);
  end;

  procedure afficherMenuPrincipale();
    begin
      couleurTexte(15);
      effacerZoneDeTexte(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, L_MENU, H_MENU);
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
    end;

  procedure menuRessourcesPage1();
    begin
      effacerZoneDeTexte(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, L_MENU, H_MENU);
      afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
        '1/ Lingots de fer',
        '2/ Câbles de cuivre',
        '3/ Plaques de fer',
        '4/ Tuyaux en fer',
        '5/ Sacs de Béton',
        '6/ Autres'
      ]);
    end;

  procedure menuRessourcesPage2();
    begin
      effacerZoneDeTexte(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, L_MENU, H_MENU);
      afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
        '1/ Acier ',
        '2/ Plaques renforcecées',
        '3/ Poutres industrielles',
        '4/ Fondations',
        '5/ Autres'
      ]);
    end;


  procedure menuConstruction();
    var
      choix:integer;
    begin
    repeat
      effacerZoneDeTexte(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, L_MENU, H_MENU);
      afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
        'Quel bâtiment voulez-vous construire ?',
        '1/ Construire une mine',
        '2/ Construire un constructeur',
        '3/ Construire une centrale',
        '4/ Construire l''ascenseur orbital'
      ]);
      readln(choix);
    until choix in [1..4];
    end;

  procedure menuProductionConstructeur();
  begin
    effacerZoneDeTexte(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, L_MENU, H_MENU);
    afficheLigneParLigne(X_MENU_PRINCIPALE, Y_MENU_PRINCIPALE, [
      'Que doit produire le constructeur ?',
      '1/ Lingots de cuivre',
      '2/ Lingots de fer',
      '3/ Cables de cuivre',
      '4/ Plaques de fer',
      '5/ Tuyaux en fer',
      '6/ Autres'
    ]);
  end;

  procedure afficherInventaire();
  begin
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
      'Acier ',
      'Plaques renforcecées',
      'Poutres industrielles',
      'Fondations'
    ]);
    deplacerCurseurXY(X_MENU_PRINCIPALE+10, 8);
  end;

  procedure menuDeJeu();
  var
    choix: integer;
  begin
    repeat
      afficherMenuPrincipale();
      readln(choix);
      case choix of
      // 1/ Construire un bâtiment
      1: menuConstruction();
      // 2/ Changer la production
      2: menuProductionConstructeur();
      // 3/ Améliorer un bâtiment
      // 4/ Explorer la zone
      // 4 : explorationEmplacement();
      // 5/ Changer de zone
      // 6/ Transférer des ressources
      // 7/ Passer la journée 
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
    dessinerCadreXY(x, y, x + largeurCadre, y + 10, double, White, Black);

    deplacerCurseurXY(x + 2, y + 2);
    write('BATIMENT   : ', unBatiment.nom);

    deplacerCurseurXY(x + 2, y + 3);
    write('NIVEAU     : ', unBatiment.niveau);

    deplacerCurseurXY(x + 2, y + 4);
    write('RESSOURCE  : ', unBatiment.ressourceProduite);

    deplacerCurseurXY(x + 2, y + 5);
    write('ENERGIE    : ', unBatiment.coutEnegrie);

  end;

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