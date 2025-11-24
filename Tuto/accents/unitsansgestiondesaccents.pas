unit unitSansGestionDesAccents;
{$mode ObjFPC}{$H+}             //Si vous ne mettez pas la ligne, les accents contenus dans cette unité ne seront pas gérés ! Même si l'affichage est fait dans une unité gérant les accents.

interface  
function TexteAvecAccents2() : string;

implementation   
function TexteAvecAccents2() : string;
begin
    TexteAvecAccents2 := 'Les accents ne sont pas gérés dans cette unité';
end;

end.

