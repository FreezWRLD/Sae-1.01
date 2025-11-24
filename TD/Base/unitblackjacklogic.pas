unit unitBlackJackLogic;

{$mode objfpc}{$H+}

interface

//----- TYPE -----
type
  typeCouleur = (trefle,carreau,coeur,pique);           //Les 4 couleurs
  typeCarte = record                                    //Une carte à jouer
       couleur : typeCouleur;
       valeur : integer;
  end;
  typePaquet = array[1..52] of typeCarte;               //Type : paquet de cartes
  typeMain = record                                     //Type : main d'un joueur
       cartes : typePaquet;                             //Cartes possédées
       nbCartes : integer;                              //Nombre de cartes possédées
  end;

//Menu principal
procedure menu();
//Renvoie la main du joueur
function getMainJoueur() : typeMain;
//Renvoie la main de la banque
function getMainBanque() : typeMain; 
//renvoie la valeur d'une main
function valeur(main : typeMain) : integer;
//renvoie le score du joueur
function getScoreJoueur() : integer;
//renvoie le score de la banque     
function getScoreBanque() : integer;


implementation
    uses unitBlackJackIHM,math,sysutils;



var
  paquet : typePaquet;                                  //Paquet utilisé
  numCarteEnCours : integer;                            //Numéro de la dernière carte du paquet donnée
  mainJoueur : typeMain;                                //Main du joueur
  mainBanque : typeMain;                                //Main de la banque
  scoreJoueur : integer;                                //Score du joueur
  scoreBanque : integer;                                //Score de la banque

  
//renvoie le score du joueur
function getScoreJoueur() : integer;
begin
     getScoreJoueur:= scoreJoueur;
end;

//renvoie le score de la banque
function getScoreBanque() : integer;
begin
    getScoreBanque:= scoreBanque;
end;

//renvoie la valeur d'une main
function valeur(main : typeMain) : integer;
var
  nbAs : integer;                                      //Nombre d'as vu (pour la règle des as)
  i : integer;
begin
     //calcul de la valeur en prenant en compte les As comme des 1
     valeur := 0;
     nbAs:=0;
     for i:=1 to main.nbCartes do
     begin
         valeur := valeur + min(10,main.cartes[i].valeur);
         if(main.cartes[i].valeur = 1) then nbAs := nbAs + 1;
     end;
     //Si la main contient un As (au moins) et à une valeur <= 11 on ajoute 11 (l'as vaut 11 et non 1)
     if(nbAs>0) and (valeur <= 11) then valeur := valeur + 10;
end;

//On tire une carte pour la main donnée en paramètre
procedure tirerCarte(var main : typeMain);
begin
     //Le nombre de carte augmente de 1
     main.nbCartes:=main.nbCartes+1;
     //On ajoute la carte du paquet dans la main
     numCarteEnCours := numCarteEnCours+1;
     main.cartes[main.nbCartes] := paquet[numCarteEnCours];
end;

//initialisation
procedure initialisation();
var
  col : typeCouleur;
  val : integer;
  compteur : integer;
  i : integer;
  mem : typeCarte;
  numCarte1,numCarte2 : integer;
begin
     //Création d'un paquet classé
     compteur := 1;
     //Pour chaque couleur
     for col := Low(typeCouleur) to High(typeCouleur) do
     begin
       //Pour chaque valeur
       for val := 1 to 13 do
       begin
         //On crée une carte avec cette valeur et cette couleur
         paquet[compteur].couleur:=col;
         paquet[compteur].valeur:=val;
         compteur:=compteur+1;
       end;
     end;

     //Mélange du paquet
     for i := 1 to 10000 do
     begin
          //On choisit 2 cartes aléatoirement
          numCarte1 := random(52)+1;
          numCarte2 := random(52)+1;
          //On les échanges
          mem := paquet[numCarte1];
          paquet[numCarte1] := paquet[numCarte2];
          paquet[numCarte2] := mem;
     end;

     //On recommence le paquet au début
     numCarteEnCours:=0;

     //Initialisation des mains des deux joueurs
     mainJoueur.nbCartes:=0;
     mainBanque.nbCartes:=0;
     //Chaque joueur tire 2 cartes
     for i:=1 to 2 do
     begin
       tirerCarte(mainJoueur);
       tirerCarte(mainBanque);
     end;
end;

//Victoire
procedure victoire();
begin
    ecranFinal('VOUS AVEZ GAGNE '+IntToStr(scoreJoueur)+' A '+IntToStr(scoreBanque)+' !');
end;

//Defaite
procedure defaite();
begin     
    ecranFinal('VOUS AVEZ PERDU '+IntToStr(scoreJoueur)+' A '+IntToStr(scoreBanque)+' !');
end;

//Victoire d'un tour
procedure victoireTour();
begin   
   affichagePlateau();
   affichageMessage('VOUS AVEZ GAGNE LA MANCHE !');
   scoreJoueur:=scoreJoueur+1;
end;

//Défaite d'un tour
procedure defaiteTour();
begin   
   affichagePlateau();
   affichageMessage('VOUS AVEZ PERDU LA MANCHE !');
   scoreBanque:=scoreBanque+1;
end;

//Le joueur a fait un blackJack
procedure blackJ();
begin
   affichageMessage('BLACK JACK !');
   victoireTour();
end;

//Burst
procedure bust();
begin
     affichageMessage('BUSTED !');
     defaiteTour();
end;

//Déroulement d'un tour
procedure tour();
var
  choix : integer;
begin
     //On initialise le tour
     initialisation();

     choix := 1;
     //Tant que le joueur ne souhaite pas s'arrêter
     while (choix = 1) and (mainJoueur.nbCartes<10) and (valeur(mainJoueur) < 21) do
     begin            
       //On affiche le plateau
       affichagePlateau();
       //Affiche le menu de choix du joueur
       choix := affichageMenuChoix();

       //Si le joueur tire une carte
       if(choix = 1) then
       begin
           tirerCarte(mainJoueur);
       end;
     end;

     //On affiche le plateau
     affichagePlateau();
     //Si le joueur a BUST
     if valeur(mainJoueur) > 21 then bust()
     //Si le joueur a 21
     else if valeur(mainJoueur) = 21 then blackJ()
     else
     begin
       //On fait jouer l'IA
       while( valeur(mainBanque) < valeur(mainJoueur)) do
       begin
         tirerCarte(mainBanque);
         affichagePlateau();
         readln;
       end;
       //Si la banque n'a pas bust, elle a gagnée
       if valeur(mainBanque) <= 21 then defaiteTour()
       else victoireTour();
     end;


end;

//Lance une partie
procedure partie();
begin
     randomize;
     //On réinitialise les scores
     scoreJoueur:=0;
     scoreBanque:=0;
     while(scoreJoueur<5) and (scoreBanque<5) do
        tour();
     if scoreJoueur=5 then victoire()
     else defaite()
end;

//Quitter le jeu
procedure quitter();
begin
   quitterIHM();
end;

//Menu principal
procedure menu();
var choix : string;
begin
     choix := menuIHM();
     if (choix = '1') then partie()
     else quitter();
end;

//Renvoie la main du joueur
function getMainJoueur() : typeMain;
begin
     getMainJoueur := mainJoueur;
end;

//Renvoie la main de la banque
function getMainBanque() : typeMain;
begin
     getMainBanque := mainBanque;
end;

end.

