<?xml version="1.0" encoding="UTF-8"?>
<sch:schema queryBinding="xslt2" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="tekst" uri="https://standaarden.overheid.nl/stop/imop/tekst/"/>
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <!-- -->
  <sch:p>Versie 1.0.4</sch:p>
  <sch:p>Schematron voor aanvullende validatie voor imop-tekst.xsd</sch:p>
  <sch:pattern id="sch_tekst_001" see="tekst:Lijst tekst:Li tekst:LiNummer">
    <sch:title>Lijst - Nummering lijstitems</sch:title>
    <sch:rule context="tekst:Lijst[@type = 'ongemarkeerd']">
      <sch:assert id="STOP0001" role="error" test="count(tekst:Li/tekst:LiNummer) = 0"> {"code": "STOP0001", "eId": "<sch:value-of select="@eId"/>", "melding": "De Lijst met eId <sch:value-of select="@eId"/> van type 'ongemarkeerd' heeft LiNummer-elementen met een nummering of symbolen, dit is niet toegestaan. Pas het type van de lijst aan of verwijder de LiNummer-elementen.", "ernst": "fout"},</sch:assert>
    </sch:rule>
    <!--  -->
    <sch:rule context="tekst:Lijst[@type = 'expliciet']">
      <sch:assert id="STOP0002" role="error"
        test="count(tekst:Li[tekst:LiNummer]) = count(tekst:Li)"> {"code": "STOP0002", "eId": "<sch:value-of select="@eId"/>", "melding": "De Lijst met eId <sch:value-of select="@eId"/> van type 'expliciet' heeft geen LiNummer elementen met nummering of symbolen, het gebruik van LiNummer is verplicht. Pas het type van de lijst aan of voeg LiNummer's met nummering of symbolen toe aan de lijst-items", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_022" see="tekst:Al">
    <sch:title>Alinea - Bevat content</sch:title>
    <sch:rule context="tekst:Al">
      <sch:report id="STOP0005" role="error"
        test="normalize-space(.) = '' and not(tekst:InlineTekstAfbeelding)"> {"code": "STOP0005", "element": "<sch:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/>", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "melding": "De alinea voor element <sch:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/> met id <sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/> bevat geen tekst. Verwijder de lege alinea", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_027" see="tekst:Kop">
    <sch:title>Kop - Bevat content</sch:title>
    <sch:rule context="tekst:Kop">
      <sch:report id="STOP0006" role="error" test="normalize-space(.) = ''"> {"code": "STOP0006", "element": "<sch:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/>", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "melding": "De kop voor element <sch:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/> met id <sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/> bevat geen tekst. Corrigeer de kop of verplaats de inhoud naar een ander element", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_003" see="tekst:table tekst:NootRef">
    <sch:title>Tabel - Referenties naar een noot</sch:title>
    <sch:rule context="tekst:table//tekst:Nootref">
      <sch:let name="nootID" value="@refid"/>
      <sch:assert id="STOP0008" test="ancestor::tekst:table//tekst:Noot[@id = $nootID]"> {"code": "STOP0008", "ref": "<sch:value-of select="@refid"/>", "eId": "<sch:value-of
          select="ancestor::tekst:table/@eId"/>", "melding": "De referentie naar de noot met id <sch:value-of select="@refid"/> verwijst niet naar een noot in dezelfde tabel <sch:value-of
          select="ancestor::tekst:table/@eId"/>. Verplaats de noot waarnaar verwezen wordt naar de tabel of vervang de referentie in de tabel voor de noot waarnaar verwezen wordt", "ernst": "fout"},</sch:assert>
    </sch:rule>
    <sch:rule context="tekst:Nootref">
      <sch:let name="nootID" value="@refid"/>
      <sch:assert id="STOP0007" test="ancestor::tekst:table"> {"code": "STOP0007", "ref": "<sch:value-of select="@refid"/>", "melding": "De referentie naar de noot met id <sch:value-of select="@refid"/> staat niet in een tabel. Vervang de referentie naar de noot voor de noot waarnaar verwezen wordt", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_004" see="tekst:Lijst tekst:Li tekst:table">
    <sch:title>Lijst - plaatsing tabel in een lijst</sch:title>
    <sch:rule context="tekst:Li[tekst:table]">
      <sch:report id="STOP0009" role="warning"
        test="self::tekst:Li/tekst:table and not(ancestor::tekst:Instructie)"> {"code": "STOP0009", "eId": "<sch:value-of select="@eId"/>", "melding": "Het lijst-item <sch:value-of select="@eId"/> bevat een tabel, onderzoek of de tabel buiten de lijst kan worden geplaatst, eventueel door de lijst in delen op te splitsen", "ernst": "waarschuwing"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="sch_tekst_032" see="tekst:Illustratie tekst:InlineTekstAfbeelding">
    <sch:title>Illustratie - attributen kleur en schaal worden niet ondersteund</sch:title>
    <sch:rule context="tekst:Illustratie | tekst:InlineTekstAfbeelding">
      <sch:report id="STOP0045" role="warning" test="@schaal"> {"code": "STOP0045", "ouder": "<sch:value-of select="local-name(ancestor::*[@eId][1])"/>", "eId": "<sch:value-of
          select="ancestor::*[@eId][1]/@eId"/>", "melding": "De Illustratie binnen <sch:value-of select="local-name(ancestor::*[@eId][1])"/> met eId <sch:value-of
          select="ancestor::*[@eId][1]/@eId"/> heeft een waarde voor attribuut @schaal. Dit attribuut wordt genegeerd in de publicatie van documenten volgens STOP 1.0.4. In plaats daarvan wordt het attribuut @dpi gebruikt voor de berekening van de afbeeldingsgrootte. Verwijder het attribuut @schaal.", "ernst": "waarschuwing"},</sch:report>
      <sch:report id="STOP0046" role="warning" test="@kleur"> {"code": "STOP0046", "ouder": "<sch:value-of select="local-name(ancestor::*[@eId][1])"/>", "eId": "<sch:value-of
          select="ancestor::*[@eId][1]/@eId"/>", "melding": "De Illustratie binnen <sch:value-of select="local-name(ancestor::*[@eId][1])"/> met eId <sch:value-of
          select="ancestor::*[@eId][1]/@eId"/> heeft een waarde voor attribuut @kleur. Dit attribuut wordt genegeerd in de publicatie van STOP 1.0.4. Verwijder het attribuut @kleur.", "ernst": "waarschuwing"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_005" see="tekst:Divisietekst tekst:Kop">
    <sch:title>Divisietekst - gebruik verplichte Kop</sch:title>
    <sch:rule
      context="tekst:Divisietekst[not(child::tekst:Kop)][ancestor::tekst:Bijlage[starts-with(@wId, 'mnre1034_1-0__cmp_') or starts-with(@wId, 'mnre1034_2-0__cmp_')]]">
      <sch:assert id="STOP0042" role="warning"
        test="parent::tekst:Bijlage and (count(parent::tekst:*/tekst:Divisietekst) + count(parent::tekst:*/tekst:Divisie) = 1)"
        > {"code": "STOP0042", "eId": "<sch:value-of select="@eId"/>", "melding": "Een Kop voor Divisietekst met eId <sch:value-of select="@eId"/> is eigenlijk verplicht; maar deze waarschuwing is alleen voor de Omgevingsregeling (OR) niet blokkerend.", "ernst": "waarschuwing"},</sch:assert>
    </sch:rule>
    <sch:rule
      context="tekst:Divisietekst[not(child::tekst:Kop)][not(ancestor::tekst:RegelingMutatie)]">
      <sch:assert id="STOP0041" role="error"
        test="(parent::tekst:Bijlage | parent::tekst:Toelichting | parent::tekst:Motivering | parent::tekst:AlgemeneToelichting | ancestor::tekst:Kennisgeving) and (count(parent::tekst:*/tekst:Divisietekst) + count(parent::tekst:*/tekst:Divisie) = 1)"
        > {"code": "STOP0041", "eId": "<sch:value-of select="@eId"/>", "melding": "Een Kop voor Divisietekst met eId <sch:value-of select="@eId"/> is verplicht. Voeg een valide Kop aan deze Divisietekst toe, wijzig Divisietekst naar Inleidendetekst, of wijzig het bovenliggende element Divisie naar Divisietekst", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    INTERNE REFERENTIES HEBBEN CORRECTE VERWIJZINGEN
  -->
  <sch:pattern id="sch_tekst_006" see="tekst:IntRef">
    <sch:title>Referentie intern - correcte verwijzing</sch:title>
    <sch:rule context="tekst:IntRef[not(ancestor::tekst:RegelingMutatie)]">
      <sch:let name="doelwit" value="@ref"/>
      <sch:assert id="STOP0010" role="error" test="//*[@eId = $doelwit] | //*[@wId = $doelwit]"> {"code": "STOP0010", "element": "<sch:name/>", "ref": "<sch:value-of select="$doelwit"
        />", "melding": "De @ref van element <sch:name/> met waarde <sch:value-of select="$doelwit"
        /> verwijst niet naar een bestaande identifier van een tekst-element in de tekst van dezelfde expression als waar de verwijzing in staat. Controleer de referentie, corrigeer of de referentie of de identificatie van het element waarnaar wordt verwezen.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="sch_tekst_034" see="tekst:IntRef">
    <sch:title>Interne referentie - correcte scope</sch:title>
    <sch:rule context="tekst:IntRef[@scope]">
      <sch:let name="alle-elementnamen-met-eId"
        value="'^(Aanhef|Afdeling|AlgemeneToelichting|Artikel|ArtikelgewijzeToelichting|Begrip|Begrippenlijst|BesluitCompact |Bijlage|Boek|Citaat|Deel|Divisie|Divisietekst|ExtIoRef|Figuur|Formule|Hoofdstuk|InleidendeTekst|IntIoRef|Kadertekst|Li|Lichaam|Lid|Lijst|Motivering|Paragraaf|RegelingOpschrift|Sluiting|Subparagraaf|Subsubparagraaf|Titel|Toelichting|WijzigArtikel|WijzigBijlage|WijzigLid|table)$'"/>
      <sch:assert test="matches(normalize-space(@scope), $alle-elementnamen-met-eId)">
        {"code": "STOP0052", "scope": "<sch:value-of select="@scope"/>", "ref": "<sch:value-of
          select="@ref"/>", "melding": "De scope <sch:value-of select="@scope"/> van de IntRef met <sch:value-of
          select="@ref"/> bevat niet een in het tekst-schema gedefinieerde naam van een verwijsbaar element. Geef de juiste elementnaam in attribuut scope.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_028" see="tekst:IntIoRef">
    <sch:title>Referentie informatieobject - correcte verwijzing</sch:title>
    <sch:rule context="tekst:IntIoRef[not(ancestor::tekst:RegelingMutatie)]">
      <sch:let name="doelwit" value="@ref"/>
      <sch:assert id="STOP0011" role="error" test="//tekst:ExtIoRef[@wId = $doelwit]"> {"code": "STOP0011", "element": "<sch:name/>", "ref": "<sch:value-of select="$doelwit"
        />", "melding": "De @ref van element <sch:name/> met waarde <sch:value-of select="$doelwit"
        /> verwijst niet naar een wId van een ExtIoRef binnen hetzelfde bestand. Controleer de referentie, corrigeer of de referentie of de wId identificatie van het element waarnaar wordt verwezen", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_007" see="tekst:ExtIoRef">
    <sch:title>Referentie extern informatieobject</sch:title>
    <sch:rule context="tekst:ExtIoRef">
      <sch:let name="ref" value="normalize-space(@ref)"/>
      <sch:assert id="STOP0012" role="error" test="normalize-space(.) = $ref"> {"code": "STOP0012", "eId": "<sch:value-of select="@eId"/>", "melding": "De JOIN identifier van ExtIoRef <sch:value-of select="@eId"/> in de tekst is niet gelijk aan de als referentie opgenomen JOIN-identificatie. Controleer de gebruikte JOIN-identicatie en plaats de juiste verwijzing als zowel de @ref als de tekst van het element ExtIoRef", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_008" see="tekst:agAKN">
    <sch:title>Identificatie - correct gebruik wId, eId </sch:title>
    <sch:rule context="//*[@eId]">
      <sch:let name="doelwitE" value="@eId"/>
      <sch:let name="doelwitW" value="@wId"/>
      <sch:report id="STOP0013" role="error" test="ends-with($doelwitE, '.')"> {"code": "STOP0013", "eId": "<sch:value-of select="@eId"/>", "element": "<sch:name/>", "melding": "Het attribuut @eId of een deel van de eId <sch:value-of select="@eId"/> van element <sch:name/> eindigt op een '.', dit is niet toegestaan. Verwijder de laatste punt(en) '.' voor deze eId", "ernst": "fout"},</sch:report>
      <sch:report id="STOP0043" role="error" test="contains($doelwitE, '.__')"> {"code": "STOP0043", "eId": "<sch:value-of select="@eId"/>", "element": "<sch:name/>", "melding": "Het attribuut @eId of een deel van de eId <sch:value-of select="@eId"/> van element <sch:name/> eindigt op '.__', dit is niet toegestaan. Verwijder deze punt '.' binnen deze eId", "ernst": "fout"},</sch:report>
      <sch:report id="STOP0014" role="error" test="ends-with($doelwitW, '.')"> {"code": "STOP0014", "wId": "<sch:value-of select="@wId"/>", "element": "<sch:name/>", "melding": "Het attribuut @wId <sch:value-of select="@wId"/> van element <sch:name/> eindigt op een '.', dit is niet toegestaan. Verwijder de laatste punt '.' van deze wId", "ernst": "fout"},</sch:report>
      <sch:report id="STOP0044" role="error" test="contains($doelwitW, '.__')"> {"code": "STOP0044", "wId": "<sch:value-of select="@wId"/>", "element": "<sch:name/>", "melding": "Het attribuut @wId <sch:value-of select="@wId"/> van element <sch:name/> eindigt op een '.__', dit is niet toegestaan. Verwijder deze punt '.' binnen deze wId", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_023" see="tekst:RegelingTijdelijkdeel tekst:WijzigArtikel">
    <sch:title>RegelingTijdelijkdeel - WijzigArtikel niet toegestaan</sch:title>
    <sch:rule context="tekst:RegelingTijdelijkdeel//tekst:WijzigArtikel">
      <sch:report id="STOP0015" test="self::tekst:WijzigArtikel"> {"code": "STOP0015", "eId": "<sch:value-of select="@eId"/>", "melding": "Het WijzigArtikel <sch:value-of select="@eId"/> is in een RegelingTijdelijkdeel niet toegestaan. Verwijder het WijzigArtikel of pas dit aan naar een Artikel indien dit mogelijk is", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_026" see="tekst:RegelingCompact tekst:WijzigArtikel">
    <sch:title>RegelingCompact - WijzigArtikel niet toegestaan</sch:title>
    <sch:rule context="tekst:RegelingCompact//tekst:WijzigArtikel">
      <sch:report id="STOP0016" test="self::tekst:WijzigArtikel"> {"code": "STOP0016", "eId": "<sch:value-of select="@eId"/>", "melding": "Het WijzigArtikel <sch:value-of select="@eId"/> is in een RegelingCompact niet toegestaan. Verwijder het WijzigArtikel of pas dit aan naar een Artikel indien dit mogelijk is", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!-- 
    Renvooi markering alleen toegestaan binnen een tekst:RegelingMutatie
  -->
  <sch:pattern id="sch_tekst_009"
    see="tekst:RegelingMutatie tekst:NieuweTekst
    tekst:VerwijderdeTekst">
    <sch:title>RegelingMutatie - Wijzigingen tekstueel</sch:title>
    <sch:rule context="//tekst:NieuweTekst | //tekst:VerwijderdeTekst">
      <sch:p>Een tekstuele mutatie ten behoeve van renvooi MAG NIET buiten een RegelingMutatie
        voorkomen</sch:p>
      <sch:assert id="STOP0017" role="error" test="ancestor::tekst:RegelingMutatie"> {"code": "STOP0017", "ouder": "<sch:value-of select="local-name(parent::tekst:*)"/>", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "element": "<sch:name/>", "melding": "Tekstuele wijziging is niet toegestaan buiten de context van een tekst:RegelingMutatie. element <sch:value-of select="local-name(parent::tekst:*)"/> met id \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>\" bevat een <sch:name/>. Verwijder het element <sch:name/>", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_010" see="tekst:RegelingMutatie tekst:agWijzigacties">
    <sch:title>RegelingMutatie - Wijzigingen structuur</sch:title>
    <sch:rule context="//tekst:*[@wijzigactie]">
      <sch:p>Een structuur wijziging MAG NIET buiten een RegelingMutatie voorkomen</sch:p>
      <sch:assert id="STOP0018" role="error" test="ancestor::tekst:RegelingMutatie"> {"code": "STOP0018", "element": "<sch:value-of select="local-name()"/>", "eId": "<sch:value-of
          select="ancestor-or-self::tekst:*[@eId][1]/@eId"/>", "melding": "Een attribuut @wijzigactie is niet toegestaan op element <sch:value-of select="local-name()"/> met id \"<sch:value-of
          select="ancestor-or-self::tekst:*[@eId][1]/@eId"/>\" buiten de context van een tekst:RegelingMutatie. Verwijder het attribuut @wijzigactie", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    Unieke eId en wId's voor Besluiten en Regelingen
  -->
  <xsl:key
    match="tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
    name="alleEIDs" use="@eId"/>
  <xsl:key
    match="tekst:*[@wId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
    name="alleWIDs" use="@wId"/>
  <sch:pattern id="sch_tekst_011" see="tekst:agAKN">
    <sch:title>Identificatie - Alle wId en eId buiten een AKN-component zijn uniek</sch:title>
    <sch:rule
      context="tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]">
      <sch:assert id="STOP0020" role="error" test="count(key('alleEIDs', @eId)) = 1"> {"code": "STOP0020", "eId": "<sch:value-of select="@eId"/>", "melding": "De eId '<sch:value-of select="@eId"/>' binnen het bereik is niet uniek. Controleer de opbouw van de eId en corrigeer deze", "ernst": "fout"},</sch:assert>
      <sch:assert id="STOP0021" role="error" test="count(key('alleWIDs', @wId)) = 1"> {"code": "STOP0021", "wId": "<sch:value-of select="@wId"/>", "melding": "De wId '<sch:value-of select="@wId"/>' binnen het bereik is niet uniek. Controleer de opbouw van de wId en corrigeer deze", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_020" see="tekst:agAKN">
    <sch:title>Identificatie - AKN-naamgeving voor eId en wId</sch:title>
    <sch:rule context="*[@eId]">
      <sch:let name="AKNnaam">
        <xsl:choose>
          <xsl:when test="matches(local-name(), 'Lichaam')">body</xsl:when>
          <xsl:when test="matches(local-name(), 'RegelingOpschrift')">longTitle</xsl:when>
          <xsl:when test="matches(local-name(), 'AlgemeneToelichting')">genrecital</xsl:when>
          <xsl:when test="matches(local-name(), '^ArtikelgewijzeToelichting$')"
            >artrecital</xsl:when>
          <xsl:when test="matches(local-name(), 'Artikel|WijzigArtikel')">art</xsl:when>
          <xsl:when test="matches(local-name(), 'WijzigLid|Lid')">para</xsl:when>
          <xsl:when test="matches(local-name(), 'Divisietekst')">content</xsl:when>
          <xsl:when test="matches(local-name(), 'Divisie')">div</xsl:when>
          <xsl:when test="matches(local-name(), 'Boek')">book</xsl:when>
          <xsl:when test="matches(local-name(), 'Titel')">title</xsl:when>
          <xsl:when test="matches(local-name(), 'Deel')">part</xsl:when>
          <xsl:when test="matches(local-name(), 'Hoofdstuk')">chp</xsl:when>
          <xsl:when test="matches(local-name(), 'Afdeling')">subchp</xsl:when>
          <xsl:when test="matches(local-name(), 'Paragraaf|Subparagraaf|Subsubparagraaf')"
            >subsec</xsl:when>
          <xsl:when test="matches(local-name(), 'WijzigBijlage|Bijlage')">cmp</xsl:when>
          <xsl:when test="matches(local-name(), 'Inhoudsopgave')">toc</xsl:when>
          <xsl:when test="matches(local-name(), 'Motivering')">acc</xsl:when>
          <xsl:when test="matches(local-name(), 'Toelichting')">recital</xsl:when>
          <xsl:when test="matches(local-name(), 'InleidendeTekst')">intro</xsl:when>
          <xsl:when test="matches(local-name(), 'Aanhef')">formula_1</xsl:when>
          <xsl:when test="matches(local-name(), 'Kadertekst')">recital</xsl:when>
          <xsl:when test="matches(local-name(), 'Sluiting')">formula_2</xsl:when>
          <xsl:when test="matches(local-name(), 'table')">table</xsl:when>
          <xsl:when test="matches(local-name(), 'Figuur')">img</xsl:when>
          <xsl:when test="matches(local-name(), 'Formule')">math</xsl:when>
          <xsl:when test="matches(local-name(), 'Citaat')">cit</xsl:when>
          <xsl:when test="matches(local-name(), 'Begrippenlijst|Lijst')">list</xsl:when>
          <xsl:when test="matches(local-name(), 'Li|Begrip')">item</xsl:when>
          <xsl:when test="matches(local-name(), 'IntIoRef|ExtIoRef')">ref</xsl:when>
          <xsl:otherwise>X</xsl:otherwise>
        </xsl:choose>
      </sch:let>
      <sch:let name="mijnEID">
        <xsl:choose>
          <xsl:when test="contains(@eId, '__')">
            <xsl:value-of select="tokenize(@eId, '__')[last()]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@eId"/>
          </xsl:otherwise>
        </xsl:choose>
      </sch:let>
      <sch:let name="mijnWID">
        <xsl:value-of select="tokenize(@wId, '__')[last()]"/>
      </sch:let>
      <sch:assert id="STOP0022" test="starts-with($mijnEID, $AKNnaam)"> {"code": "STOP0022", "AKNdeel": "<sch:value-of select="$mijnEID"/>", "element": "<sch:name/>", "waarde": "<sch:value-of select="$AKNnaam"/>", "wId": "<sch:value-of select="@wId"/>", "melding": "De AKN-naamgeving voor eId '<sch:value-of select="$mijnEID"/>' is niet correct voor element <sch:name/> met id '<sch:value-of select="@wId"/>', Dit moet zijn: '<sch:value-of select="$AKNnaam"/>'. Pas de naamgeving voor dit element en alle onderliggende elementen aan. Controleer ook de naamgeving van de bijbehorende wId en onderliggende elementen.", "ernst": "fout"},</sch:assert>
      <sch:p>Een wId MOET voldoen aan de AKN-naamgevingsconventie</sch:p>
      <sch:assert id="STOP0023" test="starts-with($mijnWID, $AKNnaam)"> {"code": "STOP0023", "AKNdeel": "<sch:value-of select="$mijnWID"/>", "element": "<sch:name/>", "waarde": "<sch:value-of select="$AKNnaam"/>", "wId": "<sch:value-of select="@wId"/>", "melding": "De AKN-naamgeving voor wId '<sch:value-of select="$mijnWID"/>' is niet correct voor element <sch:name/> met id '<sch:value-of select="@wId"/>', Dit moet zijn: '<sch:value-of select="$AKNnaam"/>'. Pas de naamgeving voor dit element en alle onderliggende elementen aan. Controleer ook de naamgeving van de bijbehorende eId en onderliggende elementen.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <!-- VOOR TABELLEN EEN REEKS CONTROLES OP CALS REGELS -->
  <!--  -->
  <sch:pattern id="sch_tekst_014" see="tekst:table tekst:tgroup">
    <sch:title>Tabel - minimale opbouw</sch:title>
    <sch:rule context="tekst:table">
      <sch:assert id="STOP0029" role="error" test="number(tekst:tgroup/@cols) >= 2"> {"code": "STOP0029", "eId": "<sch:value-of select="@eId"/>", "melding": "De tabel met <sch:value-of select="@eId"/> heeft slechts 1 kolom, dit is niet toegestaan. Pas de tabel aan, of plaats de inhoud van de tabel naar bijvoorbeeld een element Kadertekst", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_016" see="tekst:table tekst:entry">
    <sch:title>Tabel - positie en identificatie van een tabelcel</sch:title>
    <sch:rule context="tekst:entry[@namest and @colname]">
      <sch:let name="start" value="@namest"/>
      <sch:let name="col" value="@colname"/>
      <sch:p>Bij horizontale overspanning MOET de eerste cel ook de start van de overspanning
        zijn</sch:p>
      <sch:assert id="STOP0033" role="error" test="$col = $start"> {"code": "STOP0033", "naam": "<sch:value-of select="@namest"/>", "nummer": "<sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>", "ouder": "<sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>", "eId": "<sch:value-of select="ancestor::tekst:table/@eId"/>", "melding": "De start van de overspanning (@namest) van de cel <sch:value-of select="@namest"/>, in de <sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>e rij, van de <sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/> van tabel <sch:value-of select="ancestor::tekst:table/@eId"/> is niet gelijk aan de @colname van de cel.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:rule context="tekst:entry[@namest][@nameend]">
      <sch:p>Bij horizontale overspanning MOET de positie van @nameend groter zijn dan de positie
        van @namest</sch:p>
      <sch:let name="start" value="@namest"/>
      <sch:let name="end" value="@nameend"/>
      <sch:assert id="STOP0032" role="error"
        test="xs:integer(ancestor::tekst:tgroup/tekst:colspec[@colname = $start]/@colnum) &lt;= xs:integer(ancestor::tekst:tgroup/tekst:colspec[@colname = $end]/@colnum)"
        > {"code": "STOP0032", "naam": "<sch:value-of select="@namest"/>", "nummer": "<sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>", "ouder": "<sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>", "eId": "<sch:value-of select="ancestor::tekst:table/@eId"/>", "melding": "De entry met @namest \"<sch:value-of select="@namest"/>\", van de <sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>e rij, van de <sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>, in de tabel met eId: <sch:value-of select="ancestor::tekst:table/@eId"/>, heeft een positie bepaling groter dan de positie van de als @nameend genoemde cel. Corrigeer de gegevens voor de overspanning.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:rule context="tekst:entry[@colname]">
      <sch:p>De referentie van een cel MOET correct verwijzen naar een kolom</sch:p>
      <sch:let name="id" value="@colname"/>
      <sch:report id="STOP0036" role="error"
        test="not(ancestor::tekst:tgroup/tekst:colspec[@colname = $id])"> {"code": "STOP0036", "naam": "colname", "nummer": "<sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>", "ouder": "<sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>", "eId": "<sch:value-of select="ancestor::tekst:table/@eId"/>", "melding": "De entry met @colname van de <sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>e rij, van <sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>, van de tabel met id: <sch:value-of select="ancestor::tekst:table/@eId"/> , verwijst niet naar een bestaande kolom. Controleer en corrigeer de identifier voor de kolom (@colname)", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_017" see="tekst:table">
    <sch:title>Tabel - het aantal cellen is correct</sch:title>
    <sch:rule context="tekst:tgroup/tekst:thead | tekst:tgroup/tekst:tbody">
      <sch:let name="totaalCellen" value="count(tekst:row) * number(parent::tekst:tgroup/@cols)"/>
      <sch:let name="colPosities">
        <xsl:for-each select="parent::tekst:tgroup/tekst:colspec">
          <col colnum="{@colnum}" name="{@colname}"/>
        </xsl:for-each>
      </sch:let>
      <sch:let name="cellen" value="count(//tekst:entry[not(@wijzigactie = 'verwijder')])"/>
      <sch:let name="spanEinde">
        <xsl:for-each
          select="self::tekst:tbody//tekst:entry[not(@wijzigactie = 'verwijder')] | self::tekst:thead//tekst:entry[not(@wijzigactie = 'verwijder')]">
          <xsl:variable as="xs:string?" name="namest" select="@namest"/>
          <xsl:variable as="xs:string?" name="nameend" select="@nameend"/>
          <xsl:variable as="xs:integer?" name="numend"
            select="$colPosities/*[@name = $nameend]/@colnum"/>
          <xsl:variable as="xs:integer?" name="numst"
            select="$colPosities/*[@name = $namest]/@colnum"/>
          <nr>
            <xsl:choose>
              <xsl:when test="$numend and $numst and @morerows">
                <xsl:value-of select="($numend - $numst + 1) * (@morerows + 1)"/>
              </xsl:when>
              <xsl:when test="$numend and $numst">
                <xsl:value-of select="$numend - $numst + 1"/>
              </xsl:when>
              <xsl:when test="@morerows">
                <xsl:value-of select="1 + @morerows"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </nr>
        </xsl:for-each>
      </sch:let>
      <sch:let name="spannend" value="sum($spanEinde/*)"/>
      <sch:p>Het aantal colspec's MOET gelijk zijn aan het opgegeven aantal kolommen.</sch:p>
      <sch:assert id="STOP0037" role="error"
        test="number(parent::tekst:tgroup/@cols) = count(parent::tekst:tgroup/tekst:colspec)"> {"code": "STOP0037", "nummer": "<sch:value-of
          select="count(parent::tekst:tgroup/tekst:colspec)"/>", "naam": "<sch:name/>", "eId": "<sch:value-of select="ancestor::tekst:table/@eId"/>", "aantal": "<sch:value-of
          select="parent::tekst:tgroup/@cols"/>", "melding": "Het aantal colspec's (<sch:value-of
          select="count(parent::tekst:tgroup/tekst:colspec)"/>) voor <sch:name/> in tabel <sch:value-of select="ancestor::tekst:table/@eId"/> komt niet overeen met het aantal kolommen (<sch:value-of
          select="parent::tekst:tgroup/@cols"/>).", "ernst": "fout"},</sch:assert>
      <sch:p>Het totale aantal cellen MOET overeenkomen met het aantal mogelijke cellen</sch:p>
      <sch:assert id="STOP0038" role="error" test="$totaalCellen = $spannend"> {"code": "STOP0038", "aantal": "<sch:value-of select="$spannend"/>", "naam": "<sch:name/>", "eId": "<sch:value-of
          select="ancestor::tekst:table/@eId"/>", "nummer": "<sch:value-of select="$totaalCellen"
        />", "melding": "Het aantal cellen in <sch:name/> van tabel \"<sch:value-of
          select="ancestor::tekst:table/@eId"/>\" komt niet overeen met de verwachting (resultaat: <sch:value-of select="$spannend"/> van verwachting <sch:value-of select="$totaalCellen"
        />).", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_033" see="tekst:Extref">
    <sch:title>Externe referentie, notatie</sch:title>
    <sch:rule context="tekst:ExtRef">
      <sch:let name="notatie">
        <xsl:choose>
          <xsl:when test="@soort = 'AKN'">/akn/</xsl:when>
          <xsl:when test="@soort = 'JCI'">jci1</xsl:when>
          <xsl:when test="@soort = 'URL'">http</xsl:when>
          <xsl:when test="@soort = 'JOIN'">/join/</xsl:when>
          <xsl:when test="@soort = 'document'"/>
        </xsl:choose>
      </sch:let>
      <sch:p>Een externe referentie MOET de juiste notatie gebruiken</sch:p>
      <sch:assert id="STOP0050" role="error" test="starts-with(@ref, $notatie)">{"code": "STOP0050", "type": "<sch:value-of select="@soort"/>", "ref": "<sch:value-of select="@ref"
        />", "melding": "De ExtRef van het type <sch:value-of select="@soort"/> met referentie <sch:value-of select="@ref"
        /> heeft niet de juiste notatie.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_037">
    <sch:title>Gereserveerd zonder opvolgende elementen</sch:title>
    <sch:rule context="tekst:Gereserveerd[not(ancestor::tekst:Vervang)]">
      <sch:p>Het element Gereserveerd MAG GEEN opvolgende elementen op hetzelfde niveau
        hebben</sch:p>
      <sch:assert id="STOP0055" role="error" test="not(following-sibling::tekst:*)"> {"code": "STOP0055", "naam": "<sch:value-of select="local-name(following-sibling::tekst:*[1])"/>", "element": "<sch:value-of select="local-name(parent::tekst:*)"/>", "eId": "<sch:value-of
          select="parent::tekst:*/@eId"/>", "melding": "Het element <sch:value-of select="local-name(following-sibling::tekst:*[1])"/> binnen <sch:value-of select="local-name(parent::tekst:*)"/> met eId: \"<sch:value-of
          select="parent::tekst:*/@eId"/>\" is niet toegestaan na een element Gereserveerd. Verwijder het element Gereserveerd of verplaats dit element naar een eigen structuur of tekst.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_038">
    <sch:title>Vervallen zonder opvolgende elementen</sch:title>
    <sch:rule context="tekst:Vervallen[not(ancestor::tekst:Vervang)]">
      <sch:p>Het element Vervallen MAG GEEN opvolgende elementen met inhoud op hetzelfde niveau
        hebben</sch:p>
      <sch:assert id="STOP0057" role="error"
        test="not(following-sibling::tekst:Inhoud | following-sibling::tekst:Lid)"> {"code": "STOP0057", "naam": "<sch:value-of select="local-name(following-sibling::tekst:*[1])"/>", "element": "<sch:value-of select="local-name(parent::tekst:*)"/>", "eId": "<sch:value-of
          select="parent::tekst:*/@eId"/>", "melding": "Het element <sch:value-of select="local-name(following-sibling::tekst:*[1])"/> binnen <sch:value-of select="local-name(parent::tekst:*)"/> met eId: \"<sch:value-of
          select="parent::tekst:*/@eId"/>\" is niet toegestaan na een element Vervallen. Verwijder het element Vervallen of verplaats dit element naar een eigen structuur of tekst.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_039">
    <sch:title>Structuur compleet</sch:title>
    <sch:rule
      context="tekst:Afdeling | tekst:Bijlage | tekst:Boek | tekst:Deel | tekst:Divisie | tekst:Hoofdstuk | tekst:Paragraaf | tekst:Subparagraaf | tekst:Subsubparagraaf | tekst:Titel">
      <sch:p>Een structuur-element MOET altijd ten minste een element na de Kop bevatten</sch:p>
      <sch:assert id="STOP0058" role="error" test="child::tekst:*[not(self::tekst:Kop)]"> {"code": "STOP0058", "naam": "<sch:name/>", "eId": "<sch:value-of select="@eId"/>", "melding": "Het element <sch:name/> met eId: \"<sch:value-of select="@eId"/> is niet compleet, een kind-element anders dan een Kop is verplicht. Completeer of verwijder dit structuur-element.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_040">
    <sch:title>Artikel compleet</sch:title>
    <sch:rule context="tekst:Artikel">
      <sch:p>Een Artikel MOET altijd tenminste een element na de Kop bevatten</sch:p>
      <sch:assert id="STOP0059" role="error" test="child::tekst:*[not(self::tekst:Kop)]"> {"code": "STOP0059", "naam": "<sch:name/>", "eId": "<sch:value-of select="@eId"/>", "melding": "Het element <sch:name/> met eId: \"<sch:value-of select="@eId"/> is niet compleet, een kind-element anders dan een Kop is verplicht. Completeer of verwijder dit element.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_041">
    <sch:title>Divisietekst compleet</sch:title>
    <sch:rule context="tekst:Divisietekst">
      <sch:p>Een Divisietekst MOET altijd een element anders dan een Kop bevatten</sch:p>
      <sch:assert id="STOP0060" role="error" test="child::tekst:*[not(self::tekst:Kop)]"> {"code": "STOP0060", "naam": "<sch:name/>", "eId": "<sch:value-of select="@eId"/>", "melding": "Het element <sch:name/> met eId: \"<sch:value-of select="@eId"/> is niet compleet, een kind-element anders dan een Kop is verplicht. Completeer of verwijder dit element.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_043">
    <sch:title>Kennisgeving zonder divisie</sch:title>
    <sch:rule context="tekst:Divisie[ancestor::tekst:Kennisgeving]">
      <sch:report id="STOP0061" role="error" test=".">{"code": "STOP0061", "eId": "<sch:value-of
          select="@eId"/>", "melding": "De kennisgeving bevat een Divisie met eId <sch:value-of
          select="@eId"/>. Dit is niet toegestaan. Gebruik alleen Divisietekst.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_044">
    <sch:title>Vervallen structuur</sch:title>
    <sch:rule
      context="tekst:Vervallen[not(ancestor::tekst:Vervang)][not(parent::tekst:Artikel)][not(parent::tekst:Divisietekst)]">
      <sch:p>Indien een structuur-element vervallen is dan moeten ook alle onderliggende delen
        (structuur en tekst) vervallen zijn</sch:p>
      <sch:report id="STOP0062" role="error"
        test="following-sibling::tekst:*[not(child::tekst:Vervallen)]">{"code": "STOP0062", "naam": "<sch:value-of select="local-name(parent::tekst:*)"/>", "eId": "<sch:value-of
          select="parent::tekst:*/@eId"/>", "element": "<sch:value-of
          select="local-name(following-sibling::tekst:*[not(child::tekst:Vervallen)][1])"/>", "id": "<sch:value-of select="following-sibling::tekst:*[not(child::tekst:Vervallen)][1]/@eId"
        />", "melding": "Het element <sch:value-of select="local-name(parent::tekst:*)"/> met eId: \"<sch:value-of
          select="parent::tekst:*/@eId"/>\" is vervallen, maar heeft minstens nog een niet vervallen element\". Controleer vanaf element <sch:value-of
          select="local-name(following-sibling::tekst:*[not(child::tekst:Vervallen)][1])"/> met eId \"<sch:value-of select="following-sibling::tekst:*[not(child::tekst:Vervallen)][1]/@eId"
        /> of alle onderliggende elementen als vervallen zijn aangemerkt.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_045">
    <sch:rule context="tekst:Contact">
      <sch:let name="adres" value="@adres"/>
      <sch:let name="pattern">
        <xsl:choose>
          <xsl:when test="@soort = 'e-mail'">[^@]+@[^\.]+\..+</xsl:when>
          <xsl:otherwise>X</xsl:otherwise>
        </xsl:choose>
      </sch:let>
      <sch:p>Als het element tekst:Contact een attribuut @adres heeft, moet de inhoud van het
        attribuut een adres zijn dat is geformatteerd volgens de specificaties van de waarde van
        attribuut @soort.</sch:p>
      <sch:assert id="STOP0064" role="error" test="matches(@adres, $pattern)">{"code": "STOP0064", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "melding": "Het adres zoals genoemd in het element Contact binnen element met eId <sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/> heeft een attribuut \"adres\"; de waarde van @adres moet een correct geformatteerd adres zijn. Corrigeer het adres.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
