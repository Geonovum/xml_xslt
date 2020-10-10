<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <xsl:param name="filelist.ow"/>
  <xsl:param name="filelist.op"/>
  <xsl:param name="filelist.gio"/>
  <xsl:param name="filelist.lvbb"/>
  <xsl:param name="filelist.gml"/>
  <xsl:param name="temp.dir"/>
  <xsl:param name="output.dir"/>

  <xsl:param name="besluit" select="collection(concat($temp.dir,'/op?select=*.xml'))/AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <xsl:param name="ID01" select="string(($besluit//ExpressionIdentificatie/FRBRWork)[2])" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID02" select="string(($besluit//ConsolidatieInformatie//BeoogdeRegeling//doel)[1])" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>

  <xsl:param name="ns.manifest" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow')"/>

  <xsl:template match="/">
    <xsl:call-template name="manifest_op"/>
    <xsl:call-template name="manifest_ow"/>
  </xsl:template>

  <xsl:template name="manifest_op">
    <xsl:result-document href="{concat($output.dir,'/manifest.xml')}" method="xml">
      <xsl:element name="lvbb:manifest">
        <xsl:for-each select="fn:tokenize(fn:string-join(($filelist.lvbb,'manifest.xml',$filelist.op,$filelist.gio),';'),';')">
          <xsl:variable name="naam" select="fn:tokenize(.,'/')[last()]"/>
          <xsl:element name="lvbb:bestand">
            <xsl:element name="lvbb:bestandsnaam">
              <xsl:value-of select="$naam"/>
            </xsl:element>
            <xsl:element name="lvbb:contentType">
              <xsl:value-of select="string('application/xml')"/>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="fn:tokenize($filelist.gml,';')">
          <xsl:variable name="naam" select="fn:tokenize(.,'/')[last()]"/>
          <xsl:element name="lvbb:bestand">
            <xsl:element name="lvbb:bestandsnaam">
              <xsl:value-of select="$naam"/>
            </xsl:element>
            <xsl:element name="lvbb:contentType">
              <xsl:value-of select="string('application/gml+xml')"/>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="fn:tokenize(fn:string-join(('manifest-ow.xml',$filelist.ow),';'),';')">
          <xsl:variable name="naam" select="fn:tokenize(.,'/')[last()]"/>
          <xsl:element name="lvbb:bestand">
            <xsl:element name="lvbb:bestandsnaam">
              <xsl:value-of select="$naam"/>
            </xsl:element>
            <xsl:element name="lvbb:contentType">
              <xsl:value-of select="string('application/xml')"/>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="manifest_ow">
    <xsl:result-document href="{concat($output.dir,'/manifest-ow.xml')}" method="xml">
      <xsl:element name="Aanleveringen" namespace="{$ns.manifest}">
        <xsl:attribute name="xsi:schemaLocation" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow https://register.geostandaarden.nl/xmlschema/tpod/v1.0.2/bestanden-ow/generiek/manifest-ow.xsd')"/>
        <xsl:element name="domein" namespace="{$ns.manifest}">
          <xsl:value-of select="string('omgevingswet')"/>
        </xsl:element>
        <xsl:element name="Aanlevering" namespace="{$ns.manifest}">
          <xsl:element name="WorkIDRegeling" namespace="{$ns.manifest}">
            <xsl:value-of select="$ID01"/>
          </xsl:element>
          <xsl:element name="DoelID" namespace="{$ns.manifest}">
            <xsl:value-of select="$ID02"/>
          </xsl:element>
          <xsl:for-each select="fn:tokenize($filelist.ow,';')">
            <xsl:variable name="bestandsnaam" select="concat('file:/',.)"/>
            <xsl:variable name="naam" select="fn:tokenize(.,'/')[last()]"/>
            <xsl:element name="Bestand" namespace="{$ns.manifest}">
              <xsl:element name="naam" namespace="{$ns.manifest}">
                <xsl:value-of select="$naam"/>
              </xsl:element>
              <xsl:for-each select="document($bestandsnaam)//sl:objectType">
                <xsl:element name="objecttype" namespace="{$ns.manifest}">
                  <xsl:value-of select="."/>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

</xsl:stylesheet>
