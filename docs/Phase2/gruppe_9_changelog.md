# Changelog

Dieses Changelog ist eine aufgearbeitete Version der Commit History.

## Erster Game Jam

Übertragen von der Version für die erste Abgabe.

### Rev #1

- Repository und Projekt erstellt

### Rev #2

- Erstes Objekt "Player" erstellt

### Rev #3

- Vertikale Spielerbewegung des "Player" implementiert

### Rev #4

- Horizontale Bewegung des "Player" implementiert

### Rev #5

- Hintergrundgrafik mit Partikelsystem das aussieht wie Sterne implementiert um das Spiel hübscher zu machen

### Rev #6

- Raketentriebwerkanimation für den "Player" implementiert

### Rev #7

- Spielerbewegung verbessert: Bewegungen werden nun langsam beschleunigt und gebremst um mehr zu dem Weltraum Theme zu passen und Movement interessanter zu machen

### Rev #8

- Erste Implementierung eines Gegners

### Rev #9

- Verbesserungen am Gegnerverhalten, sie laufen nun auf den Spieler zu

### Rev #10

- Refactoring von Spieler-/Gegnerkollisionen
- Unbenutzte Szene entfernt

### Rev #11

- Schussmechanik integriert

### Rev #12

- Gegner-Spawning implementiert

### Rev #13

- Gegner können nun besiegt werden

### Rev #14

- Anzeigen für Energie und Gesundheit hinzugefügt

### Rev #15

- Energiemechanik und -verbrauch implementiert

### Rev #16

- Gesundheitsverlust für Spieler hinzugefügt

### Rev #17

- Refactoring

### Rev #18

- Kleinere Fehlerbehebungen

### Rev #19

- Menüdesign überarbeitet

### Rev #20

- Diverse Soundeffekte integriert und verbessert

### Rev #21

- Fehlerbehebung: Sound stoppte zu früh

### Rev #22

- Auspuffgeräusche ergänzt

### Rev #23

- Todesgeräusch für Gegner hinzugefügt

### Rev #24

- Refactoring der Spielerlogik

### Rev #25

- Spieler-Tod hinzugefügt

### Rev #26

- Begrenzung des Spielfeldes implementiert

### Rev #27

- Außenbereich des Spielfelds ist nun always-on-top um Grafikbugs zu vermeiden

### Rev #28

- Hilfe-Menü hinzugefügt welches das Spiel erklärt

### Rev #29

- Credits-Menü implementiert, welches Contributoren und genutzte Tools anzeigt

### Rev #30

- Der Spieler stirbt nun wenn er keine Energie hat um ihn zu zwingen Gegner zu töten

### Rev #31

- Das riesige Partikelsystem das sich über die gesamte Map erstreckt ist nun in 36 kleine geteilt, dadurch kann Godot die Teile die nicht auf der Map sind durch culling ausblenden was die Performance verbessert

### Rev #32

- Diverse Fehlerbehebungen

### Rev #33

- Refactoring der Codebase damit Herr Eckert beim lesen keinen kompletten Schlaganfall bekommt

### Rev #34

- Noch mehr Refactoring

### Rev #35

- Behebe ein Problem bei dem nach mehrmaligen sterben das Spiel crashte

### Rev #36 - 1ac691a91b9294bfb447161a087536a7502feee0

- Readme für die Repo um zu beschreiben was ihr Inhalt ist

## Zweite Abgabe

Neue Historie für die zweite Abgabe.

### Rev #37

- Neue Ordnerstruktur für besseren Überblick eingeführt

### Rev #38

- Upgrade-Menü grundlegend hinzugefügt

### Rev #39

- Besseres UI und Quality-of-Life-Verbesserungen

### Rev #40

- UI-Elemente für Upgrades hinzugefügt (UpgradeElement UI)

### Rev #41

- Öffnen und Schließen des Upgrade-Menüs implementiert

### Rev #42

- Kauf-Logik für Skills integriert

### Rev #43

- Speed, Health und Shield Upgrade hinzugefügt

### Rev #44

- Magnet, Heal und Teleport Skills hinzugefügt

### Rev #45

- Spieler-Code besser lesbar gemacht

### Rev #46

- Wave-basiertes Gegner-Spawning implementiert

### Rev #47

- Highscore-System implementiert:
  - Highscore wird nun berechnet und gespeichert
  - Highscore-Display hinzugefügt

### Rev #48

- Skillpoints-System eingebaut:
  - Skillpoints werden gesammelt und angezeigt
  - Skillpoints durch Gameplay verdienbar gemacht

### Rev #49

- Schwierigkeitsgrad angepasst (Rebalancing)

### Rev #50

- Weiteres Rebalancing für bessere Spielbalance

### Rev #51

- Pausenmenü ("Break Menu") implementiert

### Rev #52

- Verbesserungen am Pausenmenü:
  - Menü-Layout und Bedienung verbessert

### Rev #53

- Fehlerbehebung: Break-Phase wurde nach Schließen des Upgrade-Shops nicht korrekt angezeigt

### Rev #54

- Skillpoints durch das Besiegen von Gegnern sammelbar gemacht

### Rev #55

- Weitere Gegner-Wellen hinzugefügt

### Rev #56

- Highscore-Mechanik für den Wellenmodus implementiert

### Rev #57

- Fehlerbehebung: Punktestand-Funktionen fehlten in bestimmten Fällen

### Rev #58

- Neuer Gegnertyp "Spiral Enemy" hinzugefügt

### Rev #59

- Verbesserungen an der zweiten Gegnerwelle vorgenommen

### Rev #60

- Gegner-Spawning auf die Spielfeld-Arena begrenzt

### Rev #61

- Gegnerwellen 3 und 4 implementiert

### Rev #62

- Alternative Steuerung für den Spieler implementiert

### Rev #63

- Gegnerwelle 1 neu ausbalanciert

### Rev #64

- Neuer Gegner "Cruiser" implementiert

### Rev #65

- Neue Gegnerwelle mit "Cruiser" hinzugefügt

### Rev #66

- Fehlerbehebung: Endlosmodus funktionierte nicht korrekt

### Rev #67

- Weitere Anpassungen an Gegnerwellen für bessere Balance

### Rev #68

- Weitere Gegnerwelle hinzugefügt

### Rev #69

- Spiel insgesamt etwas einfacher gemacht (Balancing)

### Rev #70

- Fehlerbehebung: Skills wurden nach Spielende nicht zurückgesetzt

### Rev #71

- Neuer Skill "Rocket" implementiert

### Rev #72

- Diverse Fixes für iExpo Build (Fehlende Dateien, Deferred-Calls, Debug-Objekte entfernt)

### Rev #73

- Fehlerbehebung: Debug-Cruiser wurde doppelt im Menü angezeigt und entfernt

### Rev #74

- Weitere Fehlerbehebungen und Cleanup für iExpo

### Rev #75

- Performance-Verbesserungen:
  - Partikelanzahl reduziert
  - Allgemeine Performance optimiert

### Rev #76

- Fokustest Build
