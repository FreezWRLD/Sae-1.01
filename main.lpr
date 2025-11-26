program main;
{$mode objfpc}{$H+}
{$codepage utf8} 
uses
  sysutils, declarations, gestionEcran, ihm, objets, SatisfactIUTLogic, joueur;

var
  i: Integer;
  zone: _Zone;

begin
  // Initialisation du jeu
  initialiserZones;
  
  // Récupération de la zone de base
  zone := JZones[base];
  
  // Affichage de l'en-tête
  effacerEcran;
  deplacerCurseurXY(5, 2);
  write('=== ZONE DE BASE ===');
  
  // Affichage des emplacements
  deplacerCurseurXY(5, 4);
  writeln('Emplacements :');
  
  for i := 0 to High(zone.emplacements) do
  begin
    deplacerCurseurXY(10, 6 + i*2);
    write('Emplacement ', i+1, ' : ');
    
    if zone.emplacements[i].estDecouvert then
    begin
      if zone.emplacements[i].batiment.typeBatiment = hub then
        write('Hub (Niveau ', zone.emplacements[i].batiment.niveau, ')')
      else if zone.emplacements[i].gisement.existe then
        write('Gisement de fer (Pureté: ', zone.emplacements[i].gisement.mineraiPurete, ')')
      else
        write('Vide');
    end
    else
    begin
      write('Non découvert');
    end;
  end;
  
  // Affichage de l'inventaire
  deplacerCurseurXY(5, 28);
  write('=== INVENTAIRE ===');
  
  deplacerCurseurXY(10, 30);
  write('Fer : ', zone.inventaire.quantites[fer]);
  
  deplacerCurseurXY(10, 31);
  write('Cuivre : ', zone.inventaire.quantites[cuivre]);
  
  deplacerCurseurXY(10, 32);
  write('Charbon : ', zone.inventaire.quantites[charbon]);
  
  // Positionnement du curseur en bas de l'écran
  deplacerCurseurXY(1, 40);
  write('Appuyez sur Entrée pour quitter...');
  
  readln;
end.