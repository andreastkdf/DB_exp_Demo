-- 1.1

select * from Joueur;

select * from Gain;

select * from Rencontre;

-- 1.2

-- a

select nujoueur, lieutournoi, annee
from Gain
where
(annee>=1990) and (annee<=1994) and (sponsor='Peugeot');


-- b

select j.nom, j.annaiss
from Joueur j, Gain g
where
(g.annee=1994) and (lieutournoi='Roland Garros') and (g.nujoueur = j.nujoueur);

-- c

select j.nom, j.nationalite
from Joueur j, Gain w, Gain r
where
(w.Lieutournoi = 'Wimbledon') and (w.annee = '1992') and
(w.nujoueur = j.nujoueur) and (r.nujoueur = w.nujoueur) and
(r.LieuTournoi = 'Roland Garros') and (r.annee = '1992');

-- d

select distinct j.nom, j.nationalite
from Joueur j, Gain g, Rencontre r
where
j.nujoueur = g.nujoueur and g.sponsor = 'Peugeot'
and r.nugagnant = g.nujoueur and r.lieutournoi = 'Roland Garros';

-- e

select distinct j.nom
from Joueur j, Gain g
where
j.nujoueur = g.nujoueur and g.lieutournoi = 'Roland Garros' and
not exists (select nujoueur from gain where
nujoueur = g.nujoueur and lieutournoi = 'Roland Garros' and
prime<1000000);

-- f
 
select distinct j.nom, j.nujoueur
from Joueur j, Rencontre r
where j.nuJoueur = r.nuGagnant and r.Lieutournoi = 'Roland Garros'
and not exists (select nuPerdant from Rencontre where
    nuPerdant = r.nugagnant and lieutournoi='Roland Garros');


-- g

/* Liste des vainqueurs de tournoi, mentionnant le nom du joueur
 avec le lieu et l'année du tournoi qu'il a gagné */
 
SELECT j.nom, g.lieuTournoi, g.annee
FROM Joueur j, Gain g
WHERE j.nuJoueur = g.nuJoueur 
AND NOT EXISTS 
(SELECT nugagnant
FROM Rencontre r
WHERE r.lieuTournoi = g.lieuTournoi
AND r.annee = g.annee
AND r.nuPerdant = j.nuJoueur);


-- h
/* Noms des joueurs ayant participé à tous les tournois en 1994 */

select 

