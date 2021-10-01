Zet de om te nummeren bestanden in de bron-directory. Het resultaat verschijnt in de resultaat directory.
De bron bestanden worden niet gewijzigd.

Zijn er meerdere gerelateerde bestanden (multi-versie databestanden), zie dan de "test-set-gemeentestad (multieversie)" directory voor de juiste directory layout.
Het komt hier op neer:

De start-dataset komt in de directory "bron"
Alle subsequente datasets komen in directories "bron_1", "bron_2", etc

Binnen OXygen is een zeer grote data-set (omgevingsverordening-utrecht, 270 bestanden) binnen anderhalve minuut gereed.
In MingW heb ik gemerkt kan het tot tien minuten duren

Tijdens het draaien is een Internet verbinding nodig. Het script haalt unieke GUIDs op via een internet API.

Mocht het binnen MingW of DOS te langzaam draaien, dan kan volgende helpen:
In MingW: export ANT_OPTS="-Xmx2G -XX:MaxPermSize=512m"
In DOS "export" wijzigen in "set"
