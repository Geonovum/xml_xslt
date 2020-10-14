<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- Pad naar het setje bestanden van de opdracht -->
  <xsl:param name="input.dir"/>
  <xsl:param name="output.dir"/>
  <xsl:param name="temp.dir"/>

  <xsl:param name="input" select="fn:string-join(('file:',tokenize($input.dir,'\\')),'/')"/>
  <xsl:param name="output" select="fn:string-join(('file:',tokenize($output.dir,'\\')),'/')"/>
  <xsl:param name="temp" select="fn:string-join(('file:',tokenize($temp.dir,'\\')),'/')"/>

  <xsl:param name="GIO_bestanden" select="collection(concat($input, '?select=*.xml'))/root()[AanleveringInformatieObject]" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <xsl:param name="RegelingVersieInformatie" select="document(fn:string-join(($temp,'besluit.xml'),'/'))/AanleveringBesluit/RegelingVersieInformatie" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>

  <!-- match op alle xml bestanden waarvan het root element een 'AanleveringInformatieObject' is -->

  <xsl:template match="/" mode="GIO">
    <xsl:variable name="GIO" select="tokenize(document-uri(),'/')[last()]"/>
    <xsl:result-document href="{concat($output,'/',$GIO)}" method="xml" indent='yes'>
      <xsl:apply-templates select="node()"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="/">
    <xsl:apply-templates select="$GIO_bestanden" mode="GIO"/>
  </xsl:template>

  <xsl:template match="AanleveringInformatieObject" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
      <xsl:attribute name="schemaversie" select="string('1.0.4-rc')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- extra check op officieleTitel -->

  <xsl:template match="officieleTitel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:value-of select="(root()//FRBRWork[1],.)[1]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
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