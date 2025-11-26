unit Joueur;

{$mode objfpc}{$H+}

interface
uses
  SysUtils, SatisfactIUTLogic, declarations, objets;

// Initialise toutes les zones du joueur
procedure initialiserJeu(var JDate : _Date; var ZoneActuelle : _TypeZone; var JZones : _EnsembleDeZones);
  
implementation

procedure initialiserJeu(var JDate : _Date; var ZoneActuelle : _TypeZone; var JZones : _EnsembleDeZones);
begin
  JZones := InitZones();
  JDate := InitDate();
  ZoneActuelle := base;
end;

  

end.