unit unitBlackJackIHM;
{$codepage utf8}
{$mode objfpc}{$H+}

interface                 
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

//IHM du menu principal, renvoie le choix fait par l'utilisateur
//1 -> nouvelle partie
//reste -> quitter
function menuIHM() : String;
begin

end;

//Affichage d'un message de fin
procedure quitterIHM();
begin

end;

//Affiche le cadre principal du plateau
procedure affichageCadrePrincipal();
begin

end;

//Affiche le texte de la carte donnée à la position donnée
procedure affichageTextCarte(x,y : integer; carte : typeCarte);
begin

end;

//Affiche une carte (donnée en paramètre) à la position donnée
procedure affichageCarte(x,y : integer; carte : typeCarte);
begin

end;

//Affiche les cartes du joueur
procedure affichageCartesJoueur();
begin

end;

//Affiche les cartes de la banque
procedure affichageCartesBanque();
begin

end;

//Affiche le menu de choix d'action pour le joueur
function affichageMenuChoix() : integer;
begin

end;

//Affiche la valeur des deux mains
procedure affichageValeursMains();
begin

end;

//Affiche les scores
procedure affichageScores();
begin

end;


//Affiche un message au centre de l'écran
procedure affichageMessage(message : String);
begin

end;

//Affichage du message final (fin de partie)
procedure ecranFinal(message : String);
begin

end;

//Affiche le plateau
procedure affichagePlateau();
begin
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

