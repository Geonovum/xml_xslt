<?xml version="1.0" encoding="UTF-8"?>
<sch:schema queryBinding="xslt2" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="tekst" uri="https://standaarden.overheid.nl/stop/imop/tekst/" />
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform" />
  <sch:p>Versie 1.0.4</sch:p>
  <sch:p>Schematron voor aanvullende validatie voor tekstmutaties</sch:p>
  <!--
    Initiële regelingen
  -->
  <sch:pattern id="sch_tekst_024" see="tekst:RegelingKlassiek tekst:BesluitKlassiek
    tekst:WijzigBijlage tekst:RegelingCompact tekst:RegelingVrijetekst
    tekst:RegelingTijdelijkdeel agComponentNieuweRegeling">
    <sch:title>Regelingen - initieel met componentnaam</sch:title>
    <sch:rule
      context="tekst:BesluitKlassiek/tekst:RegelingKlassiek | tekst:WijzigBijlage/tekst:RegelingCompact | tekst:WijzigBijlage/tekst:RegelingVrijetekst | tekst:WijzigBijlage/tekst:RegelingTijdelijkdeel">
      <sch:let name="regeling">
        <xsl:choose>
          <xsl:when test="child::tekst:RegelingOpschrift">
            <xsl:value-of select="normalize-space(child::tekst:RegelingOpschrift/.)" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space(/tekst:*/tekst:RegelingOpschrift/.)" />
          </xsl:otherwise>
        </xsl:choose>
      </sch:let>
      <sch:assert id="STOP0024" test="@componentnaam"> {"code": "STOP0024", "regeling": "<sch:value-of select="$regeling" />", "melding": "De initiële regeling \"<sch:value-of select="$regeling" />\" heeft geen attribuut @componentnaam, dit attribuut is voor een initiële regeling verplicht. Voeg het attribuut toe bij voorbeeld met als waarde \"main\"", "ernst": "fout"},</sch:assert>
      <sch:assert id="STOP0025" test="@wordt"> {"code": "STOP0025", "regeling": "<sch:value-of select="$regeling" />", "melding": "De initiële regeling \"<sch:value-of select="$regeling" />\" heeft geen attribuut @wordt, dit attribuut is voor een initiële regeling verplicht. Voeg het attribuut toe met als waarde de juiste AKN versie-identifier", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    Unieke componentnamen
  -->
  <sch:pattern id="sch_tekst_031" see="tekst:agComponentMutatie agComponentNieuweRegeling">
    <sch:title>Identificatie - componentnaam uniek</sch:title>
    <sch:rule context="tekst:*[@componentnaam]">
      <sch:let name="mijnComponent" value="@componentnaam" />
      <sch:assert id="STOP0026" role="error" test="count(//tekst:*[@componentnaam = $mijnComponent]) = 1"> {"code": "STOP0026", "component": "<sch:value-of select="$mijnComponent" />", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />", "melding": "De componentnaam \"<sch:value-of select="$mijnComponent" /> binnen <sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" /> is niet uniek. Pas de componentnaam aan om deze uniek te maken", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    Unieke ID's binnen componenten
  -->
  <sch:pattern id="sch_tekst_012" see="tekst:agAKN">
    <sch:title>Identificatie - eId, wId binnen een AKN-component</sch:title>
    <sch:rule context="tekst:*[@componentnaam]">
      <sch:let name="component" value="@componentnaam" />
      <sch:let name="index">
        <xsl:for-each
          select="//tekst:*[@eId][ancestor::tekst:*[@componentnaam][1][@componentnaam = $component]][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijderContainer'])]">
          <xsl:sort select="@eId" />
          <e>
            <xsl:value-of select="@eId" />
          </e>
        </xsl:for-each>
        <xsl:for-each
          select="//tekst:*[@eId][ancestor::tekst:*[@componentnaam][1][@componentnaam = $component]][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijderContainer'])]">
          <xsl:sort select="@wId" />
          <w>
            <xsl:value-of select="@wId" />
          </w>
        </xsl:for-each>
      </sch:let>
      <sch:let name="eId-fout">
        <xsl:for-each select="$index/e[preceding-sibling::e = .]">
          <xsl:value-of select="." />
          <xsl:if test="not(position() = last())">
            <xsl:text>; </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </sch:let>
      <sch:let name="wId-fout">
        <xsl:for-each select="$index/w[preceding-sibling::w = .]">
          <xsl:value-of select="self::w/." />
          <xsl:if test="not(position() = last())">
            <xsl:text>; </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </sch:let>
      <sch:assert id="STOP0027" role="error" test="$eId-fout = ''"> {"code": "STOP0027", "eId": "<sch:value-of select="$eId-fout" />", "component": "<sch:value-of select="$component" />", "melding": "De eId '<sch:value-of select="$eId-fout" />' binnen component <sch:value-of select="$component" /> moet uniek zijn. Controleer de opbouw van de wId en corrigeer deze", "ernst": "fout"},</sch:assert>
      <sch:assert id="STOP0028" role="error" test="$wId-fout = ''"> {"code": "STOP0028", "wId": "<sch:value-of select="$wId-fout" />", "component": "<sch:value-of select="$component" />", "melding": "De wId '<sch:value-of select="$wId-fout" />' binnen component <sch:value-of select="$component" /> moet uniek zijn. Controleer de opbouw van de wId en corrigeer deze", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_018" see="tekst:WijzigArtikel tekst:WijzigLid tekst:WijzigInstructies">
    <sch:title>RegelingMutatie - WijzigInstructies in een WijzigArtikel</sch:title>
    <sch:rule context="tekst:WijzigArtikel/descendant::tekst:WijzigInstructies">
      <sch:assert id="STOP0039" test="ancestor::tekst:BesluitKlassiek"> {"code": "STOP0039", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" />", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />", "melding": "Het element WijzigInstructies binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" /> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />\" is niet toegestaan. Verwijder de WijzigInstructies, of verplaats deze naar een RegelingMutatie binnen een WijzigBijlage.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_048" see="tekst:WijzigArtikel tekst:WijzigLid tekst:WijzigInstructies">
    <sch:title>RegelingMutatie - OpmerkingVersie in een WijzigArtikel</sch:title>
    <sch:rule context="tekst:WijzigArtikel/descendant::tekst:OpmerkingVersie">
      <sch:assert id="STOP0051" test="ancestor::tekst:BesluitKlassiek"> {"code": "STOP0051", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" />", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />", "melding": "Het element OpmerkingVersie binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" /> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />\" is allen toegestaan in een BesluitCompact. Verwijder de OpmerkingVersie.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_019" see="tekst:WijzigArtikel tekst:WijzigLid tekst:RegelingMutatie">
    <sch:title>RegelingMutatie - in een WijzigArtikel</sch:title>
    <sch:rule context="tekst:WijzigArtikel/descendant::tekst:RegelingMutatie">
      <sch:assert id="STOP0040" test="ancestor::tekst:Lichaam/parent::tekst:BesluitKlassiek | ancestor::tekst:Lichaam/parent::tekst:RegelingKlassiek"> {"code": "STOP0040", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" />", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />", "melding": "Het element RegelingMutatie binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" /> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />\" is niet toegestaan. Neem de RegelingMutatie op in een WijzigBijlage.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_020" see="tekst:Wat">
    <sch:title>renvooi in Wat</sch:title>
    <sch:rule context="tekst:Wat">
      <sch:report test="tekst:VerwijderdeTekst | tekst:NieuweTekst"> {"code": "STOP0047", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" />", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />", "melding": "Het element Wat van de RegelingMutatie binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" /> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />\" bevat renvooimarkeringen. Verwijder de element(en) NieuweTekst en VerwijderdeTekst.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="sch_tekst_021" see="tekst:Al tekst:Begrip tekst:Begrippenlijst tekst:Citaat
    tekst:Definitie tekst:Figuur tekst:Figuur:Titel tekst:Formule tekst:Groep
    tekst:InlineTekstAfbeelding tekst:Kadertekst tekst:Li tekst:Lijst tekst:Lijstaanhef
    tekst:Lijstsluiting ekst:Noot tekst:Nootref tekst:Nummer tekst:Opschrift tekst:Samenvatting
    tekst:Subtitel tekst:Term tekst:Titelregel tekst:Tussenkop tekst:colspec tekst:row
    tekst:table tekst:title">
    <sch:title>wijzigactie nieuweContainer verwijderContainer op andere inhouds-element dan
      Groep</sch:title>
    <sch:rule context="tekst:Inhoud//tekst:*[@wijzigactie][local-name() != 'Groep']">
      <sch:report test="(@wijzigactie = 'nieuweContainer' or @wijzigactie = 'verwijderContainer')">
        {"code": "STOP0048", "naam": "<sch:value-of select="local-name(.)" />", "eId": "<sch:value-of select="ancestor-or-self::tekst:*[@eId][1]/@eId" />", "melding": "Op element <sch:value-of select="local-name(.)" /> met (bovenliggend) eId <sch:value-of select="ancestor-or-self::tekst:*[@eId][1]/@eId" /> is de wijzigactie \"nieuweContainer\" en \"verwijderContainer\" toegepast. Dit kan leiden tot invalide XML of informatieverlies. Verwijder de @wijzigactie.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_0045">
    <sch:title>@Wijzigactie voor Inhoud</sch:title>
    <sch:rule context="tekst:Vervang//tekst:Inhoud[@wijzigactie]">
      <sch:p>tekst:Inhoud mag uitsluitend een @wijzigactie hebben gecombineerd met tekst:Vervallen
        of tekst:Gereserveerd</sch:p>
      <sch:assert id="STOP0063" role="error" test="parent::tekst:*/tekst:Gereserveerd | parent::tekst:*/tekst:Vervallen">{"code": "STOP0063", "naam": "<sch:value-of select="local-name(ancestor::tekst:Vervang[@wat][1])" />", "wat": "<sch:value-of select="ancestor::tekst:Vervang[@wat][1]/@wat" />", "melding": "Het element Inhoud van <sch:value-of select="local-name(ancestor::tekst:Vervang[@wat][1])" /> met het attribuut @wat \"<sch:value-of select="ancestor::tekst:Vervang[@wat][1]/@wat" />\" heeft ten onrechte een attribuut @wijzigactie. Dit is alleen toegestaan indien gecombineerd met een Gereserveerd of Vervallen. Verwijder het attribuut @wijzigactie.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
