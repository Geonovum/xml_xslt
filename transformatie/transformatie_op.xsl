<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="file.config" select="replace(document-uri(),'template','config')"/>

  <!-- file.list bevat alle te verwerken bestanden -->

  <xsl:param name="file.list"/>

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
      </xsl:choose>
    </xsl:for-each>
  </xsl:param>

  <!-- transformeer OP-bestanden -->

  <xsl:param name="root" select="document(concat('file:/',$manifest/file[@name='besluit.xml']/fullname))"/>
  <xsl:param name="ID01" select="tokenize(($root//(eindverantwoordelijke,maker))[1],'/')[last()]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID02" select="($root//versienummer)[1]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>

  <xsl:template match="/">
    <xsl:call-template name="manifest"/>
    <xsl:call-template name="besluit"/>
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
      <xsl:apply-templates select="$root/node()"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('https://standaarden.overheid.nl/lvbb/stop/ ../lvbb/lvbb-stop-aanlevering.xsd')"/>
      <xsl:attribute name="schemaversie" select="string('1.0')"/>
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
      <xsl:for-each select="(eindverantwoordelijke,maker,officieleTitel,alternatieveTitels,heeftCiteertitelInformatie,afkortingen,grondslagen,onderwerpen,rechtsgebieden,$root//soortProcedure,informatieobjectRefs)">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
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

  <xsl:template match="doel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="doelen" namespace="{namespace-uri()}">
      <xsl:element name="{name()}" namespace="{namespace-uri()}">
        <xsl:variable name="ID02" select="tokenize(parent::BeoogdeRegeling/instrumentVersie,'/')[6]"/>
        <xsl:variable name="ID03" select="tokenize(.,'/')[last()]"/>
        <xsl:value-of select="fn:string-join(('','join','id','proces',$ID01,$ID02,$ID03),'/')"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Besluit" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:choose>
      <xsl:when test="Regeling">
        <xsl:element name="BesluitCompact" namespace="{namespace-uri()}">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="NieuweRegeling">
        <xsl:element name="BesluitKlassiek" namespace="{namespace-uri()}">
          <xsl:apply-templates select="@*|node()"/>
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

  <xsl:template match="(IntIoRef|ExtIoRef|IntRef)/@doel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
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

  <xsl:template match="overheidsdomein" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="overheidsdomeinen" namespace="{namespace-uri()}">
      <xsl:element name="{name()}" namespace="{namespace-uri()}">
        <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
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