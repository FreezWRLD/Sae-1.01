unit unitBlackJackIHM;
{$codepage utf8}
{$mode objfpc}{$H+}

interface               
var
  couleurDeTapis:Byte;  
  couleurDeTexte:Byte;
procedure choisirCouleurDeJeu(color:byte; colorText:byte);
//IHM du menu principal, renvoie le choix fait par l'utilisateur
//1 -> nouvelle partie
//reste -> quitter
function menuIHM() : String; 
//Affichage d'un message de fin
procedure quitterIHM();   
//Affiche le plateau
procedure affichagePlateau();
//Affiche le menu de choix d'action pour le joueur
function affichageMenuChoix() : integer;  
//Affiche un message au centre de l'écran
procedure affichageMessage(message : String);  
//Affichage du message final (fin de partie)
procedure ecranFinal(message : String);
implementation
uses
    GestionEcran,unitBlackJackLogic,sysUtils;


procedure choisirCouleurDeJeu(color:byte; colorText:byte);
begin
couleurDeTapis:=color;
couleurDeTexte:=colorText;
end;


//IHM du menu principal, renvoie le choix fait par l'utilisateur
//1 -> nouvelle partie
//reste -> quitter
function menuIHM() : String;
begin
 dessinerCadreXY(19,5,100,20, simple, white, black);
 deplacerCurseurXY(42,6);
writeln( '----------------------------------' );
deplacerCurseurXY(42,7);
writeln('-- Bienvenu dans BlackJack 2022 --');
deplacerCurseurXY(42,8);
writeln( '----------------------------------' );
deplacerCurseurXY(48,11);
writeln('1/ Nouvelle Partie');
deplacerCurseurXY(48,13);
writeln('0/ Quitter');
deplacerCurseurXY(42,16);
writeln('Votre choix : ');
deplacerCurseurXY(55,16);
readln(menuIHM);
end;

//Affichage d'un message de fin
procedure quitterIHM();
begin
  effacerEcran();
   dessinerCadreXY(31,13,88,15, double, white, black);
  deplacerCurseurXY(56,14);
  writeln('AU REVOIR');
  readln;
end;

//Affiche le cadre principal du plateau
procedure affichageCadrePrincipal();
begin
  effacerEtColorierEcran(couleurDeTapis);
  dessinerCadreXY(1,1,118,29, simple, black, couleurDeTapis);
  dessinerCadreXY(51,0,68,2, simple, black, couleurDeTapis);
  deplacerCurseurXY(53,1);
  write('BlackJack 2025');
end;

//Affiche le texte de la carte donnée à la position donnée
procedure affichageTextCarte(x,y : integer; carte : typeCarte);
var
  Lettre:Char;
  colortext:String;
  color:Byte;
begin
  deplacerCurseurXY(x,y);
  
case carte.valeur of 
  10 : Lettre := 'X';
  11 : Lettre := 'V';
  12 : Lettre := 'D';
  13 : Lettre := 'R';
end;

case carte.couleur of 
  trefle : colortext := 'Tr';
  carreau : colortext := 'Ca';
  coeur : colortext := 'Co';
  pique : colortext := '♠';
end;
  if (carte.couleur = coeur) OR (carte.couleur = carreau) then color := Red
  else color := Black;
  couleurTexte(color);
  deplacerCurseurXY(x+3,y+2);
  writeln(Lettre,' ',colortext);
  couleurTexte(white);

end;

//Affiche une carte (donnée en paramètre) à la position donnée
procedure affichageCarte(x,y : integer; carte : typeCarte);
var
  color:byte;
begin
  if (carte.couleur = coeur) OR (carte.couleur = carreau) then color := Red
  else color := Black;
  dessinerCadreXY(x,y,(x+9),(y+4), simple, color, white);
  affichageTextCarte(x,y,carte);
end;

//Affiche les cartes du joueur
procedure affichageCartesJoueur();
var
  i:integer;
  x,y,pos:integer;
begin
  y:=16;
  x:= 5;
  for i:=1 to getMainJoueur().nbCartes do 
  begin
    affichageCarte(x,y,(getMainJoueur().cartes[i]));
    x := x + 10;
  end;
end;

//Affiche les cartes de la banque
procedure affichageCartesBanque();
var
  i:integer;
  x,y,pos:integer;
begin
  y:=5;
  x:= 5;
  for i:=1 to getMainBanque().nbCartes do 
  begin
    affichageCarte(x,y,(getMainBanque().cartes[i]));
    x := x + 10;
  end;
end;

//Affiche le menu de choix d'action pour le joueur
function affichageMenuChoix() : integer;
begin
couleurFond(couleurDeTapis);
couleurTexte(couleurDeTexte);
 deplacerCurseurXY(15,25);
 write('1/ Tirer une carte                  2/ Arrêter');
 deplacerCurseurXY(80,25);
 readln(affichageMenuChoix);
end;

//Affiche la valeur des deux mains
procedure affichageValeursMains();
begin
couleurFond(couleurDeTapis);
couleurTexte(couleurDeTexte);
  deplacerCurseurXY(5,3);
  writeln('Valeur de la main : ', valeur(getMainBanque()));
  deplacerCurseurXY(5,23);
  writeln('Valeur de la main : ', valeur(getMainJoueur()));
end;

//Affiche les scores
procedure affichageScores();
begin
couleurFond(couleurDeTapis);
couleurTexte(couleurDeTexte);
deplacerCurseurXY(97,3);
  writeln('Score : ', getScoreBanque);
  deplacerCurseurXY(97,23);
  writeln('Score : ', getScoreJoueur);
end;


//Affiche un message au centre de l'écran
procedure affichageMessage(message : String);
begin
couleurFond(couleurDeTapis);
couleurTexte(couleurDeTexte);
 dessinerCadreXY(31,13,88,15,double, black,couleurDeTapis);
 deplacerCurseurXY(60-(Length(message) div 2),14 );
write(message);
 readln;
end;

//Affichage du message final (fin de partie)
procedure ecranFinal(message : String);
begin
effacerEtColorierEcran(black);
  dessinerCadreXY(31,13,88,15,double, white,black);
 deplacerCurseurXY(60-(Length(message) div 2),14 );
 write(message);
 readln
end;

//Affiche le plateau
procedure affichagePlateau();
begin
     choisirCouleurDeJeu(green, black);
     //Affichage du cadre principal
     affichageCadrePrincipal();
     //Affichage des cartes du joueurs et de la banque
     affichageCartesJoueur();
     affichageCartesBanque();
     //Affichage des valeurs des mains
     affichageValeursMains();
     //Affichage des scores
     affichageScores();
end;

end.

