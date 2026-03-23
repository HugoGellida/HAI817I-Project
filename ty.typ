#import "../template.typ": *

#show: (doc) => template(doc, titre: [Classifieur de texte \ Machine learning])


= Introduction

Aujourd'hui, le `machine learning` s’impose comme un outil essentiel pour l’analyse et l’interprétation de données. La classification de texte permet d’attribuer automatiquement des catégories à des documents, facilitant leur organisation, leur recherche et leur exploitation.

Ce rapport s’inscrit dans cette problématique en implémentant un classifieur de texte appliqué au jeu de données `SciTweets` @data-set. L’objectif principal est de créer un pipeline @pipeline servant à classifier le texte, puis de l'essayer sur plusieurs sous-ensemble distincts du jeu de données (scientifiques/non-scientifiques, claim ou référence/contexte, claim/référence/contexte).

Ce travail vise à analyser l’efficacité du pipeline sur les différents sous-ensembles du jeu de données et à mettre en évidence les enjeux liés à la qualité des données.

Ce projet est divisé en 3 grandes parties:
- Jeu de données
- Pipeline
- Amélioration des données

= Jeu de données `SciTweets`

== C’est quoi `SciTweets`

Le premier objectif de ce projet est de pouvoir comprendre le jeu de données `SciTweets`, car cela nous permettra de pouvoir le manipuler facilement.

`SciTweets` est un jeu de données composé de messages courts issus de la plateforme Twitter (X), portant sur des thématiques scientifiques. Chaque texte est associé à une ou plusieurs catégories (labels), ce qui permet de l’exploiter dans des tâches de classification automatique.

Les informations disponibles dans ce jeu de données sont les suivantes:
- `tweet_id` : l’identifiant du tweet
- `text` : le contenu du tweet
- `science_related` : indique si le tweet est lié à la science
- `scientific_claim` : indique si le tweet formule une affirmation ou une hypothèse scientifique
- `scientific_reference` : indique si le tweet cite une référence scientifique
- `scientific_context` : indique si le tweet s’inscrit dans une discussion scientifique plutôt que dans une opinion personnelle

Il est important de noter que lorsqu’un tweet est classé comme scientifique (`science_related`), il appartient nécessairement à au moins une des sous-catégories suivantes : `claim`, `reference` ou `context`. Par ailleurs, un même tweet peut appartenir à plusieurs sous-catégories simultanément.

== Manipulation du jeu de données

Une fois que nous avons compris chaque informations que contenait `SciTweets`, nous sommes capable de créer d'autres jeux de données compatible au pipeline. Les objectifs de ces jeux de données se concentrent précisément sur:
- Différencier un tweet scientifique d'un tweet non-scientifique
- Différencier un tweet de sous-catégorie `claim` ou `reference` de ceux de sous-catégorie `context`
- Différencier les tweets `claim`, `reference` et `context`.

Pour que nos jeux de données soient compatible avec notre futur pipeline, il faut qu'ils respectent un format prédéfini en avance:
- `text`: le contenu du tweet
- `info`: la colonne permettant de différencier les tweets.

Lors de la manipulation de `SciTweets`, nous sommes forcés à supprimer une colonne créée au préalable, car elle ne contient aucune information exploitable. Pour le premier jeu de données, la colonne `info` est définie comme un simple booléen indiquant si un tweet est scientifique ou non. Pour le deuxième et troisième jeux de données, les sous-catégories sont regroupées et encodées en one-hot @hot-one, ce qui permet de représenter l’ensemble des informations au sein de la colonne `info`. Nous ne pouvons pas simplement faire un booléen comme le premier car les tweets peuvent être de plusieurs sous-catégories.

= Pipeline

La préparation du jeu de données `SciTweets` ainsi que la création de ses sous-ensembles constituent la première étape de notre pipeline. Comme mentionné précédemment, il est essentiel que chaque sous-ensemble respecte un format identique. Cela permet de réutiliser le même pipeline sans modification, indépendamment de la tâche de classification considérée.

Une fois les jeux de données préparés, nous procédons à la séparation des données en variables d’entrée et de sortie. La variable X correspond au texte des tweets, tandis que la variable y correspond à la colonne info, qui contient les labels à prédire. Le jeu de données est ensuite divisé en deux parties: un ensemble d’entraînement (70 %) et un ensemble de test (30 %).

Avant l’entraînement des modèles, les données textuelles doivent être transformées en une représentation numérique exploitable, appelée vectorisation. Cette étape permet de convertir les textes en vecteurs de caractéristiques.

Plusieurs modèles de classification sont ensuite étudiés afin de comparer leurs performances:
- `KNeighborsClassifier`
- `DecisionTreeClassifier`
- `SVC` (`Support Vector Classifier`)
- `RandomForestClassifier`

Chaque modèle est entraîné sur l’ensemble d’apprentissage, puis évalué sur l’ensemble de test.

Enfin, les performances des modèles sont analysées à l’aide de métriques adaptées. En particulier, la matrice de confusion permet de visualiser les prédictions correctes et incorrectes pour chaque classe. Cette analyse est essentielle pour mieux comprendre le comportement du modèle, notamment en présence de déséquilibres entre les classes.

= Améliorations des données

Nous remarquons, lors de la création des jeux de données, que les classes sont très déséquilibrées (par exemple, une classe contient 300 tweets contre seulement 50 pour une autre). Cela implique que le modèle produit par le pipeline est performant pour identifier les tweets de la classe majoritaire, mais nettement moins efficace pour ceux de la classe minoritaire. Le taux de précision peut alors apparaître élevé, mais il reflète principalement la bonne performance sur la classe dominante.

L’une des solutions adoptées pour remédier à ce problème est l’`up-sampling`. Cette technique consiste à augmenter artificiellement le nombre d’exemples de la classe minoritaire, soit par duplication de données existantes, soit par génération de nouvelles données, jusqu’à obtenir un meilleur équilibre entre les classes.

Cette approche peut entraîner une diminution apparente du taux de précision global, mais elle permet d’obtenir une évaluation plus représentative des performances du modèle. Les métriques deviennent alors plus équilibrées entre les différentes classes, améliorant notamment la capacité du modèle à détecter les classes minoritaires et offrant ainsi une meilleure généralisation.

Il existe notamment une autre méthode pour bien équilibré le jeu de données étant le `down-sampling`. Son principe est de diminuer le nombre de données de la classe dominante. Nous avons décidé de ne pas utiliser cette méthode par crainte que le nombre de données utilisées lors de l’entraînement serait alors trop bas.

= Bibliographie

#bibliography("biblio.yml", title: none)

= Annexe

== Exemple annexe <Annexe>

#pagebreak()
#pagebreak()

#link(<Annexe>)[Cliquez-moi!]