-- l : moyenne des primes par année

select annee,avg(prime) as MOYPRIMES from gain
group by annee
order by annee;


-- m : valeur de la plus forte prime attribué lors d'un 
-- tournoi en 1992 et noms des joueurs qui l'on touché

select j.nom, g.prime from Gain g, Joueur j
where g.annee=1992 and g.nujoueur = j.nujoueur
and g.prime = (select max(prime) from Gain where annee=1992);


-- n : somme gagnée en 1992 par chaque joueur, pour l'ensemble
-- des tournois auxquels il a participé (présentation gain decr.)

select j.nom, SUM(g.prime) as SOMME_PRIme from Joueur j, Gain g 
where g.annee=1992 and j.nujoueur = g.nujoueur
group by j.nom order by SOMME_PRIme DESC;

-- o : Noms et prénosms des vainqueurs du Simple Homme et du Simple
-- Dame du tournoi de Roland Garros en 1992

select distinct j.nom, j.prenom from Joueur j, Rencontre r
where j.nujoueur = r.nugagnant
and r.annee = 1992 and r.lieutournoi = 'Roland Garros'
and not exists (select * from Rencontre 
	where r.nugagnant = nuperdant and annee=1992 and
	lieutournoi='Roland Garros');

--  p : Nom des joueurs ayant participé à tous les tournois de RG

select distinct j.nom
from Joueur j, Gain g
where j.nujoueur = g.nujoueur
and g.lieutournoi = 'Roland Garros'
and not exists (select * from gain where lieutournoi='Roland Garros'
	and j.nujoueur <> nujoueur and annee <> ALL (select distinct annee from gain where
		lieutournoi='Roland Garros' and j.nujoueur =  nujoueur));

-- q : Pour chaque joueur, noms des adversaires qu'il a toujours battu

select distinct j1.nom, j2.nom from Joueur j1, Joueur j2, Rencontre r 
where j1.nujoueur=r.nugagnant and j2.nujoueur = r.nuperdant
 and not exists (
	select * from Rencontre where j2.nujoueur = nugagnant and 
	nuperdant = j1.nujoueur);

 -- r : noms des sponsors représentés à tous les tournoi

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

-- s :  Noms des pays qui ont eu un vaiqueur de tournoi chaque annee

select j1.nationalite from joueur j1, Rencontre r1
where j1.nujoueur = r1.nugagnant and
not exists (select * from Rencontre where r1.annee = annee and
nuperdant=r1.nugagnant and lieutournoi=r1.lieutournoi)
group by  j1.nationalite
having count(distinct r1.annee) >= 
(select count(distinct annee) from Rencontre) ;





