<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:xlink="http://www.w3.org/1999/xlink">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <xsl:param name="basedir" select="fn:substring-before(fn:base-uri(),'document.xml')"/>

  <xsl:param name="comments" select="collection(concat($basedir,'?select=comments.xml'))/w:comments"/>
  <xsl:param name="footnotes" select="collection(concat($basedir,'?select=footnotes.xml'))/w:footnotes"/>
  <xsl:param name="relationships" select="collection(concat($basedir,'?select=document.xml.rels;recurse=yes'))/Relationships" xpath-default-namespace="http://schemas.openxmlformats.org/package/2006/relationships"/>
  <xsl:param name="styles" select="collection(concat($basedir,'?select=styles.xml'))/w:styles"/>

  <!-- OIN-lijst -->
  <xsl:param name="OIN" select="document('OIN.xml')//item"/>

  <!-- lees stijlen in -->
  <xsl:param name="title" select="$styles/w:style[w:name/@w:val='Title']/@w:styleId" as="xs:string"/>
  <xsl:param name="headings" select="$styles/w:style[fn:matches(w:name/@w:val,'heading\s[1-7]')]/@w:styleId"/>
  <xsl:param name="heading_1" select="$headings[1]" as="xs:string"/>
  <xsl:param name="heading_2" select="$headings[2]" as="xs:string"/>
  <xsl:param name="heading_3" select="$headings[3]" as="xs:string"/>
  <xsl:param name="heading_4" select="$headings[4]" as="xs:string"/>
  <xsl:param name="heading_5" select="$headings[5]" as="xs:string"/>
  <xsl:param name="heading_6" select="$headings[6]" as="xs:string"/>
  <xsl:param name="heading_7" select="$headings[7]" as="xs:string"/>
  <xsl:param name="heading" select="translate($headings[1],'1','#')"/>

  <!-- lees metadata besluit in -->
  <xsl:variable name="tbl_doc" select="$comments/w:comment/w:tbl[contains(fn:string-join(w:tr[1]/w:tc[1]//w:t),'Document')]"/>
  <!-- lees metadata work in -->
  <xsl:variable name="D01" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'idWerk')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D02" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'versieSTOP')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D03" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'versieTPOD')]/w:tc[2]//w:t),'geen')[1]"/>
  <!-- lees metadata regeling in -->
  <xsl:variable name="D04" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'officieleTitel')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D05" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'citeertitel')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D06" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'soortRegeling')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D07" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'versieRegeling')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D08" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'overheidsdomein')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D09" select="tokenize((fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'onderwerpen')]/w:tc[2]//w:t),'geen')[1],'\|')"/>
  <xsl:variable name="D10" select="tokenize((fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'rechtsgebieden')]/w:tc[2]//w:t),'geen')[1],',\|')"/>
  <!-- lees metadata organisatie in -->
  <xsl:variable name="D11" select="(fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'soortOrganisatie')]/w:tc[2]//w:t),'geen')[1]"/>
  <xsl:variable name="D12" select="tokenize((fn:string-join($tbl_doc//w:tr[contains(fn:string-join(w:tc[1]//w:t),'idOrganisatie')]/w:tc[2]//w:t),'geen')[1],'/')[last()]"/>
  <!-- lees ow_objecten_vrijetekst in -->
  <xsl:variable name="ow_objecten_artikel" select="$comments/w:comment[contains(('Activiteit|Gebiedsaanwijzing|Geometrie|Omgevingsnorm|Thema'),fn:string-join(w:tbl[1]/w:tr[1]/w:tc[1]//w:t))]"/>
  <xsl:variable name="ow_objecten_vrijetekst" select="$comments/w:comment[contains(('Gebiedsaanwijzing|Hoofdlijn|Thema'),fn:string-join(w:tbl[1]/w:tr[1]/w:tc[1]//w:t))]"/>

  <!-- belangrijke identifiers -->
  <xsl:variable name="ID_bill_work" select="concat('/akn/nl/bill/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01)"/>
  <xsl:variable name="ID_bill_expression" select="concat('/akn/nl/bill/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01,'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'),';',$D07)"/>
  <xsl:variable name="ID_act_work" select="concat('/akn/nl/act/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01)"/>
  <xsl:variable name="ID_act_expression" select="concat('/akn/nl/act/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01,'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'),';',$D07)"/>

  <!-- algemeen -->
  <xsl:template match="*">
    <!--xsl:comment><xsl:value-of select="concat('GW: ',name())"/></xsl:comment-->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- bouw het document op -->
  <xsl:template match="w:document">
    <xsl:element name="AanleveringBesluit">
      <xsl:namespace name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
      <xsl:namespace name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
      <xsl:namespace name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
      <xsl:namespace name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
      <xsl:namespace name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
      <xsl:namespace name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
      <xsl:namespace name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
      <!-- geef informatie door aan AKN.xsl -->
      <xsl:processing-instruction name="akn">
        <xsl:value-of select="fn:string-join(($D12,$D07),'_')"/>
      </xsl:processing-instruction>
      <xsl:element name="sl:standBestand">
        <xsl:element name="sl:dataset">
          <xsl:value-of select="$D04"/>
        </xsl:element>
        <xsl:element name="sl:gebied">
          <xsl:choose>
            <xsl:when test="$D11='ministerie'">
              <xsl:value-of select="string('Nederland')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$OIN[BG=fn:string-join(('','tooi','id',$D11,$D12),'/')]/naam"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
        <xsl:element name="sl:leveringsId">
          <xsl:value-of select="$D01"/>
        </xsl:element>
      </xsl:element>
      <!-- de eerste sectie is de tekst van het besluit, overige secties zijn teksten van één of meer regelingen -->
      <xsl:for-each-group select="w:body/element()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$title][1]">
        <xsl:if test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$title]">
          <xsl:for-each-group select="current-group()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$title]">
            <xsl:choose>
              <xsl:when test="position() eq 1">
                <!-- besluitdeel -->
              </xsl:when>
              <xsl:when test="position() gt 1">
                <!-- regelingdeel -->
                <xsl:call-template name="regeling">
                  <xsl:with-param name="regeling">
                    <xsl:sequence select="current-group()"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each-group>
        </xsl:if>
      </xsl:for-each-group>
    </xsl:element>
  </xsl:template>

  <!-- maak de regelingen -->
  <xsl:template name="regeling">
    <xsl:param name="regeling"/>
    <xsl:for-each-group select="$regeling/element()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=($heading_1,'Divisiekop1')][1]">
      <xsl:choose>
        <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$title]">
          <xsl:element name="RegelingOpschrift">
            <xsl:apply-templates select="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val='Titel']"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$heading_1]">
          <xsl:for-each-group select="current-group()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val='Divisiekop1'][1]">
            <xsl:choose>
              <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$heading_1]">
                <xsl:element name="Lichaam">
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
            <xsl:element name="Lichaam">
              <!-- section_lichaam_vrijetekst plaatst de vrijtekststructuur -->
              <xsl:call-template name="section_lichaam_vrijetekst">
                <xsl:with-param name="group" select="current-group()"/>
                <xsl:with-param name="index" select="1"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:for-each-group>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:param name="section_lichaam_artikel_word" select="($heading_1,$heading_2,$heading_3,$heading_4,$heading_5,$heading_6,'Lidmetnummering')"/>
  <xsl:param name="section_lichaam_artikel_imop" select="('Hoofdstuk','Afdeling','Paragraaf','Subparagraaf','Subsubparagraaf','Artikel','Lid')"/>

  <xsl:template name="section_lichaam_artikel">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_lichaam_artikel_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:variable name="test_1" select="current-group()"/>
      <xsl:variable name="test_2" select="current-group()//w:commentRangeStart/@w:id"/>
      <xsl:choose>
        <xsl:when test="$styleId=fn:format-number($index,'Kop#')">
          <xsl:element name="{$section_lichaam_artikel_imop[$index]}">
            <xsl:variable name="comment_id" select="current-group()[1]//w:commentRangeStart/@w:id"/>
            <xsl:call-template name="ow_objecten_artikel">
              <xsl:with-param name="comments" select="$ow_objecten_artikel[@w:id=$comment_id]"/>
              <xsl:with-param name="index" select="count(current-group()[1]/(.|preceding::w:p)[.//w:commentRangeStart])"/>
            </xsl:call-template>
            <xsl:apply-templates select="current-group()[1]"/>
            <xsl:call-template name="section_lichaam_artikel">
              <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$styleId=$section_lichaam_artikel_word[$index]">
          <xsl:element name="Lid">
            <xsl:element name="LidNummer">
              <xsl:value-of select="fn:string-join(current-group()[1]/w:r[following-sibling::w:r[w:tab][1]]/w:t)"/>
            </xsl:element>
            <!-- doe niets -->
          </xsl:element>
        </xsl:when>
        <xsl:when test="$index gt count($section_lichaam_artikel_word)">
          <!-- doe niets -->
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

  <xsl:param name="section_lichaam_vrijtekst_word" select="('Divisiekop1','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7','Divisiekop8','Divisiekop9')"/>
  <xsl:param name="section_lichaam_vrijtekst_imop" select="('Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie')"/>

  <xsl:template name="section_lichaam_vrijetekst">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_bijlage_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:choose>
        <xsl:when test="$styleId=fn:format-number($index,'Divisiekop#')">
          <xsl:element name="{$section_lichaam_vrijtekst_imop[$index]}">
            <xsl:variable name="comment_id" select="current-group()[1]//w:commentRangeStart/@w:id"/>
            <xsl:call-template name="ow_objecten_vrijetekst">
              <xsl:with-param name="comments" select="$ow_objecten_vrijetekst[@w:id=$comment_id]"/>
              <xsl:with-param name="index" select="count(current-group()[1]/(.|preceding::w:p)[.//w:commentRangeStart])"/>
            </xsl:call-template>
            <xsl:apply-templates select="current-group()[1]"/>
            <xsl:call-template name="section_lichaam_vrijetekst">
              <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$index gt count($section_lichaam_vrijtekst_word)">
          <!-- doe niets -->
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

  <xsl:param name="section_bijlage_word" select="('Divisiekop1','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7','Divisiekop8','Divisiekop9')"/>
  <xsl:param name="section_bijlage_imop" select="('Bijlage','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie')"/>

  <xsl:template name="section_bijlage">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_bijlage_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:choose>
        <xsl:when test="$styleId=fn:format-number($index,'Divisiekop#')">
          <xsl:element name="{$section_bijlage_imop[$index]}">
            <xsl:apply-templates select="current-group()[1]"/>
            <xsl:call-template name="section_bijlage">
              <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$index gt count($section_bijlage_word)">
          <!-- doe niets -->
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

  <!-- paragraaf bewerken -->
  <xsl:template match="w:p">
    <xsl:variable name="styleId" select="w:pPr/w:pStyle/@w:val"/>
    <xsl:choose>
      <xsl:when test="$styleId=('Kop1','Kop2','Kop3','Kop4','Kop5','Kop6','Kop7','Divisiekop1','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7','Divisiekop8','Divisiekop9')">
        <xsl:element name="Kop">
          <xsl:choose>
            <xsl:when test="w:r[w:tab]">
              <xsl:for-each-group select="*" group-starting-with="w:r[w:tab][1]">
                <xsl:choose>
                  <xsl:when test="position()=1">
                    <xsl:variable name="nummer" select="fn:tokenize(fn:string-join(current-group()/w:t),'\s+')"/>
                    <xsl:choose>
                      <xsl:when test="count($nummer) eq 0">
                        <!-- doe niets -->
                      </xsl:when>
                      <xsl:when test="count($nummer) eq 1">
                        <xsl:element name="Nummer">
                          <xsl:value-of select="$nummer[last()]"/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="count($nummer) gt 1">
                        <xsl:element name="Label">
                          <xsl:value-of select="fn:subsequence($nummer,1,count($nummer)-1)"/>
                        </xsl:element>
                        <xsl:element name="Nummer">
                          <xsl:value-of select="$nummer[last()]"/>
                        </xsl:element>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:element name="Opschrift">
                      <xsl:apply-templates select="current-group()"/>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each-group>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="Opschrift">
                <xsl:apply-templates/>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$styleId=('Lidmetnummering')">
        <xsl:for-each-group select="*" group-starting-with="w:r[w:tab][1]">
          <xsl:choose>
            <xsl:when test="position()=1">
              <!-- lidnummer wordt geplaatst door section_lichaam_artikel -->
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="Al">
                <xsl:apply-templates select="current-group()"/>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each-group>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="Al">
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
        <xsl:element name="{$styleId[$index]}">
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

  <!--tekst doorgeven-->

  <xsl:template match="w:t">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="w:br">
    <xsl:element name="br"/>
  </xsl:template>

  <xsl:template match="w:tab">
    <!-- doe niets -->
  </xsl:template>

  <xsl:template match="w:instrText">
    <!-- doe niets -->
  </xsl:template>

  <!-- comments -->

  <xsl:template name="ow_objecten_artikel">
    <xsl:param name="comments"/>
    <xsl:param name="index"/>
    <xsl:if test="$comments">
      <xsl:variable name="ow_thema">
        <xsl:for-each select="$comments[contains(fn:string-join(w:tbl[1]/w:tr[1]/w:tc[1]//w:t),'Thema')]">
          <xsl:variable name="w:tbl" select="./w:tbl[1]"/>
          <xsl:element name="item">
            <xsl:attribute name="id" select="./@w:id"/>
            <xsl:for-each select="for $counter in 2 to count($w:tbl/w:tr) return $w:tbl/w:tr[$counter]">
              <xsl:variable name="w:tr" select="."/>
              <xsl:element name="waarde">
                <xsl:attribute name="naam" select="fn:string-join($w:tr/w:tc[1]//w:t)"/>
                <xsl:value-of select="fn:string-join($w:tr/w:tc[2]//w:t)"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="ow_locatie">
        <xsl:for-each select="$comments[contains(fn:string-join(w:tbl[1]/w:tr[1]/w:tc[1]//w:t),'Geometrie')]">
          <xsl:variable name="w:tbl" select="./w:tbl[1]"/>
          <xsl:element name="item">
            <xsl:attribute name="id" select="./@w:id"/>
            <xsl:for-each select="for $counter in 2 to count($w:tbl/w:tr) return $w:tbl/w:tr[$counter]">
              <xsl:variable name="w:tr" select="."/>
              <xsl:element name="waarde">
                <xsl:attribute name="naam" select="fn:string-join($w:tr/w:tc[1]//w:t)"/>
                <xsl:value-of select="fn:string-join($w:tr/w:tc[2]//w:t)"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="ow_gebiedsaanwijzing">
        <xsl:for-each select="$comments[contains(fn:string-join(w:tbl[1]/w:tr[1]/w:tc[1]//w:t),'Gebiedsaanwijzing')]">
          <xsl:variable name="w:tbl" select="./w:tbl[1]"/>
          <xsl:element name="item">
            <xsl:attribute name="id" select="./@w:id"/>
            <xsl:for-each select="for $counter in 2 to count($w:tbl/w:tr) return $w:tbl/w:tr[$counter]">
              <xsl:variable name="w:tr" select="."/>
              <xsl:element name="waarde">
                <xsl:attribute name="naam" select="fn:string-join($w:tr/w:tc[1]//w:t)"/>
                <xsl:value-of select="fn:string-join($w:tr/w:tc[2]//w:t)"/>
              </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="for $counter in 2 to count($w:tbl/w:tr/descendant::w:tbl/w:tr) return $w:tbl/w:tr/descendant::w:tbl/w:tr[$counter]">
              <xsl:variable name="w:tr" select="."/>
              <xsl:element name="waarde">
                <xsl:attribute name="naam" select="fn:string-join($w:tr/w:tc[1]//w:t)"/>
                <xsl:value-of select="fn:string-join($w:tr/w:tc[2]//w:t)"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="ow_activiteit">
        <xsl:for-each select="$comments[contains(fn:string-join(w:tbl[1]/w:tr[1]/w:tc[1]//w:t),'Activiteit')]">
          <xsl:variable name="w:tbl" select="./w:tbl[1]"/>
          <xsl:element name="item">
            <xsl:attribute name="id" select="./@w:id"/>
            <xsl:for-each select="for $counter in 2 to count($w:tbl/w:tr[not(descendant::w:tbl)]) return $w:tbl/w:tr[$counter]">
              <xsl:variable name="w:tr" select="."/>
              <xsl:element name="waarde">
                <xsl:attribute name="naam" select="fn:string-join($w:tr/w:tc[1]//w:t)"/>
                <xsl:value-of select="fn:string-join($w:tr/w:tc[2]//w:t)"/>
              </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="for $counter in 2 to count($w:tbl/w:tr/descendant::w:tbl/w:tr) return $w:tbl/w:tr/descendant::w:tbl/w:tr[$counter]">
              <xsl:variable name="w:tr" select="."/>
              <xsl:element name="waarde">
                <xsl:attribute name="naam" select="fn:string-join($w:tr/w:tc[1]//w:t)"/>
                <xsl:value-of select="fn:string-join($w:tr/w:tc[2]//w:t)"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:variable>

      <xsl:element name="sl:stand">
        <xsl:element name="ow-dc:owObject">
          <xsl:element name="r:Regeltekst">
            <xsl:element name="r:identificatie">
              <xsl:value-of select="concat('nl.imow-',$D12,'.regeltekst.',fn:format-date(current-date(),'[Y0001]'),fn:format-number($index,'000000'))"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="sl:stand">
        <xsl:element name="ow-dc:owObject">
          <xsl:element name="r:RegelVoorIedereen">
            <xsl:element name="r:identificatie">
              <xsl:value-of select="concat('nl.imow-',$D12,'.juridischeregel.',fn:format-date(current-date(),'[Y0001]'),fn:format-number($index,'000000'))"/>
            </xsl:element>
            <xsl:element name="r:idealisatie">
              <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/idealisatie/id/concept/Exact')"/>
            </xsl:element>
            <xsl:element name="r:artikelOfLid">
              <xsl:element name="r:RegeltekstRef">
                <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.regeltekst.',fn:format-date(current-date(),'[Y0001]'),fn:format-number($index,'000000'))"/>
              </xsl:element>
            </xsl:element>
            <xsl:for-each select="$ow_thema/item">
              <xsl:element name="r:thema">
                <xsl:value-of select="string(./waarde[@naam='thema'])"/>
              </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$ow_locatie/item">
              <xsl:element name="r:locatieaanduiding">
                <xsl:for-each select="fn:tokenize(./waarde[@naam='bestandsnaam'],';\s*')">
                  <xsl:element name="l:LocatieRef">
                    <xsl:attribute name="xlink:href" select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$ow_gebiedsaanwijzing/item">
              <xsl:element name="r:gebiedsaanwijzing">
                <xsl:element name="ga:GebiedsaanwijzingRef">
                  <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.gebiedsaanwijzing.',fn:format-date(current-date(),'[Y0001]'),fn:format-number(./@id,'000000'))"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$ow_activiteit/item">
              <xsl:variable name="item" select="."/>
              <xsl:for-each select="fn:tokenize($item/waarde[@naam='activiteiten'],';\s*')">
                <xsl:variable name="index" select="position()"/>
                <xsl:element name="r:activiteitaanduiding">
                  <xsl:element name="rol:ActiviteitRef">
                    <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.activiteit.',fn:format-number($item/@id,'000000'),fn:format-number($index,'00'))"/>
                  </xsl:element>
                  <xsl:element name="r:ActiviteitLocatieaanduiding">
                    <xsl:element name="r:identificatie">
                      <xsl:value-of select="concat('nl.imow-',$D12,'.activiteitlocatieaanduiding.',fn:format-date(current-date(),'[Y0001]'),fn:format-number($item/@id,'000000'),fn:format-number($index,'00'))"/>
                    </xsl:element>
                    <xsl:element name="r:activiteitregelkwalificatie">
                      <xsl:value-of select="$item/waarde[@naam='activiteitregelkwalificatie']"/>
                    </xsl:element>
                    <xsl:element name="r:locatieaanduiding">
                      <xsl:for-each select="fn:tokenize($item/waarde[@naam='geometrie'],';\s*')">
                        <xsl:element name="l:LocatieRef">
                          <xsl:attribute name="xlink:href" select="."/>
                        </xsl:element>
                      </xsl:for-each>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:for-each select="$ow_locatie/item">
        <xsl:element name="sl:stand">
          <xsl:element name="ow-dc:owObject">
            <xsl:element name="l:Gebied">
              <xsl:element name="l:identificatie">
                <xsl:value-of select="concat('nl.imow-',$D12,'.gebied.',fn:format-date(current-date(),'[Y0001]'),fn:format-number(./@id,'000000'))"/>
              </xsl:element>
              <xsl:element name="l:noemer">
                <xsl:value-of select="string(./waarde[@naam='noemer'])"/>
              </xsl:element>
              <xsl:element name="l:geometrie">
                <xsl:element name="l:GeometrieRef">
                  <xsl:attribute name="xlink:href" select="string(./waarde[@naam='bestandsnaam'])"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="$ow_gebiedsaanwijzing/item">
        <xsl:element name="sl:stand">
          <xsl:element name="ow-dc:owObject">
            <xsl:element name="ga:Gebiedsaanwijzing">
              <xsl:element name="ga:identificatie">
                <xsl:value-of select="concat('nl.imow-',$D12,'.gebiedsaanwijzing.',fn:format-date(current-date(),'[Y0001]'),fn:format-number(./@id,'000000'))"/>
              </xsl:element>
              <xsl:element name="ga:type">
                <xsl:value-of select="string(./waarde[@naam='type'])"/>
              </xsl:element>
              <xsl:element name="ga:naam">
                <xsl:value-of select="string(./waarde[@naam='waarde'])"/>
              </xsl:element>
              <xsl:element name="ga:groep">
                <xsl:value-of select="string(./waarde[@naam='groep'])"/>
              </xsl:element>
              <xsl:element name="r:locatieaanduiding">
                <xsl:for-each select="fn:tokenize(./waarde[@naam='geometrie'],';\s*')">
                  <xsl:element name="l:LocatieRef">
                    <xsl:attribute name="xlink:href" select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="$ow_activiteit/item">
        <xsl:variable name="item" select="."/>
        <xsl:for-each select="fn:tokenize($item/waarde[@naam='activiteiten'],';\s*')">
          <xsl:variable name="index" select="position()"/>
          <xsl:element name="sl:stand">
            <xsl:element name="ow-dc:owObject">
              <xsl:element name="rol:Activiteit">
                <xsl:element name="rol:identificatie">
                  <xsl:value-of select="concat('nl.imow-',$D12,'.activiteit.',fn:format-number($item/@id,'000000'),fn:format-number($index,'00'))"/>
                </xsl:element>
                <xsl:element name="rol:naam">
                  <xsl:value-of select="."/>
                </xsl:element>
                <xsl:element name="rol:groep">
                  <xsl:value-of select="string($item/waarde[@naam='activiteitengroep'])"/>
                </xsl:element>
                <xsl:comment><xsl:value-of select="string($item/waarde[@naam='bovenliggendeActiviteit'])"/></xsl:comment>
                <xsl:element name="rol:bovenliggendeActiviteit">
                  <xsl:element name="rol:ActiviteitRef">
                    <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.activiteit.','########')"/>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
      </xsl:for-each>

    </xsl:if>
  </xsl:template>

  <xsl:template name="ow_objecten_vrijetekst">
    <xsl:param name="comments"/>
    <xsl:param name="index"/>
    <xsl:if test="$comments">
      <xsl:variable name="ow_thema">
        <xsl:for-each select="$comments[contains(fn:string-join(w:tbl[1]/w:tr[1]/w:tc[1]//w:t),'Thema')]">
          <xsl:variable name="w:tbl" select="./w:tbl[1]"/>
          <xsl:element name="item">
            <xsl:attribute name="id" select="./@w:id"/>
            <xsl:for-each select="for $counter in 2 to count($w:tbl/w:tr) return $w:tbl/w:tr[$counter]">
              <xsl:variable name="w:tr" select="."/>
              <xsl:element name="waarde">
                <xsl:attribute name="naam" select="fn:string-join($w:tr/w:tc[1]//w:t)"/>
                <xsl:value-of select="fn:string-join($w:tr/w:tc[2]//w:t)"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="ow_hoofdlijn">
        <xsl:for-each select="$comments[contains(fn:string-join(w:tbl[1]/w:tr[1]/w:tc[1]//w:t),'Hoofdlijn')]">
          <xsl:variable name="w:tbl" select="./w:tbl[1]"/>
          <xsl:element name="item">
            <xsl:attribute name="id" select="./@w:id"/>
            <xsl:for-each select="for $counter in 2 to count($w:tbl/w:tr) return $w:tbl/w:tr[$counter]">
              <xsl:variable name="w:tr" select="."/>
              <xsl:element name="waarde">
                <xsl:attribute name="naam" select="fn:string-join($w:tr/w:tc[1]//w:t)"/>
                <xsl:value-of select="fn:string-join($w:tr/w:tc[2]//w:t)"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:variable>
      <xsl:element name="sl:stand">
        <xsl:element name="ow-dc:owObject">
          <xsl:element name="vt:Divisie">
            <xsl:element name="vt:identificatie">
              <xsl:value-of select="concat('nl.imow-',$D12,'.divisie.',fn:format-date(current-date(),'[Y0001]'),fn:format-number($index,'000000'))"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="sl:stand">
        <xsl:element name="ow-dc:owObject">
          <xsl:element name="vt:Tekstdeel">
            <xsl:element name="vt:identificatie">
              <xsl:value-of select="concat('nl.imow-',$D12,'.tekstdeel.',fn:format-date(current-date(),'[Y0001]'),fn:format-number($index,'000000'))"/>
            </xsl:element>
            <xsl:element name="vt:idealisatie">
              <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/idealisatie/id/concept/Exact')"/>
            </xsl:element>
            <xsl:for-each select="$ow_thema/item">
              <xsl:element name="vt:thema">
                <xsl:value-of select="string(./waarde[@naam='thema'])"/>
              </xsl:element>
            </xsl:for-each>
            <xsl:element name="vt:divisieaanduiding">
              <xsl:element name="vt:DivisieRef">
                <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.divisie.',fn:format-date(current-date(),'[Y0001]'),fn:format-number($index,'000000'))"/>
              </xsl:element>
            </xsl:element>
            <xsl:for-each select="$ow_hoofdlijn/item">
              <xsl:element name="vt:hoofdlijnaanduiding">
                <xsl:element name="vt:HoofdlijnRef">
                  <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.hoofdlijn.',fn:format-date(current-date(),'[Y0001]'),fn:format-number(./@id,'000000'))"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:for-each select="$ow_hoofdlijn/item">
        <xsl:element name="sl:stand">
          <xsl:element name="ow-dc:owObject">
            <xsl:element name="vt:Hoofdlijn">
              <xsl:element name="vt:identificatie">
                <xsl:value-of select="concat('nl.imow-',$D12,'.hoofdlijn.',fn:format-date(current-date(),'[Y0001]'),fn:format-number(./@id,'000000'))"/>
              </xsl:element>
              <xsl:element name="vt:soort">
                <xsl:value-of select="string(./waarde[@naam='soort'])"/>
              </xsl:element>
              <xsl:element name="vt:naam">
                <xsl:value-of select="string(./waarde[@naam='naam'])"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>