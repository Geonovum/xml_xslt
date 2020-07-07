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
  <!-- -->
  <sch:p>Versie @@@VERSIE@@@</sch:p>
  <sch:pattern>
    <sch:title>Lijst: nummering afhankelijk van het type van de lijst [T]</sch:title>
    <sch:rule context="tekst:Lijst[not(@type)]">
      <sch:p>Een Lijst zonder type aanduiding MOET worden behandeld als een lijst van het type
        'expliciet'</sch:p>
      <sch:assert role="error" test="count(tekst:Li[not(tekst:LiNummer)]) = 0"> Een Lijst van type
        'expliciet' heeft verplicht altijd LiNummer elementen. </sch:assert>
    </sch:rule>
    <sch:rule context="tekst:Lijst[@type = 'ongemarkeerd']">
      <sch:p>Een Lijst van het type 'ongemarkeerd' MOET lijst items hebben zonder nummering.</sch:p>
      <sch:assert role="error" test="count(tekst:Li/tekst:LiNummer) = 0"> Een Lijst van type
        'ongemarkeerd' mag geen LiNummer elementen hebben. </sch:assert>
    </sch:rule>
    <sch:rule context="tekst:Lijst[@type = 'expliciet']">
      <sch:p>Een Lijst van het type 'expliciet' MOET genummerde lijst items hebben.</sch:p>
      <sch:assert role="error" test="count(tekst:Li[not(tekst:LiNummer)]) = 0"> Een Lijst van type
        'expliciet' heeft verplicht altijd LiNummer elementen. </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:title>Nummer voor structuur en LidNummer voor WijzigArtikel [T]</sch:title>
    <sch:rule context="tekst:lichaam/descendant::tekst:Nummer | tekst:WijzigArtikel/descendant::tekst:LidNummer">
      <sch:p>Nummer voor structuur en LidNummer voor WijzigArtikel MAG NIET op een punt '.'
        eindigen.</sch:p>
      <sch:report role="error" test="ends-with(., '.')"> De nummering van element <sch:value-of
          select="local-name(ancestor::node()[@wId][1])" /> met id <sch:value-of
          select="ancestor::*[@wId][1]/@wId" /> mag NIET eindigen met een punt '.'. </sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:title>Een NootRef kan alleen binnen een tabel worden gebruikt [T]</sch:title>
    <sch:rule context="tekst:Nootref">
      <sch:let name="nootID" value="@refid" />
      <sch:p>Een NootRef MOET in de context van een tabel staan verwijzend naar een Noot binnen
        dezelfde tabel.</sch:p>
      <sch:assert test="ancestor::tekst:table"> De Nootref naar Noot met id <sch:value-of
          select="@refid" /> staat niet in een tabel. </sch:assert>
      <sch:p>Een NootRef MOET verwijzen naar een Noot in dezelfde tabel.</sch:p>
      <sch:assert test="ancestor::tekst:table/descendant::tekst:Noot[@id = $nootID]"> De NootRef
        naar Noot met id <sch:value-of select="@refid" /> verwijst niet naar een NOOT in dezelfde
        tabel <sch:value-of select="ancestor::tekst:table/@wId" />. </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:title>Gebruik van een tabel in een lijst is voorbehouden aan oudere regelingen (legacy)
      [T]</sch:title>
    <sch:rule context="tekst:li/tekst:table">
      <sch:p>Voor nieuwe regelingen is het niet toegestaan een tabel binnen een Lijst te
        plaatsen.</sch:p>
      <sch:report role="warning"
        test="(parent::tekst:BesluitKlassiek | parent::BesluitCompact | parent::tekst:WijzigBijlage)/(tekst:RegelingKlassiek | tekst:RegelingVrijetekst | tekst:RegelingTijdelijkdeel | tekst:RegelingCompact)"
        > Een tabel in Lijstitem <sch:value-of select="parent::Li/@wId" /> is niet toegestaan voor
        nieuwe regelingen. </sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:title>Een kop voor Divisietekst is in sommige gevallen optioneel.</sch:title>
    <sch:rule context="tekst:Divisietekst[not(child::tekst:Kop)]">
      <sch:p />
      <sch:assert
        test="(parent::tekst:Bijlage | parent::tekst:Toelichting | parent::tekst:Motivering | parent::tekst:AlgemeneToelichting) and count(parent::tekst:*/child::tekst:*) = 2"
        >Een Kop voor Divisietekst <sch:value-of select="@wId" /> is verplicht in deze
        context.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!-- INTERNE REFERENTIES HEBBEN CORRECTE VERWIJZINGEN -->
  <sch:pattern>
    <sch:title>De waarden van een interne referentie element moet verwijzen naar een bestaande
      identificatie binnen hetzelfde instrument</sch:title>
    <sch:rule context="tekst:IntRef[not(ancestor::tekst:RegelingMutatie)]">
      <sch:let name="doelwit" value="@ref" />
      <sch:p>Een interne referentie MOET verwijzen naar een in hetzelfde bestand bestaande
        identifier</sch:p>
      <sch:assert role="error" test="//*[@eId = $doelwit] | //*[@wId = $doelwit]"> De @ref van
        element <sch:name /> met waarde <sch:value-of select="$doelwit" /> verwijst niet naar een
        bestaande identifier binnen hetzelfde instrument. </sch:assert>
    </sch:rule>
    <sch:rule context="tekst:IntIoRef[not(ancestor::tekst:RegelingMutatie)]">
      <sch:let name="doelwit" value="@ref" />
      <sch:p>Een referentie naar een ExtIoRef MOET verwijzen naar een @wId identifier in hetzelfde
        instrument</sch:p>
      <sch:assert role="error" test="//tekst:*[@wId = $doelwit]"> De @ref van element <sch:name />
        met waarde <sch:value-of select="$doelwit" /> verwijst niet naar een @wId binnen hetzelfde
        instrument</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:title>De referentie en de tekst van een ExtIoRef moeten gelijk luidend zijn</sch:title>
    <sch:rule context="tekst:ExtIoRef">
      <sch:let name="waarde" value="@ref" />
      <sch:p>De afgebeelde JOIN-identifier MOET gelijk zijn aan de JOIN referentie.</sch:p>
      <sch:assert role="error" test=". = $waarde"> De JOIN identifier van ExtIoRef <sch:value-of
          select="@wId" /> in de tekst is niet gelijk aan de referentie.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:title>Een @wId en @eId mogen niet eindigen op een '.' [T]</sch:title>
    <sch:rule context="//*[@eId]">
      <sch:let name="doelwitE" value="@eId" />
      <sch:let name="doelwitW" value="@wId" />
      <sch:p>Een attribuut @eId MAG NIET eindigen met een '.'.</sch:p>
      <sch:report role="warning" test="ends-with($doelwitE, '.')"> Het attribuut @eId <sch:value-of
          select="$doelwitE" /> eindigt op een '.', dit is niet toegestaan. </sch:report>
      <sch:p>Een attribuut @wId MAG NIET eindigen met een '.'.</sch:p>
      <sch:report role="warning" test="ends-with($doelwitW, '.')"> Het attribuut @wId <sch:value-of
          select="$doelwitW" /> eindigt op een '.', dit is niet toegestaan. </sch:report>
    </sch:rule>
  </sch:pattern>
  <!-- 
    Renvooi markering alleen toegestaan binnen een tekst:RegelingMutatie
  -->
  <sch:pattern>
    <sch:title>Tekstuele-wijzigingen in de context van een RegelingMutatie [T]</sch:title>
    <sch:rule context="//tekst:NieuweTekst | //tekst:VerwijderdeTekst">
      <sch:p>Een tekstuele wijziging MOET in de context van een tekst:RegelingMutatie staan.</sch:p>
      <sch:assert role="error" test="ancestor::tekst:RegelingMutatie"> Tekstuele wijziging is niet
        toegestaan voor <sch:value-of select="local-name(parent::tekst:*)" /> - "<sch:value-of
          select="ancestor::tekst:*[@wId][1]/@wId" />" buiten de context van een
        tekst:RegelingMutatie. </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:title>Structuur-wijzigingen in de context van een tekst:RegelingMutatie [T]</sch:title>
    <sch:rule context="//tekst:*[@wijzigactie]">
      <sch:p>Een structuur wijziging MOET in de context van een tekst:RegelingMutatie staan.</sch:p>
      <sch:assert role="error" test="ancestor::tekst:RegelingMutatie"> Attribuut @wijzigactie is
        niet toegestaan op element <sch:value-of select="local-name()" /> - "<sch:value-of
          select="ancestor::tekst:*[@wId][1]/@wId" />" buiten de context van een
        tekst:RegelingMutatie. </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    Unieke eId en wId's voor Besluiten / Regelingen
  -->
  <xsl:key
    match="(tekst:BesluitCompact | tekst:BesluitKlassiek | tekst:RegelingCompact | tekst:RegelingTijdelijkdeel | tekst:RegelingKlassiek | tekst:RegelingVrijetekst)/descendant::tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
    name="alleEIDs" use="@eId" />
  <xsl:key
    match="(tekst:BesluitCompact | tekst:BesluitKlassiek | tekst:RegelingCompact | tekst:RegelingTijdelijkdeel | tekst:RegelingKlassiek | tekst:RegelingVrijetekst)/descendant::tekst:*[@wId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
    name="alleWIDs" use="@wId" />
  <sch:pattern>
    <sch:title>Alle identifiers wId en eId moeten uniek zijn</sch:title>
    <sch:rule
      context="(tekst:BesluitCompact | tekst:BesluitKlassiek | tekst:RegelingCompact | tekst:RegelingTijdelijkdeel | tekst:RegelingKlassiek | tekst:RegelingVrijetekst)/descendant::tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]">
      <sch:p>eId identifiers moeten uniek zijn in een Besluit</sch:p>
      <sch:assert role="error" test="count(key('alleEIDs', @eId)) = 1"> Error: eId '<sch:value-of
          select="@eId" />' binnen het bereik is niet uniek. </sch:assert>
      <sch:p>wId identifiers moeten uniek zijn in een bereik</sch:p>
      <sch:assert role="error" test="count(key('alleWIDs', @wId)) = 1"> Error: wId '<sch:value-of
          select="@wId" />' binnen het bereik is niet uniek. </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    Unieke ID's voor componenten
  -->
  <sch:pattern id="Unieke-componentIds">
    <sch:title>Binnen een component moeten de identifiers uniek zijn.</sch:title>
    <sch:rule context="tekst:*[@componentnaam]/descendant::tekst:*[@eId]">
      <sch:let name="mijnEID" value="@eId" />
      <sch:let name="mijnWID" value="@wId" />
      <sch:p>Een eId binnen een AKN-component MOET uniek zijn.</sch:p>
      <sch:assert role="error"
        test="count(ancestor::tekst:*[@componentnaam]/descendant::tekst:*[@eId[. = $mijnEID]]) = 1">
        Error: eId '<sch:value-of select="@eId" />' binnen component <sch:value-of
          select="ancestor::tekst:*[@componentnaam]/@componentnaam" /> moet uniek zijn. </sch:assert>
      <sch:p>Een wId binnen een AKN-component MOET uniek zijn.</sch:p>
      <sch:assert role="error"
        test="count(ancestor::tekst:*[@componentnaam]/descendant::tekst:*[@wId[. = $mijnWID]]) = 1">
        Error: wId '<sch:value-of select="@wId" />' binnen component <sch:value-of
          select="ancestor::tekst:*[@componentnaam]/@componentnaam" /> moet uniek zijn.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <!-- VOOR TABELLEN EEN REEKS CONTROLES OP GEBRUIK WIJZIGACTIES -->
  <!--  -->
  <sch:pattern>
    <sch:title>Wijzigactie voor rijen en kolommen mogen niet samen voorkomen [D]</sch:title>
    <sch:rule context="tekst:tgroup">
      <sch:p>Wijzigactie MOET OF voor kolommen OF voor rijen voorkomen, niet gecombineerd.</sch:p>
      <sch:report role="error"
        test="descendant::tekst:row[@wijzigactie] and descendant::tekst:colspec[@wijzigactie]"> Een
        @wijzigactie op zowel rijen als kolommen in tabel '<sch:value-of
          select="ancestor::tekst:table/@wId" />' is niet toegestaan. </sch:report>
      <sch:p>Wijzigactie MAG NIET voorkomen, wanneer verticale overspanning is gebruikt.</sch:p>
      <sch:report role="error"
        test="descendant::tekst:row[@wijzigactie] or descendant::tekst:colspec[@wijzigactie] and descendant::tekst:entry[@morerows]"
        > Een @wijzigactie voor tabel <sch:value-of select="ancestor::tekst:table/@wId" /> met een
        verticale overspanning is niet toegestaan. </sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <!-- VOOR TABELLEN EEN REEKS CONTROLES OP CALS REGELS -->
  <!--  -->
  <sch:pattern>
    <sch:title>Een table moet meer dan 1 kolommen hebben.</sch:title>
    <sch:rule context="tekst:table">
      <sch:assert role="error" test="number(tekst:tgroup/@cols) >= 2"> De tabel met <sch:value-of
          select="@wId" /> heeft slechts 1 kolom, dit is niet toegestaan.</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:title>@colwidth validaties</sch:title>
    <sch:rule context="tekst:colspec[string-length(@colwidth) = 1]">
      <sch:assert role="error" test="@colwidth = '*'"> De colspec met @colname: <sch:value-of
          select="@colname" /> van de tabel met <sch:value-of select="ancestor::tekst:table/@wId" />
        kent een @colwidth van 1 karakter die ongelijk is aan *. </sch:assert>
    </sch:rule>
    <sch:rule context="tekst:colspec[string-length(@colwidth) &gt; 1]">
      <sch:assert role="error" test="matches(@colwidth, '^[0-9 \.]+(\*|mm|cm|pi|pt|in)$')"> De
        colspec met @colname: <sch:value-of select="@colname" /> van de tabel met <sch:value-of
          select="ancestor::tekst:table/@wId" /> kent een @colwidth zonder een eenheid of *.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:title>entry validaties</sch:title>
    <sch:rule context="tekst:entry[@namest ne @nameend]">
      <sch:p>@nameend moet groter of gelijk zijn dan @namest</sch:p>
      <sch:assert role="error"
        test="xs:integer(replace(@namest, '[^\d]', '')) lt xs:integer(replace(@nameend, '[^\d]', ''))"
        > De entry met @namest <sch:value-of select="@namest" />, van de <xsl:value-of
          select="count(preceding-sibling::tekst:row) + 1" />e rij, van <sch:value-of
          select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)" />, van de tabel met
        id: <sch:value-of select="ancestor::tekst:table/@wId" />, kent een namest groter dan de
        nameend </sch:assert>
    </sch:rule>
    <sch:rule context="tekst:entry[@namest and @colname]">
      <sch:p>@namest moet gelijk zijn dan @colname</sch:p>
      <sch:assert role="error" test="@namest ne @colname"> De entry met @namest <sch:value-of
          select="@namest" />, van de <xsl:value-of select="count(preceding-sibling::tekst:row) + 1"
         />e rij, van <sch:value-of
          select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)" />, van de tabel met
        id: <sch:value-of select="ancestor::tekst:table/@wId" />, kent een @namest die ongelijk is
        aan @colname. </sch:assert>
    </sch:rule>
    <sch:rule context="tekst:row">
      <sch:p>Het is onlogisch wanneer alle entries in 1 row @morerows attributen hebben.</sch:p>
      <sch:report role="warning" test="count(tekst:entry) = count(tekst:entry[@morerows])"> Alle
        cellen van de <xsl:value-of select="count(preceding-sibling::tekst:row) + 1" />e rij van
          <sch:value-of select="local-name(parent::tekst:*)" /> in tabel <sch:value-of
          select="ancestor::tekst:table/@wId" /> hebben een @morerows attribuut. </sch:report>
      <sch:report role="error" test="count(tekst:entry) = count(tekst:entry[@morerows = '1'])"> Alle
        cellen van de <xsl:value-of select="count(preceding-sibling::tekst:row) + 1" />e rij van
        tabel <sch:value-of select="ancestor::tekst:table/@wId" /> hebben een @morerows attribuut
        met de waarde '1'. </sch:report>
    </sch:rule>
    <sch:rule context="tekst:entry/@colname | tekst:entry/@namest | tekst:entry/@nameend">
      <sch:p>De referentie van een entry naar een kolom MOET correct verwijzen naar een
        colspec.</sch:p>
      <sch:let name="id" value="." />
      <sch:assert role="error" test="ancestor::tekst:tgroup/tekst:colspec[@colname = $id]"> De entry
        met @<sch:value-of select="name()" />
        <sch:value-of select="." /> van de <xsl:value-of
          select="count(parent::tekst:entry/preceding-sibling::tekst:row) + 1" />e rij, van
          <sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)" />, van
        de tabel met id: <sch:value-of select="ancestor::tekst:table/@wId" />, verwijst niet naar
        een bestaande kolom. </sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:title>Het aantal cellen geplaatst in een tabel moet overeenkomen met de specificatie
      [T]</sch:title>
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
</sch:schema>
