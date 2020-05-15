<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:geo="http://www.geostandaarden.nl/basisgeometrie/v20190901" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- Pad naar het setje bestanden van de opdracht -->
  <xsl:param name="input.file" select="tokenize(document-uri(),'/')[last()]"/>
  <xsl:param name="input.dir" select="replace(document-uri(),$input.file,'')"/>
  <xsl:param name="GIO_bestanden" select="collection(concat($input.dir, '?select=*.xml;recurse=yes'))/AanleveringGIO/InformatieObjectVersie" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/"/>

  <!-- namespaces -->
  <xsl:param name="ns_geo" select="string('https://standaarden.overheid.nl/stop/imop/geo/')"/>
  <xsl:param name="ns_gio" select="string('https://standaarden.overheid.nl/stop/imop/gio/')"/>
  <xsl:param name="ns_basisgeo" select="string('http://www.geostandaarden.nl/basisgeometrie/1.0')"/>

  <xsl:template match="geo:FeatureCollectionGeometrie">
    <xsl:element name="geo:GeoInformatieObjectVaststelling" namespace="{$ns_geo}">
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('https://standaarden.overheid.nl/stop/imop/geo/ ../stop/imop-geo.xsd')"/>
      <xsl:namespace name="basisgeo" select="string('http://www.geostandaarden.nl/basisgeometrie/1.0')"/>
      <xsl:namespace name="gio" select="string('https://standaarden.overheid.nl/stop/imop/gio/')"/>
      <xsl:namespace name="gml" select="string('http://www.opengis.net/gml/3.2')"/>
      <xsl:attribute name="schemaversie">1.0</xsl:attribute>
      <xsl:variable name="GIO" select="$GIO_bestanden[contains(descendant::bestandsnaam,$input.file)][1]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
      <xsl:element name="geo:context" namespace="{$ns_geo}">
        <xsl:element name="gio:GeografischeContext" namespace="{$ns_gio}">
          <xsl:element name="gio:achtergrondVerwijzing" namespace="{$ns_gio}">
            <xsl:value-of select="$GIO/Achtergrond[1]/bronbeschrijving[1]/text()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
          </xsl:element>
          <xsl:element name="gio:achtergrondActualiteit" namespace="{$ns_gio}">
            <xsl:value-of select="$GIO/Achtergrond[1]/bronactualiteit[1]/text()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="geo:vastgesteldeVersie" namespace="{$ns_geo}">
        <xsl:element name="geo:GeoInformatieObjectVersie" namespace="{$ns_geo}">
          <xsl:element name="geo:FRBRWork" namespace="{$ns_geo}">
            <xsl:value-of select="$GIO/ExpressionIdentificatie[1]/FRBRWork[1]/text()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
          </xsl:element>
          <xsl:element name="geo:FRBRExpression" namespace="{$ns_geo}">
            <xsl:value-of select="$GIO/ExpressionIdentificatie[1]/FRBRExpression[1]/text()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
          </xsl:element>
          <xsl:element name="geo:locaties" namespace="{$ns_geo}">
            <xsl:apply-templates select="geo:featureMember"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="geo:featureMember">
    <xsl:element name="geo:Locatie" namespace="{$ns_geo}">
      <xsl:element name="geo:geometrie" namespace="{$ns_geo}">
        <xsl:element name="basisgeo:Geometrie" namespace="{$ns_basisgeo}">
          <xsl:variable name="gml_id" select="geo:Geometrie[1]/geo:id[1]/text()"/>
          <xsl:attribute name="gml:id" select="concat('id-', $gml_id, '-xx')"/>
          <xsl:element name="basisgeo:id" namespace="{$ns_basisgeo}">
            <xsl:value-of select="$gml_id"/>
          </xsl:element>
          <xsl:element name="basisgeo:geometrie" namespace="{$ns_basisgeo}">
            <xsl:apply-templates select="geo:Geometrie[1]/geo:geometrie/node()"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- Algemene templates -->

  <xsl:template match="element()">
    <xsl:variable name="test" select="."/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:choose>
      <xsl:when test="(normalize-space(.)='') and contains(.,'&#10;')">
        <!-- lege tekst met een zachte return is indentation -->
        <xsl:value-of select="fn:tokenize(.,'&#10;')[1]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="myArray">
          <xsl:value-of select="fn:tokenize(.,'\s+')"/>
        </xsl:variable>
        <xsl:value-of select="fn:concat($myArray,'')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>
