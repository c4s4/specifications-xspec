Spécifications Xspec
====================

Michel Casabianca

m.casabianca-ext@lefevbre-sarrut.eu

---
Comment fonctionne Xspec ?
--------------------------

Xspec est un framework de test unitaire pour XSLT. Il permet d'appliquer une transformation sur un fragment XML et de vérifier *automatiquement* que le résultat de cette transformation est celui attendu.

Par exemple, pour vérifier que le fragment :

```xml
<auteur>
  <aute>Florence LAROCHE-GISSEROT</aute>
</auteur>
```

Est transformé en :

```xml
<AUTEUR>
  <AUTEUR-NOM-COMPLET>
    <AUT-PRENOM>Florence</AUT-PRENOM>
    <AUT-NOM>LAROCHE-GISSEROT</AUT-NOM>
  </AUTEUR-NOM-COMPLET>
</AUTEUR>
```

On écrira le test suivant :

---
Exemple de test
---------------

```xml
<?xml version="1.0" encoding="UTF-8"?>

<x:description xmlns:x="http://www.jenitennison.com/xslt/xspec"
               stylesheet="../../main/xsl/main.xsl">

  <x:scenario label="Prénom nom">
    <x:context>
      <auteur>
        <aute>Florence LAROCHE-GISSEROT</aute>
      </auteur>
    </x:context>

    <x:expect label="Doit donner...">
      <AUTEUR>
        <AUTEUR-NOM-COMPLET>
          <AUT-PRENOM>Florence</AUT-PRENOM>
          <AUT-NOM>LAROCHE-GISSEROT</AUT-NOM>
        </AUTEUR-NOM-COMPLET>
      </AUTEUR>
    </x:expect>
  </x:scenario>

</x:description>
```

---
Résultat des tests
------------------

On pourra exécuter ce test dans Oxygen ou en ligne de commande. Xspec produit alors un rapport de test qui indique les tests ayant échoué avec le résultat obtenu comparé au résultat attendu :

![Test en échec](img/echec-test.png)

Cette manière d'afficher la différence entre le résultat de la transformation et le résultat attendu est extrêmement pratique.

---
Éléments *context* et *expect*
------------------------------

A noter que l'on peut, pour l'élément *context* :

- Indiquer le contexte courant dans le fragment XML de l'entrée avec l'attribut *select*.
- Indiquer le mode dans lequel on doit appliquer la transformation avec l'attribut *mode*.
- Indiquer un fichier dans lequel se trouve le fragment XML de l'entrée avec l'attribut *href*.

Pour l'élément *expect* :

- Indiquer le résultat attendu dans l'attribut *select* (avec une expression Xpath).
- Indiquer une condition à tester dans un attribut *test* (avec une expression Xpath dont le résultat est un booléen).
- Indiquer le résultat attendu par le contenu d'un fichier avec l'attribut *href*.

Il est possible écrire plus d'un élément *expect*.

---
Astuces utiles
--------------

Il est aussi utile de savoir que l'on peut :

- Désactiver des tests en les entourant d'un élément *pending*.
- Ignorer tous les autres tests avec l'attribut *focus*.

Enfin, on peut inclure un fichier de tests dans un autre (avec l'élément *import*). On aura alors intérêt à lancer un unique fichier *main.xspec* qui importe tous les autres.

À noter que l'on peut aussi tester une **fonction**, avec un test de la forme :

```xml
<x:scenario label="Date publication août">
  <x:call function="els:date-publication">
    <x:param select="'2016-08'"/>
  </x:call>
  <x:expect label="2016-08 == 2016-3"
            select="'2016-3'"/>
</x:scenario>
```

---
Pourquoi utiliser Xspec ?
-------------------------

Les raisons sont les mêmes que pour tout langage de programmation :

- Pour éviter les régressions.
- Pour pouvoir se concentrer sur un problème réduit (la transformation d'un élément *auteur*, sans avoir à manipuler un document entier).
- Pour pouvoir facilement tester de nombreux cas aux limites.

Mais surtout, c'est le fait que ces tests soient **automatisés** qui est important. On peut alors envisager :

- D'effectuer du refactoring en limitant les risques.
- Valider facilement la transformation avant une release.
- Mettre en place une intégration continue.

---
Spécifications Xspec
--------------------

En utilisant Xspec et en voyant le rapport de tests, je me suis dit que l'on pourrait spécifier la transformation avec un document qui indiquerait sur une colonne l'entrée de la transformation et sur une autre son résultat :

![Spécifications](img/specifications.png)

J'ai donc écrit une transformation XSLT pour produire cette page de spécifications à partir d'un jeu de tests Xspec. Cette feuille de style est disponible à l'adresse <https://bitbucket.org/elsgestion/sie-encyclo-ouvrage/src/04f5271a9ff0a4497e926f4c90e90b232a2116aa/src/main/xsl/specifications.xsl>.

---
Spécifications Excel
--------------------

Aux ELS, on a pour habitude de spécifier les transformations avec une feuille Excel du type :

![Spécification Excel](img/excel.png)

L'intérêt des spécifications Xspec est multiple :

- Ces spécifications sont **vivantes** : si elles ne correspondent pas à l'implémentation de la transformation, le test Xspec échoue.
- Du fait qu'elles sont validées lors de tests, elles sont **à jour**.
- Elles peuvent rendre compte de la richesse structurelle du XML. Ce n'est pas une bête correspondance 1:1 du fichier Excel qui est loin de la réalité.
- Elles servent de test, écrire ces spécifications n'est donc pas une tâche purement administrative.

---
Exemple de projet réel
----------------------

Ces tests Xspec ont été mis en œuvre à grande échelle sur le projet de transformation des encyclopédies Dalloz de la DTD Encyclopédie vers la DTD Ouvrage.

Le projet se trouve sur Bitbucket à l'adresse <https://bitbucket.org/elsgestion/sie-encyclo-ouvrage>.

Ce projet permet de nourrir le débat sur :

- La généralisation des tests Xspec en cours de développement.
- L'utilisation de spécifications Xspec comme outil de communication sur la transformation à réaliser.

---
Merci pour votre attention
==========================
