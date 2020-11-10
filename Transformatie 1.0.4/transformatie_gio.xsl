<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- Pad naar het setje bestanden van de opdracht -->
  <xsl:param name="input.dir"/>
  <xsl:param name="output.dir"/>
  <xsl:param name="temp.dir"/>

  <xsl:param name="GIO_bestanden" select="collection(concat($input.dir, '?select=*.xml'))/root()[AanleveringInformatieObject]" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <xsl:param name="RegelingVersieInformatie" select="document(concat($temp.dir,'/besluit.xml'))/AanleveringBesluit/RegelingVersieInformatie" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <xsl:param name="hash" select="collection(concat($temp.dir,'/checksum','?select=*.xml'))"/>

  <!-- match op alle xml bestanden waarvan het root element een 'AanleveringInformatieObject' is -->

  <xsl:template match="hash" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="GML" select="string(parent::Bestand/bestandsnaam)"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:value-of select="$hash/file[name=$GML]/checksum" xpath-default-namespace=""/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="/" mode="GIO">
    <xsl:variable name="GIO" select="tokenize(document-uri(),'/')[last()]"/>
    <xsl:result-document href="{concat($output.dir,'/',$GIO)}" method="xml" indent='yes'>
      <xsl:apply-templates select="node()"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates select="$GIO_bestanden" mode="GIO"/>
  </xsl:template>

  <xsl:template match="AanleveringInformatieObject" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
    <xsl:comment>Voor validatie is het noodzakelijk om ook de catalogi van de gepubliceerde versie 1.0.4 te laden.</xsl:comment>
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
      <xsl:namespace name="geo" select="string('https://standaarden.overheid.nl/stop/imop/geo/')"/>
      <xsl:attribute name="schemaversie" select="string('1.0.4')"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering https://standaarden.overheid.nl/lvbb/1.0.4/lvbb-stop-aanlevering.xsd')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- extra check op officieleTitel -->

  <xsl:template match="officieleTitel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:value-of select="(root()//FRBRWork[1],.)[1]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
    </xsl:element>
  </xsl:template>

  <!-- FeatureTypeStyle -->

  <xsl:template match="FeatureTypeStyle" xpath-default-namespace="http://www.opengis.net/se">
    <xsl:element name="FeatureTypeStyle" namespace="http://www.opengis.net/se">
      <xsl:attribute name="version" select="string('1.1.0')"></xsl:attribute>
      <xsl:element name="FeatureTypeName" namespace="http://www.opengis.net/se">
        <xsl:value-of select="string('geo:Locatie')"/>
      </xsl:element>
      <xsl:apply-templates select="element()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Rule" xpath-default-namespace="http://www.opengis.net/se">
    <xsl:element name="Rule" namespace="http://www.opengis.net/se">
      <xsl:apply-templates select="(Name,PolygonSymbolizer/Description)" xpath-default-namespace="http://www.opengis.net/se"/>
      <xsl:apply-templates select="Filter" xpath-default-namespace="http://www.opengis.net/ogc"/>
      <xsl:apply-templates select="PolygonSymbolizer" xpath-default-namespace="http://www.opengis.net/se"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="PolygonSymbolizer" xpath-default-namespace="http://www.opengis.net/se">
    <xsl:element name="PolygonSymbolizer" namespace="http://www.opengis.net/se">
      <xsl:apply-templates select="element() except Description" xpath-default-namespace="http://www.opengis.net/se"/>
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