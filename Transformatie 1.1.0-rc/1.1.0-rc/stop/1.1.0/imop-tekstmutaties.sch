<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
            xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            queryBinding="xslt2">
   <sch:ns prefix="tekst" uri="https://standaarden.overheid.nl/stop/imop/tekst/"/>
   <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
   <sch:p>Versie 1.1.0</sch:p>
   <sch:p>Schematron voor aanvullende validatie voor tekstmutaties</sch:p>
   <!--
    Initiële regelingen
  -->
   <sch:pattern id="sch_tekst_024">
      <sch:title>Regelingen - initieel met componentnaam</sch:title>
      <sch:rule context="tekst:BesluitKlassiek/tekst:RegelingKlassiek | tekst:WijzigBijlage/tekst:RegelingCompact | tekst:WijzigBijlage/tekst:RegelingVrijetekst | tekst:WijzigBijlage/tekst:RegelingTijdelijkdeel">
         <sch:let name="regeling">
            <xsl:choose>
               <xsl:when test="child::tekst:RegelingOpschrift">
                  <xsl:value-of select="string-join(child::tekst:RegelingOpschrift/*/normalize-space(), '')"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="string-join(tekst:*/tekst:RegelingOpschrift/*/normalize-space(), '')"/>
               </xsl:otherwise>
            </xsl:choose>
         </sch:let>
         <sch:assert id="STOP0024" test="@componentnaam" role="fout"> {"code": "STOP0024", "regeling": "<sch:value-of select="$regeling"/>", "melding": "De initiële regeling \"<sch:value-of select="$regeling"/>\" heeft geen attribuut @componentnaam, dit attribuut is voor een initiële regeling verplicht. Voeg het attribuut toe met een unieke naamgeving.", "ernst": "fout"},</sch:assert>
         <sch:assert id="STOP0025" test="@wordt" role="fout"> {"code": "STOP0025", "regeling": "<sch:value-of select="$regeling"/>", "melding": "De initiële regeling \"<sch:value-of select="$regeling"/>\" heeft geen attribuut @wordt, dit attribuut is voor een initiële regeling verplicht. Voeg het attribuut toe met als waarde de juiste AKN versie-identifier", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <!--
    Unieke componentnamen
  -->
   <sch:pattern id="sch_tekst_031">
      <sch:title>Identificatie - componentnaam uniek</sch:title>
      <sch:rule context="tekst:*[@componentnaam]">
         <sch:let name="mijnComponent" value="@componentnaam"/>
         <sch:assert id="STOP0026"
                     test="count(//tekst:*[@componentnaam = $mijnComponent]) = 1"
                     role="fout"> {"code": "STOP0026", "component": "<sch:value-of select="$mijnComponent"/>", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "melding": "De componentnaam \"<sch:value-of select="$mijnComponent"/> binnen <sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/> is niet uniek. Pas de componentnaam aan om deze uniek te maken", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <!--
    Unieke ID's binnen componenten
  -->
   <sch:pattern id="sch_tekst_012">
      <sch:title>Identificatie - eId, wId binnen een AKN-component</sch:title>
      <sch:rule context="tekst:*[@componentnaam]">
         <sch:let name="component" value="@componentnaam"/>
         <sch:let name="index">
            <xsl:for-each select="//tekst:*[@eId][ancestor::tekst:*[@componentnaam][1][@componentnaam = $component]][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijderContainer'])]">
               <xsl:sort select="@eId"/>
               <e>
                  <xsl:value-of select="@eId"/>
               </e>
            </xsl:for-each>
            <xsl:for-each select="//tekst:*[@eId][ancestor::tekst:*[@componentnaam][1][@componentnaam = $component]][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijderContainer'])]">
               <xsl:sort select="@wId"/>
               <w>
                  <xsl:value-of select="@wId"/>
               </w>
            </xsl:for-each>
         </sch:let>
         <sch:let name="eId-fout">
            <xsl:for-each select="$index/e[preceding-sibling::e = .]">
               <xsl:value-of select="."/>
               <xsl:if test="not(position() = last())">
                  <xsl:text>; </xsl:text>
               </xsl:if>
            </xsl:for-each>
         </sch:let>
         <sch:let name="wId-fout">
            <xsl:for-each select="$index/w[preceding-sibling::w = .]">
               <xsl:value-of select="self::w/."/>
               <xsl:if test="not(position() = last())">
                  <xsl:text>; </xsl:text>
               </xsl:if>
            </xsl:for-each>
         </sch:let>
         <sch:assert id="STOP0027" test="$eId-fout = ''" role="fout"> {"code": "STOP0027", "eId": "<sch:value-of select="$eId-fout"/>", "component": "<sch:value-of select="$component"/>", "melding": "De eId '<sch:value-of select="$eId-fout"/>' binnen component <sch:value-of select="$component"/> moet uniek zijn. Controleer de opbouw van de eId en corrigeer deze", "ernst": "fout"},</sch:assert>
         <sch:assert id="STOP0028" test="$wId-fout = ''" role="fout"> {"code": "STOP0028", "wId": "<sch:value-of select="$wId-fout"/>", "component": "<sch:value-of select="$component"/>", "melding": "De wId '<sch:value-of select="$wId-fout"/>' binnen component <sch:value-of select="$component"/> moet uniek zijn. Controleer de opbouw van de wId en corrigeer deze", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_tekst_018">
      <sch:title>RegelingMutatie - WijzigInstructies in een WijzigArtikel</sch:title>
      <sch:rule context="tekst:WijzigArtikel//tekst:WijzigInstructies">
         <sch:assert id="STOP0039" test="ancestor::tekst:BesluitKlassiek" role="fout"> {"code": "STOP0039", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "melding": "Het element WijzigInstructies binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])"/> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>\" is niet toegestaan. Verwijder de WijzigInstructies, of verplaats deze naar een RegelingMutatie binnen een WijzigBijlage.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_tekst_048">
      <sch:title>RegelingMutatie - OpmerkingVersie in een WijzigArtikel</sch:title>
      <sch:rule context="tekst:WijzigArtikel//tekst:OpmerkingVersie">
         <sch:assert id="STOP0051" test="ancestor::tekst:BesluitKlassiek" role="fout"> {"code": "STOP0051", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "melding": "Het element OpmerkingVersie binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])"/> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>\" is alleen toegestaan in een BesluitCompact. Verwijder de OpmerkingVersie.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_tekst_019">
      <sch:title>RegelingMutatie - in een WijzigArtikel</sch:title>
      <sch:rule context="tekst:WijzigArtikel//tekst:RegelingMutatie">
         <sch:assert id="STOP0040"
                     test="ancestor::tekst:Lichaam/parent::tekst:BesluitKlassiek | ancestor::tekst:Lichaam/parent::tekst:RegelingKlassiek"
                     role="fout"> {"code": "STOP0040", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "melding": "Het element RegelingMutatie binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])"/> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>\" is niet toegestaan. Neem de RegelingMutatie op in een WijzigBijlage.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_tekst_020">
      <sch:title>renvooi in Wat</sch:title>
      <sch:rule context="tekst:Wat">
         <sch:report test="tekst:VerwijderdeTekst | tekst:NieuweTekst" role="fout"> {"code": "STOP0047", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "melding": "Het element Wat van de RegelingMutatie binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])"/> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>\" bevat renvooimarkeringen. Verwijder de element(en) NieuweTekst en VerwijderdeTekst.", "ernst": "fout"},</sch:report>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_tekst_021">
      <sch:title>wijzigactie nieuweContainer verwijderContainer op andere inhouds-element dan
      Groep</sch:title>
      <sch:rule context="tekst:Inhoud//tekst:*[@wijzigactie][local-name() != 'Groep']">
         <sch:report test="(@wijzigactie = 'nieuweContainer' or @wijzigactie = 'verwijderContainer')"
                     role="fout">
        {"code": "STOP0048", "naam": "<sch:value-of select="local-name(.)"/>", "eId": "<sch:value-of select="ancestor-or-self::tekst:*[@eId][1]/@eId"/>", "melding": "Op element <sch:value-of select="local-name(.)"/> met (bovenliggend) eId <sch:value-of select="ancestor-or-self::tekst:*[@eId][1]/@eId"/> is de wijzigactie \"nieuweContainer\" en \"verwijderContainer\" toegepast. Dit kan leiden tot invalide XML of informatieverlies. Verwijder de @wijzigactie.", "ernst": "fout"},</sch:report>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_tekst_0045">
      <sch:title>@Wijzigactie voor Inhoud</sch:title>
      <sch:rule context="tekst:Vervang//tekst:Inhoud[@wijzigactie]">
         <sch:p>tekst:Inhoud mag uitsluitend een @wijzigactie hebben gecombineerd met tekst:Vervallen,
         tekst:Gereserveerd of tekst:Lid</sch:p>
         <sch:assert id="STOP0063"
                     test="parent::tekst:*/tekst:Gereserveerd | parent::tekst:*/tekst:Vervallen  | parent::tekst:*/tekst:Lid"
                     role="fout">{"code": "STOP0063", "naam": "<sch:value-of select="local-name(ancestor::tekst:Vervang[@wat][1])"/>", "wat": "<sch:value-of select="ancestor::tekst:Vervang[@wat][1]/@wat"/>", "melding": "Het element Inhoud van <sch:value-of select="local-name(ancestor::tekst:Vervang[@wat][1])"/> met het attribuut @wat \"<sch:value-of select="ancestor::tekst:Vervang[@wat][1]/@wat"/>\" heeft ten onrechte een attribuut @wijzigactie. Dit is alleen toegestaan indien gecombineerd met een Gereserveerd, Vervallen of Lid. Verwijder het attribuut @wijzigactie.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_tekst_046">
      <sch:title>Een wijzigactie voor Sluiting</sch:title>
      <sch:rule context="tekst:Sluiting[@wijzigactie]">
         <sch:p>Het attribuut @wijzigactie is niet toegestaan buiten een Vervang in een
        BesluitMutatie.</sch:p>
         <sch:assert id="STOP0065"
                     test="ancestor::tekst:Vervang[1]/ancestor::tekst:BesluitMutatie"
                     role="fout">
      {"code": "STOP0065", "naam": "<sch:value-of select="local-name()"/>", "melding": "Het attribuut @wijzigactie is niet toegestaan voor element <sch:value-of select="local-name()"/> buiten een BesluitMutatie/Vervang. Verwijder het attribuut @wijzigactie", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_tekst_066">
      <sch:rule context="*[@wordt][@was]">
         <sch:let name="wasWork" value="substring-before(@was/./string(), '@')"/>
         <sch:let name="wordtWork" value="substring-before(@wordt/./string(), '@')"/>
         <sch:p>@was en @wordt moeten hetzelfde work hebben</sch:p>
         <sch:assert id="STOP0066" test="$wasWork = $wordtWork" role="fout">
      {"code": "STOP0066", "wasID": "<sch:value-of select="$wasWork"/>", "wordtID": "<sch:value-of select="$wordtWork"/>", "melding": "De identificatie van de @was <sch:value-of select="$wasWork"/> en @wordt <sch:value-of select="$wordtWork"/> hebben niet dezelfde work-identificatie. Corrigeer de AKN-expression. identificatie.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern id="sch_tekst_068">
      <sch:title>Noot unieke ids</sch:title>
      <sch:rule context="tekst:*[@componentnaam]">
         <sch:let name="component" value="@componentnaam"/>
         <sch:let name="nootIndex">
            <xsl:for-each select="//tekst:Noot[ancestor::tekst:*[@componentnaam][1][@componentnaam = $component]][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijderContainer'])]">
               <xsl:sort select="@id"/>
               <n>
                  <xsl:value-of select="@id"/>
               </n>
            </xsl:for-each>
         </sch:let>
         <sch:let name="nootId-fout">
            <xsl:for-each select="$nootIndex/n[preceding-sibling::n = .]">
               <xsl:value-of select="self::n/."/>
               <xsl:if test="not(position() = last())">
                  <xsl:text>; </xsl:text>
               </xsl:if>
            </xsl:for-each>
         </sch:let>
         <sch:assert id="STOP0067" test="$nootId-fout = ''" role="fout"> {"code": "STOP0067", "id": "<sch:value-of select="$nootId-fout"/>", "component": "<sch:value-of select="$component"/>", "melding": "De id voor tekst:Noot '<sch:value-of select="$nootId-fout"/>' binnen component '<sch:value-of select="$component"/>' moet uniek zijn. Controleer de id en corrigeer zodat de identificatie uniek is binnen de component.", "ernst": "fout"},</sch:assert>
      </sch:rule>
   </sch:pattern>
</sch:schema>
