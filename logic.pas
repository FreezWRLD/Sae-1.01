unit logic;

{$mode objfpc}{$H+}

interface
uses
  SysUtils,ihm, types, constantes ;

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
  
end.