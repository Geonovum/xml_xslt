<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <!-- file.list bevat alle te verwerken bestanden -->

  <xsl:param name="file.list"/>
  <xsl:param name="base.dir"/>

  <!-- waardelijsten -->

  <xsl:param name="waardelijsten" select="document(concat($base.dir,'/waardelijsten OP 1.3.0.xml'))//Waardelijst"/>

  <!-- lijst om te bepalen in welke context elementen zitten -->
  <xsl:param name="regeling.list" select="('RegelingCompact','RegelingKlassiek','RegelingMutatie','RegelingTijdelijkdeel','RegelingVrijetekst')"/>
  <xsl:param name="context.list" select="('BesluitCompact','BesluitKlassiek','RegelingCompact','RegelingKlassiek','RegelingMutatie','RegelingTijdelijkdeel','RegelingVrijetekst')"/>

  <!-- stel manifest-bestand samen -->

  <xsl:param name="manifest">
    <xsl:for-each select="fn:tokenize($file.list,';')">
      <xsl:variable name="fullname" select="."/>
      <xsl:choose>
        <xsl:when test="document($fullname)/AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('besluit.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="fn:tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)/lvbb:publicatieOpdracht">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('opdracht.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="fn:tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:param>

  <!-- transformeer OP-bestanden -->

  <xsl:param name="besluit" select="document($manifest/file[@name='besluit.xml']/fullname)"/>
  <xsl:param name="ID01" select="fn:tokenize(($besluit//RegelingMetadata/(eindverantwoordelijke,maker))[1],'/')[5]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID02" select="string(($besluit//RegelingVersieMetadata/versienummer)[1])" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>

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
    <xsl:result-document href="stap_1.xml" method="xml">
      <xsl:apply-templates select="$besluit/node()"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
      <xsl:attribute name="schemaversie" select="string('1.2.0')"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering https://standaarden.overheid.nl/lvbb/1.2.0/lvbb-stop-aanlevering.xsd')"/>
      <!-- geef informatie door aan AKN.xsl -->
      <xsl:processing-instruction name="akn">
        <xsl:value-of select="fn:string-join(($ID01,$ID02),'_')"/>
      </xsl:processing-instruction>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- loop Divisie[Divisietekst[not(Kop)]][count(Divisie|Divisietekst) eq 1] na -->

  <xsl:template match="Divisie[Divisietekst[not(Kop)]][count(Divisie|Divisietekst) eq 1]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/" priority="1">
    <xsl:element name="Divisietekst" namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
      <xsl:copy-of select="@*"/>
      <xsl:processing-instruction name="akn" select="@eId"/>
      <xsl:processing-instruction name="akn" select="Divisietekst/@eId" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
      <xsl:apply-templates select="Kop" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
      <xsl:apply-templates select="Divisietekst/node()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="element()[(@eId,@wId)]">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*"/>
      <xsl:processing-instruction name="akn" select="@eId"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- enkele controles die nu in de validatie zijn opgenomen -->

  <!-- controle of BeoogdeRegeling/eId en BeoogdInformatieobject/eId correct zijn opgebouwd -->

  <xsl:template match="BeoogdeRegeling/eId" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="eId" select="root()//(WijzigArtikel,BesluitKlassiek)[1]/@eId" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    <xsl:element name="eId" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:value-of select="($eId,.)[1]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BeoogdInformatieobject/eId" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="join" select="string(ancestor::BeoogdInformatieobject/instrumentVersie)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
    <xsl:variable name="eId" select="(root()//element()[fn:index-of($regeling.list,name()) gt 0])[1]//ExtIoRef[@ref=$join]/@eId" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    <xsl:variable name="component" select="(root()//element()[fn:index-of($regeling.list,name()) gt 0])[1]/@componentnaam" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    <xsl:element name="eId" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:choose>
        <xsl:when test="count($eId) gt 1">
          <xsl:comment><xsl:text>Er zijn meer elementen ExtIoRef met dezelfde join.</xsl:text></xsl:comment>
          <xsl:value-of select="."/>
        </xsl:when>
        <xsl:when test="not($eId)">
          <xsl:comment><xsl:text>Er is geen element ExtIoRef met dezelfde join.</xsl:text></xsl:comment>
          <!-- hier controle op regelingsgebied -->
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

  <!-- controle of officieleTitel overeenkomt met RegelingOpschrift -->

  <xsl:template match="RegelingMetadata/officieleTitel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="titel" select="root()//element()[fn:index-of($regeling.list,name()) gt 0][1]/RegelingOpschrift" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:value-of select="normalize-space(($titel,.)[1])"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BesluitMetadata/officieleTitel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="titel" select="root()//(BesluitCompact,BesluitKlassiek)[1]/RegelingOpschrift" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:value-of select="normalize-space(($titel,.)[1])"/>
    </xsl:element>
  </xsl:template>

  <!-- controle of alternatieveTitel gelijk is aan officieleTitel -->

  <xsl:template match="alternatieveTitels" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="officieleTitel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
      <xsl:apply-templates select="(ancestor::BesluitMetadata,ancestor::RegelingMetadata)[1]/officieleTitel"/>
    </xsl:variable>
    <xsl:variable name="alternatieveTitels" select="alternatieveTitel[normalize-space(.) ne normalize-space($officieleTitel)]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
    <xsl:if test="$alternatieveTitels">
      <xsl:element name="{name()}" namespace="https://standaarden.overheid.nl/stop/imop/data/">
        <xsl:apply-templates select="$alternatieveTitels"/>
      </xsl:element>
    </xsl:if>
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
    <xsl:choose>
      <xsl:when test="(normalize-space(.)='') and contains(.,'&#10;')">
        <!-- lege tekst met een zachte return is indentation -->
        <xsl:value-of select="fn:tokenize(.,'&#10;')[1]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>