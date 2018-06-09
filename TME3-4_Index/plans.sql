EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.age = 18;

/* 
scan de l'index en fonction de l'age ; age =18 -> on a 2200 personnes
lecture table Bigannuaire apres le filtrage -> 2200 personnes
affichage nom et prenom des personnes -> 2200 personnes
*/

EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.age BETWEEN 20 AND 29;

/*
scan de l'index en fonction de l'age entre 20 et 29 ans -> 24400 lignes
lecture table BigAnnuaire apres filtrage ->24400 lignes
affichage nom et prenom des personnes ->24400 lignes
*/


EXPLAIN plan FOR
   SELECT a.nom, a.prenom
   FROM BigAnnuaire a
   WHERE a.age < 70 AND (a.cp = 93000 OR a.cp = 75000);
/*
scan code postal egal 93000 ou 75000 -> 440 lignes
lecture table BigAnnuaire apres filtrage et selection age < 70 -> 307 lignes
affichage nom et prenom des personnes ->307 lignes
*/

EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.age = 20 AND a.cp = 13000 AND a.nom LIKE 'T%';

 /*
scan avec index age : age =20 -> 2 lignes
scan avec index code postal : code postal = 13000 -> 2 lignes
filtrage du nom : nom doit commencer par un T -> 1 ligne
affichage nom et prenom des resultats -> 1 ligne
*/

-- EX 2  : Select WITH OR WITHOUT index

EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.age <= 100;

 Prédicat	Rows	Index used		Cost
age < = 10	22200		yes			222250
age < = 20	44422		yes 		44521			
age < = 30	66644		yes			66793		
age < = 40	88867		no 			70893		
age < = 60	133K		no 			70893
age < = 100	220K		no			70893

/*
Question b) : 
Pour quel prédicat Oracle préfère-t-il évaluer la requête sans utiliser l'index IndexAge ? Pourquoi ?
-> des que l'ensemble recherché est trop grand pour que ce soit avantageux d'uiliser l'index
Oracle estime qu'il lui serait plus couteux d'indexer.
*/

/*
Question c) : 
Proposer deux requêtes BETWEEN 50000 AND … sélectionnant un intervalle de valeurs du code postal comprises entre 50000 et N.
°)la première utilise l'index IndexCP,
°)la deuxième ne l'utilise pas.
*/

EXPLAIN plan FOR
    SELECT /*+ index(a IndexCP) */ a.nom, a.prenom 
    FROM BigAnnuaire a
    WHERE a.cp BETWEEN 50000 AND 91000;
@p4

/*
nb lignes 90730
cout 90942
*/

EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.cp BETWEEN 50000 AND 91000;
@p4

/*
nb lignes identique -> NORMAL
cout 70893 -> l'indexage coute plus cher dans ce cas 
*/

/* Exercice 3 */
/* Question a */

EXPLAIN plan FOR
   SELECT /*+ index(a IndexAge) */  a.nom, a.prenom 
   FROM BigAnnuaire a WHERE a.age < 7;
@p4;
/*
requete tres selective -> l'index est plus favorable que la lecture de toutes les pages
-> rows: 13 333 cost=13365
*/
EXPLAIN plan FOR
   SELECT /*+  no_index(a IndexAge) */  a.nom, a.prenom
   FROM BigAnnuaire a WHERE a.age < 7;
@p4
/*
lecture de toutes les pages de BigAnnuaire -> prend beaucoup de temps ( bien plus qu'avec l'index)
-> cost = 70893
*/
/*
Verification:
*/
EXPLAIN plan FOR
   SELECT a.nom, a.prenom
   FROM BigAnnuaire a WHERE a.age < 7;
@p4;
/*
devrait etre les memes resultats que avec l'index -> utilise bien l'index
*/

/*Question b: meme chose avec age>19
*/

EXPLAIN plan FOR
   SELECT /*+ index(a IndexAge) */  a.nom, a.prenom 
   FROM BigAnnuaire a WHERE a.age > 19;
@p4;
/*
-> l'index n'est pas suffisament avantageux dasn ce cas 
cost = 180 000
la requete n'est pas suffisamment selective:
(100-19)/100 = 81/100 -> 81% des pages seront lues
on se retrouve plusieurs fois a relire la meme pages

*/
EXPLAIN plan FOR
   SELECT /*+  no_index(a IndexAge) */  a.nom, a.prenom
   FROM BigAnnuaire a WHERE a.age > 19;
@p4
/*
COst = 70893 -> lecture de toutes les pages
*/

/*Question c: age = 18 and cp =75 000
*/
EXPLAIN plan FOR
    SELECT /*+ index(a IndexAge) no_index(a IndexCp)  */  a.nom, a.prenom 
    FROM BigAnnuaire a WHERE a.age = 18 AND a.cp = 75000;
@p4
/*
cost = 2206
index sur age
*/
EXPLAIN plan FOR
    SELECT /*+ no_index(a IndexAge) index(a IndexCp)  */  a.nom, a.prenom 
    FROM BigAnnuaire a WHERE a.age = 18 AND a.cp = 75000;
@p4;
/*
COst = 221;
index cp
*/
EXPLAIN plan FOR
    SELECT /*+ no_index(a IndexAge) no_index(a IndexCp)  */a.nom, a.prenom 
    FROM BigAnnuaire a WHERE a.age = 18 AND a.cp = 75000;
@p4;
/*
Cost = 70893
lit toutes les pages
*/
EXPLAIN plan FOR
    SELECT /*+ index_combine(a IndexAge IndexCp) */a.nom, a.prenom 
    FROM BigAnnuaire a WHERE a.age = 18 AND a.cp = 75000;
@p4;
/*
Cost = 10
utilise les deux index!
*/

/*
Exercice 4. Requête de jointure utilisant un index
*/

/*question a*/
EXPLAIN plan FOR
    SELECT a.nom, a.prenom, v.ville
    FROM Annuaire a, Ville v
    WHERE a.cp = v.cp
    AND a.age=18;
@p3
/*
dans l'ordre du plan d'execution:
acces table : Ville
utilisation index sur l'age:
acces table Annuaire avec rowid (index age)
hash join 
affichage nom prenom ville
*/

/*question b*/
EXPLAIN plan FOR
    SELECT a.nom, a.prenom, v.ville
    FROM Annuaire a, Ville v
    WHERE a.cp = v.cp
    AND a.cp BETWEEN 75000 AND 76000;
@p3
/*
dans l'ordre du plan d'execution:
acces table Annuaire avec index ?
utilisation index sur code postal
acces table : Ville
nested loop ville identique antre Annuaire et Ville
nested loop verification code postal
affichage nom, prenom, ville
*/

/*Exercice 5: Autres requêtes
*/
/* par nous meme*/

/*
a) Requêtes avec group by
*/
EXPLAIN plan FOR
    SELECT age, COUNT(*)
    FROM BigAnnuaire a
    GROUP BY age;
@p3
/*explications:
utilisation index : lecture de la teble sans toucher les donnees de la table : regarde juste les index
utilisation table de hachage pour faire un group by
affichage age et le nombre de personnes qui ont cet age
*/

/*b) Requêtes avec group by having
*/
EXPLAIN plan FOR
    SELECT age, COUNT(*)
    FROM BigAnnuaire a
    GROUP BY age
    HAVING COUNT(*) > 200;
@p3
/*explications:
utilisation index : lecture de la teble sans toucher les donnees de la table : regarde juste les index
utilisation table de hachage pour faire un group by
filter = having
affichage age dont le nombre personnes de cet age sont plus de 200
*/

/*
c) Requete min max
*/
EXPLAIN plan FOR
    SELECT MIN(cp), MAX(cp)
    FROM BigAnnuaire a;
@p3
/* explications:
utilisation index : lecture de la teble sans toucher les donnees de la table : regarde juste les index
sort aggregate : ordonne les donnees et aggrege en minimum et en maximum
affiche le min et le max des codes postaux
*/

/*
d) Requête avec not in
*/
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.prenom NOT IN ( SELECT b.prenom
                        FROM BigAnnuaire b
			WHERE b.age<=7);
@p3
/*explications:
acces table : BigAnnuaire
utilisation index sur l'age
acces table apres utilisation index age sur BigAnnuaire
hash join right anti (le not in)
affichage nom et prenom
*/

/*e) Requête avec not exists
*/
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE NOT EXISTS ( SELECT *
                       FROM BigAnnuaire b
		       WHERE b.prenom = a.prenom
		       AND b.age < a.age);
@p3
/*explications:
acces table BigAnnuaire
acces table BigAnnuaire 
(pour les deux requetes imbriquée ou non)
hash join anti ( le not exists)
affiche nom, prenom
*/

/*
f) Requête avec minus : les code spostaux des villes qui n'ont pas de centenaire.
*/
EXPLAIN plan FOR
  SELECT cp
  FROM BigAnnuaire a
  minus
   SELECT cp
   FROM BigAnnuaire b
   WHERE b.age>=100;
@p3
/*explications:
utilisation index : lecture de la teble sans toucher les donnees de la table : regarde juste les index
utilisation index sur age ( sur table BigAnnuaire )
hash join (joint les deux requetes)
view ?
sort unique ?
utilisation index : lecture de la teble sans toucher les donnees de la table : regarde juste les index
sort unique ?
minus : difference
affiche code postal
*/

/*g) requête avec where age >= ALL (…)
*/
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.age >= ALL (SELECT b.age 
                       FROM BigAnnuaire b
		       WHERE b.cp = 75000);
@p3

