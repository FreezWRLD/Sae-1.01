unit joueur;

{$mode objfpc}{$H+}
{$codepage utf8} 

interface
uses
  SysUtils, declarations, typinfo;  
var
  i: Integer;
  JDate : _Date;
  JZones : _EnsembleDeZones ;
  ZoneActuelle : _TypeZone = base;  // Zone actuelle du joueur

  procedure Jeu();

implementation
uses SatisfactIUTLogic,ihm;

  procedure Jeu();
  begin
    initialiserJeu(JDate, ZoneActuelle, JZones);  // Initialise toutes les variables du jeu
    menuDemarrage();
  end;
end.