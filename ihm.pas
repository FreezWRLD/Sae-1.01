unit ihm;
{$codepage utf8} 
{$mode objfpc}{$H+}

interface
uses
  SysUtils, gestionEcran, types, SatisfactIUTLogic;

  procedure ecranDemarrage(); //Procédure qui affichera l'écran d'accueil et qui renvoira le choix de l'utilisateur
  procedure ecranJeu(); //Procédure qui affichera l'écran du menu principal
  procedure afficherBatiment(x, y: integer; unBatiment: _Batiment);
  
implementation
  procedure ecranDemarrage();
  var
    choix:integer=0; //Variable de type entier saisit au clavier qui correspond au choix de l'utilisateur
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
          deplacerCurseurXY(77,3);
          writeln(propre('Dans une réalité. pas si alternative que ça.'));
          writeln();
          writeln('                                                           2024 : une année particulièrement compliquée.');
          writeln('                                 Suite à un mouvement de grève encore jamais vu (les Gilets Verts) pas moins de douze gouvernements');
          writeln('                                               se sont succédé entre janvier et mars. Oui, douze. En trois mois.');
          writeln();
          writeln('                                 L instabilité économique provoquée par ces changements politiques incessants a plongé le pays dans');
          writeln('                                 une ère de chaos. Et ce qui devait arriver... arriva. Privée de toute subvention de l État, la direc');
          writeln('                                 tion de l IUT de Dijon a dû se rendre à l évidence : à défaut d avoir un budget, il allait falloir');
          writeln('                                        utiliser la seule ressource encore abondante et peu coûteuse... vous, les étudiant(e)s.');
          writeln();
          writeln('                                 Le 30 avril 2024, la direction dévoile alors une stratégie de redressement financier pour le moins');
          writeln('                                 novatrice : Envoyer les étudiant(e)s coloniser dautres planètes et y construire des usines de pro');
          writeln('                                 duction automatisées. Un moyen simple (et étonnamment peu onéreux) d obtenir rapidement les ressour');
          writeln('                                                           ces nécessaires à la survie de létablissement.');
          writeln();
          writeln('                                 C est ainsi que, le 15 septembre 2024, vous embarquez pour un voyage à destination de Mars, à bord');
          writeln('                                   d une fusée baptisée "Maëlle", fièrement assemblée lors d une SAE du département GMP. Avec pour');
          writeln('                                   seul(e)s compagnons la Lune, le ciel, et une check-list de sécurité rédigée par Franck Deher,');
          writeln('                                     vous atteignez (contre toute attente) la surface martienne sans le moindre incident majeur.');
          writeln();
          writeln('                                             Maintenant, il est temps de vous mettre au travail. L IUT a besoin de vous !');
          writeln();
          writeln();
          writeln();
          writeln();
          writeln();
          writeln();
          writeln();
          writeln('                                                             < Appuyez sur une touche pour continuer >');
        readln();
        ecranJeu();
        end;
        2:  
      end;
    until (choix=1) OR (choix=2);
  end;


  procedure ecranJeu();
  begin
    
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