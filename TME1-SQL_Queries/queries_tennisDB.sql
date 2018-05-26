/*

BD TENNIS, schéma :

JOUEUR (NUJOUEUR, NOM, PRENOM, ANNAISS, NATIONALITE)
RENCONTRE (NUGAGNANT, NUPERDANT, LIEUTOURNOI, ANNEE, SCORE)
GAIN (NUJOUEUR, LIEUTOURNOI, ANNEE, PRIME, SPONSOR)

*/

-- 1.1

select * from Joueur;

select * from Gain;

select * from Rencontre;

-- 1.2

-- a
-- Numéro et tournoi d'engagement des joueurs sponsorisés par Peugeot
-- MARTINEZ
-- entre 1990 et 1994

select nujoueur, lieutournoi, annee
from Gain
where
(annee>=1990) and (annee<=1994) and (sponsor='Peugeot');


-- b
-- Nom et année de naissance des joueurs ayant participé au tournoi
-- de Roland Garros en 1994

select j.nom, j.annaiss
from Joueur j, Gain g
where
(g.annee=1994) and (lieutournoi='Roland Garros') 
and (g.nujoueur = j.nujoueur);

-- c
-- Nom et nationalité des joueurs ayant participé à la fois
-- au tournoi de Roland Garros et à celui de Wimbledon, en 1992
 
select j.nom, j.nationalite
from Joueur j, Gain w, Gain r
where
(w.Lieutournoi = 'Wimbledon') and (w.annee = '1992') and
(w.nujoueur = j.nujoueur) and (r.nujoueur = w.nujoueur) and
(r.LieuTournoi = 'Roland Garros') and (r.annee = '1992');

-- d
-- Nom et nationalité des joueurs ayant été sponsorisés par Peugeot
-- et ayant gagné à Roland Garros au moins un match

select distinct j.nom, j.nationalite
from Joueur j, Gain g, Rencontre r
where
j.nujoueur = g.nujoueur and g.sponsor = 'Peugeot'
and r.nugagnant = g.nujoueur and r.lieutournoi = 'Roland Garros';

-- e
-- Nom des joueurs ayant toutes leurs primes à Roland Garros
-- supérieures à 1M€

select distinct j.nom
from Joueur j, Gain g
where
j.nujoueur = g.nujoueur and g.lieutournoi = 'Roland Garros' and
not exists (select nujoueur from gain where
	nujoueur = g.nujoueur and lieutournoi = 'Roland Garros' and
	prime<1000000);

-- f
-- Numéros des joueurs ayant toujours gagné à Roland Garros

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

select j.nom
from Joueur j, Gain g
where j.nujoueur = g.nujoueur
and g.annee = 1994
GROUP BY j.nom, g.nuJoueur
HAVING COUNT(g.lieuTournoi) = 
(SELECT COUNT(distinct lieuTournoi) FROM Gain WHERE annee = 1994);

-- i

select count(nujoueur) from gain where annee=1993 and lieutournoi='Wimbledon';

-- j

Select nuJoueur from Gain
group by nujoueur
having count(sponsor)>2
order by nujoueur;


-- k

select nuJoueur from Gain
group by nujoueur
having count(distinct sponsor)=2
order by nujoueur;


--1.3 requetes tme

--l: Moyenne des primes gagnées par année

select annee, avg(prime) as MOYPRIMES
from gain
group by annee
order by annee;


--m: Valeur de la plus forte prime attribuée en 1992 et noms des joueurs qui l'ont touchée

select j.nom from Joueur j, Gain g
where j.nujoueur = g.nujoueur
and g.prime = (select MAX(prime) from gain where Annee=1992);

--> ! Better solution ! --
select j.nom, g.prime from Gain g, Joueur j
where g.annee=1992 and g.nujoueur = j.nujoueur
and g.prime = (select max(prime) from Gain where annee=1992);
 

--n: Somme gagnée en 1992 par chaque joeur, pour l'ensemble des tournois
--   auxquels il a participé (présentation par de gain décroissant)

select j.nom, SUM(g.prime) as SOMME_PRIME
from Joueur j, Gain g
where j.nujoueur = g.nujoueur and g.annee = 1992
group by j.nom
order by SOMME_PRIME DESC;

--o: Noms et prenoms des vainqueurs du Simple Homme et du Simple Dame du
-- tournoi de Roland Garros en 1992

select distinct j.nom, j.prenom
from Joueur j, Rencontre r
where j.nujoueur = r.nugagnant and 
r.annee = 1992 and r.lieutournoi = 'Roland Garros' and
not exists (select nuPerdant from rencontre where
	annee=1992 and nuPerdant = r.nugagnant and lieutournoi='Roland Garros');

--p: Nom des joueurs ayant participé à tous les tournois de Roland Garros

select distinct j.nom
from Joueur j, Gain g
where j.nujoueur = g.nujoueur
and g.lieutournoi = 'Roland Garros'
and not exists (select * from gain where lieutournoi='Roland Garros'
	and j.nujoueur <> nujoueur and annee <> ALL (select distinct annee from gain where
		lieutournoi='Roland Garros' and j.nujoueur =  nujoueur));

--q: Pour chaque joueur, noms des adversaires qu'il a toujours battu

select j1.nom, j2.nom
from Joueur j1, Joueur j2
where not exists ( select * from Rencontre r1
	where r1.nuperdant = j1.nujoueur and r1.nugagnant = j2.nujoueur) and
exists (select * from Rencontre r2 where r2.nugagnant = j1.nuJoueur and r2.nuperdant=j2.NuJoueur)
order by j1.nom;

--r: Noms des sponsors représentés à tous les tournois

SELECT DISTINCT g.sponsor
FROM Gain g
WHERE NOT EXISTS
(SELECT *
	FROM Gain g2
	WHERE g2.annee <> ALL 
	(SELECT g3.annee
		FROM Gain g3
		WHERE g3.sponsor = g.sponsor)
)
AND NOT EXISTS
(SELECT *
	FROM Gain g4
	WHERE g4.lieutournoi <> ALL
	(SELECT g5.lieutournoi
		FROM Gain g5
		WHERE g5.sponsor = g.sponsor)
);


/*s : Noms des pays qui ont eu un vaiqueur de tournoi chaque année*/

SELECT distinct j.nationalite
FROM Joueur j, Rencontre r
WHERE j.nujoueur = r.nugagnant
AND j.nujoueur NOT IN 
(SELECT r2.nuperdant
	FROM Rencontre r2
	WHERE r2.lieutournoi=r.lieutournoi
	AND r2.annee=r.annee)
GROUP BY j.nationalite
HAVING COUNT(DISTINCT r.annee) >= 
(SELECT COUNT(DISTINCT g.annee)
	FROM Gain g);
