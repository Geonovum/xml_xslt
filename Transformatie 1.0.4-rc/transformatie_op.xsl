<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <!-- file.list bevat alle te verwerken bestanden -->

  <xsl:param name="file.list"/>

  <!-- waardelijsten -->

  <xsl:param name="waardelijsten" select="document('waardelijsten OP 1.0.4.xml')//Waardelijst"/>

  <!-- lijst om te bepalen in welke context een IntRef zit -->

  <xsl:param name="context.list" select="('BesluitCompact','BesluitKlassiek','RegelingCompact','RegelingKlassiek','RegelingTijdelijkdeel','RegelingVrijetekst')"></xsl:param>

  <!-- stel manifest-bestand samen -->

  <xsl:param name="manifest">
    <xsl:for-each select="tokenize($file.list,';')">
      <xsl:choose>
        <xsl:when test="document(concat('file:/',.))/AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
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
  <xsl:param name="ID01" select="$besluit//RegelingMetadata/soortRegeling" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID02" select="tokenize($besluit//RegelingMetadata/(eindverantwoordelijke,maker)[1],'/')[4]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID03" select="$waardelijsten[WaardelijstInfo/id='/join/id/stop/soortregeling']/Waarde[id=$ID01]/label" xpath-default-namespace=""/>

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
      <xsl:apply-templates select="$besluit/node()"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
    <xsl:comment>Voor validatie is het noodzakelijk om ook de catalogi van de gepubliceerde versie 1.0.4-rc te laden.</xsl:comment>
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
      <xsl:attribute name="schemaversie" select="string('1.0.4-rc')"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering https://standaarden.overheid.nl/lvbb/1.0.4-rc/lvbb-stop-aanlevering.xsd')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="maker" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:apply-templates select="node()"/>
    </xsl:element>
    <xsl:if test="not(ancestor::BesluitMetadata/soortBestuursorgaan)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:variable name="soortBestuursorgaan">
        <xsl:choose>
          <xsl:when test="$ID03='AMvB'">
            <xsl:value-of select="string('/tooi/def/thes/kern/c_91fb5e42')"/><!-- regering -->
          </xsl:when>
          <xsl:when test="$ID03='Ministeriële Regeling'">
            <xsl:value-of select="string('/tooi/def/thes/kern/c_bcfb7b4e')"/><!-- minister -->
          </xsl:when>
          <xsl:when test="$ID03='Omgevingsplan'">
            <xsl:value-of select="string('/tooi/def/thes/kern/c_2a7d8663')"/><!-- gemeenteraad -->
          </xsl:when>
          <xsl:when test="$ID03='Omgevingsverordening'">
            <xsl:value-of select="string('/tooi/def/thes/kern/c_411b4e4a')"/><!-- provinciale staten -->
          </xsl:when>
          <xsl:when test="$ID03='Waterschapsverordening'">
            <xsl:value-of select="string('/tooi/def/thes/kern/c_70c87e3d')"/><!-- algemeen bestuur waterschap -->
          </xsl:when>
          <xsl:when test="$ID03='Omgevingsvisie'">
            <xsl:choose>
              <xsl:when test="$ID02='ministerie'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_bcfb7b4e')"/><!-- minister -->
              </xsl:when>
              <xsl:when test="$ID02='provincie'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_61676cbc')"/><!-- gedeputeerde staten -->
              </xsl:when>
              <xsl:when test="$ID02='waterschap'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_5cc92c89')"/><!-- dagelijks bestuur waterschap -->
              </xsl:when>
              <xsl:when test="$ID02='gemeente'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_2a7d8663')"/><!-- gemeenteraad -->
              </xsl:when>
              <xsl:otherwise>
                <xsl:comment><xsl:value-of select="concat('soortBestuursorgaan is onbekend. Waarde soortRegeling is ''',$ID03,''', soort bestuursorgaan is ''',$ID02,'''.')"/></xsl:comment>
                <xsl:value-of select="string('onbekend')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$ID03='Projectbesluit'">
            <xsl:choose>
              <xsl:when test="$ID02='ministerie'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_bcfb7b4e')"/><!-- minister -->
              </xsl:when>
              <xsl:when test="$ID02='provincie'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_61676cbc')"/><!-- gedeputeerde staten -->
              </xsl:when>
              <xsl:when test="$ID02='waterschap'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_5cc92c89')"/><!-- dagelijks bestuur waterschap -->
              </xsl:when>
              <xsl:otherwise>
                <xsl:comment><xsl:value-of select="concat('soortBestuursorgaan is onbekend. Waarde soortRegeling is ''',$ID03,''', soort bestuursorgaan is ''',$ID02,'''.')"/></xsl:comment>
                <xsl:value-of select="string('onbekend')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$ID03='Instructie'">
            <xsl:choose>
              <xsl:when test="$ID02='ministerie'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_bcfb7b4e')"/><!-- minister -->
              </xsl:when>
              <xsl:when test="$ID02='provincie'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_61676cbc')"/><!-- gedeputeerde staten -->
              </xsl:when>
              <xsl:otherwise>
                <xsl:comment><xsl:value-of select="concat('soortBestuursorgaan is onbekend. Waarde soortRegeling is ''',$ID03,''', soort bestuursorgaan is ''',$ID02,'''.')"/></xsl:comment>
                <xsl:value-of select="string('onbekend')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$ID03='Reactieve interventie'">
            <xsl:value-of select="string('/tooi/def/thes/kern/c_61676cbc')"/><!-- gedeputeerde staten -->
          </xsl:when>
          <xsl:when test="$ID03='Voorbeschermingsregels'">
            <xsl:choose>
              <xsl:when test="$ID02='ministerie'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_bcfb7b4e')"/><!-- minister -->
              </xsl:when>
              <xsl:when test="$ID02='provincie'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_61676cbc')"/><!-- gedeputeerde staten -->
              </xsl:when>
              <xsl:when test="$ID02='gemeente'">
                <xsl:value-of select="string('/tooi/def/thes/kern/c_2a7d8663')"/><!-- gemeenteraad -->
              </xsl:when>
              <xsl:otherwise>
                <xsl:comment><xsl:value-of select="concat('soortBestuursorgaan is onbekend. Waarde soortRegeling is ''',$ID03,''', soort bestuursorgaan is ''',$ID02,'''.')"/></xsl:comment>
                <xsl:value-of select="string('onbekend')"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="string('onbekend')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$soortBestuursorgaan='onbekend'">
          <xsl:comment><xsl:value-of select="concat('soortBestuursorgaan is onbekend. Waarde soortRegeling is ''',$ID03,''', soort bestuursorgaan is ''',$ID02,'''.')"/></xsl:comment>
        </xsl:when>
        <xsl:otherwise>
          <xsl:comment><xsl:value-of select="concat('soortBestuursorgaan is ''',$waardelijsten[WaardelijstInfo/id='/tooi/def/class/Bestuursorgaan']/Waarde[id=$soortBestuursorgaan]/label,'''.')" xpath-default-namespace=""/></xsl:comment>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:element name="soortBestuursorgaan" namespace="https://standaarden.overheid.nl/stop/imop/data/">
        <xsl:value-of select="$soortBestuursorgaan"/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="IntRef" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="id" select="@ref"/>
    <xsl:variable name="context" select="./ancestor::element()[fn:index-of($context.list,name()) gt 0][1]"/>
    <xsl:variable name="node" select="($context//element()[@eId=$id][1],'geen')[1]"/>
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="scope" select="local-name($node)"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- enkele controles die nu in de validatie zijn opgenomen -->

  <xsl:template match="BeoogdeRegeling/eId" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="eId" select="root()//(WijzigArtikel,BesluitKlassiek)[1]/@eId" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    <xsl:element name="eId" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:value-of select="($eId,.)[1]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BeoogdInformatieobject/eId" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="join" select="ancestor::BeoogdInformatieobject/instrumentVersie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
    <xsl:variable name="eId" select="root()//ExtIoRef[@ref=$join]/@eId" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    <xsl:variable name="component" select="root()//(RegelingCompact,RegelingKlassiek,RegelingTijdelijkdeel,RegelingVrijetekst)[1]/@componentnaam" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    <xsl:element name="eId" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:choose>
        <xsl:when test="count($eId) gt 1">
          <xsl:comment><xsl:text>Er zijn meer elementen ExtIoRef met dezelfde join.</xsl:text></xsl:comment>
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="$component and $eId">
          <xsl:value-of select="concat('!',$component,'#',$eId)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="RegelingMetadata/officieleTitel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="titel" select="root()//(RegelingCompact,RegelingKlassiek,RegelingTijdelijkdeel,RegelingVrijetekst)[1]/RegelingOpschrift" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:value-of select="($titel,.)[1]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BesluitMetadata/officieleTitel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="titel" select="root()//(BesluitCompact,BesluitKlassiek)[1]/RegelingOpschrift" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:value-of select="($titel,.)[1]"/>
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