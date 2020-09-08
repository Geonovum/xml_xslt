<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <xsl:param name="file.config" select="replace(document-uri(),'template','config')"/>

  <!-- file.list bevat alle te verwerken bestanden -->

  <xsl:param name="file.list"/>

  <!-- OIN-lijst -->

  <xsl:param name="OIN" select="document('OIN.xml')//item"/>

  <!-- stel manifest-bestand samen -->

  <xsl:param name="manifest">
    <xsl:for-each select="tokenize($file.list,';')">
      <xsl:choose>
        <xsl:when test="document(concat('file:/',.))/AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('besluit.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document(concat('file:/',.))/lvbb:publicatieOpdracht">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('opdracht.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:param>

  <!-- transformeer OP-bestanden -->

  <xsl:param name="besluit" select="document(concat('file:/',$manifest/file[@name='besluit.xml']/fullname))"/>
  <xsl:param name="opdracht" select="document(concat('file:/',$manifest/file[@name='opdracht.xml']/fullname))"/>
  <xsl:param name="ID01" select="tokenize(($besluit//(eindverantwoordelijke,maker))[1],'/')[last()]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID02" select="($besluit//versienummer)[1]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>

  <xsl:template match="/">
    <xsl:call-template name="manifest"/>
    <xsl:call-template name="besluit"/>
    <xsl:call-template name="opdracht"/>
  </xsl:template>

  <!-- maak manifest-bestand waarin is aangegeven wat de functie van een bestand is -->

  <xsl:template name="manifest">
    <xsl:element name="manifest">
      <xsl:for-each select="$manifest/file">
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- transformeer besluit -->

  <xsl:template name="besluit">
    <xsl:result-document href="besluit.xml" method="xml">
      <xsl:apply-templates select="$besluit/node()"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
      <xsl:attribute name="schemaversie" select="string('1.0.3')"/>
      <!-- geef informatie door aan AKN.xsl -->
      <xsl:processing-instruction name="akn">
        <xsl:value-of select="fn:string-join(($ID01,$ID02),'_')"/>
      </xsl:processing-instruction>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="element()[parent::AanleveringBesluit]" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BesluitMetadata" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select="(eindverantwoordelijke,maker,officieleTitel,alternatieveTitels,heeftCiteertitelInformatie,afkortingen,grondslagen,onderwerpen,rechtsgebieden,$besluit//soortProcedure,informatieobjectRefs)">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Procedure" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:for-each select="(Procedureverloop)">
      <xsl:apply-templates select="."/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="Procedureverloop" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*"/>
      <xsl:for-each select="(bekendOp,ontvangenOp,procedurestappen)">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BesluitDoel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="ConsolidatieInformatie" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BeoogdeRegeling" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:choose>
      <xsl:when test="starts-with(instrumentVersie,'/akn/nl/act/')">
        <xsl:result-document href="{$file.config}" method="xml">
          <xsl:element name="BeoogdeRegeling">
            <xsl:element name="DoelID">
              <xsl:variable name="ID02" select="tokenize(instrumentVersie,'/')[6]"/>
              <xsl:variable name="ID03" select="tokenize(doel,'/')[last()]"/>
              <xsl:value-of select="fn:string-join(('','join','id','proces',$ID01,$ID02,$ID03),'/')"/>
            </xsl:element>
            <xsl:element name="WorkID">
              <xsl:value-of select="tokenize(instrumentVersie,'/nld')[1]"/>
            </xsl:element>
          </xsl:element>
        </xsl:result-document>
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="starts-with(instrumentVersie,'/join/id/regdata/')">
        <xsl:element name="BeoogdInformatieobject" namespace="{namespace-uri()}">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="BeoogdeRegeling/doel|BeoogdInformatieobject/doel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="doelen" namespace="{namespace-uri()}">
      <xsl:element name="{name()}" namespace="{namespace-uri()}">
        <xsl:variable name="ID02" select="tokenize(parent::BeoogdeRegeling/instrumentVersie,'/')[6]"/>
        <xsl:variable name="ID03" select="tokenize(.,'/')[last()]"/>
        <xsl:value-of select="fn:string-join(('','join','id','proces',$ID01,$ID02,$ID03),'/')"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="soortTijdstempel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="ID01" select="fn:index-of(('geldigTot','geldigVanaf','inwerkingtreding'),.)"/>
    <xsl:variable name="ID02" select="('juridischWerkendVanaf','geldigVanaf','juridischWerkendVanaf')[$ID01]"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:value-of select="$ID02"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Besluit" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:choose>
      <xsl:when test="Regeling">
        <!-- regeling met WijzigArtikel en WijzigBijlage -->
        <xsl:element name="BesluitCompact" namespace="{namespace-uri()}">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="NieuweRegeling/Lichaam//Artikel">
        <!-- regeling met artikelstructuur -->
        <xsl:element name="BesluitKlassiek" namespace="{namespace-uri()}">
          <xsl:element name="RegelingKlassiek" namespace="{namespace-uri()}">
            <xsl:attribute name="componentnaam" select="string('initieel_reg')"/>
            <xsl:attribute name="wordt" select="NieuweRegeling/@wordt"/>
            <xsl:apply-templates select="NieuweRegeling/node()"/>
          </xsl:element>
        </xsl:element>
      </xsl:when>
      <xsl:when test="NieuweRegeling/Lichaam/FormeleDivisie">
        <!-- regeling met vrijetekststructuur -->
        <xsl:element name="BesluitCompact" namespace="{namespace-uri()}">
          <xsl:element name="RegelingOpschrift" namespace="{namespace-uri()}">
            <xsl:attribute name="eId" select="string('eId')"/>
            <xsl:attribute name="wId" select="string('wId')"/>
            <xsl:element name="Al" namespace="{namespace-uri()}">
              <xsl:value-of select="string('[regelingopschrift van het besluit]')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element name="Aanhef" namespace="{namespace-uri()}">
            <xsl:attribute name="eId" select="string('eId')"/>
            <xsl:attribute name="wId" select="string('wId')"/>
            <xsl:element name="Al" namespace="{namespace-uri()}">
              <xsl:value-of select="string('[optionele aanhef]')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element name="Lichaam" namespace="{namespace-uri()}">
            <xsl:attribute name="eId" select="string('eId')"/>
            <xsl:attribute name="wId" select="string('wId')"/>
            <xsl:element name="WijzigArtikel" namespace="{namespace-uri()}">
              <xsl:attribute name="eId" select="string('eId')"/>
              <xsl:attribute name="wId" select="string('wId')"/>
              <xsl:element name="Kop" namespace="{namespace-uri()}">
                <xsl:element name="Label" namespace="{namespace-uri()}">
                  <xsl:value-of select="string('Artikel')"/>
                </xsl:element>
                <xsl:element name="Nummer" namespace="{namespace-uri()}">
                  <xsl:value-of select="string('I')"/>
                </xsl:element>
                <xsl:element name="Opschrift" namespace="{namespace-uri()}">
                  <xsl:value-of select="string('[optioneel opschrift]')"/>
                </xsl:element>
              </xsl:element>
              <xsl:element name="Wat" namespace="{namespace-uri()}">
                <xsl:value-of select="string('[omschrijving wat er besloten wordt, met een verwijzing naar de WijzigBijlage]')"/>
              </xsl:element>
            </xsl:element>
            <xsl:element name="Artikel" namespace="{namespace-uri()}">
              <xsl:attribute name="eId" select="string('eId')"/>
              <xsl:attribute name="wId" select="string('wId')"/>
              <xsl:element name="Kop" namespace="{namespace-uri()}">
                <xsl:element name="Label" namespace="{namespace-uri()}">
                  <xsl:value-of select="string('Artikel')"/>
                </xsl:element>
                <xsl:element name="Nummer" namespace="{namespace-uri()}">
                  <xsl:value-of select="string('II')"/>
                </xsl:element>
                <xsl:element name="Opschrift" namespace="{namespace-uri()}">
                  <xsl:value-of select="string('[optioneel opschrift]')"/>
                </xsl:element>
              </xsl:element>
              <xsl:element name="Inhoud" namespace="{namespace-uri()}">
                <xsl:element name="Al" namespace="{namespace-uri()}">
                  <xsl:value-of select="string('[artikel dat de inwerkingtreding vaststelt]')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          <xsl:element name="Sluiting" namespace="{namespace-uri()}">
            <xsl:attribute name="eId" select="string('eId')"/>
            <xsl:attribute name="wId" select="string('wId')"/>
            <xsl:element name="Al" namespace="{namespace-uri()}">
              <xsl:value-of select="string('[sluiting]')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element name="WijzigBijlage" namespace="{namespace-uri()}">
            <xsl:attribute name="eId" select="string('eId')"/>
            <xsl:attribute name="wId" select="string('wId')"/>
            <xsl:element name="Kop" namespace="{namespace-uri()}">
              <xsl:element name="Label" namespace="{namespace-uri()}">
                <xsl:value-of select="string('Bijlage')"/>
              </xsl:element>
              <xsl:element name="Nummer" namespace="{namespace-uri()}">
                <xsl:value-of select="string('I')"/>
              </xsl:element>
              <xsl:element name="Opschrift" namespace="{namespace-uri()}">
                <xsl:value-of select="string('[optioneel opschrift]')"/>
              </xsl:element>
            </xsl:element>
            <xsl:element name="RegelingVrijetekst" namespace="{namespace-uri()}">
              <xsl:attribute name="componentnaam" select="string('initieel_reg')"/>
              <xsl:attribute name="wordt" select="NieuweRegeling/@wordt"/>
              <xsl:apply-templates select="NieuweRegeling/node()"/>
            </xsl:element>
          </xsl:element>
          <xsl:apply-templates select="Nawerk/node()"/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Regeling" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <xsl:template match="MaakInitieleRegeling" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="RegelingCompact" namespace="{namespace-uri()}">
      <xsl:attribute name="componentnaam" select="string('initieel_reg')"/>
      <xsl:attribute name="wordt" select="@wordt"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="(IntIoRef|ExtIoRef|IntRef|ExtRef)/@doel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:attribute name="ref" select="."/>
  </xsl:template>

  <xsl:template match="Bijlage/Inhoud" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="Divisietekst" namespace="{namespace-uri()}">
      <xsl:attribute name="eId" select="string('geen')"/>
      <xsl:attribute name="wId" select="string('geen')"/>
      <xsl:element name="{name()}" namespace="{namespace-uri()}">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="FormeleDivisie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="Divisie" namespace="{namespace-uri()}">
      <xsl:attribute name="eId" select="string('geen')"/>
      <xsl:attribute name="wId" select="string('geen')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="FormeleInhoud|Divisie/Inhoud" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="Divisietekst" namespace="{namespace-uri()}">
      <xsl:attribute name="eId" select="string('geen')"/>
      <xsl:attribute name="wId" select="string('geen')"/>
      <xsl:element name="Inhoud" namespace="{namespace-uri()}">
        <xsl:apply-templates select="node()"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="RegelingMetadata" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="RegelingVersieMetadata" namespace="{namespace-uri()}">
      <xsl:apply-templates select="versienummer"/>
    </xsl:element>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="element() except versienummer"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="redactioneleTitel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="alternatieveTitels" namespace="{namespace-uri()}">
      <xsl:element name="alternatieveTitel" namespace="{namespace-uri()}">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="overheidsdomein" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="overheidsdomeinen" namespace="{namespace-uri()}">
      <xsl:element name="{name()}" namespace="{namespace-uri()}">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- transformeer opdracht -->
  
  <xsl:template name="opdracht">
    <xsl:result-document href="opdracht.xml" method="xml">
      <xsl:apply-templates select="$opdracht/node()"/>
    </xsl:result-document>
  </xsl:template>
  
  <xsl:template match="lvbb:publicatieOpdracht">
    <xsl:variable name="id" select="($OIN[fn:ends-with(BG,$ID01)]/OIN,'onbekend')[1]"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="lvbb:idLevering"/>
      <xsl:element name="lvbb:idBevoegdGezag">
        <xsl:value-of select="$id"/>
      </xsl:element>
      <xsl:element name="lvbb:idAanleveraar">
        <xsl:value-of select="$id"/>
      </xsl:element>
      <xsl:apply-templates select="lvbb:publicatie"/>
      <xsl:apply-templates select="lvbb:datumBekendmaking"/>
    </xsl:element>
  </xsl:template>

  <!-- Algemene templates -->

  <xsl:template match="element()">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>