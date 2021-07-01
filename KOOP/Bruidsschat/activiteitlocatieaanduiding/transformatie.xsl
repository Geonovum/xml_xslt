<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:xlink="http://www.w3.org/1999/xlink">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="base.dir" select="string('file:/C:/Werkbestanden/Geonovum/activiteitlocatieaanduiding')"/>
  <xsl:param name="input.dir" select="fn:string-join(($base.dir,'input'),'/')"/>
  <xsl:param name="output.dir" select="fn:string-join(($base.dir,'output'),'/')"/>

  <xsl:param name="owRegeltekst" select="collection(concat($input.dir,'?select=*.xml'))/ow-dc:owBestand[descendant::sl:objectType='Regeltekst']"/>
  <xsl:param name="owRegeltekst.filename" select="fn:tokenize(fn:base-uri($owRegeltekst),'/')[last()]"/>

  <xsl:param name="owLocatie" select="collection(concat($input.dir,'?select=*.xml'))/ow-dc:owBestand[descendant::sl:objectType='Ambtsgebied']"/>
  <xsl:param name="owLocatie.filename" select="fn:tokenize(fn:base-uri($owLocatie),'/')[last()]"/>

  <xsl:param name="owActiviteit" select="collection(concat($input.dir,'?select=*.xml'))/ow-dc:owBestand[descendant::sl:objectType='Activiteit']"/>
  <xsl:param name="owActiviteit.filename" select="fn:tokenize(fn:base-uri($owActiviteit),'/')[last()]"/>

  <xsl:param name="owRegelingsgebied" select="collection(concat($input.dir,'?select=*.xml'))/ow-dc:owBestand[descendant::sl:objectType='Regelingsgebied']"/>
  <xsl:param name="owRegelingsgebied.filename" select="fn:tokenize(fn:base-uri($owRegelingsgebied),'/')[last()]"/>

  <xsl:param name="owManifest" select="collection(concat($input.dir,'?select=*.xml'))/Aanleveringen" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow"/>
  <xsl:param name="owManifest.filename" select="fn:tokenize(fn:base-uri($owManifest),'/')[last()]"/>

  <xsl:param name="unique_ala" as="xs:anyAtomicType*">
    <xsl:for-each-group select="$owRegeltekst//r:activiteitaanduiding" group-by="rol:ActiviteitRef/@xlink:href">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="r:ActiviteitLocatieaanduiding/r:activiteitregelkwalificatie">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:for-each-group select="current-group()" group-by="r:ActiviteitLocatieaanduiding/r:locatieaanduiding/fn:string-join(descendant::element()/@xlink:href,'|')">
          <xsl:variable name="index_3" select="current-grouping-key()"/>
          <xsl:sequence select="fn:string-join(($index_1,$index_2,$index_3),'|')"/>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </xsl:param>

  <xsl:template match="/">
    <xsl:call-template name="owRegeltekst"/>
    <xsl:call-template name="owLocatie"/>
    <xsl:call-template name="owActiviteit"/>
    <xsl:call-template name="owRegelingsgebied"/>
    <xsl:call-template name="owManifest"/>
  </xsl:template>

  <xsl:template name="owRegeltekst">
    <xsl:result-document href="{fn:string-join(($output.dir,$owRegeltekst.filename),'/')}" method="xml">
      <xsl:apply-templates select="$owRegeltekst"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="owLocatie">
    <xsl:result-document href="{fn:string-join(($output.dir,$owLocatie.filename),'/')}" method="xml">
      <xsl:apply-templates select="$owLocatie"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="owActiviteit">
    <xsl:result-document href="{fn:string-join(($output.dir,$owActiviteit.filename),'/')}" method="xml">
      <xsl:apply-templates select="$owActiviteit"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="owRegelingsgebied">
    <xsl:result-document href="{fn:string-join(($output.dir,$owRegelingsgebied.filename),'/')}" method="xml">
      <xsl:apply-templates select="$owRegelingsgebied"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="owManifest">
    <xsl:result-document href="{fn:string-join(($output.dir,$owManifest.filename),'/')}" method="xml">
      <xsl:apply-templates select="$owManifest"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="r:ActiviteitLocatieaanduiding/r:identificatie">
    <xsl:param name="dataset"/>
    <xsl:variable name="ala" select="ancestor::r:activiteitaanduiding"/>
    <xsl:variable name="id" select="fn:string-join(($ala/rol:ActiviteitRef/@xlink:href,$ala/r:ActiviteitLocatieaanduiding/r:activiteitregelkwalificatie,$ala/r:ActiviteitLocatieaanduiding/r:locatieaanduiding/descendant::element()/@xlink:href),'|')"/>
    <xsl:variable name="index" select="fn:index-of($unique_ala,$id)"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:copy-of select="@*|namespace::*"/>
      <xsl:value-of select="concat('nl.imow-',$dataset,'.activiteitlocatieaanduiding.2020',fn:format-number($index,'000000'))"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="l:Ambtsgebied">
    <xsl:param name="dataset"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:element name="l:identificatie" namespace="{namespace-uri()}">
        <xsl:value-of select="concat('nl.imow-',$dataset,'.ambtsgebied.2020000001')"/>
      </xsl:element>
      <xsl:copy-of select="l:noemer"/>
      <xsl:element name="l:bestuurlijkeGrenzenVerwijzing" namespace="{namespace-uri()}">
        <xsl:element name="l:BestuurlijkeGrenzenVerwijzing" namespace="{namespace-uri()}">
          <xsl:element name="l:bestuurlijkeGrenzenID" namespace="{namespace-uri()}">
            <xsl:value-of select="l:identificatie"/>
          </xsl:element>
          <xsl:copy-of select="(l:domein,l:geldigOp)"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="l:AmbtsgebiedRef">
    <xsl:param name="dataset"/>
    <xsl:element name="l:LocatieRef" namespace="{namespace-uri()}">
      <xsl:attribute name="xlink:href" select="concat('nl.imow-',$dataset,'.ambtsgebied.2020000001')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ow-dc:owBestand">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:copy-of select="@*|namespace::*"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
      <xsl:apply-templates select="node()">
        <xsl:with-param name="dataset" select="descendant::sl:dataset"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Aanleveringen" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
    <xsl:element name="Aanleveringen" namespace="{namespace-uri()}">
      <xsl:copy-of select="@*|namespace::*"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/generiek/manifest-ow.xsd')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- algemeen -->

  <xsl:template match="element()">
    <xsl:param name="dataset"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()">
        <xsl:with-param name="dataset" select="$dataset"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="comment()">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>