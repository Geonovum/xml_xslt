# Downloadpakketjes transformeren naar initieel besluit
De transformatie voor het transformeren van downloadpakketjes naar initieel besluit gaat uit van de standaard-pakketjes. Wat niet nodig is wordt niet gebruikt.

## Installatie
De opbouw van de transformatie gaat uit van verwerking vanuit Oxygen. De xslt-processor is Saxon-pe of Saxon-ee. Vooraf is het nodig om het certificaat van '*.officiele-overheidspublicaties.nl' op te slaan in de keystore van Oxygen. Doe dat als volgt:
1. Download en installeer de toepassing 'KeyStore Explorer' van https://keystore-explorer.org/downloads.html
2. Open de applicatie en open keystore 'cacert' in de oxygen-map '[Oxygen]/jre/lib/security/cacert'. Wachtwoord voor cacerts is 'changeit'.
3. Importeer het bijgevoegde certificaat 'overheid.cer'. Let erop, deze is geldig tot 5-5-2023, dus daarna moet deze opnieuw toegevoegd worden.
4. Sla de keystore op.
5. kijk of de commons.jar (in ons geval: commons-codec-1.9.jar) in de library zit, zo niet voeg deze toe bij het project.

Nu moet het mogelijk zijn om vanuit het build-script gml-bestanden te downloaden van de downloadpagina. Let erop, dat dit dient te gebeuren voordat de pre/eto-omgeving is leeggehaald.

## Transformeren
De werkwijze is als gebruikelijk.
1. Plaats de inhoud van het downloadpakketje in de map 'input'.
2. Voer het ant-script build.xml uit. Let erop dat hiervoor de Saxon-pe of Saxon-ee processor wordt gebruikt.

Het resultaat wordt in de map 'output' geplaatst. In de map 'temp' staat nog een handig tijdelijk bestand 'filelist.xml' dat in verkorte vorm belangrijke informatie over de GIO's bevat.