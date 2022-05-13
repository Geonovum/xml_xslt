<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:digest="java:org.apache.commons.codec.digest.DigestUtils" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/" xmlns:uit="https://standaarden.overheid.nl/stop/imop/uitwisseling/">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <!-- de transformatie zet een downloadpakketje om naar publicatie van een initieel besluit -->

  <xsl:param name="base.dir" select="fn:tokenize(fn:base-uri(.),'input')[1]"/>
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
  <!-- algemeen -->
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

  <!-- informatieobjectrefs -->
  <xsl:param name="informatieobjectRefs" select="$regeling_tekst//tekst:ExtIoRef/@ref" as="xs:token*"/>

  <!-- bouw de op-bestanden op -->

  <xsl:template match="/">
    <xsl:call-template name="opdracht"/>
    <xsl:call-template name="AanleveringBesluit"/>
  </xsl:template>

  <xsl:template name="opdracht">
    <xsl:element name="publicatieOpdracht" namespace="{$lvbb}">
      <xsl:element name="idLevering" namespace="{$lvbb}">
        <xsl:value-of select="$id_levering"/>
      </xsl:element>
      <xsl:element name="idBevoegdGezag" namespace="{$lvbb}">
        <xsl:value-of select="$oin_code"/>
      </xsl:element>
      <xsl:element name="idAanleveraar" namespace="{$lvbb}">
        <xsl:value-of select="$oin_code"/>
      </xsl:element>
      <xsl:element name="publicatie" namespace="{$lvbb}">
        <xsl:value-of select="string('besluit.xml')"/>
      </xsl:element>
      <xsl:element name="datumBekendmaking" namespace="{$lvbb}">
        <xsl:value-of select="fn:format-date(current-date() + xs:dayTimeDuration('P1D'),'[Y0001]-[M01]-[D01]')"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="AanleveringBesluit">
    <xsl:result-document href="{concat($output.dir,'besluit.xml')}" method="xml">
      <xsl:element name="AanleveringBesluit" namespace="{$aan}">
        <xsl:namespace name="dso" select="$dso"/>
        <xsl:attribute name="schemaversie" select="string('1.2.0')"/>
        <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering https://standaarden.overheid.nl/lvbb/1.2.0/lvbb-stop-aanlevering.xsd')"/>
        <xsl:element name="BesluitVersie" namespace="{$aan}">
          <xsl:element name="ExpressionIdentificatie" namespace="{$data}">
            <xsl:element name="FRBRWork" namespace="{$data}">
              <xsl:value-of select="$id_bill_work"/>
            </xsl:element>
            <xsl:element name="FRBRExpression" namespace="{$data}">
              <xsl:value-of select="$id_bill_expression"/>
            </xsl:element>
            <xsl:element name="soortWork" namespace="{$data}">
              <xsl:value-of select="string('/join/id/stop/work_003')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element name="BesluitMetadata" namespace="{$data}">
            <xsl:element name="eindverantwoordelijke" namespace="{$data}">
              <xsl:value-of select="$regeling_metadata/data:eindverantwoordelijke"/>
            </xsl:element>
            <xsl:element name="maker" namespace="{$data}">
              <xsl:value-of select="$regeling_metadata/data:maker"/>
            </xsl:element>
            <xsl:element name="soortBestuursorgaan" namespace="{$data}">
              <xsl:value-of select="$regeling_metadata/data:soortBestuursorgaan"/>
            </xsl:element>
            <xsl:element name="officieleTitel" namespace="{$data}">
              <xsl:value-of select="$regeling_metadata/data:officieleTitel"/>
            </xsl:element>
            <xsl:element name="onderwerpen" namespace="{$data}">
              <xsl:for-each select="$regeling_metadata/data:onderwerpen/data:onderwerp">
                <xsl:element name="onderwerp" namespace="{$data}">
                  <xsl:value-of select="."/>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
            <xsl:element name="rechtsgebieden" namespace="{$data}">
              <xsl:for-each select="$regeling_metadata/data:rechtsgebieden/data:rechtsgebied">
                <xsl:element name="rechtsgebied" namespace="{$data}">
                  <xsl:value-of select="."/>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
            <xsl:element name="soortProcedure" namespace="{$data}">
              <xsl:value-of select="string('/join/id/stop/proceduretype_definitief')"/>
            </xsl:element>
            <xsl:if test="count($informatieobjectRefs) gt 0">
              <xsl:element name="informatieobjectRefs" namespace="{$data}">
                <xsl:for-each select="$informatieobjectRefs">
                  <xsl:element name="informatieobjectRef" namespace="{$data}">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
          </xsl:element>
          <xsl:element name="Procedureverloop" namespace="{$data}">
            <xsl:element name="bekendOp" namespace="{$data}">
              <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
            </xsl:element>
            <xsl:element name="ontvangenOp" namespace="{$data}">
              <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
            </xsl:element>
            <xsl:element name="procedurestappen" namespace="{$data}">
              <xsl:for-each select="for $index in 2 to 3 return $index">
                <xsl:variable name="index" select="."/>
                <xsl:element name="Procedurestap" namespace="{$data}">
                  <xsl:element name="soortStap" namespace="{$data}">
                    <xsl:value-of select="fn:string-join(('','join','id','stop','procedure',fn:format-number($index,'stap_000')),'/')"/>
                  </xsl:element>
                  <xsl:element name="voltooidOp" namespace="{$data}">
                    <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
          <xsl:element name="ConsolidatieInformatie" namespace="{$data}">
            <xsl:element name="BeoogdeRegelgeving" namespace="{$data}">
              <xsl:element name="BeoogdeRegeling" namespace="{$data}">
                <xsl:element name="doelen" namespace="{$data}">
                  <xsl:element name="doel" namespace="{$data}">
                    <xsl:value-of select="$id_doel"/>
                  </xsl:element>
                </xsl:element>
                <xsl:element name="instrumentVersie" namespace="{$data}">
                  <xsl:value-of select="$regeling_identificatie/data:FRBRExpression"/>
                </xsl:element>
                <xsl:element name="eId" namespace="{$data}">
                  <xsl:value-of select="string('art_I')"/>
                </xsl:element>
              </xsl:element>
              <xsl:for-each select="$informatieobjectRefs">
                <xsl:variable name="ref" select="."/>
                <xsl:variable name="eId" select="$regeling_tekst//tekst:ExtIoRef[@ref=$ref]/@eId"/>
                <xsl:element name="BeoogdInformatieobject" namespace="{$data}">
                  <xsl:element name="doelen" namespace="{$data}">
                    <xsl:element name="doel" namespace="{$data}">
                      <xsl:value-of select="$id_doel"/>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="instrumentVersie" namespace="{$data}">
                    <xsl:value-of select="$ref"/>
                  </xsl:element>
                  <xsl:element name="eId" namespace="{$data}">
                    <xsl:value-of select="concat('!initieel_reg#',$eId)"/>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
            <xsl:element name="Tijdstempels" namespace="{$data}">
              <xsl:element name="Tijdstempel" namespace="{$data}">
                <xsl:element name="doel" namespace="{$data}">
                  <xsl:value-of select="$id_doel"/>
                </xsl:element>
                <xsl:element name="soortTijdstempel" namespace="{$data}">
                  <xsl:value-of select="string('juridischWerkendVanaf')"/>
                </xsl:element>
                <xsl:element name="datum" namespace="{$data}">
                  <xsl:value-of select="format-date(current-date() + xs:dayTimeDuration('P1D'),'[Y0001]-[M01]-[D01]')"/>
                </xsl:element>
                <xsl:element name="eId" namespace="{$data}">
                  <xsl:value-of select="string('art_II')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          <xsl:choose>
            <xsl:when test="fn:tokenize($regeling_metadata/data:soortRegeling,'/')[last()]=('regelingtype_003','regelingtype_005')">
              <xsl:element name="BesluitCompact" namespace="{$tekst}">
                <xsl:element name="RegelingOpschrift" namespace="{$tekst}">
                  <xsl:attribute name="eId" select="string('longTitle')"/>
                  <xsl:attribute name="wId" select="string('longTitle')"/>
                  <xsl:element name="Al" namespace="{$tekst}">
                    <xsl:value-of select="string('[Regelingopschrift besluit]')"/>
                  </xsl:element>
                </xsl:element>
                <xsl:element name="Lichaam" namespace="{$tekst}">
                  <xsl:attribute name="eId" select="string('body')"/>
                  <xsl:attribute name="wId" select="string('body')"/>
                  <xsl:element name="WijzigArtikel" namespace="{$tekst}">
                    <xsl:attribute name="eId" select="string('art_I')"/>
                    <xsl:attribute name="wId" select="concat($id_bg_code,'_1__art_I')"/>
                    <xsl:element name="Kop" namespace="{$tekst}">
                      <xsl:element name="Label" namespace="{$tekst}">
                        <xsl:value-of select="string('Artikel')"/>
                      </xsl:element>
                      <xsl:element name="Nummer" namespace="{$tekst}">
                        <xsl:value-of select="string('I')"/>
                      </xsl:element>
                    </xsl:element>
                    <xsl:element name="Wat" namespace="{$tekst}">
                      <xsl:value-of select="string('[Artikel I bevat de verwijzing naar ')"/>
                      <xsl:element name="IntRef" namespace="{$tekst}">
                        <xsl:attribute name="ref" select="string('cmp_I')"/>
                        <xsl:attribute name="scope" select="string('WijzigBijlage')"/>
                        <xsl:value-of select="string('bijlage I')"/>
                      </xsl:element>
                      <xsl:value-of select="string('.]')"/>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="Artikel" namespace="{$tekst}">
                    <xsl:attribute name="eId" select="string('art_II')"/>
                    <xsl:attribute name="wId" select="concat($id_bg_code,'_1__art_II')"/>
                    <xsl:element name="Kop" namespace="{$tekst}">
                      <xsl:element name="Label" namespace="{$tekst}">
                        <xsl:value-of select="string('Artikel')"/>
                      </xsl:element>
                      <xsl:element name="Nummer" namespace="{$tekst}">
                        <xsl:value-of select="string('II')"/>
                      </xsl:element>
                    </xsl:element>
                    <xsl:element name="Inhoud" namespace="{$tekst}">
                      <xsl:element name="Al" namespace="{$tekst}">
                        <xsl:value-of select="string('[Artikel II regelt de datum inwerkingtreding.]')"/>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
                <xsl:element name="WijzigBijlage" namespace="{$tekst}">
                  <xsl:attribute name="eId" select="string('cmp_I')"/>
                  <xsl:attribute name="wId" select="concat($id_bg_code,'_1__cmp_I')"/>
                  <xsl:element name="Kop" namespace="{$tekst}">
                    <xsl:element name="Label" namespace="{$tekst}">
                      <xsl:value-of select="string('Bijlage')"/>
                    </xsl:element>
                    <xsl:element name="Nummer" namespace="{$tekst}">
                      <xsl:value-of select="string('I')"/>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="{$regeling_tekst/local-name()}" namespace="{$tekst}">
                    <xsl:attribute name="componentnaam" select="string('initieel_reg')"/>
                    <xsl:attribute name="wordt" select="$regeling_identificatie/data:FRBRExpression"/>
                    <xsl:apply-templates select="$regeling_tekst/node()"/>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:when>
          </xsl:choose>
        </xsl:element>
        <xsl:element name="RegelingVersieInformatie" namespace="{$aan}">
          <xsl:element name="ExpressionIdentificatie" namespace="{$data}">
            <xsl:apply-templates select="$regeling_identificatie/node()"/>
          </xsl:element>
          <xsl:element name="RegelingVersieMetadata" namespace="{$data}">
            <xsl:apply-templates select="$regeling_versieMetadata/node()"/>
          </xsl:element>
          <xsl:element name="RegelingMetadata" namespace="{$data}">
            <xsl:apply-templates select="$regeling_metadata/node()"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="data:opvolging">
    <!-- doe niets -->
  </xsl:template>

  <!-- algemeen -->

  <xsl:template match="element()">
    <xsl:element name="{local-name()}" namespace="{namespace-uri()}">
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