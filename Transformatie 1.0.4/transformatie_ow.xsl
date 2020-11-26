<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject" xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- doorgegeven parameters -->

  <xsl:param name="file.list"/>

  <!-- stel manifest-bestand samen -->

  <xsl:param name="manifest">
    <xsl:for-each select="tokenize($file.list,';')">
      <xsl:variable name="fullname" select="."/>
      <xsl:choose>
        <xsl:when test="document($fullname)//r:Regeltekst" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('regeltekst.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//vt:Divisie" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('vrijetekst.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//rol:Activiteit" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('activiteit.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//ga:Gebiedsaanwijzing" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('gebiedsaanwijzing.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//rol:Normwaarde" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('normwaarde.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//l:Gebied" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('locatie.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//p:Pons" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('pons.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//k:Kaart" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('kaart.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//rg:Regelingsgebied" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('regelingsgebied.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//vt:Hoofdlijn" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('hoofdlijn.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//Aanleveringen" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('manifest_ow.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:param>

  <xsl:template match="/">
    <xsl:element name="manifest">
      <xsl:for-each select="$manifest/file">
        <xsl:copy-of select="."/>
        <xsl:call-template name="bestand">
          <xsl:with-param name="name" select="./@name"/>
          <xsl:with-param name="fullname" select="./fullname"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- transformeer generieke zaken -->

  <xsl:template name="bestand">
    <xsl:param name="name"/>
    <xsl:param name="fullname"/>
    <xsl:variable name="document" select="document($fullname)"/>
    <xsl:result-document href="{$name}" method="xml">
      <xsl:apply-templates select="$document/node()"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="owBestand" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
    <xsl:element name="ow-dc:owBestand" namespace="{namespace-uri()}">
      <xsl:copy-of select="@*|namespace::*"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Aanleveringen" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
    <xsl:element name="Aanleveringen" namespace="{namespace-uri()}">
      <xsl:copy-of select="@*|namespace::*"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3/bestanden-ow/generiek/manifest-ow.xsd')"/>
      <xsl:apply-templates select="node()"/>
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