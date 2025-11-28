program main;
{$mode objfpc}{$H+}
{$codepage utf8} 
uses
  sysutils, declarations, gestionEcran, ihm, objets, SatisfactIUTLogic;
var 
  ensembleDeZones : _EnsembleDeZones;
begin
  ensembleDeZones := InitZones;
  AfficherEmplacementZone(ensembleDeZones[base]);
  readln();
end.