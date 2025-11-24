program TutoGestionAccents;
{$codepage utf8}        //Rajouter cette ligne juste après la déclaration du programme ou de l'unit
{$mode objfpc}{$H+}

uses unitAvecAccentsGeres, unitSansGestionDesAccents;

begin
  writeln('Les accents sont bien gérés dans le programme principal!');
  writeln(TexteAvecAccents1());               
  writeln(TexteAvecAccents2());
  readln;
end.        
uses
  classes,sysutils;
begin 
   
end.