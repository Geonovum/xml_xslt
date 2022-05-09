<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:digest="java:org.apache.commons.codec.digest.DigestUtils" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <!-- de transformatie zet een downloadpakketje om naar publicatie van een initieel besluit -->

  <xsl:param name="base.dir" select="fn:tokenize(fn:base-uri(.),'input')[1]"/>
  <xsl:param name="input.dir" select="concat($base.dir,'input/')"/>
  <xsl:param name="temp.dir" select="concat($base.dir,'temp')"/>
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

  <!-- filelist -->

  <xsl:param name="filelist">
    <xsl:analyze-string select="unparsed-text(concat($temp.dir,'/log_filelist.txt'))" regex="nl(.*) moved to (.*)">
      <xsl:matching-substring>
        <xsl:element name="informatieobject">
          <xsl:element name="join">
            <xsl:value-of select="regex-group(1)"/>
          </xsl:element>
          <xsl:element name="bg-code">
            <xsl:value-of select="fn:tokenize(regex-group(1),'/')[5]"/>
          </xsl:element>
          <xsl:element name="dc-jaar">
            <xsl:value-of select="fn:tokenize(regex-group(1),'/')[6]"/>
          </xsl:element>
          <xsl:element name="dc-id">
            <xsl:value-of select="fn:tokenize(regex-group(2),'/')[4]"/>
          </xsl:element>
        </xsl:element>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:param>

  <!-- bouw de gio-bestanden op -->

  <xsl:template match="/">
    <xsl:element name="informatieobjectRefs">
      <xsl:for-each select="$filelist/informatieobject">
        <xsl:variable name="informatieobject" select="."/>
        <xsl:variable name="index" select="position()"/>
        <xsl:variable name="naam" select="concat(fn:format-number($index,'0000'),'_',$informatieobject/dc-id)"/>
        <xsl:variable name="hash" select="normalize-space(unparsed-text(concat($temp.dir,'/checksum/',$naam,'.gml.txt')))"/>
        <xsl:variable name="FRBRExpression" select="$informatieobject/join"/>
        <xsl:variable name="FRBRWork" select="fn:tokenize($FRBRExpression,'/nld@')[1]"/>
        <xsl:variable name="ExtIoRef" select="($regeling_tekst//tekst:ExtIoRef[@ref=$FRBRExpression])[1]"/>
        <xsl:variable name="IntIoRef" select="($regeling_tekst//tekst:IntIoRef[@ref=$ExtIoRef/@wId])[1]"/>
        <xsl:variable name="noemer" select="($ExtIoRef/ancestor::tekst:Begrip/tekst:Term,$IntIoRef,'geen')[1]"/>
        <xsl:result-document href="{concat($output.dir,$naam,'.xml')}" method="xml">
          <xsl:element name="AanleveringInformatieObject" namespace="{$aan}">
            <xsl:attribute name="schemaversie" select="string('1.2.0')"/>
            <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering https://standaarden.overheid.nl/lvbb/1.2.0/lvbb-stop-aanlevering.xsd')"/>
            <xsl:element name="InformatieObjectVersie" namespace="{$aan}">
              <xsl:element name="ExpressionIdentificatie" namespace="{$data}">
                <xsl:element name="FRBRWork" namespace="{$data}">
                  <xsl:value-of select="$FRBRWork"/>
                </xsl:element>
                <xsl:element name="FRBRExpression" namespace="{$data}">
                  <xsl:value-of select="$FRBRExpression"/>
                </xsl:element>
                <xsl:element name="soortWork" namespace="{$data}">
                  <xsl:value-of select="string('/join/id/stop/work_010')"/>
                </xsl:element>
              </xsl:element>
              <xsl:element name="InformatieObjectVersieMetadata" namespace="{$data}">
                <xsl:element name="heeftBestanden" namespace="{$data}">
                  <xsl:element name="heeftBestand" namespace="{$data}">
                    <xsl:element name="Bestand" namespace="{$data}">
                      <xsl:element name="bestandsnaam" namespace="{$data}">
                        <xsl:value-of select="concat($naam,'.gml')"/>
                      </xsl:element>
                      <xsl:element name="hash" namespace="{$data}">
                        <xsl:value-of select="$hash"/>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
                <xsl:element name="heeftGeboorteregeling" namespace="{$data}">
                  <xsl:value-of select="$regeling_identificatie/data:FRBRWork"/>
                </xsl:element>
              </xsl:element>
              <xsl:element name="InformatieObjectMetadata" namespace="{$data}">
                <xsl:element name="eindverantwoordelijke" namespace="{$data}">
                  <xsl:value-of select="$regeling_metadata/data:eindverantwoordelijke"/>
                </xsl:element>
                <xsl:element name="maker" namespace="{$data}">
                  <xsl:value-of select="$regeling_metadata/data:maker"/>
                </xsl:element>
                <xsl:element name="alternatieveTitels" namespace="{$data}">
                  <xsl:element name="alternatieveTitel" namespace="{$data}">
                    <xsl:value-of select="$noemer"/>
                  </xsl:element>
                </xsl:element>
                <xsl:element name="officieleTitel" namespace="{$data}">
                  <xsl:value-of select="$FRBRWork"/>
                </xsl:element>
                <xsl:element name="publicatieinstructie" namespace="{$data}">
                  <xsl:value-of select="string('TeConsolideren')"/>
                </xsl:element>
                <xsl:element name="formaatInformatieobject" namespace="{$data}">
                  <xsl:value-of select="string('/join/id/stop/informatieobject/gio_002')"/>
                </xsl:element>
                <xsl:element name="naamInformatieObject" namespace="{$data}">
                  <xsl:value-of select="$noemer"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:result-document>
        <!-- log -->
        <xsl:element name="informatieobject">
          <xsl:apply-templates select="$informatieobject/node()"/>
          <xsl:element name="noemer">
            <xsl:value-of select="$noemer"/>
          </xsl:element>
          <xsl:element name="bestandsnaam">
            <xsl:value-of select="concat($naam,'.gml')"/>
          </xsl:element>
          <xsl:element name="hash">
            <xsl:value-of select="$hash"/>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
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