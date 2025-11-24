unit unitAvecAccentsGeres;
{$codepage utf8}                //La ligne doit être mise sur chaque unité contenant un texte avec des accents même si ce n'est pas elle qui l'affiche
{$mode ObjFPC}{$H+}

interface
function TexteAvecAccents1() : string;




implementation
function TexteAvecAccents1() : string;
begin
    TexteAvecAccents1 := 'Les accents sont gérés dans cette unité';
end;

end.

