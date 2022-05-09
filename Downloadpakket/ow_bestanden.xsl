<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:digest="java:org.apache.commons.codec.digest.DigestUtils" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <!-- de transformatie zet een downloadpakketje om naar publicatie van een initieel besluit -->

  <xsl:param name="base.dir" select="fn:tokenize(fn:base-uri(.),'temp/ow')[1]"/>
  <xsl:param name="input.dir" select="concat($base.dir,'input/')"/>
  <xsl:param name="temp.dir" select="concat($base.dir,'temp/')"/>
  <xsl:param name="output.dir" select="concat($base.dir,'output/')"/>

  <!-- namespaces LVBB -->
  <xsl:param name="lvbb" select="string('http://www.overheid.nl/2017/lvbb')"/>
  <!-- namespaces OP -->
  <xsl:param name="data" select="string('https://standaarden.overheid.nl/stop/imop/data/')"/>
  <xsl:param name="tekst" select="string('https://standaarden.overheid.nl/stop/imop/tekst/')"/>
  <xsl:param name="dso" select="string('https://www.dso.nl/')"/>
  <xsl:param name="basisgeo" select="string('http://www.geostandaarden.nl/basisgeometrie/1.0')"/>
  <xsl:param name="geo" select="string('https://standaarden.overheid.nl/stop/imop/geo/')"/>
  <xsl:param name="gio" select="string('https://standaarden.overheid.nl/stop/imop/gio/')"/>
  <xsl:param name="gml" select="string('http://www.opengis.net/gml/3.2')"/>
  <xsl:param name="aan" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering/')"/>
  <xsl:param name="uit" select="string('https://standaarden.overheid.nl/stop/imop/uitwisseling/')"/>
  <!-- namespaces OW -->
  <xsl:param name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
  <xsl:param name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
  <xsl:param name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
  <xsl:param name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
  <xsl:param name="manifest" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow')"/>
  <xsl:param name="ow" select="string('http://www.geostandaarden.nl/imow/owobject')"/>
  <xsl:param name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
  <xsl:param name="p" select="string('http://www.geostandaarden.nl/imow/pons')"/>
  <xsl:param name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
  <xsl:param name="rg" select="string('http://www.geostandaarden.nl/imow/regelingsgebied')"/>
  <xsl:param name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
  <xsl:param name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
  <xsl:param name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
  <!-- algemeen -->
  <xsl:param name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
  <xsl:param name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>

  <!-- bestanden -->
  <xsl:param name="regeling_identificatie" select="document(concat($input.dir,'Regeling/Regeling-Identificatie.xml'))/element()"/>
  <xsl:param name="regeling_metadata" select="document(concat($input.dir,'Regeling/Regeling-Metadata.xml'))/element()"/>
  <xsl:param name="regeling_tekst" select="document(concat($input.dir,'Regeling/Regeling-Tekst.xml'))/element()"/>
  <xsl:param name="regeling_versieMetadata" select="document(concat($input.dir,'Regeling/Regeling-VersieMetadata.xml'))/element()"/>
  <xsl:param name="regeling_ow" select="document(concat($input.dir,'OW-bestanden/manifest-ow.xml'))/element()"/>

  <!-- parameters -->
  <xsl:param name="id_bg_code" select="fn:tokenize($regeling_metadata/data:eindverantwoordelijke,'/')[last()]"/>
  <xsl:param name="id_levering" select="digest:md5Hex(fn:string-join($regeling_tekst//text()))"/>
  <xsl:param name="id_bill_work" select="fn:string-join(('','akn','nl','bill',$id_bg_code,fn:format-date(current-date(),'[Y0001]'),$id_levering),'/')"/>
  <xsl:param name="id_bill_expression" select="fn:string-join(($id_bill_work,concat('nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'),';1')),'/')"/>
  <xsl:param name="id_doel" select="$regeling_ow//(DoelID)[1]" as="xs:string" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow"/>

  <!-- oin -->
  <xsl:param name="oin" select="document('OIN.xml')/lijst"/>
  <xsl:param name="oin_code" select="$oin/item[fn:ends-with(BG,$id_bg_code)]/OIN"/>
  <xsl:param name="oin_naam" select="$oin/item[fn:ends-with(BG,$id_bg_code)]/naam"/>

  <!-- bouw de ow-bestanden op -->

  <xsl:template match="ow-dc:owBestand">
    <xsl:element name="ow-dc:owBestand" namespace="{$ow-dc}">
      <xsl:namespace name="da" select="$da"/>
      <xsl:namespace name="ga" select="$ga"/>
      <xsl:namespace name="k" select="$k"/>
      <xsl:namespace name="l" select="$l"/>
      <xsl:namespace name="ow" select="$ow"/>
      <xsl:namespace name="ow-dc" select="$ow-dc"/>
      <xsl:namespace name="p" select="$p"/>
      <xsl:namespace name="r" select="$r"/>
      <xsl:namespace name="rg" select="$rg"/>
      <xsl:namespace name="rol" select="$rol"/>
      <xsl:namespace name="sl" select="$sl"/>
      <xsl:namespace name="vt" select="$vt"/>
      <xsl:namespace name="xlink" select="$xlink"/>
      <xsl:namespace name="xsi" select="$xsi"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sl:dataset[text()=('Onbekend')]">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:value-of select="$oin_code"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sl:gebied[text()=('Onbekend')]">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:value-of select="$oin_naam"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sl:leveringsId[text()=('Onbekend')]">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:value-of select="$id_levering"/>
    </xsl:element>
  </xsl:template>

  <!-- algemeen -->

  <xsl:template match="element()">
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

  <xsl:template match="comment()">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>