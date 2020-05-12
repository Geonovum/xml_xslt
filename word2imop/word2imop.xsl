<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:wx="http://schemas.microsoft.com/office/word/2006/auxHint" xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <xsl:param name="basedir" select="fn:substring-before(fn:base-uri(),'document.xml')"/>

  <!-- namespaces -->
  <xsl:param name="data" select="string('https://standaarden.overheid.nl/stop/imop/data/')"/>
  <xsl:param name="eigen" select="string('https://www.eigen.nl/')"/>
  <xsl:param name="lvbb" select="string('https://standaarden.overheid.nl/lvbb/stop/')"/>
  <xsl:param name="tekst" select="string('https://standaarden.overheid.nl/stop/imop/tekst/')"/>

  <!-- scheidingsteken in paden -->
  <xsl:param name="delimiter" select="string('/')"/>

  <!-- verwijzingen naar gebruikte documenten -->
  <xsl:param name="comments" select="concat($basedir,'comments.xml')"/>
  <xsl:param name="numbering" select="concat($basedir,'numbering.xml')"/>
  <xsl:param name="relations" select="concat($basedir,'_rels/document.xml.rels')"/>
  <xsl:param name="settings" select="concat($basedir,'settings.xml')"/>
  <xsl:param name="styles" select="concat($basedir,'styles.xml')"/>
  <xsl:param name="footnotes" select="concat($basedir,'footnotes.xml')"/>

  <!-- lees metadata besluit in -->
  <xsl:variable name="tbl_doc" select="document($comments,.)/w:comments/w:comment/w:tbl[contains(fn:string-join(w:tr[1]/w:tc[1]//w:t),'Document')]"/>
  <!-- lees metadata work in -->
  <xsl:variable name="D01" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'idWerk')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D02" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'versieSTOP')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D03" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'versieTPOD')]/w:tc[2]//w:t),'geen')[1]"/>
  <!-- lees metadata regeling in -->
  <xsl:variable name="D04" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'officieleTitel')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D05" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'redactioneleTitel')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D06" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'typeDocument')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D07" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'versieDocument')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D08" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'overheidsdomein')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D09" select="tokenize((fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'onderwerpen')]/w:tc[2]//w:t),'geen')[1],'\|')"/>
  <xsl:variable name="D10" select="tokenize((fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'rechtsgebieden')]/w:tc[2]//w:t),'geen')[1],',\|')"/>
  <!-- lees metadata organisatie in -->
  <xsl:variable name="D11" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'typeOrganisatie')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D12" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'idOrganisatie')]/w:tc[2]//w:t),'geen')[1]"/>
  <!-- lees metadata procedure in -->
  <xsl:variable name="tbl_proc" select="document($comments,.)/w:comments/w:comment/w:tbl[contains(fn:string-join(w:tr[1]/w:tc[1]//w:t),'Procedure')]"/>
  <xsl:variable name="P01" select="(fn:string-join($tbl_proc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'bekendOp')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="P02" select="(fn:string-join($tbl_proc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'ontvangenOp')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="P03">
    <xsl:for-each select="for $index in 4 to 14 return ($tbl_proc//w:tr[$index]/w:tc[2]//w:t,'geen')[1]">
      <xsl:element name="item">
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:for-each>
  </xsl:variable>

  <!-- belangrijke identifiers -->
  <xsl:variable name="ID_bill_work" select="concat('/akn/nl/bill/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01)"/>
  <xsl:variable name="ID_bill_expression" select="concat('/akn/nl/bill/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01,'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'))"/>
  <xsl:variable name="ID_act_work" select="concat('/akn/nl/act/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01)"/>
  <xsl:variable name="ID_act_expression" select="concat('/akn/nl/act/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01,'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'))"/>

  <!-- bouw het document op -->
  <xsl:template match="w:document">
    <xsl:element name="AanleveringBesluit" namespace="{$lvbb}">
      <xsl:attribute name="schemaversie" select="$D02"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.overheid.nl/imop/def# ../stop/LVBB-stop.xsd')"/>
      <!-- geef informatie door aan AKN.xsl -->
      <xsl:processing-instruction name="akn">
        <xsl:value-of select="fn:string-join(($D12,$D07),'_')"/>
      </xsl:processing-instruction>
      <!-- BesluitVersie -->
      <xsl:element name="BesluitVersie" namespace="{$lvbb}">
        <!-- ExpressionIdentificatie -->
        <xsl:element name="ExpressionIdentificatie" namespace="{$data}">
          <xsl:element name="FRBRWork" namespace="{$data}">
            <xsl:value-of select="$ID_bill_work"/>
          </xsl:element>
          <xsl:element name="FRBRExpression" namespace="{$data}">
            <xsl:value-of select="$ID_bill_expression"/>
          </xsl:element>
          <xsl:element name="soortWork" namespace="{$data}">
            <xsl:value-of select="string('/join/id/stop/work_003')"/>
          </xsl:element>
        </xsl:element>
        <!-- BesluitMetadata -->
        <xsl:element name="BesluitMetadata" namespace="{$data}">
          <xsl:element name="eindverantwoordelijke" namespace="{$data}">
            <xsl:value-of select="concat('/tooi/id/',$D11,'/',$D12)"/>
          </xsl:element>
          <xsl:element name="maker" namespace="{$data}">
            <xsl:value-of select="concat('/tooi/id/',$D11,'/',$D12)"/>
          </xsl:element>
          <xsl:element name="officieleTitel" namespace="{$data}">
            <xsl:value-of select="$D04"/>
          </xsl:element>
          <xsl:element name="redactioneleTitel" namespace="{$data}">
            <xsl:value-of select="$D05"/>
          </xsl:element>
          <xsl:element name="overheidsdomein" namespace="{$data}">
            <xsl:variable name="overheidsdomein" select="('geen','belastingen','bouwen, wonen en leefomgeving','cultuur, sport, vrije tijd','werk- en loopbaan','economie en ondernemen','familie, jeugd en gezin','financiën','gezondheid en zorg','immigratie, integratie en inburgering','internationale- en ontwikkelingssamenwerking','landbouw, natuur en voedsel','milieu, ruimte en water','onderwijs en wetenschap','openbare orde en veiligheid','overheid, bestuur en koninkrijk','defensie','subsidies, uitkeringen en toeslagen','verkeer en vervoer','rechtspraak')"/>
            <xsl:variable name="overheidsdomeinID" select="('/tooi/def/concept/c_bed49b60','/tooi/def/concept/c_3708ac5e','/tooi/def/concept/c_c70d3447','/tooi/def/concept/c_30e85e85','/tooi/def/concept/c_9fbcfc19','/tooi/def/concept/c_6bdc2b89','/tooi/def/concept/c_dfcf3a97','/tooi/def/concept/c_c95f4dd4','/tooi/def/concept/c_56a74243','/tooi/def/concept/c_33cf4691','/tooi/def/concept/c_67671688','/tooi/def/concept/c_86b84a9d','/tooi/def/concept/c_a058394a','/tooi/def/concept/c_e8ff69cb','/tooi/def/concept/c_fd285f2b','/tooi/def/concept/c_1c504a92','/tooi/def/concept/c_17f08b1f','/tooi/def/concept/c_9153c2b4','/tooi/def/concept/c_49cf6ea2')"/>
            <xsl:value-of select="$overheidsdomeinID[fn:index-of($overheidsdomein,$D08)]"/>
          </xsl:element>
          <xsl:element name="onderwerpen" namespace="{$data}">
            <xsl:for-each select="$D09">
              <xsl:element name="onderwerp" namespace="{$data}">
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
          <xsl:element name="rechtsgebieden" namespace="{$data}">
            <xsl:for-each select="$D10">
              <xsl:element name="rechtsgebied" namespace="{$data}">
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
        <!-- Procedure -->
        <xsl:element name="Procedure" namespace="{$data}">
          <xsl:element name="Procedureverloop" namespace="{$data}">
            <xsl:element name="bekendOp" namespace="{$data}">
              <xsl:value-of select="$P01"/>
            </xsl:element>
            <xsl:element name="ontvangenOp" namespace="{$data}">
              <xsl:value-of select="$P02"/>
            </xsl:element>
            <xsl:element name="soortProcedure" namespace="{$data}">
              <xsl:value-of select="string('/join/id/stop/proceduretype_definitief')"/>
            </xsl:element>
            <xsl:element name="procedurestappen" namespace="{$data}">
              <xsl:for-each select="$P03/item">
                <xsl:if test=". ne 'geen'">
                  <xsl:element name="Procedurestap" namespace="{$data}">
                    <xsl:element name="soortStap" namespace="{$data}">
                      <xsl:value-of select="fn:format-number(position(),'/join/id/stop/procedure/stap_000')"/>
                    </xsl:element>
                    <xsl:element name="voltooidOp" namespace="{$data}">
                      <xsl:value-of select="."/>
                    </xsl:element>
                  </xsl:element>
                </xsl:if>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <!-- BesluitDoel -->
        <xsl:element name="BesluitDoel" namespace="{$data}">
          <xsl:element name="BeoogdeRegelgeving" namespace="{$data}">
            <xsl:element name="BeoogdeRegeling" namespace="{$data}">
              <xsl:element name="doel" namespace="{$data}">
                <xsl:value-of select="concat('/akn/ontology/event/nl/',$D12,'/sync/Instelling')"/>
              </xsl:element>
              <xsl:element name="instrumentVersie" namespace="{$data}">
                <xsl:value-of select="$ID_act_expression"/>
              </xsl:element>
              <xsl:element name="eId" namespace="{$data}"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <!-- alleen w:body is van belang -->
        <xsl:element name="Besluit" namespace="{$tekst}">
          <xsl:apply-templates select="w:body"/>
        </xsl:element>
      </xsl:element>
      <!-- RegelingVersieInformatie -->
      <xsl:element name="RegelingVersieInformatie" namespace="{$lvbb}">
        <!-- ExpressionIdentificatie -->
        <xsl:element name="ExpressionIdentificatie" namespace="{$data}">
          <xsl:element name="FRBRWork" namespace="{$data}">
            <xsl:value-of select="$ID_act_work"/>
          </xsl:element>
          <xsl:element name="FRBRExpression" namespace="{$data}">
            <xsl:value-of select="$ID_act_expression"/>
          </xsl:element>
          <xsl:element name="soortWork" namespace="{$data}">
            <xsl:value-of select="string('/join/id/stop/work_019')"/>
          </xsl:element>
        </xsl:element>
        <!-- RegelingMetadata -->
        <xsl:element name="RegelingMetadata" namespace="{$data}">
          <xsl:element name="soortRegeling" namespace="{$data}">
            <xsl:value-of select="$D06"/>
          </xsl:element>
          <xsl:element name="versienummer" namespace="{$data}">
            <xsl:value-of select="$D07"/>
          </xsl:element>
          <xsl:element name="eindverantwoordelijke" namespace="{$data}">
            <xsl:value-of select="concat('/tooi/id/',$D11,'/',$D12)"/>
          </xsl:element>
          <xsl:element name="maker" namespace="{$data}">
            <xsl:value-of select="concat('/tooi/id/',$D11,'/',$D12)"/>
          </xsl:element>
          <xsl:element name="officieleTitel" namespace="{$data}">
            <xsl:value-of select="$D04"/>
          </xsl:element>
          <xsl:element name="redactioneleTitel" namespace="{$data}">
            <xsl:value-of select="$D05"/>
          </xsl:element>
          <xsl:element name="overheidsdomein" namespace="{$data}">
            <xsl:variable name="overheidsdomein" select="('geen','belastingen','bouwen, wonen en leefomgeving','cultuur, sport, vrije tijd','werk- en loopbaan','economie en ondernemen','familie, jeugd en gezin','financiën','gezondheid en zorg','immigratie, integratie en inburgering','internationale- en ontwikkelingssamenwerking','landbouw, natuur en voedsel','milieu, ruimte en water','onderwijs en wetenschap','openbare orde en veiligheid','overheid, bestuur en koninkrijk','defensie','subsidies, uitkeringen en toeslagen','verkeer en vervoer','rechtspraak')"/>
            <xsl:variable name="overheidsdomeinID" select="('/tooi/def/concept/c_bed49b60','/tooi/def/concept/c_3708ac5e','/tooi/def/concept/c_c70d3447','/tooi/def/concept/c_30e85e85','/tooi/def/concept/c_9fbcfc19','/tooi/def/concept/c_6bdc2b89','/tooi/def/concept/c_dfcf3a97','/tooi/def/concept/c_c95f4dd4','/tooi/def/concept/c_56a74243','/tooi/def/concept/c_33cf4691','/tooi/def/concept/c_67671688','/tooi/def/concept/c_86b84a9d','/tooi/def/concept/c_a058394a','/tooi/def/concept/c_e8ff69cb','/tooi/def/concept/c_fd285f2b','/tooi/def/concept/c_1c504a92','/tooi/def/concept/c_17f08b1f','/tooi/def/concept/c_9153c2b4','/tooi/def/concept/c_49cf6ea2')"/>
            <xsl:value-of select="$overheidsdomeinID[fn:index-of($overheidsdomein,$D08)]"/>
          </xsl:element>
          <xsl:element name="onderwerpen" namespace="{$data}">
            <xsl:for-each select="$D09">
              <xsl:element name="onderwerp" namespace="{$data}">
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
          <xsl:element name="rechtsgebieden" namespace="{$data}">
            <xsl:for-each select="$D10">
              <xsl:element name="rechtsgebied" namespace="{$data}">
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*">
    <!--xsl:comment><xsl:value-of select="concat('GW: ',name())"/></xsl:comment-->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- maak het document aan -->
  <xsl:template match="w:body">
    <xsl:element name="NieuweRegeling" namespace="{$tekst}">
      <xsl:attribute name="FRBRwork" select="$ID_act_work"/>
      <xsl:attribute name="componentnaam" select="string('main')"/>
      <xsl:attribute name="wordt" select="$ID_act_expression"/>
      <xsl:for-each-group select="*" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=('Kop1','Divisiekop1')][1]">
        <xsl:choose>
          <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val='Titel']">
            <xsl:element name="RegelingOpschrift" namespace="{$tekst}">
              <xsl:apply-templates select="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val='Titel']"/>
            </xsl:element>
            <xsl:variable name="aanhef" select="current-group()/self::w:p[not(w:pPr/w:pStyle/@w:val='Titel')]"/>
            <xsl:choose>
              <xsl:when test="$aanhef">
                <xsl:element name="Aanhef" namespace="{$tekst}">
                  <xsl:call-template name="group_adjacent">
                    <xsl:with-param name="group" select="$aanhef"/>
                  </xsl:call-template>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <!-- hier kan eventueel een standaard aanhef -->
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val='Kop1']">
            <xsl:for-each-group select="current-group()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val='Divisiekop1'][1]">
              <xsl:choose>
                <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val='Kop1']">
                  <xsl:element name="Lichaam" namespace="{$tekst}">
                    <!-- section_lichaam_artikel plaatst de artikelstructuur -->
                    <xsl:call-template name="section_lichaam_artikel">
                      <xsl:with-param name="group" select="current-group()"/>
                      <xsl:with-param name="index" select="1"/>
                    </xsl:call-template>
                  </xsl:element>
                </xsl:when>
                <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val='Divisiekop1']">
                  <!-- section_bijlage plaatst de vrijtekststructuur -->
                  <xsl:call-template name="section_bijlage">
                    <xsl:with-param name="group" select="current-group()"/>
                    <xsl:with-param name="index" select="1"/>
                  </xsl:call-template>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each-group>
          </xsl:when>
          <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val='Divisiekop1']">
            <xsl:for-each-group select="current-group()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val='Divisiekop1'][1]">
              <xsl:element name="Lichaam" namespace="{$tekst}">
                <!-- section_lichaam_vrijetekst plaatst de artikelstructuur -->
                <xsl:call-template name="section_lichaam_vrijetekst">
                  <xsl:with-param name="group" select="current-group()"/>
                  <xsl:with-param name="index" select="1"/>
                </xsl:call-template>
              </xsl:element>
            </xsl:for-each-group>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:element>
  </xsl:template>

  <xsl:param name="section_lichaam_artikel_word" select="('Kop1','Kop2','Kop3','Kop4','Kop5','Kop6','Lidmetnummering')"/>
  <xsl:param name="section_lichaam_artikel_imop" select="('Hoofdstuk','Afdeling','Paragraaf','Subparagraaf','Subsubparagraaf','Artikel','Lid')"/>

  <xsl:template name="section_lichaam_artikel">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_lichaam_artikel_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:choose>
        <xsl:when test="$styleId=fn:format-number($index,'Kop#')">
          <xsl:element name="{$section_lichaam_artikel_imop[$index]}" namespace="{$tekst}">
            <xsl:apply-templates select="current-group()[1]"/>
            <xsl:call-template name="section_lichaam_artikel">
              <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$styleId=$section_lichaam_artikel_word[$index]">
          <xsl:element name="Lid" namespace="{$tekst}">
            <xsl:element name="LidNummer" namespace="{$tekst}">
              <xsl:value-of select="fn:string-join(current-group()[1]/w:r[following-sibling::w:r[w:tab][1]]/w:t)"/>
            </xsl:element>
            <xsl:element name="Inhoud" namespace="{$tekst}">
              <xsl:call-template name="group_starting_with">
                <xsl:with-param name="group" select="current-group()"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$index gt count($section_lichaam_artikel_word)">
          <xsl:element name="Inhoud" namespace="{$tekst}">
            <xsl:call-template name="group_starting_with">
              <xsl:with-param name="group" select="current-group()"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="section_lichaam_artikel">
            <xsl:with-param name="group" select="current-group()"/>
            <xsl:with-param name="index" select="$index+1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:param name="section_lichaam_vrijtekst_word" select="('Divisiekop1','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7')"/>
  <xsl:param name="section_lichaam_vrijtekst_imop" select="('FormeleDivisie','FormeleDivisie','FormeleDivisie','FormeleDivisie','FormeleDivisie','FormeleDivisie','FormeleDivisie')"/>

  <xsl:template name="section_lichaam_vrijetekst">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_bijlage_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:choose>
        <xsl:when test="$styleId=fn:format-number($index,'Divisiekop#')">
          <xsl:element name="{$section_lichaam_vrijtekst_imop[$index]}" namespace="{$tekst}">
            <xsl:apply-templates select="current-group()[1]"/>
            <xsl:call-template name="section_lichaam_vrijetekst">
              <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$index gt count($section_lichaam_vrijtekst_word)">
          <xsl:element name="FormeleInhoud" namespace="{$tekst}">
            <xsl:call-template name="group_adjacent">
              <xsl:with-param name="group" select="current-group()"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="section_lichaam_vrijetekst">
            <xsl:with-param name="group" select="current-group()"/>
            <xsl:with-param name="index" select="$index+1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:param name="section_bijlage_word" select="('Divisiekop1','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7')"/>
  <xsl:param name="section_bijlage_imop" select="('Bijlage','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie')"/>

  <xsl:template name="section_bijlage">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_bijlage_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:choose>
        <xsl:when test="$styleId=fn:format-number($index,'Divisiekop#')">
          <xsl:element name="{$section_bijlage_imop[$index]}" namespace="{$tekst}">
            <xsl:apply-templates select="current-group()[1]"/>
            <xsl:call-template name="section_bijlage">
              <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$index gt count($section_bijlage_word)">
          <xsl:element name="Inhoud" namespace="{$tekst}">
            <xsl:call-template name="group_starting_with">
              <xsl:with-param name="group" select="current-group()"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="section_bijlage">
            <xsl:with-param name="group" select="current-group()"/>
            <xsl:with-param name="index" select="$index+1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <!-- groepeer elementen niet-hiërarchisch -->

  <xsl:template name="group_starting_with">
    <xsl:param name="group"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val='Begrip'][1]">
      <xsl:choose>
        <xsl:when test="current-group()[1]/w:pPr/w:pStyle/@w:val='Begrip'">
          <xsl:call-template name="begrippenlijst">
            <xsl:with-param name="group" select="current-group()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="group_adjacent">
            <xsl:with-param name="group" select="current-group()"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template name="group_adjacent">
    <xsl:param name="group"/>
    <xsl:for-each-group select="$group" group-adjacent="if (self::w:p[w:r/w:drawing]|self::w:p[contains(w:pPr/w:pStyle/@w:val,'Bijschrift')]) then 'figuur' else if (self::w:tbl|self::w:p[contains(w:pPr/w:pStyle/@w:val,'Tabeltitel')]) then 'tabel' else if (self::w:p[fn:ends-with(fn:string-join(w:r/w:t),':')][contains(following-sibling::*[1]/w:pPr/w:pStyle/@w:val,'Opsommingmetnummering')]|self::w:p[contains(w:pPr/w:pStyle/@w:val,'Opsomming')]) then 'lijst' else 'standaard'">
      <xsl:choose>
        <xsl:when test="current-grouping-key()='figuur'">
          <xsl:element name="Figuur" namespace="{$tekst}">
            <xsl:for-each select="current-group()">
              <xsl:choose>
                <xsl:when test="self::w:p[w:r/w:drawing]">
                  <xsl:apply-templates select="./w:r/w:drawing"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="."/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:element>
        </xsl:when>
        <xsl:when test="current-grouping-key()='tabel'">
          <xsl:apply-templates select="current-group()"/>
        </xsl:when>
        <xsl:when test="current-grouping-key()='lijst'">
          <xsl:call-template name="lijst">
            <xsl:with-param name="group" select="current-group()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="current-grouping-key()='standaard'">
          <xsl:apply-templates select="current-group()"/>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <!-- groepeer element begrippenlijst -->
  <xsl:template name="begrippenlijst">
    <xsl:param name="group"/>
    <xsl:element name="Begrippenlijst" namespace="{$tekst}">
      <xsl:for-each-group select="$group" group-starting-with="self::w:p[w:pPr/w:pStyle/@w:val='Begrip']">
        <xsl:choose>
          <xsl:when test="current-group()[1]/w:pPr/w:pStyle/@w:val='Begrip'">
            <xsl:element name="Begrip" namespace="{$tekst}">
              <xsl:element name="Term" namespace="{$tekst}">
                <xsl:apply-templates select="current-group()[1]/node()"/>
              </xsl:element>
              <xsl:element name="Definitie" namespace="{$tekst}">
                <xsl:call-template name="group_adjacent">
                  <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
                </xsl:call-template>
              </xsl:element>
            </xsl:element>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:element>
  </xsl:template>

  <!-- groepeer element lijst -->
  <xsl:template name="lijst">
    <xsl:param name="group"/>
    <xsl:param name="indent" select="0"/>
    <xsl:element name="Lijst" namespace="{$tekst}">
      <xsl:attribute name="type" select="string('expliciet')"/>
      <xsl:for-each-group select="$group" group-starting-with="self::w:p[contains(w:pPr/w:pStyle/@w:val,'Opsommingmetnummering')][number((w:pPr/w:ind/@w:left,'0')[1]) eq $indent]">
        <xsl:choose>
          <xsl:when test="current-group()[last()]/self::w:p[fn:ends-with(fn:string-join(w:r/w:t),':')]">
            <!-- controleer of het een lijstaanhef is -->
            <xsl:element name="Lijstaanhef" namespace="{$tekst}">
              <xsl:choose>
                <xsl:when test="contains(self::w:p/w:pPr/w:pStyle/@w:val,'metnummering')">
                  <xsl:for-each-group select="current-group()[1]/*" group-starting-with="w:r[w:tab][1]">
                    <xsl:choose>
                      <xsl:when test="position()=1">
                        <!-- nummering wordt door lidmetnummering en opsommingmetnummering geplaatst -->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:apply-templates select="current-group()"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each-group>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="node()"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:when>
          <xsl:when test="current-group()[1]/self::w:p[contains(w:pPr/w:pStyle/@w:val,'Opsommingmetnummering')]">
            <!-- controleer of het een opsommigslid is -->
            <xsl:element name="Li" namespace="{$tekst}">
              <xsl:element name="LiNummer" namespace="{$tekst}">
                <xsl:for-each-group select="current-group()[1]/*" group-starting-with="w:r[w:tab][1]">
                  <xsl:choose>
                    <xsl:when test="position()=1">
                      <!-- plaats de nummering -->
                      <xsl:apply-templates select="current-group()"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- de tekst wordt geplaatst door w:p -->
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each-group>
              </xsl:element>
              <!-- controleer of er geneste opsommingen zijn op basis van w:ind -->
              <xsl:for-each-group select="current-group()" group-by="self::w:p[number(w:pPr/w:ind/@w:left) gt $indent] or self::w:p[fn:ends-with(fn:string-join(w:r/w:t),':')]">
                <xsl:choose>
                  <xsl:when test="current-grouping-key()">
                    <xsl:variable name="indents">
                      <xsl:sequence select="current-group()/w:pPr/w:ind[number(@w:left) gt $indent]"/>
                    </xsl:variable>
                    <xsl:call-template name="lijst">
                      <xsl:with-param name="group" select="current-group()"/>
                      <xsl:with-param name="indent" select="number($indents/w:ind[1]/@w:left)"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="current-group()"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each-group>
            </xsl:element>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:element>
  </xsl:template>

  <!-- paragraaf bewerken -->
  <xsl:template match="w:p">
    <xsl:variable name="styleId" select="w:pPr/w:pStyle/@w:val"/>
    <xsl:choose>
      <xsl:when test="$styleId=('Kop1','Kop2','Kop3','Kop4','Kop5','Kop6','Kop7','Divisiekop1','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7')">
        <xsl:element name="Kop" namespace="{$tekst}">
          <xsl:for-each-group select="*" group-starting-with="w:r[w:tab][1]">
            <xsl:choose>
              <xsl:when test="position()=1">
                <xsl:variable name="nummer" select="fn:tokenize(fn:string-join(current-group()/w:t),'\s+')"/>
                <xsl:if test="count($nummer) gt 1">
                  <xsl:element name="Label" namespace="{$tekst}">
                    <xsl:value-of select="fn:subsequence($nummer,1,count($nummer)-1)"/>
                  </xsl:element>
                </xsl:if>
                <xsl:element name="Nummer" namespace="{$tekst}">
                  <xsl:value-of select="$nummer[last()]"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="Opschrift" namespace="{$tekst}">
                  <xsl:apply-templates select="current-group()"/>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each-group>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$styleId=('Lidmetnummering')">
        <xsl:for-each-group select="*" group-starting-with="w:r[w:tab][1]">
          <xsl:choose>
            <xsl:when test="position()=1">
              <!-- lidnummer wordt geplaatst door section_lichaam_artikel -->
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="Al" namespace="{$tekst}">
                <xsl:apply-templates select="current-group()"/>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each-group>
      </xsl:when>
      <xsl:when test="$styleId=('Opsommingmetnummering')">
        <xsl:for-each-group select="*" group-starting-with="w:r[w:tab][1]">
          <xsl:choose>
            <xsl:when test="position()=1">
              <!-- opsommingsnummer wordt geplaatst door lijst -->
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="Al" namespace="{$tekst}">
                <xsl:apply-templates select="current-group()"/>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each-group>
      </xsl:when>
      <xsl:when test="$styleId=('Alineakop')">
        <xsl:element name="Tussenkop" namespace="{$tekst}">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$styleId=('Bijschrift')">
        <xsl:element name="Bijschrift" namespace="{$tekst}">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$styleId=('Tabeltitel')">
        <!-- table plaatst title -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="Al" namespace="{$tekst}">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- range bewerken -->

  <xsl:template match="w:r[. ne '']">
    <xsl:choose>
      <xsl:when test="w:rPr">
        <xsl:call-template name="range">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="index" select="1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="range">
    <xsl:param name="node"/>
    <xsl:param name="index"/>
    <xsl:variable name="styleId" select="('b','i','u','sup','sub')"/>
    <xsl:choose>
      <xsl:when test="$index gt count($styleId)">
        <xsl:apply-templates select="$node/node()"/>
      </xsl:when>
      <xsl:when test="$node/w:rPr[(*[local-name() eq $styleId[$index]]) or (w:vertAlign[starts-with(@w:val,$styleId[$index])])]">
        <xsl:element name="{$styleId[$index]}" namespace="{$tekst}">
          <xsl:call-template name="range">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="index" select="$index+1"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="range">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="index" select="$index+1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="w:hyperlink">
    <xsl:apply-templates/>
  </xsl:template>

  <!--tekst doorgeven-->

  <xsl:template match="w:t">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="w:br">
    <xsl:element name="br" namespace="{$tekst}"/>
  </xsl:template>

  <xsl:template match="w:tab">
    <!-- doe niets -->
  </xsl:template>

  <xsl:template match="w:instrText">
    <!-- doe niets -->
  </xsl:template>

  <!-- tabel bewerken -->

  <xsl:template match="w:tbl">
    <xsl:variable name="title" select="(preceding-sibling::*[1][self::w:p/w:pPr/w:pStyle/@w:val='Tabeltitel'],w:tblPr/w:tblCaption/@w:val,null)[1]"/>
    <xsl:element name="table" namespace="{$tekst}">
      <xsl:attribute name="eigen:class" namespace="{$eigen}" select="string('standaard')"/>
      <xsl:attribute name="frame" select="string('all')"/>
      <xsl:attribute name="colsep" select="string('1')"/>
      <xsl:attribute name="rowsep" select="string('1')"/>
      <xsl:if test="$title">
        <xsl:element name="title" namespace="{$tekst}">
          <xsl:value-of select="$title"/>
        </xsl:element>
      </xsl:if>
      <xsl:element name="tgroup" namespace="{$tekst}">
        <xsl:variable name="cols" select="w:tblGrid/w:gridCol"/>
        <xsl:variable name="colwidths" select="w:tblGrid/w:gridCol/@w:w"/>
        <xsl:attribute name="cols" select="count($cols)"/>
        <xsl:attribute name="align" select="string('left')"/>
        <xsl:for-each select="$cols">
          <xsl:variable name="index" select="position()"/>
          <xsl:element name="colspec" namespace="{$tekst}">
            <xsl:attribute name="colname" select="concat('col',$index)"/>
            <xsl:attribute name="colwidth" select="@w:w"/>
          </xsl:element>
        </xsl:for-each>
        <xsl:variable name="thead" select="w:tr[w:trPr/w:tblHeader]"/>
        <xsl:if test="$thead">
          <xsl:element name="thead" namespace="{$tekst}">
            <xsl:attribute name="valign" select="string('top')"/>
            <xsl:apply-templates select="$thead"/>
          </xsl:element>
        </xsl:if>
        <xsl:variable name="tbody" select="w:tr[not(w:trPr/w:tblHeader)]"/>
        <xsl:if test="$tbody">
          <xsl:element name="tbody" namespace="{$tekst}">
            <xsl:attribute name="valign" select="string('top')"/>
            <xsl:apply-templates select="$tbody"/>
          </xsl:element>
        </xsl:if>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="w:tr">
    <xsl:element name="row" namespace="{$tekst}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="w:tc">
    <xsl:choose>
      <xsl:when test="boolean(.//w:vMerge and not(.//w:vMerge/@w:val))">
        <!-- dit is een verticaal samengevoegde tabelcel -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="entry" namespace="{$tekst}">
          <xsl:variable name="index" select="count(.|preceding-sibling::w:tc[not(w:tcPr/w:gridSpan)]) + sum(preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val)"/>
          <!-- bevat de naam van de startkolom van de horizontaal samengevoegde tabelcel -->
          <xsl:attribute name="namest" select="concat('col',string($index))"/>
          <!-- bevat de naam van de eindkolom van de horizontaal samengevoegde tabelcel -->
          <xsl:attribute name="nameend">
            <xsl:choose>
              <xsl:when test="w:tcPr/w:gridSpan/@w:val">
                <xsl:value-of select="concat('col',string($index + number(w:tcPr/w:gridSpan/@w:val) - 1))"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="concat('col',string($index))"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <!-- bevat het aantal extra rijen van de verticaal samengevoegde tabelcel -->
          <xsl:variable name="morerows" as="xs:integer">
            <xsl:variable name="check" select="parent::w:tr/following-sibling::w:tr/w:tc[count(.|preceding-sibling::w:tc[not(w:tcPr/w:gridSpan)]) + sum(preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val)=$index]"/>
            <!-- check bevat de tabelcellen die van belang zijn -->
            <xsl:choose>
              <xsl:when test="$check">
                <xsl:for-each-group select="$check" group-adjacent="boolean(.//w:vMerge and not(.//w:vMerge/@w:val))">
                  <xsl:if test="position()=1">
                    <xsl:choose>
                      <xsl:when test="current-group()[1][.//w:vMerge and not(.//w:vMerge/@w:val)]">
                        <xsl:value-of select="count(current-group())"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="0"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                </xsl:for-each-group>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="0"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="$morerows gt 0">
            <xsl:attribute name="morerows" select="$morerows"/>
          </xsl:if>
          <!-- bevat de uitlijning van de tabelcel -->
          <xsl:attribute name="align">
            <xsl:call-template name="align"/>
          </xsl:attribute>
          <xsl:call-template name="group_adjacent">
            <xsl:with-param name="group" select="*"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- routine om alignment te testen -->
  <xsl:template name="align">
    <xsl:variable name="align" select=".//w:jc[1]/@w:val"/>
    <xsl:choose>
      <xsl:when test="$align='left'">
        <xsl:value-of select="string('left')"/>
      </xsl:when>
      <xsl:when test="$align='right'">
        <xsl:value-of select="string('right')"/>
      </xsl:when>
      <xsl:when test="$align='center'">
        <xsl:value-of select="string('center')"/>
      </xsl:when>
      <xsl:when test="$align='both'">
        <!-- het zou justify moeten zijn, maar er wordt eigenlijk altijd left bedoeld -->
        <xsl:value-of select="string('left')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="string('left')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- illustraties toevoegen (Word 2010) -->

  <xsl:template match="w:drawing">
    <xsl:variable name="imageId" select=".//a:graphic//@r:embed"/>
    <xsl:choose>
      <xsl:when test="$imageId!=''">
        <xsl:variable name="imageName" select="document($relations,.)//*[@Id=$imageId]/@Target"/>
        <xsl:element name="Illustratie" namespace="{$tekst}">
          <xsl:attribute name="naam" select="$imageName"/>
          <xsl:attribute name="breedte" select="string(number((wp:anchor/wp:extent|wp:inline/a:graphic/a:graphicData/pic:pic/pic:spPr/a:xfrm/a:ext)[1]/@cx) div 635)"/>
          <xsl:attribute name="hoogte" select="string(number((wp:anchor/wp:extent|wp:inline/a:graphic/a:graphicData/pic:pic/pic:spPr/a:xfrm/a:ext)[1]/@cy) div 635)"/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- voetnoten toevoegen -->

  <xsl:template match="w:footnoteReference">
    <xsl:variable name="footnoteId" select="@w:id"/>
    <xsl:variable name="footnote" select="document($footnotes,.)//w:footnote[@w:id=$footnoteId]"/>
    <xsl:variable name="index" select="count(.|preceding::w:footnoteReference)"/>
    <xsl:element name="Noot" namespace="{$tekst}">
      <xsl:attribute name="id" select="concat('N',$footnoteId)"/>
      <xsl:attribute name="type" select="string('voet')"/>
      <xsl:element name="NootNummer" namespace="{$tekst}">
        <xsl:value-of select="$index"/>
      </xsl:element>
      <xsl:apply-templates select="$footnote/node()"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>