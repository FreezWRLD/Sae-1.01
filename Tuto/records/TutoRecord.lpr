//But du tuto : gérer un type complexe (record)   
program TutoRecord;
{$mode objfpc}{$H+}
uses UnitPersonnage;

var
  bob : TPersonnage;

begin
  //On crée Bob
  bob := CreerPersonnage('Bob',100);
  //On affiche Bob
  writeln(PersonnageToString(bob));

  //Bob prend des dégats (-10pv)
  PrendreDegat(bob,10);     
  writeln(PersonnageToString(bob));

  //Bob prend des dégats (-100pv) et tombe inconscient
  PrendreDegat(bob,100);
  writeln(PersonnageToString(bob));

  //Bob prend des dégats (-1pv) et meurt
  PrendreDegat(bob,100);
  writeln(PersonnageToString(bob));

  readln;
end.
           