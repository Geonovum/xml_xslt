<sch:schema queryBinding="xslt2" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="tekst" uri="https://standaarden.overheid.nl/stop/imop/tekst/" />
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform" />
  <!-- Variabelen om de waarden voor identificerende data te kunnen valideren zijn als
       sch:let opgenomen op de plek waar ze gebruikt worden. -->
  <!-- Wijziging: tonen wId ipv eId bij controle op uniciteit -->
  <!-- Verwijderd: validatie met FRBRwork - komt in tekst niet meer voor. -->
  <!-- Wijziging: Geen wId/eId uniciteits controle voor WijzigInstructies -->
  <!-- Laatste ID = sch_tekst_028 -->
  <!-- -->
  <sch:p>Versie @@@VERSIE@@@</sch:p>
  <sch:p>Schematron voor aanvullende validatie voor imop-tekst.xsd</sch:p>
  <sch:pattern id="sch_tekst_001" see="tekst:Lijst tekst:Li tekst:LiNummer">
    <sch:title>Nummering van lijst-items (Li) is afhankelijk van het attribuut @type van de
      Lijst</sch:title>
    <sch:rule context="tekst:Lijst[@type = 'ongemarkeerd']">
      <sch:p>Een Lijst van het type 'ongemarkeerd' MOET lijst-items hebben zonder nummering of
        symbolen</sch:p>
      <sch:assert role="error" test="count(tekst:Li/tekst:LiNummer) = 0">De Lijst met @eId:
          <sch:value-of select="@eId" /> van type 'ongemarkeerd' heeft LiNummer elementen met een
        nummering of symbolen, dit is niet toegestaan. Pas het type van de lijst aan of verwijder de
        LiNummer elementen.</sch:assert>
    </sch:rule>
    <sch:rule context="tekst:Lijst[@type = 'expliciet']">
      <sch:p>Een Lijst van het type 'expliciet' MOET lijst-items hebben met nummering of
        symbolen</sch:p>
      <sch:assert role="error" test="count(tekst:Li[descendant::tekst:LiNummer]) = count(tekst:Li)"
        >De Lijst met @eId <sch:value-of select="@eId" /> van type 'expliciet' heeft geen LiNummer
        elementen met nummering of symbolen, het gebruik van LiNummer is verplicht. Pas het type van
        de lijst aan of voeg LiNummer's met nummering of symbolen toe aan de
        lijst-items.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_002" see="tekst:Nummer tekst:LidNummer tekst:Artikel
    tekst:WijzigArtikel tekst:Lid tekst:WijzigLid tekst:Hoofdstuk tekst:Afdeling tekst:Deel
    tekst:Titel tekst:Paragraaf tekst:Subparaghraaf tekst:Subsubparagraaf tekst:Divisie
    tekst:Divisietekst">
    <sch:title>Het nummer voor een structuur-element mag niet worden afgesloten met een punt
      '.'</sch:title>
    <sch:rule
      context="tekst:Artikel//tekst:Nummer | tekst:Artikel//tekst:LidNummer | tekst:WijzigArtikel//tekst:Nummer | tekst:WijzigArtikel//tekst:LidNummer | tekst:Lichaam//tekst:Nummer | tekst:Lichaam//tekst:LidNummer">
      <sch:p>Nummer voor structuur-elementen of een LidNummer voor Lid of WijzigLid MAG NIET op een
        punt '.' eindigen.</sch:p>
      <sch:report role="error" test="ends-with(., '.')"> De nummering van element <sch:value-of
          select="local-name(ancestor::node()[@wId][1])" /> met id <sch:value-of
          select="ancestor::*[@wId][1]/@wId" /> mag eindigt met een punt '.'. Verwijder de laatste
        punt uit het nummer</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_022" see="tekst:Al">
    <sch:title>Een alinea zonder inhoud levert mogelijk problemen bij verwerking</sch:title>
    <sch:rule context="tekst:Al">
      <sch:p>Het element Al moet content bevatten: ten minste tekst of een illustratie</sch:p>
      <sch:report role="error"
        test="normalize-space(.) = '' and not(descendant::tekst:InlineTekstAfbeelding)"> De alinea
        voor element <sch:value-of select="ancestor::tekst:*[@wId][1]/local-name()" /> met id
          <sch:value-of select="ancestor::tekst:*[@wId][1]/@wId" /> bevat geen tekst. Verwijder het
        element Al.</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_003" see="tekst:table tekst:NootRef">
    <sch:title>Een NootRef mag alleen binnen een tabel worden gebruikt waarbij de Noot waarnaar
      verwezen wordt in dezelfde tabel voorkomt</sch:title>
    <sch:rule context="tekst:Nootref">
      <sch:let name="nootID" value="@refid" />
      <sch:p>Een NootRef MOET in de context van een tabel staan.</sch:p>
      <sch:assert test="ancestor::tekst:table"> De Nootref naar Noot met id <sch:value-of
          select="@refid" /> staat niet in een tabel. Vervang de NootRef voor de Noot op de plek
        waar nu de NootRef staat.</sch:assert>
      <sch:p>Een NootRef MOET verwijzen naar een Noot in dezelfde tabel.</sch:p>
      <sch:assert test="ancestor::tekst:table/descendant::tekst:Noot[@id = $nootID]"> De NootRef
        naar Noot met id <sch:value-of select="@refid" /> verwijst niet naar een NOOT in dezelfde
        tabel <sch:value-of select="ancestor::tekst:table/@wId" />. Verplaats de Noot waarnaar
        verwezen wordt naar de tabel of vervang de NootRef in de tabel voor de Noot waarnaar
        verwezen wordt.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_004" see="tekst:Lijst tekst:Li tekst:table">
    <sch:title>Gebruik van een tabel binnen een lijst is kan problemen veroorzaken in de weergave
      van de lijst, advies is om dit te voorkomen. Dit is wel toegestaan om met name oudere
      regelingen (legacy) te kunnen ondersteunen</sch:title>
    <sch:rule context="tekst:Li/tekst:table">
      <sch:p>Voor nieuwe regelingen wordt het afgeraden om een tabel binnen een Lijst op te
        nemen</sch:p>
      <sch:report role="warning"
        test="(parent::tekst:BesluitKlassiek | parent::BesluitCompact | parent::tekst:WijzigBijlage)/(tekst:RegelingKlassiek | tekst:RegelingVrijetekst | tekst:RegelingTijdelijkdeel | tekst:RegelingCompact)"
        >Het lijst-item <sch:value-of select="parent::Li/@wId" /> bevat een tabel, onderzoek of de
        tabel buiten de lijst kan worden geplaatst, eventueel door de lijst in delen op te
        splitsen</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_005" see="tekst:Divisietekst tekst:Kop">
    <sch:title>Het gebruik van een Kop voor Divisietekst is verplicht, met uitzondering van de
      situatie wanneer Divisietekst het enige of het eerste element is binnen een Bijlage,
      Toelichting of Motivering</sch:title>
    <sch:rule context="tekst:Divisietekst[not(child::tekst:Kop)]">
      <sch:p>Divisietekst zonder een Kop is alleen toegestaan in de beschreven context</sch:p>
      <sch:assert
        test="(parent::tekst:Bijlage | parent::tekst:Toelichting | parent::tekst:Motivering | parent::tekst:AlgemeneToelichting) and preceding-sibling::*[1][self::tekst:Kop]"
        >Een Kop voor Divisietekst met wId <sch:value-of select="@wId" /> is verplicht. Voeg een
        valide Kop aan deze Divisietekst toe</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    INTERNE REFERENTIES HEBBEN CORRECTE VERWIJZINGEN
  -->
  <sch:pattern id="sch_tekst_006" see="tekst:IntRef tekst:IntIoRef">
    <sch:title>De waarden van een interne referentie element moet verwijzen naar een bestaande
      identificatie binnen hetzelfde bestand</sch:title>
    <sch:rule context="tekst:IntRef[not(ancestor::tekst:RegelingMutatie)]">
      <sch:let name="doelwit" value="@ref" />
      <sch:p>Een interne referentie MOET verwijzen naar een in hetzelfde bestand bestaande
        identifier</sch:p>
      <sch:assert role="error" test="//*[@eId = $doelwit] | //*[@wId = $doelwit]"> De @ref van
        element <sch:name /> met waarde <sch:value-of select="$doelwit" /> verwijst niet naar een
        bestaande identifier binnen hetzelfde bestand. Controleer de referentie, corrigeer of de
        referentie of de identificatie van het element waarnaar wordt verwezen</sch:assert>
    </sch:rule>
    <sch:rule context="tekst:IntIoRef[not(ancestor::tekst:RegelingMutatie)]">
      <sch:let name="doelwit" value="@ref" />
      <sch:p>Een referentie naar een ExtIoRef MOET verwijzen naar een @wId identifier binnen
        hetzelfde instrument</sch:p>
      <sch:assert role="error" test="//tekst:ExtIoRef[@wId = $doelwit]"> De @ref van element
        <sch:name /> met waarde <sch:value-of select="$doelwit" /> verwijst niet naar een
        identificatie (@wId) binnen hetzelfde bestand. Controleer de referentie, corrigeer of de
        referentie of de wId identificatie van het element waarnaar wordt verwezen</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_007" see="tekst:ExtIoRef">
    <sch:title>De referentie naar de JOIN-identifier en de tekst van een ExtIoRef moeten
      gelijkluidend zijn</sch:title>
    <sch:rule context="tekst:ExtIoRef">
      <sch:let name="waarde" value="@ref" />
      <sch:p>De in tekst weergegeven JOIN-identifier MOET gelijk zijn aan de waarde van de
        referentie naar een JOIN-identifier</sch:p>
      <sch:assert role="error" test=". = $waarde"> De JOIN identifier van ExtIoRef <sch:value-of
          select="@wId" /> in de tekst is niet gelijk aan de als referentie opgenomen
        JOIN-identificatie. Controleer de gebruikte JOIN-identicatie en plaats de juiste verwijzing
        als zowel de @ref als de tekst van het element ExtIoRef.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_008" see="tekst:agAKN">
    <sch:title>Een attribuut @wId of @eId moet correct zijn en mag niet eindigen met een punt
      '.'</sch:title>
    <sch:rule context="//*[@eId]">
      <sch:let name="doelwitE" value="@eId" />
      <sch:let name="doelwitW" value="@wId" />
      <sch:p>Een attribuut @eId MAG NIET eindigen met een punt '.'.</sch:p>
      <sch:report role="error" test="ends-with($doelwitE, '.')"> Het attribuut @eId <sch:value-of
          select="$doelwitE" /> van element <sch:name /> eindigt op een '.', dit is niet toegestaan.
        Verwijder de laatste punt '.' van deze eId</sch:report>
      <sch:p>Een attribuut @wId MAG NIET eindigen met een '.'.</sch:p>
      <sch:report role="error" test="ends-with($doelwitW, '.')"> Het attribuut @wId <sch:value-of
          select="$doelwitW" /> van element <sch:name /> eindigt op een '.', dit is niet toegestaan.
        Verwijder de laatste punt '.' van deze wId </sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_023" see="tekst:RegelingTijdelijkdeel tekst:WijzigArtikel">
    <sch:title>RegelingTijdelijkdeel - WijzigArtikel niet toegestaan</sch:title>
    <sch:rule context="tekst:RegelingTijdelijkdeel//tekst:WijzigArtikel">
      <sch:p>Een RegelingTijdelijkDeel MAG GEEN WijzigArtikel hebben</sch:p>
      <sch:report test="self::tekst:WijzigArtikel">Het WijzigArtikel <sch:value-of select="@wId" />
        is in een RegelingTijdelijkdeel niet toegestaan. Verwijder het WijzigArtikel of pas dit aan
        naar een Artikel.</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_027" see="tekst:RegelingCompact tekst:WijzigArtikel">
    <sch:title>RegelingCompact - WijzigArtikel niet toegestaan</sch:title>
    <sch:rule context="tekst:RegelingCompact//tekst:WijzigArtikel">
      <sch:p>Een RegelingTijdelijkDeel MAG GEEN WijzigArtikel hebben</sch:p>
      <sch:report test="self::tekst:WijzigArtikel">Het WijzigArtikel <sch:value-of select="@wId" />
        is in een RegelinCompact niet toegestaan. Verwijder het WijzigArtikel of pas dit aan naar
        een Artikel.</sch:report>
    </sch:rule>
  </sch:pattern>
  <!-- 
    Renvooi markering alleen toegestaan binnen een tekst:RegelingMutatie
  -->
  <sch:pattern id="sch_tekst_009" see="tekst:RegelingMutatie tekst:NieuweTekst
    tekst:VerwijderdeTekst">
    <sch:title>Markeren van tekstuele wijzigingen ten behoeve van renvooi zijn alleen toegestaan in
      de context van een RegelingMutatie</sch:title>
    <sch:rule context="//tekst:NieuweTekst | //tekst:VerwijderdeTekst">
      <sch:p>Een tekstuele wijziging ten behoeve van renvooi MOET in de context van een
        RegelingMutatie staan.</sch:p>
      <sch:assert role="error" test="ancestor::tekst:RegelingMutatie"> Tekstuele wijziging is niet
        toegestaan voor <sch:value-of select="local-name(parent::tekst:*)" /> - "<sch:value-of
          select="ancestor::tekst:*[@wId][1]/@wId" />" buiten de context van een
        tekst:RegelingMutatie. Verwijder het element <sch:name />. </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_010" see="tekst:RegelingMutatie tekst:agWijzigacties">
    <sch:title>Structuur-wijzigingen in de context van een tekst:RegelingMutatie</sch:title>
    <sch:rule context="//tekst:*[@wijzigactie]">
      <sch:p>Een structuur wijziging MOET in de context van een tekst:RegelingMutatie staan.</sch:p>
      <sch:assert role="error" test="ancestor::tekst:RegelingMutatie"> Attribuut @wijzigactie is
        niet toegestaan op element <sch:value-of select="local-name()" /> - "<sch:value-of
          select="ancestor::tekst:*[@wId][1]/@wId" />" buiten de context van een
        tekst:RegelingMutatie. Verwijder het attribuut @wijzigactie. </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_028" see="tekst:table tekst:agWijzigacties">
    <sch:title>Tabel met wijzigingen in de context van een tekst:RegelingMutatie</sch:title>
    <sch:rule context="tekst:table//tekst:*[@wijzigactie]">
      <sch:p>Mutaties in een tabel met een overspanning kunnen niet worden verwerkt.</sch:p>
      <sch:assert role="error"
        test="ancestor::tekst:table//tekst:entry[@morerows] or ancestor::tekst:table/descendant::tekst:entry[@namest]"
        > de Wijzigacties in de tabel <sch:value-of select="ancestor::tekst:table/@wId" /> met
        horizontale of verticale overspanning kunnen niet worden verwerkt in renvooi. </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    Unieke eId en wId's voor Besluiten en Regelingen
  -->
  <xsl:key
    match="tekst:BesluitCompact//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:BesluitKlassiek//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingCompact//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingTijdelijkdeel//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingKlassiek//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingVrijetekst//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
    name="alleEIDs" use="@eId" />
  <xsl:key
    match="tekst:BesluitCompact//tekst:*[@wId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:BesluitKlassiek//tekst:*[@wId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingCompact//tekst:*[@wId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingTijdelijkdeel//tekst:*[@wId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingKlassiek//tekst:*[@wId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingVrijetekst//tekst:*[@wId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
    name="alleWIDs" use="@wId" />
  <sch:pattern id="sch_tekst_011" see="tekst:agAKN">
    <sch:title>Alle identifiers wId en eId buiten een AKN-component moeten uniek zijn binnen een
      bestand </sch:title>
    <sch:rule
      context="tekst:BesluitCompact//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:BesluitKlassiek//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingCompact//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingTijdelijkdeel//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingKlassiek//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)] | tekst:RegelingVrijetekst//tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]">
      <sch:p>eId identifiers buiten een AKN-component moeten uniek zijn</sch:p>
      <sch:assert role="error" test="count(key('alleEIDs', @eId)) = 1"> Error: eId '<sch:value-of
          select="@eId" />' binnen het bereik is niet uniek. Controleer de opbouw van de eId en
        corrigeer deze.</sch:assert>
      <sch:p>wId identifiers moeten uniek zijn in een bereik</sch:p>
      <sch:assert role="error" test="count(key('alleWIDs', @wId)) = 1"> Error: wId '<sch:value-of
          select="@wId" />' binnen het bereik is niet uniek. Controleer de opbouw van de wId en
        corrigeer deze.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_020" see="tekst:agAKN">
    <sch:title>Gebruik van de AKN-naamgeving voor eId's</sch:title>
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
          <xsl:when test="matches(local-name(), 'Toelichting|Kadertekst')">recital</xsl:when>
          <xsl:when test="matches(local-name(), 'InleidendeTekst')">intro</xsl:when>
          <xsl:when test="matches(local-name(), 'Aanhef')">formula</xsl:when>
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
            <xsl:value-of select="tokenize(@eId, '__')[last()]" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@eId" />
          </xsl:otherwise>
        </xsl:choose>
      </sch:let>
      <sch:p>De AKN-naamgevingsconventie moet worden gehanteerd voor eId's en wId's</sch:p>
      <sch:assert test="starts-with($mijnEID, $AKNnaam)">De AKN-naamgeving <sch:value-of
          select="$mijnEID" /> is niet correct voor element <sch:name />
        <sch:value-of select="@eId" />. Pas de naamgeving voor dit element en alle onderliggende
        elementen aan. Controleer ook de naamgeving van de bijbehorende wId.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    Initiële regelingen
  -->
  <sch:pattern id="sch_tekst_024" see="tekst:RegelingKlassiek tekst:BesluitKlassiek
    tekst:WijzigBijlage tekst:RegelingCompact tekst:RegelingVrijetekst tekst:RegelingTijdelijkdeel
    agComponentNieuweRegeling">
    <sch:title>Voor initiële regelingen zijn de attributen @componentnaam en @wordt
      verplicht</sch:title>
    <sch:rule
      context="tekst:BesluitKlassiek/tekst:RegelingKlassiek | tekst:WijzigBijlage/tekst:RegelingCompact | tekst:WijzigBijlage/tekst:RegelingVrijetekst | tekst:WijzigBijlage/tekst:RegelingTijdelijkdeel">
      <sch:p>Een initiële regeling moet een attribuut @componentnaam hebben met correcte
        naamgeving</sch:p>
      <sch:assert test="@componentnaam"> De initiële regeling <sch:name /> heeft geen attribuut
        @componentnaam, dit attribuut is voor een initiële regeling verplicht. Voeg het attribuut
        toe met als waarde "main". </sch:assert>
      <sch:p>Een initiële regeling moet een attribuut @wordt hebben met de AKN-identificatie voor de
        versie</sch:p>
      <sch:assert test="@wordt"> De initiële regeling <sch:name /> heeft geen attribuut @wordt, dit
        attribuut is voor een initiële regeling verplicht. Voeg het attribuut toe met als waarde de
        juiste AKN versie-identifier. </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    Unieke componentnamen
  -->
  <sch:pattern id="sch_tekst_025" see="tekst:agComponentMutatie">
    <sch:title>Binnen een besluit moeten de componentnamen voor regelingmutaties uniek
      zijn.</sch:title>
    <sch:rule context="tekst:*[@componentnaam]">
      <sch:let name="mijnComponent" value="@componentnaam" />
      <sch:p>Een componentnaam binnen een besluit MOET uniek zijn</sch:p>
      <sch:assert role="error"
        test="count(ancestor::tekst:*[@componentnaam]/@componentnaam = $mijnComponent) = 1"> De
        componentnaam <sch:value-of select="$mijnComponent" /> binnen <sch:value-of
          select="ancestor::tekst:*[@wId][1]/@wId" /> is niet uniek. Pas de componentnaam aan om
        deze uniek te maken.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    Unieke ID's binnen componenten
  -->
  <sch:pattern id="sch_tekst_012" see="tekst:agAKN">
    <sch:title>Binnen een AKN-component moeten de identifiers eId en wId uniek zijn.</sch:title>
    <sch:rule context="tekst:*[@componentnaam]//tekst:*[@eId]">
      <sch:let name="mijnEID" value="@eId" />
      <sch:let name="mijnWID" value="@wId" />
      <sch:p>Een eId binnen een AKN-component MOET uniek zijn</sch:p>
      <sch:assert role="error"
        test="count(ancestor::tekst:*[@componentnaam]/descendant::tekst:*[@eId[. = $mijnEID]]) = 1">
        De eId '<sch:value-of select="@eId" />' binnen component <sch:value-of
          select="ancestor::tekst:*[@componentnaam]/@componentnaam" /> moet uniek zijn. </sch:assert>
      <sch:p>Een wId binnen een AKN-component MOET uniek zijn. Controleer de opbouw van de eId en
        corrigeer deze</sch:p>
      <sch:assert role="error"
        test="count(ancestor::tekst:*[@componentnaam]/descendant::tekst:*[@wId[. = $mijnWID]]) = 1">
        De wId '<sch:value-of select="@wId" />' binnen component <sch:value-of
          select="ancestor::tekst:*[@componentnaam]/@componentnaam" /> moet uniek zijn. Controleer
        de opbouw van de wId en corrigeer deze.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <!-- VOOR TABELLEN EEN REEKS CONTROLES OP CALS REGELS -->
  <!--  -->
  <sch:pattern id="sch_tekst_014" see="tekst:table tekst:tgroup">
    <sch:title>Een tabel moet ten minste uit twee kolommen bestaan</sch:title>
    <sch:rule context="tekst:table">
      <sch:p>Bepaal of het aantal kolommen van de tabel gelijk is aan of groter dan 2</sch:p>
      <sch:assert role="error" test="number(tekst:tgroup/@cols) >= 2"> De tabel met <sch:value-of
          select="@wId" /> heeft slechts 1 kolom, dit is niet toegestaan. Pas de tabel aan, of
        plaats de inhoud van de tabel naar een element Kadertekst.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_015" see="tekst:table tekst:agColspec">
    <sch:title>De breedte van de kolommen moet conform de standaard worden aangegeven</sch:title>
    <sch:rule context="tekst:colspec[string-length(@colwidth) = 1]">
      <sch:p />
      <sch:assert role="error" test="@colwidth = '*'"> De colspec met @colname: <sch:value-of
          select="@colname" /> van de tabel met <sch:value-of select="ancestor::tekst:table/@wId" />
        kent een @colwidth van 1 karakter dat ongelijk is aan *. Corrigeer de @colwidth waarde
        conform de standard (bij voorbeeld: '3*') </sch:assert>
    </sch:rule>
    <sch:rule context="tekst:colspec[string-length(@colwidth) &gt; 1]">
      <sch:p>De specificatie van een kolombreedte (colwidth) moet tenminste 2 karakters lang
        zijn</sch:p>
      <sch:assert role="error" test="matches(@colwidth, '^[0-9 \.]+(\*|mm|cm|pi|pt|in)$')"> De
        colspec met @colname: <sch:value-of select="@colname" /> van de tabel met <sch:value-of
          select="ancestor::tekst:table/@wId" /> kent een @colwidth zonder een aangegeven eenheid of
        '*'. Corrigeer de @colwidth waarde conform de standard (bij voorbeeld: '3*') </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_016" see="tekst:table tekst:entry">
    <sch:title>De specificaties en positie van een tabelcel (entry) moet correct zijn en valide
      identificatie en verwijzingen hebben</sch:title>
    <sch:rule context="tekst:entry[@namest ne @nameend]">
      <sch:p>Bij horizontale overspanning moet de waarde van @nameend groter of gelijk zijn dan
        @namest</sch:p>
      <sch:assert role="error"
        test="xs:integer(replace(@namest, '[^\d]', '')) lt xs:integer(replace(@nameend, '[^\d]', ''))"
        > De entry met @namest <sch:value-of select="@namest" />, van de <xsl:value-of
          select="count(preceding-sibling::tekst:row) + 1" />e rij, van <sch:value-of
          select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)" />, van de tabel met
        wId: <sch:value-of select="ancestor::tekst:table/@wId" />, kent een @namest groter dan de
        @nameend. Corrigeer de gegevens voor de overspanning. </sch:assert>
    </sch:rule>
    <sch:rule context="tekst:entry[@namest and @colname]">
      <sch:p>Bij horizontale overspanning moet de positie van de eerste cel (@colname) gelijk zijn
        aan de start van de overspanning (@namest)</sch:p>
      <sch:assert role="error" test="@namest ne @colname"> De entry met @namest <sch:value-of
          select="@namest" />, van de <xsl:value-of select="count(preceding-sibling::tekst:row) + 1"
         />e rij, van <sch:value-of
          select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)" />, van de tabel met
        id: <sch:value-of select="ancestor::tekst:table/@wId" />, kent een @namest die ongelijk is
        aan @colname. Controleer en corrigeer deze waarden.</sch:assert>
    </sch:rule>
    <sch:rule context="tekst:row">
      <sch:p>Bij een verticale overspanning is het onlogisch wanneer alle cellen (entry) elementen
        in 1 rij (row) @morerows attributen hebben.</sch:p>
      <sch:report role="warning" test="count(tekst:entry) = count(tekst:entry[@morerows])"> Alle
        cellen van de <xsl:value-of select="count(preceding-sibling::tekst:row) + 1" />e rij van
          <sch:value-of select="local-name(parent::tekst:*)" /> in tabel <sch:value-of
          select="ancestor::tekst:table/@wId" /> hebben een @morerows attribuut. </sch:report>
      <sch:p>Bij een verticale overspanning waar alle cellen in een rij een @morerows met waarde '1'
        hebben XXX</sch:p>
      <sch:report role="error" test="count(tekst:entry) = count(tekst:entry[@morerows = '1'])"> Alle
        cellen van de <xsl:value-of select="count(preceding-sibling::tekst:row) + 1" />e rij van
        tabel <sch:value-of select="ancestor::tekst:table/@wId" /> hebben een @morerows attribuut
        met de waarde '1'. Verwijder de attributen @morerows voor de cellen in de rij.</sch:report>
    </sch:rule>
    <sch:rule context="tekst:entry/@colname | tekst:entry/@namest | tekst:entry/@nameend">
      <sch:p>De referentie van een cel (entry) naar een kolom (@colname) MOET correct verwijzen naar
        een de identifier voor een @colspec.</sch:p>
      <sch:let name="id" value="." />
      <sch:assert role="error" test="ancestor::tekst:tgroup/tekst:colspec[@colname = $id]"> De entry
        met @<sch:value-of select="name()" />
        <sch:value-of select="." /> van de <xsl:value-of
          select="count(parent::tekst:entry/preceding-sibling::tekst:row) + 1" />e rij, van
          <sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)" />, van
        de tabel met id: <sch:value-of select="ancestor::tekst:table/@wId" />, verwijst niet naar
        een bestaande kolom. Controleer en corrigeer de identifier voor de kolom
        (@colname)</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_017" see="tekst:table">
    <sch:title>Het aantal cellen geplaatst in een tabel moet overeenkomen met de
      specificatie</sch:title>
    <sch:rule context="tekst:thead | tekst:tbody">
      <sch:let name="totaalCellen" value="count(tekst:row) * number(parent::tekst:tgroup/@cols)" />
      <sch:let name="colPosities">
        <xsl:for-each select="ancestor::tekst:tgroup/tekst:colspec">
          <col colnum="{position()}" name="{@colname}" />
        </xsl:for-each>
      </sch:let>
      <sch:let name="cellen" value="count(descendant::tekst:entry)" />
      <sch:let name="spanEinde">
        <xsl:for-each select="descendant::tekst:entry">
          <xsl:variable as="xs:string?" name="namest" select="@namest" />
          <xsl:variable as="xs:string?" name="nameend" select="@nameend" />
          <xsl:variable as="xs:integer?" name="numend"
            select="$colPosities/*[@name = $nameend]/@colnum" />
          <xsl:variable as="xs:integer?" name="numst"
            select="$colPosities/*[@name = $namest]/@colnum" />
          <nr>
            <xsl:choose>
              <xsl:when test="$numend and $numst and @morerows">
                <xsl:value-of select="($numend - $numst + 1) * (@morerows + 1)" />
              </xsl:when>
              <xsl:when test="$numend and $numst">
                <xsl:value-of select="$numend - $numst + 1" />
              </xsl:when>
              <xsl:when test="@morerows">
                <xsl:value-of select="1 + @morerows" />
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </nr>
        </xsl:for-each>
      </sch:let>
      <sch:let name="spannend" value="sum($spanEinde/*)" />
      <sch:p>Het aantal colspec's MOET gelijk zijn aan het opgegeven aantal kolommen.</sch:p>
      <sch:assert role="error"
        test="number(parent::tekst:tgroup/@cols) = count(ancestor::tekst:tgroup/tekst:colspec)"> Het
        aantal colspec's (<sch:value-of select="count(ancestor::tekst:tgroup/tekst:colspec)" />)
        voor <sch:name /> in tabel <sch:value-of select="ancestor::tekst:table/@wId" /> komt niet
        overeen met het aantal kolommen (<sch:value-of select="parent::tekst:tgroup/@cols" />). </sch:assert>
      <sch:p>Het totale aantal cellen inclusief spans en morerows MOET overeenkomen met het aantal
        mogelijke cellen zonder spans en morerows.</sch:p>
      <sch:assert role="error" test="$totaalCellen = $spannend"> Het aantal cellen (<sch:value-of
          select="$spannend" />) in <sch:name /> van tabel " <sch:value-of
          select="ancestor::tekst:table/@wId" />" komt niet overeen met de verwachting (resultaat:
          <sch:value-of select="$spannend" /> van verwachting <sch:value-of select="$totaalCellen"
         />). </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_018" see="tekst:WijzigArtikel tekst:WijzigLid tekst:WijzigInstructies">
    <sch:title>Een WijzigArtikel of WijzigLid met WijzigInstructies is alleen toegestaan in een
      BesluitKlassiek</sch:title>
    <sch:rule context="tekst:WijzigArtikel//tekst:WijzigInstructies">
      <sch:p>Een element WijzigInstructies MAG NIET worden gebruikt in een ander type besluit dan
        een BesluitKlassiek</sch:p>
      <sch:assert test="ancestor::tekst:BesluitKlassiek"> Het element <sch:name /> in element
          <sch:value-of select="name(ancestor::tekst:*[@wId][1])" /> met wId <sch:value-of
          select="ancestor::tekst:*[@wId][1]/@wId" /> is niet toegestaan. Dit element is uitsluitend
        toegestaan binnen een BesluitKlassiek om wijzigingen te kunnen bekendmaken voor regelingen
        die niet volgens de STOP-standaard beschikbaar zijn.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_019" see="tekst:WijzigArtikel tekst:WijzigLid tekst:RegelingMutatie">
    <sch:title>Een WijzigArtikel of WijzigLid met RegelingMutatie is alleen toegestaan in een
      BesluitKlassiek</sch:title>
    <sch:rule context="tekst:WijzigArtikel//tekst:RegelingMutatie">
      <sch:p>Een element RegelingMutatie binnen een WijzigArtikel of WijzigLid MAG NIET worden
        gebruikt in een ander type besluit dan een BesluitKlassiek</sch:p>
      <sch:assert test="ancestor::tekst:BesluitKlassiek"> Het element <sch:name /> met wId
          <sch:value-of select="ancestor::tekst:*[@wId][1]/@wId" /> binnen <sch:value-of
          select="name(ancestor::tekst:*[@wId][1])" /> is niet toegestaan. Neem de RegelingMutatie
        op in een WijzigBijlage.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
</sch:schema>
