<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/" xmlns:gml="http://www.opengis.net/gml/3.2" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- Pad naar het setje bestanden van de opdracht -->
  <xsl:param name="input.dir" select="string('C:\Users\g.wolbers\Desktop\transformatie\0.98.3-kern\opdracht')"/>
  <xsl:param name="output.dir" select="string('C:\Users\g.wolbers\Desktop\transformatie\1.0\opdracht')"/>
  <xsl:param name="temp.dir" select="string('C:\Users\g.wolbers\Desktop\transformatie\temp')"/>

  <xsl:param name="input" select="fn:string-join(('file:',tokenize($input.dir,'\\')),'/')"/>
  <xsl:param name="output" select="fn:string-join(('file:',tokenize($output.dir,'\\')),'/')"/>
  <xsl:param name="temp" select="fn:string-join(('file:',tokenize($temp.dir,'\\')),'/')"/>

  <xsl:param name="GIO_bestanden" select="collection(concat($input, '?select=*.xml'))/root()[AanleveringGIO]" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/"/>
  <xsl:param name="RegelingVersieInformatie" select="document(fn:string-join(($temp,'besluit.xml'),'/'))/AanleveringBesluit/RegelingVersieInformatie" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <xsl:param name="hash" select="collection(concat($temp,'/checksum','?select=*.xml'))"/>

  <xsl:template match="AanleveringGIO" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/">
    <xsl:element name="AanleveringInformatieObject" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('https://standaarden.overheid.nl/lvbb/stop/ ../lvbb/lvbb-stop-aanlevering.xsd')"/>
      <xsl:attribute name="schemaversie" select="string('1.0')"/>
      <xsl:apply-templates select="/AanleveringGIO/InformatieObjectVersie[1]" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="InformatieObjectVersie" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
      <xsl:apply-templates select="(ExpressionIdentificatie,InformatieObjectMetadata)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ExpressionIdentificatie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="InformatieObjectMetadata" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:apply-templates select="(eindverantwoordelijke,maker)"/>
      <xsl:element name="alternatieveTitels" namespace="{namespace-uri()}">
        <xsl:element name="alternatieveTitel" namespace="{namespace-uri()}">
          <xsl:value-of select="officieleTitel"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates select="(officieleTitel,publicatieinstructie)"/>
      <xsl:element name="formaatInformatieobject" namespace="{namespace-uri()}">
        <xsl:value-of select="string('/join/id/stop/informatieobject/gio_002')"/>
      </xsl:element>
      <xsl:element name="soortenInformatieobject" namespace="{namespace-uri()}">
        <xsl:apply-templates select="soortInformatieobject"/>
      </xsl:element>
      <xsl:element name="heeftGeboorteregeling" namespace="{namespace-uri()}">
        <xsl:value-of select="$RegelingVersieInformatie/ExpressionIdentificatie/FRBRWork/text()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
      </xsl:element>
      <xsl:apply-templates select="heeftBestanden"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="hash" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="GML" select="string(parent::Bestand/bestandsnaam)"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:value-of select="$hash/file[name=$GML]/checksum" xpath-default-namespace=""/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/" mode="GIO">
    <xsl:variable name="GIO" select="tokenize(document-uri(),'/')[last()]"/>
    <xsl:result-document href="{concat($output,'/',$GIO)}" method="xml" indent='yes'>
      <xsl:apply-templates select="node()"/>
    </xsl:result-document>
  </xsl:template>

  <!-- match op alle xml bestanden waarvan het root element een 'AanleveringGIO' is -->
  <xsl:template match="/">
    <xsl:apply-templates select="$GIO_bestanden" mode="GIO"/>
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
