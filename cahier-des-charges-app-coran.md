# Cahier des Charges — Ayaqli
## Application mobile & site web de recherche conceptuelle, audio et apprentissage du Coran

---

## 1. Contexte et vision du projet

Il n'existe pas aujourd'hui d'outil moderne, unifié et centré exclusivement sur le texte coranique qui permette de :
- Rechercher des concepts (ex : "mariage", "patience", "justice") et obtenir instantanément l'ensemble des versets liés, avec référence, texte arabe, traduction et explication.
- Écouter la récitation audio synchronisée de ces versets.
- Suivre un programme personnalisé de mémorisation et de révision.

**Principe fondateur du projet : tout le contenu repose exclusivement sur le Coran.** Aucune donnée issue des hadiths, tafsirs tiers ou autres sources externes n'est intégrée. Une seule source de vérité, ce qui garantit la fiabilité et évite tout débat sur le choix des interprétations à inclure.

---

## 2. Objectifs du projet

- Offrir un moteur de recherche thématique fiable et rapide sur l'intégralité du texte coranique.
- Permettre l'écoute audio de chaque verset, avec plusieurs récitateurs.
- Proposer un module d'apprentissage et de révision personnalisé (mémorisation).
- Démarrer par une application mobile, avec une version web à suivre.

---

## 3. Public cible

- Toute personne souhaitant étudier, comprendre ou mémoriser le Coran par thème plutôt que par ordre linéaire des sourates.
- Étudiants en sciences islamiques, élèves de médersa, autodidactes.
- Utilisateurs souhaitant un outil de mémorisation structuré (type "Anki" appliqué au Coran).

---

## 4. Périmètre fonctionnel

### 4.1 Module Recherche conceptuelle
- Barre de recherche par mot-clé ou concept (ex : "mariage").
- Résultats affichant, pour chaque verset pertinent :
  - Référence (sourate n°, verset n°)
  - Texte intégral en arabe
  - Traduction (française, éventuellement autres langues)
  - Explication (traduction claire du sens littéral ; versets liés entre eux quand pertinent)
- Recherche par mot-clé exact ET recherche sémantique (pour remonter des versets liés au concept même sans le mot exact).
- Liste des versets liés/similaires en complément des résultats.

### 4.2 Module Audio
- Lecture audio verset par verset, plusieurs récitateurs disponibles.
- Surlignage synchronisé du texte pendant la lecture (mode "suivi").
- Lecture en boucle / vitesse réduite pour l'apprentissage.
- Bouton lecture directement accessible depuis les résultats de recherche.

### 4.3 Module Apprentissage & Révision
- Choix du contenu à apprendre : sourate complète, plage de versets, ou thème.
- Découpage en unités de mémorisation (verset ou groupe de versets).
- Planification des révisions par répétition espacée (SRS) : les intervalles s'adaptent selon le niveau de maîtrise déclaré par l'utilisateur.
- Modes de révision :
  - Écoute audio répétée
  - Mode "texte masqué" (récitation par l'utilisateur)
  - Mode "trou à compléter"
- Tableau de bord de progression : versets maîtrisés, séries de jours, prochaines sessions prévues.
- Compte utilisateur nécessaire pour sauvegarder la progression.

### 4.4 Compte utilisateur
- Création de compte (email ou autre méthode à définir).
- Sauvegarde de la progression d'apprentissage et des préférences (récitateur favori, traduction favorite, etc.).
- Fonctionnement du module recherche possible sans compte (consultation libre) ; compte requis uniquement pour le module apprentissage.

---

## 5. Contraintes

- **Contenu strictement coranique** : aucune intégration de hadith ou de tafsir de tiers.
- Fiabilité du texte arabe et des traductions : utilisation de sources reconnues et de textes établis (ex : texte Uthmani standard).
- Disponibilité hors-ligne souhaitable pour la lecture et l'écoute (au moins pour le contenu déjà consulté/téléchargé).
- Application mobile en priorité, version web à suivre dans un second temps.

---

## 6. Architecture technique (proposition)

| Composant | Proposition |
|---|---|
| Application mobile | Flutter ou React Native |
| Backend | API (Node.js ou Python) |
| Base de données versets/traductions | Base relationnelle (PostgreSQL) |
| Recherche sémantique | Base vectorielle (ex : pgvector) sur les traductions |
| Stockage audio | Fichiers audio par verset et par récitateur, mis en cache localement |
| Authentification | Système de compte utilisateur standard |

---

## 7. Modèle de données (grandes lignes)

- **Verset** : sourate, numéro, texte arabe, traduction(s), translittération (optionnel)
- **Audio** : lien fichier audio par verset, par récitateur
- **Concept/Tag** : nom du concept ↔ liste de versets associés
- **Utilisateur** : identifiants, préférences (récitateur, traduction)
- **Progression** : versets appris, historique des révisions, prochaine date de révision (SRS)

---

## 8. Phases de réalisation (proposition)

1. **Phase 1 — Socle de données** : intégration du texte coranique arabe, traductions, et audio par verset.
2. **Phase 2 — Module Recherche** : recherche par mot-clé + tags thématiques de base.
3. **Phase 3 — Recherche sémantique** : amélioration de la recherche par concept.
4. **Phase 4 — Module Audio avancé** : synchronisation texte/audio, mode suivi.
5. **Phase 5 — Module Apprentissage** : système de compte, planification SRS, modes de révision.
6. **Phase 6 — Version web** : déclinaison des fonctionnalités sur le site web.

---

## 9. Points à valider / arbitrer

- [ ] Langue(s) de traduction à inclure au lancement (français seul, ou multilingue dès le départ ?)
- [ ] Récitateur(s) audio à intégrer en priorité
- [ ] Méthode d'authentification (email, téléphone, autre)
- [ ] Niveau de détail de "l'explication" pour chaque verset (traduction seule vs versets liés vs autre)
- [x] Nom de l'application : **Ayaqli**

---

*Document à faire évoluer selon les retours et ajustements.*
