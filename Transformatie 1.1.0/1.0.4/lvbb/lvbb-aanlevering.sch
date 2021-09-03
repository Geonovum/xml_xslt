<sch:schema queryBinding="xslt2" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:ns prefix="data" uri="https://standaarden.overheid.nl/stop/imop/data/"/>
  <sch:ns prefix="tekst" uri="https://standaarden.overheid.nl/stop/imop/tekst/"/>
  <sch:ns prefix="lvbba" uri="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <sch:p>Versie 1.0.4</sch:p>
  <sch:p>Schematron voor aanvullende validaties voor lvbba</sch:p>
  <!--  -->
  <sch:pattern id="sch_lvbba_001">
    <sch:title>informatieobjectref ook aanwezig in besluit</sch:title>
    <sch:rule context="lvbba:AanleveringBesluit//data:informatieobjectRef">
      <sch:let name="ref" value="normalize-space(.)"/>
      <sch:p>De inhoud van alle voorkomens van data:informatieobjectRef moeten ook voorkomen als
        inhoud van imop-tekst:ExtIoRef</sch:p>
      <sch:assert id="BHKV1001" role="error"
        test="ancestor::lvbba:AanleveringBesluit//tekst:ExtIoRef[normalize-space(.) = $ref]"> {"code": "BHKV1001", "ref": "<sch:value-of select="$ref"/>", "melding": "De informatieobjectRef <sch:value-of select="$ref"/> komt niet voor in een ExtIoRef van het besluit", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_002">
    <sch:title>ExtIoRef ook aanwezig als informatieobjectRef</sch:title>
    <sch:rule context="lvbba:AanleveringBesluit//data:informatieobjectRef">
      <sch:let name="ref" value="normalize-space(.)"/>
      <sch:p>De inhoud van alle voorkomens van imop-tekst:ExtIoRef moeten ook voorkomen als
        data:informatieobjectRef</sch:p>
      <sch:assert id="BHKV1002" role="error"
        test="ancestor::lvbba:AanleveringBesluit//tekst:ExtIoRef[normalize-space(.) = $ref]">{"code": "BHKV1002", "ref": "<sch:value-of select="$ref"/>", "melding": "De ExtIoRef <sch:value-of select="$ref"/> is niet opgenomen als data:informatieobjectRef. Controleer de verwijzingen op volledigheid.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_003">
    <sch:title>BeoogdInformatieobject in overeenstemming met ExtIoRef/@eId</sch:title>
    <sch:rule
      context="lvbba:AanleveringBesluit[//data:ConsolidatieInformatie]//tekst:Bijlage//tekst:ExtIoRef">
      <sch:let name="component">
        <xsl:choose>
          <xsl:when test="ancestor::tekst:*[@componentnaam]">
            <xsl:value-of
              select="normalize-space(concat('!', ancestor::tekst:*[@componentnaam][1]/@componentnaam, '#'))"
            />
          </xsl:when>
          <xsl:otherwise/>
        </xsl:choose>
      </sch:let>
      <sch:let name="ref" value="concat($component, normalize-space(@eId))"/>
      <sch:p>Inhoud van attribuutwaarde van een ExtIoRef/@eId MOET als eId
        in data:BeoogdInformatieobject voorkomen</sch:p>
      <sch:assert id="BHKV1003" role="error"
        test="ancestor::lvbba:AanleveringBesluit//data:BeoogdInformatieobject/data:eId[normalize-space(.) = $ref]"
        >{"code": "BHKV1003", "ref": "<sch:value-of select="$ref"/>", "melding": "De eId <sch:value-of select="$ref"/> van BeoogdInformatieobject komt niet voor als eId van een ExtIoRef, Controleer de referenties naar de ExtIoRef's /&gt;", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_004">
    <sch:title>Tijdstempels in ontwerpbesluit</sch:title>
    <sch:rule
      context="data:BesluitMetadata/data:soortProcedure[normalize-space(.) = '/join/id/stop/proceduretype_ontwerp']">
      <sch:p>Voor een ontwerpbesluit MAG GEEN tijdstempel worden meegeleverd</sch:p>
      <sch:report id="BHKV1004" role="error"
        test="ancestor::lvbba:AanleveringBesluit//data:ConsolidatieInformatie/data:Tijdstempels"> {"code": "BHKV1004", "melding": "Het ontwerpbesluit heeft tijdstempels, dit is niet toegestaan. Verwijder de tijdstempels.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_005">
    <sch:title>Besluit met soort werk '/join/id/stop/work_003'</sch:title>
    <sch:rule context="lvbba:AanleveringBesluit/lvbba:BesluitVersie">
      <sch:let name="soortWork" value="normalize-space(data:ExpressionIdentificatie/data:soortWork)"/>
      <sch:p>De identificatie van het besluit moet als soort werk '/join/id/stop/work_003'
        hebben</sch:p>
      <sch:assert id="BHKV1005" test="$soortWork = '/join/id/stop/work_003'">{"code": "BHKV1005", "id": "<sch:value-of select="$soortWork"/>", "melding": "Het geleverde besluit heeft als soortWork '<sch:value-of select="$soortWork"/>' , Dit moet zijn: '/join/id/stop/work_003'.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_006">
    <sch:title>Regeling met soort werk '/join/id/stop/work_019</sch:title>
    <sch:rule context="tekst:RegelingCompact | tekst:RegelingKlassiek | tekst:RegelingVrijetekst">
      <sch:let name="soortWork"
        value="normalize-space(ancestor::lvbba:AanleveringBesluit/lvbba:RegelingVersieInformatie/data:ExpressionIdentificatie/data:soortWork)" />
      <sch:p>De identificatie van een RegelingCompact, RegelingKlassiek of RegelingVrijetekst moet
        als soortWork '/join/id/stop/work_019' hebben</sch:p>
      <sch:assert id="BHKV1006" role="error" test="$soortWork = '/join/id/stop/work_019'">{"code": "BHKV1006", "id": "<sch:value-of select="$soortWork" />", "melding": "Het geleverde regelingversie heeft als soortWork '<sch:value-of select="$soortWork" />'. Dit moet voor een RegelingCompact, RegelingKlassiek of RegelingVrijetekst zijn '/join/id/stop/work_019'", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_021">
    <sch:title>Regeling met soort werk '/join/id/stop/work_021</sch:title>
    <sch:rule context="tekst:RegelingTijdelijkdeel">
      <sch:let name="soortWork"
        value="normalize-space(ancestor::lvbba:AanleveringBesluit/lvbba:RegelingVersieInformatie/data:ExpressionIdentificatie/data:soortWork)" />
      <sch:p>De identificatie van een RegelingTijdelijkdeel moet als soortWork
        '/join/id/stop/work_021' hebben</sch:p>
      <sch:assert id="BHKV1027" role="error" test="$soortWork = '/join/id/stop/work_021'">{"code": "BHKV1027", "id": "<sch:value-of select="$soortWork" />", "melding": "Het geleverde regelingversie heeft als soortWork '<sch:value-of select="$soortWork" />'. Dit moet voor een tijdelijk regelingdeel zijn '/join/id/stop/work_021'.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_022">
    <sch:title>RegelingTijdelijkdeel moet isTijdelijkDeelVan hebben</sch:title>
    <sch:rule context="data:ExpressionIdentificatie[./data:soortWork = '/join/id/stop/work_021']">
      <sch:let name="eId" value="./data:FRBRExpression/string()" />
      <sch:p>Een RegelingTijdelijkdeel MOET een isTijdelijkDeelVan hebben</sch:p>
      <sch:assert id="BHKV1028" role="error" test="./data:isTijdelijkDeelVan">{"code": "BHKV1028", "eId": "<sch:value-of select="$eId" />", "melding": "De RegelingTijdelijkdeel met expressionID '<sch:value-of select="$eId" />' heeft geen isTijdelijkDeelVan. Pas dit aan.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_007">
    <sch:title>officieleTitel van Besluit</sch:title>
    <sch:rule
      context="lvbba:AanleveringBesluit//tekst:BesluitKlassiek | lvbba:AanleveringBesluit//tekst:BesluitCompact">
      <sch:let name="titelPulicatie">
        <xsl:choose>
          <xsl:when test="child::tekst:RegelingOpschrift">
            <xsl:value-of select="normalize-space(child::tekst:RegelingOpschrift)"/>
          </xsl:when>
          <xsl:when test="//tekst:RegelingOpschrift">
            <xsl:value-of select="normalize-space(//tekst:RegelingOpschrift)"/>
          </xsl:when>
          <xsl:otherwise>XX</xsl:otherwise>
        </xsl:choose>
      </sch:let>
      <sch:p>data:officieleTitel moet gelijk zijn aan de Regelingopschrift van het besluit</sch:p>
      <sch:assert id="BHKV1007" role="error"
        test="normalize-space(ancestor::lvbba:AanleveringBesluit//data:BesluitMetadata/data:officieleTitel) = $titelPulicatie"
        >{"code": "BHKV1007", "melding": "De officiële titel wijkt af van de titel van het besluit. Deze moeten gelijkluidend zijn.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_008">
    <sch:title>officieleTitel van Regeling</sch:title>
    <sch:rule
      context="tekst:RegelingKlassiek | tekst:RegelingCompact | tekst:RegelingVrijetekst | tekst:RegelingTijdelijkdeel">
      <sch:let name="titelPulicatie">
        <xsl:choose>
          <xsl:when test="child::tekst:RegelingOpschrift">
            <xsl:value-of select="normalize-space(child::tekst:RegelingOpschrift/.)"/>
          </xsl:when>
          <xsl:when test="ancestor::tekst:BesluitKlassiek/tekst:RegelingOpschrift">
            <xsl:value-of
              select="normalize-space(ancestor::tekst:BesluitKlassiek/tekst:RegelingOpschrift/.)"/>
          </xsl:when>
          <xsl:when test="ancestor::tekst:BesluitCompact/tekst:RegelingOpschrift">
            <xsl:value-of
              select="normalize-space(ancestor::tekst:BesluitCompact/tekst:RegelingOpschrift/.)"/>
          </xsl:when>
          <xsl:otherwise>XX</xsl:otherwise>
        </xsl:choose>
      </sch:let>
      <sch:p>data:officieleTitel moet gelijk zijn aan de Regelingopschrift van het besluit</sch:p>
      <sch:assert id="BHKV1008" role="error"
        test="normalize-space(ancestor::lvbba:AanleveringBesluit//data:RegelingMetadata/data:officieleTitel) = $titelPulicatie"
        >{"code": "BHKV1008", "melding": "De officiële titel wijkt af van de titel van de regeling. Deze moeten gelijkluidend zijn.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_009">
    <sch:title>eId van BeoogdeRgeling in Besluit</sch:title>
    <sch:rule context="data:BeoogdeRegeling[data:eId]">
      <sch:let name="eId" value="normalize-space(data:eId)"/>
      <sch:p>In BeoogdeRegeling moet de daarin genoemde eId voorkomen in het Besluit</sch:p>
      <sch:assert id="BHKV1009" role="error"
        test="ancestor::lvbba:AanleveringBesluit//tekst:*[@eId = $eId]">{"code": "BHKV1009", "eId": "<sch:value-of select="$eId"/>", "melding": "In het besluit is de eId <sch:value-of select="$eId"/> voor de BeoogdeRegeling niet te vinden. Controleer de referentie naar het besluit.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_010">
    <sch:title>eId van Tijdstempel in Besluit</sch:title>
    <sch:rule context="data:ConsolidatieInformatie/data:Tijdstempels/data:Tijdstempel[data:eId]">
      <sch:let name="eId" value="normalize-space(data:eId)"/>
      <sch:p>In een Tijdstempel moet de daarin genoemde eId voorkomen in het Besluit</sch:p>
      <sch:assert id="BHKV1010" role="error"
        test="ancestor::lvbba:AanleveringBesluit//tekst:*[@eId = $eId]">{"code": "BHKV1010", "eId": "<sch:value-of select="$eId"/>", "melding": "In het besluit is de eId <sch:value-of select="$eId"/> voor de tijdstempel niet te vinden. Controleer de referentie naar het besluit.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_011">
    <sch:title>eId van data:Intrekking in Besluit</sch:title>
    <sch:rule context="data:ConsolidatieInformatie/data:Intrekkingen/data:Intrekking[data:eId]">
      <sch:let name="eId" value="normalize-space(data:eId)"/>
      <sch:p>In een Tijdstempel moet de daarin genoemde eId voorkomen in het Besluit</sch:p>
      <sch:assert id="BHKV1011" role="error"
        test="ancestor::lvbba:AanleveringBesluit//tekst:*[@eId = $eId]">{"code": "BHKV1011", "eId": "<sch:value-of select="$eId"/>", "melding": "In het besluit is de eId <sch:value-of select="$eId"/> voor de data:Intrekking niet te vinden. Controleer de referentie naar het besluit.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_lvbba_012">
    <sch:title>wordt versie begint met workIdentificatie</sch:title>
    <sch:rule
      context="tekst:RegelingMutatie[@wordt] | tekst:RegelingCompact | tekst:RegelingVrijetekst | tekst:RegelingTijdelijkdeel | tekst:RegelingKlassiek">
      <sch:let name="work"
        value="ancestor::lvbba:AanleveringBesluit/lvbba:RegelingVersieInformatie/data:ExpressionIdentificatie/data:FRBRWork"/>
      <sch:p>De wordt-versie voor een regeling of mutatie heeft betrekking op de juiste
        regeling</sch:p>
      <sch:assert id="BHKV1012" role="error" test="starts-with(@wordt, $work)">{"code": "BHKV1012", "id": "<sch:value-of select="$work"/>", "melding": "De versie aanduiding voor de wordt-versie komt niet overeen met de work-identificatie <sch:value-of select="$work"/>.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <!--  -->
  <sch:pattern id="sch_lvbba_013">
    <sch:title>was versie begint met workIdentificatie</sch:title>
    <sch:rule context="tekst:RegelingMutatie[@was]">
      <sch:let name="work"
        value="ancestor::lvbba:AanleveringBesluit/lvbba:RegelingVersieInformatie/data:ExpressionIdentificatie/data:FRBRWork"/>
      <sch:p>De wordt-versie voor een regeling of mutatie heeft betrekking op de juiste
        regeling</sch:p>
      <sch:assert id="BHKV1013" role="error" test="starts-with(@was, $work)">{"code": "BHKV1013", "id": "<sch:value-of select="$work"/>", "component": "<sch:value-of select="@componentnaam"
        />", "melding": "De versie aanduiding voor de was-versie in RegelingMutatie <sch:value-of select="@componentnaam"
        /> komt niet overeen met de work-identificatie <sch:value-of select="$work"/>.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
