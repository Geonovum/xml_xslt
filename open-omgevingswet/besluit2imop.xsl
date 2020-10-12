<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <xsl:param name="temp.dir" select="string('file:/C:/Werkbestanden/Geonovum/open-omgevingswet/temp')"/>
  <xsl:param name="file.name" select="document-uri()"/>

  <xsl:param name="ns.aanlevering" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering/')"/>
  <xsl:param name="ns.data" select="string('https://standaarden.overheid.nl/stop/imop/data/')"/>
  <xsl:param name="ns.tekst" select="string('https://standaarden.overheid.nl/stop/imop/tekst/')"/>

  <xsl:param name="besluit" select="root()/AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <xsl:param name="filelist" select="collection(concat($temp.dir,'/checksum?select=*.xml'))/file[type='gml']"/>
  <xsl:param name="locaties" select="document(concat($temp.dir,'/locaties.xml'))//locatie"/>
  <xsl:param name="OIN" select="document('OIN.xml')//item"/>

  <xsl:param name="ID01" select="string($besluit//RegelingMetadata/eindverantwoordelijke)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID02" select="string(($besluit//ExpressionIdentificatie/FRBRWork)[2])" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID03" select="string(($besluit//ExpressionIdentificatie/FRBRExpression)[2])" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID04" select="fn:tokenize($ID01,'/')[last()]"/>
  <xsl:param name="ID05" select="string($besluit//RegelingVersieMetadata/versienummer)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID06" select="($OIN[fn:ends-with(BG,$ID04)]/OIN,'onbekend')[1]"/>
  <xsl:param name="ID07" select="string($besluit//Procedureverloop//Procedurestap[soortStap='/join/id/stop/procedure/stap_004']/voltooidOp)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>

  <xsl:template match="/">
    <xsl:call-template name="gio"/>
    <xsl:call-template name="besluit"/>
    <xsl:call-template name="opdracht"/>
  </xsl:template>

  <xsl:template name="gio">
    <xsl:for-each select="$locaties">
      <xsl:variable name="bestandsnaam" select="./bestandsnaam"/>
      <xsl:variable name="naam" select="fn:tokenize($bestandsnaam,'\.')[1]"/>
      <xsl:variable name="noemer" select="./noemer"/>
      <xsl:variable name="hash" select="$filelist/self::file[name=$bestandsnaam]/checksum"/>
      <xsl:variable name="index" select="position()"/>
      <xsl:result-document href="{concat('../gio/gio_',fn:format-number($index,'000'),'.xml')}" method="xml">
        <xsl:element name="AanleveringInformatieObject" namespace="{$ns.aanlevering}">
          <xsl:attribute name="schemaversie" select="string('1.0.3')"/>
          <xsl:element name="InformatieObjectVersie" namespace="{$ns.aanlevering}">
            <xsl:element name="ExpressionIdentificatie" namespace="{$ns.data}">
              <xsl:element name="FRBRWork" namespace="{$ns.data}">
                <xsl:value-of select="fn:string-join(('','join','id','regdata',$ID04,fn:format-date(current-date(),'[Y0000]'),$naam),'/')"/>
              </xsl:element>
              <xsl:element name="FRBRExpression" namespace="{$ns.data}">
                <xsl:value-of select="fn:string-join(('','join','id','regdata',$ID04,fn:format-date(current-date(),'[Y0000]'),$naam,concat('nld@',format-date(current-date(),'[Y0000]-[M00]-[D00]'))),'/')"/>
              </xsl:element>
              <xsl:element name="soortWork" namespace="{$ns.data}">
                <xsl:value-of select="string('/join/id/stop/work_010')"/>
              </xsl:element>
            </xsl:element>
            <xsl:element name="InformatieObjectVersieMetadata" namespace="{$ns.data}">
              <xsl:element name="heeftGeboorteregeling" namespace="{$ns.data}">
                <xsl:value-of select="$ID03"/>
              </xsl:element>
              <xsl:element name="heeftBestanden" namespace="{$ns.data}">
                <xsl:element name="heeftBestand" namespace="{$ns.data}">
                  <xsl:element name="Bestand" namespace="{$ns.data}">
                    <xsl:element name="bestandsnaam" namespace="{$ns.data}">
                      <xsl:value-of select="$bestandsnaam"/>
                    </xsl:element>
                    <xsl:element name="hash" namespace="{$ns.data}">
                      <xsl:value-of select="$hash"/>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:element name="InformatieObjectMetadata" namespace="{$ns.data}">
              <xsl:element name="eindverantwoordelijke" namespace="{$ns.data}">
                <xsl:value-of select="$ID01"/>
              </xsl:element>
              <xsl:element name="maker" namespace="{$ns.data}">
                <xsl:value-of select="$ID01"/>
              </xsl:element>
              <xsl:element name="alternatieveTitels" namespace="{$ns.data}">
                <xsl:element name="alternatieveTitel" namespace="{$ns.data}">
                  <xsl:value-of select="$noemer"/>
                </xsl:element>
              </xsl:element>
              <xsl:element name="officieleTitel" namespace="{$ns.data}">
                <xsl:value-of select="fn:string-join(('','join','id','regdata',$ID04,fn:format-date(current-date(),'[Y0000]'),$naam,concat('nld@',format-date(current-date(),'[Y0000]-[M00]-[D00]'))),'/')"/>
              </xsl:element>
              <xsl:element name="publicatieinstructie" namespace="{$ns.data}">
                <xsl:value-of select="string('TeConsolideren')"/>
              </xsl:element>
              <xsl:element name="naamInformatieObject" namespace="{$ns.data}">
                <xsl:value-of select="$noemer"/>
              </xsl:element>
              <xsl:element name="formaatInformatieobject" namespace="{$ns.data}">
                <xsl:value-of select="string('/join/id/stop/informatieobject/gio_002')"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="besluit">
    <!-- pas besluit aan -->
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:attribute name="schemaversie" select="string('1.0.3')"/>
      <!-- geef informatie door aan AKN.xsl -->
      <xsl:processing-instruction name="akn">
        <xsl:value-of select="fn:string-join(($ID04,$ID05),'_')"/>
      </xsl:processing-instruction>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BesluitMetadata" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="{name()}" namespace="{$ns.data}">
      <xsl:copy-of select="element()"/>
      <xsl:element name="informatieobjectRefs" namespace="{$ns.data}">
        <xsl:for-each select="$locaties">
          <xsl:variable name="FRBRExpression" select="./FRBRExpression" xpath-default-namespace=""/>
          <xsl:element name="informatieobjectRef" namespace="{$ns.data}">
            <xsl:value-of select="$FRBRExpression"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BeoogdeRegelgeving" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:element name="{name()}" namespace="{$ns.data}">
      <xsl:copy-of select="element()"/>
      <xsl:for-each select="$locaties">
        <xsl:variable name="noemer" select="./noemer" xpath-default-namespace=""/>
        <xsl:variable name="FRBRExpression" select="./FRBRExpression" xpath-default-namespace=""/>
        <xsl:variable name="index" select="position()"/>
        <xsl:element name="BeoogdInformatieobject" namespace="{$ns.data}">
          <xsl:element name="doelen" namespace="{$ns.data}">
            <xsl:element name="doel" namespace="{$ns.data}">
              <xsl:value-of select="fn:string-join(('','join','id','proces',$ID04,fn:format-date(current-date(),'[Y0000]'),'Instelling'),'/')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element name="instrumentVersie" namespace="{$ns.data}">
            <xsl:value-of select="$FRBRExpression"/>
          </xsl:element>
          <xsl:element name="eId" namespace="{$ns.data}">
            <xsl:if test="not($noemer='ambtsgebied')">
              <xsl:value-of select="fn:string-join(('!initieel_reg#cmp_o_1','content_o_1','list_o_1',fn:format-number(($index - 1),'item_o_0')),'__')"/>
            </xsl:if>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="RegelingCompact" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="{name()}" namespace="{$ns.tekst}">
      <xsl:copy-of select="@*"/>
      <xsl:copy-of select="element()"/>
      <xsl:element name="Bijlage" namespace="{$ns.tekst}">
        <xsl:element name="Kop" namespace="{$ns.tekst}">
          <xsl:element name="Opschrift" namespace="{$ns.tekst}">
            <xsl:value-of select="string('Overzicht van informatieobjecten')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="Divisietekst" namespace="{$ns.tekst}">
          <xsl:element name="Inhoud" namespace="{$ns.tekst}">
            <xsl:element name="Begrippenlijst" namespace="{$ns.tekst}">
              <xsl:for-each select="$locaties[not(./noemer='ambtsgebied')]" xpath-default-namespace="">
                <xsl:variable name="bestandsnaam" select="./bestandsnaam" xpath-default-namespace=""/>
                <xsl:variable name="FRBRExpression" select="./FRBRExpression" xpath-default-namespace=""/>
                <xsl:variable name="noemer" select="./noemer" xpath-default-namespace=""/>
                <xsl:variable name="hash" select="$filelist/self::file[name=$bestandsnaam]/checksum" xpath-default-namespace=""/>
                <xsl:variable name="index" select="position()"/>
                <xsl:element name="Begrip" namespace="{$ns.tekst}">
                  <xsl:comment>
                    <xsl:value-of select="$bestandsnaam"/>
                  </xsl:comment>
                  <xsl:element name="Term" namespace="{$ns.tekst}">
                    <xsl:value-of select="$noemer"/>
                  </xsl:element>
                  <xsl:element name="Definitie" namespace="{$ns.tekst}">
                    <xsl:element name="Al" namespace="{$ns.tekst}">
                      <xsl:element name="ExtIoRef" namespace="{$ns.tekst}">
                        <xsl:attribute name="ref" select="$FRBRExpression"/>
                        <xsl:value-of select="$FRBRExpression"/>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="opdracht">
    <xsl:result-document href="../lvbb/opdracht.xml" method="xml">
      <xsl:element name="lvbb:publicatieOpdracht">
        <xsl:element name="lvbb:idLevering">
          <xsl:value-of select="fn:tokenize($ID02,'/')[last()]"/>
        </xsl:element>
        <xsl:element name="lvbb:idBevoegdGezag">
          <xsl:value-of select="$ID06"/>
        </xsl:element>
        <xsl:element name="lvbb:idAanleveraar">
          <xsl:value-of select="$ID06"/>
        </xsl:element>
        <xsl:element name="lvbb:publicatie">
          <xsl:value-of select="fn:tokenize($file.name,'/')[last()]"/>
        </xsl:element>
        <xsl:element name="lvbb:datumBekendmaking">
          <xsl:value-of select="$ID07"/>
        </xsl:element>
      </xsl:element>
    </xsl:result-document>
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
