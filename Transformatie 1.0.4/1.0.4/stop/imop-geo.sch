<?xml version="1.0" encoding="UTF-8"?>
<sch:schema queryBinding="xslt2" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="geo" uri="https://standaarden.overheid.nl/stop/imop/geo/" />
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform" />
  <sch:ns prefix="basisgeo" uri="http://www.geostandaarden.nl/basisgeometrie/1.0" />
  <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2" />

  <sch:p>Versie 1.0.4</sch:p>
  <sch:p>Schematron voor aanvullende validatie voor imop-geo.xsd</sch:p>

  <sch:pattern id="sch_geo_001" see="geo:Locatie">
    <sch:title>Locatie rules</sch:title>
    <sch:rule context="geo:locaties">
      <sch:let name="aantalLocaties" value="count(./geo:Locatie)" />
      <sch:let name="aantalLocatiesMetGroepID" value="count(./geo:Locatie/geo:groepID)" />
      <sch:let name="aantalLocatiesMetKwantitatieveNormwaarde"
        value="count(./geo:Locatie/geo:kwantitatieveNormwaarde)" />
      <sch:let name="aantalLocatiesMetKwalitatieveNormwaarde"
        value="count(./geo:Locatie/geo:kwalitatieveNormwaarde)" />

      <sch:p>Als er één locatie is in een GIO waar een waarde groepID is ingevuld MOETEN ze allemaal
        zijn ingevuld.</sch:p>
      <sch:assert id="STOP3000" role="error" test="($aantalLocatiesMetGroepID = 0) or ($aantalLocatiesMetGroepID = $aantalLocaties)">
        {"code": "STOP3000", "melding": "Als er één locatie is in een GIO waar een waarde groepID is ingevuld moet elke locatie een GroepID hebben. Geef alle locaties een groepID.", "ernst": "fout"},</sch:assert>

      <sch:p>Als er één locatie is in een GIO waar kwantitatieveNormwaarde is ingevuld MOETEN alle
        locaties een kwantitatieveNormWaarde hebben.</sch:p>
      <sch:assert id="STOP3006" role="error" test="($aantalLocatiesMetKwantitatieveNormwaarde = 0) or ($aantalLocatiesMetKwantitatieveNormwaarde = $aantalLocaties)">
        {"code": "STOP3006", "melding": "Een locatie heeft een kwantitatieveNormwaarde, en één of meerdere andere locaties niet. Geef alle locaties een kwantitatieveNormwaarde, of verwijder alle kwantitatieveNormwaardes.", "ernst": "fout"},</sch:assert>

      <sch:p>Als er één locatie is in een GIO waar kwalitatieveNormwaarde is ingevuld MOETEN alle
        locaties een kwalitatieveNormwaarde hebben.</sch:p>
      <sch:assert id="STOP3007" role="error" test="($aantalLocatiesMetKwalitatieveNormwaarde = 0) or ($aantalLocatiesMetKwalitatieveNormwaarde = $aantalLocaties)">
        {"code": "STOP3007", "melding": "Een locatie heeft een kwalitatieveNormwaarde, en één of meerdere andere locaties niet. Geef alle locaties een kwalitatieveNormwaarde, of verwijder alle kwalitatieveNormwaardes.", "ernst": "fout"},</sch:assert>

      <sch:p>Als de locaties van de GIO kwantitatieve normwaarden hebben, moet de
        eenheid(eenheidlabel en eenheidID) aanwezig zijn in de GIO.</sch:p>
      <sch:report id="STOP3009" role="error" test="(($aantalLocatiesMetKwantitatieveNormwaarde gt 0) and ((not(exists(../geo:eenheidlabel))) or (not(exists(../geo:eenheidID)))))">
        {"code": "STOP3009", "Work-ID": "<sch:value-of select="../geo:FRBRWork" />", "melding": "De locaties van de GIO <sch:value-of select="../geo:FRBRWork" /> bevatten kwantitatieve normwaarden, terwijl eenheidlabel en/of eenheidID ontbreken. Vul deze aan.", "ernst": "fout"},</sch:report>


      <sch:p>Als de locaties van de GIO kwalitatieve normwaarden hebben, MOGEN eenheidlabel en
        eenheidID NIET voorkomen.</sch:p>
      <sch:report id="STOP3015" role="error" test="(($aantalLocatiesMetKwalitatieveNormwaarde gt 0) and ((exists(../geo:eenheidlabel) or exists(../geo:eenheidID))))">
        {"code": "STOP3015", "Work-ID": "<sch:value-of select="../geo:FRBRWork" />", "melding": "De GIO met Work-ID <sch:value-of select="../geo:FRBRWork" /> met kwalitatieve normwaarden, mag geen eenheidlabel noch eenheidID hebben. Verwijder eenheidlabel en eenheidID toe, of verwijder de kwalitatieve normwaarden.", "ernst": "fout"},</sch:report>


      <sch:p>Als de locaties van de GIO kwantitatieve òf kwalitatieve normwaarden hebben, dan moet
        de norm (normlabel en normID) aanwezig zijn.</sch:p>
      <sch:report id="STOP3011" role="error" test="((($aantalLocatiesMetKwantitatieveNormwaarde + $aantalLocatiesMetKwalitatieveNormwaarde) gt 0) and ((not(exists(../geo:normlabel))) or (not(exists(../geo:normID)))))">
        {"code": "STOP3011", "Work-ID": "<sch:value-of select="../geo:FRBRWork" />", "melding": "De locaties binnen GIO met Work-ID <sch:value-of select="../geo:FRBRWork" /> bevatten wel kwantitatieve òf kwalitatieve normwaarden, maar geen norm. Vul normlabel en normID aan.", "ernst": "fout"},</sch:report>

      <sch:p>Binnen 1 GIO mag elke basisgeo:id (GUID) van de geometrie van een locatie maar één keer
        voorkomen.</sch:p>
      <sch:assert id="STOP3013" role="error" test="count(./geo:Locatie/geo:geometrie/basisgeo:Geometrie/basisgeo:id) = count(distinct-values(./geo:Locatie/geo:geometrie/basisgeo:Geometrie/basisgeo:id))">
        {"code": "STOP3013", "Work-ID": "<sch:value-of select="../geo:FRBRWork" />", "melding": "In Work-ID <sch:value-of select="../geo:FRBRWork" /> zijn de basisgeo:id's niet uniek. Binnen 1 GIO mag basisgeo:id van geometrieen van verschillende locaties niet gelijk zijn aan elkaar. Pas dit aan.", "ernst": "fout"},</sch:assert>

    </sch:rule>

    <sch:rule context="geo:locaties/geo:Locatie">
      <sch:let name="ID" value="./geo:geometrie/basisgeo:Geometrie/basisgeo:id" />

      <sch:p>Van de elementen kwalitatieveNormwaarde en kwantitatieveNormwaarde in een Locatie mag
        er slechts één ingevuld zijn.</sch:p>
      <sch:assert id="STOP3008" role="error" test="count(./geo:kwantitatieveNormwaarde) + count(./geo:kwalitatieveNormwaarde) le 1">
        {"code": "STOP3008", "ID": "<sch:value-of select="$ID" />", "melding": "Locatie met basisgeo:id <sch:value-of select="$ID" /> heeft zowel een kwalitatieveNormwaarde als een kwantitatieveNormwaarde. Verwijder één van beide.", "ernst": "fout"},</sch:assert>

      <sch:p>Een Locatie binnen een GIO mag niet zowel een groepID (GIO-deel) als een (kwalitatieve
        of kwantitatieve) Normwaarde bevatten.</sch:p>
      <sch:report id="STOP3012" role="error" test="exists(./geo:groepID) and (exists(./geo:kwalitatieveNormwaarde) or exists(./geo:kwantitatieveNormwaarde))">
        {"code": "STOP3012", "ID": "<sch:value-of select="$ID" />", "melding": "Locatie met basisgeo:id <sch:value-of select="$ID" /> heeft zowel een groepID (GIO-deel) als een (kwalitatieve of kwantitatieve) Normwaarde. Verwijder de Normwaarde of de groepID.", "ernst": "fout"},</sch:report>      
    </sch:rule>

    <sch:rule context="geo:locaties/geo:Locatie/geo:kwalitatieveNormwaarde">
      <sch:p>Een kwalitatieveNormwaarde mag geen lege string (“”) zijn.</sch:p>
      <sch:assert id="STOP3010" role="error" test="normalize-space(.)">
        {"code": "STOP3010", "ID": "<sch:value-of select="../geo:geometrie/basisgeo:Geometrie/basisgeo:id" />", "melding": "De kwalitatieveNormwaarde van locatie met basisgeo:id <sch:value-of select="../geo:geometrie/basisgeo:Geometrie/basisgeo:id" /> is niet gevuld. Vul deze aan.", "ernst": "fout"},</sch:assert>
    </sch:rule>

  </sch:pattern>

  <sch:pattern id="sch_geo_002" see="geo:groepID">
    <sch:title>Als een locatie een groepID heeft, dan MOET deze voorkomen in het lijstje
      groepen.</sch:title>
    <sch:rule context="geo:Locatie/geo:groepID">
      <sch:let name="doelwit" value="./string()" />
      <sch:p>Als een locatie een groepID heeft, dan MOET deze voorkomen in het lijstje
        groepen.</sch:p>
      <sch:assert id="STOP3001" role="error" test="count(../../../geo:groepen/geo:Groep[./geo:groepID = $doelwit]) gt 0">
        {"code": "STOP3001", "ID": "<sch:value-of select="$doelwit" />", "melding": "Als een locatie een groepID heeft, dan MOET deze voorkomen in het lijstje groepen. GroepID <sch:value-of select="$doelwit" /> komt niet voor in groepen. Geef alle locaties een groepID die voorkomt in groepen.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_geo_003" see="geo:groepID">
    <sch:title>Als GroepID voorkomt mag het niet leeg zijn.</sch:title>
    <sch:rule context="geo:groepID">
      <sch:p>Als GroepID voorkomt mag het niet leeg zijn.</sch:p>
      <sch:assert id="STOP3002" role="error" test="normalize-space(.)">
        {"code": "STOP3002", "melding": "Als GroepID voorkomt mag het niet leeg zijn. Geef een correcte groepID.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_geo_004" see="geo:groepen">
    <sch:title>Check op unieke labels en groepIDs.</sch:title>
    <sch:rule context="geo:groepen">
      <sch:p>Twee groepIDs in het lijstje groepen mogen niet dezelfde waarde hebben.</sch:p>
      <sch:assert id="STOP3003" role="error" test="count(./geo:Groep/geo:groepID) = count(distinct-values(./geo:Groep/geo:groepID))">
        {"code": "STOP3003", "melding": "Een groepID komt meerdere keren voor. Geef unieke groepIDs.", "ernst": "fout"},</sch:assert>
      <sch:assert id="STOP3004" role="error" test="count(./geo:Groep/geo:label) = count(distinct-values(./geo:Groep/geo:label))">
        {"code": "STOP3004", "melding": "Een label komt meerdere keren voor. Geef een unieke labels.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_geo_005" see="geo:groepID">
    <sch:title>Als een groepID voorkomt in het lijstje groepen dan MOET er minstens 1 locatie zijn
      met dat groepID.</sch:title>
    <sch:rule context="geo:groepen/geo:Groep/geo:groepID">
      <sch:let name="doelwit" value="./string()" />
      <sch:p>Als een groepID voorkomt in het lijstje groepen dan MOET er minstens 1 locatie zijn met
        dat groepID.</sch:p>
      <sch:assert id="STOP3005" role="error" test="count(../../../geo:locaties/geo:Locatie[./geo:groepID = $doelwit]) gt 0">
        {"code": "STOP3005", "ID": "<sch:value-of select="$doelwit" />", "melding": "GroepID <sch:value-of select="$doelwit" /> wordt niet gebruikt voor een locatie. Verwijder deze groep, of gebruik de groep bij een Locatie.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_geo_006" see="geo:eenheidlabel geo:eenheidID geo:normlabel geo:normID">
    <sch:title>Geen norm elementen in een GIO zonder normwaarde.</sch:title>
    <sch:rule context="geo:GeoInformatieObjectVersie">
      <sch:p>In een GIO waar locaties geen kwalitatieve of kwantitatieve normwaarde hebben, MOGEN
        eenheidID, eenheidlabel, normID en normlabel NIET voorkomen.</sch:p>
      <sch:report id="STOP3016" role="error" test="(exists(geo:normID) or exists(geo:normlabel) or exists(geo:eenheidID) or exists(geo:eenheidlabel)) and (count(geo:locaties/geo:Locatie/geo:kwantitatieveNormwaarde) + count(geo:locaties/geo:Locatie/geo:kwalitatieveNormwaarde) = 0)">
       {"code": "STOP3016", "Work-ID": "<sch:value-of select="geo:FRBRWork" />", "melding": "De GIO met Work-ID <sch:value-of select="geo:FRBRWork" /> bevat norm (normID en normlabel) en/of eenheid (eenheidID en eenheidlabel), terwijl kwantitatieve of kwalitatieve normwaarden ontbreken. Geef de locaties normwaarden of verwijder de norm/eenheid elementen.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>

  <sch:pattern id="sch_geo_007" see="geo:wasID">
    <sch:title>wasID rules</sch:title>
    <sch:rule context="geo:wasID">
      <sch:p>Als een GIO een wasID heeft, dan MOET de wasID een voorgaande expressie zijn van
        hetzelfde work.</sch:p>
      <sch:assert id="STOP3017" role="error" test="starts-with(., ../geo:vastgesteldeVersie/geo:GeoInformatieObjectVersie/geo:FRBRWork)"> 
        {"code": "STOP3017", "Expression-ID": "<sch:value-of select="../geo:vastgesteldeVersie/geo:GeoInformatieObjectVersie/geo:FRBRExpression" />", "ID": "<sch:value-of select="." />", "Work-ID": "<sch:value-of select="../geo:vastgesteldeVersie/geo:GeoInformatieObjectVersie/geo:FRBRWork" />", "melding": "De wasID (<sch:value-of select="." />) van de GIO met Work-ID <sch:value-of select="../geo:vastgesteldeVersie/geo:GeoInformatieObjectVersie/geo:FRBRWork" /> is geen voorgaande expressie van dit work met Expression-ID <sch:value-of select="../geo:vastgesteldeVersie/geo:GeoInformatieObjectVersie/geo:FRBRExpression" /> . Verbeter de WasID.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
