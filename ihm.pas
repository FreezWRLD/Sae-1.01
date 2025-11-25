unit ihm;
{$codepage utf8} 
{$mode objfpc}{$H+}

interface
uses
  SysUtils, gestionEcran, types, SatisfactIUTLogic;

  procedure ecranDemarrage(); //Procédure qui affichera l'écran d'accueil et qui renvoira le choix de l'utilisateur
  procedure ecranJeu(); //Procédure qui affichera l'écran du jeu
  procedure menu();//Procédure qui affichera le menu
  procedure afficherBatiment(x, y: integer; unBatiment: _Batiment);
  
implementation
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
        ecranJeu();
        end;
        2:  
      end;
    until (choix=1) OR (choix=2);
  end;


  procedure ecranJeu();
  var 
    Planete : _EnsembleDeZones;
    DateJeu : _Date;
  begin
    Planete := InitZones();
    DateJeu := InitDate();
    for i in Planete do
    begin
      InitInventaires(Planete[i]);
    end;

  end;
  
  procedure menu();
  var
    choix1,choix2,choix3,choix4:Integer;
  begin
  writeln('Que voulez-vous faire ?'); // Position à mettre (déplacercurseurXY)
  writeln('1/ Construire un bâtiment');
  writeln('2/ Changer la production');
  writeln('3/ Améliorer un bâtiment');
  writeln('4/ Explorer la zone');
  writeln('5/ Changer de zone')
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
          ecranJoueur();
        end;
        1:
        begin
          selectionEmplacement();
          writeln('Quel bâtiment voulez-vous construire ?');
          writeln('1/ Construire une mine');
          writeln('2/ Construire un constructeur');
          writeln('3/ Construire une centrale');
          writeln('4/ Construire l''ascenseur orbital');
          readln(choix2);
          case choix2 of
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
          end;
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
                  ecranJeu();
                end;

              end;
            end;
          end;
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
    until (Choix>=0) AND (Choix=<9);
    
  end;

  // Fonction pour afficher un bâtiment dans un cadre formaté
// x, y : position du coin supérieur gauche du cadre
procedure afficherBatiment(x, y: integer; unBatiment: _Batiment);
var
  largeurCadre: integer;
  pos: coordonnees;
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

 
  

  
end.