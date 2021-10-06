<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:my="www.eigen.nl" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:digest="java:org.apache.commons.codec.digest.DigestUtils" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:xlink="http://www.w3.org/1999/xlink">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <xsl:param name="basedir" select="fn:substring-before(fn:base-uri(),'document.xml')"/>

  <xsl:include href="adler32.xslt"/>

  <xsl:param name="w:comments">
    <xsl:sequence select="collection(concat($basedir,'?select=comments.xml'))/w:comments/w:comment[w:tbl/w:tblPr/w:tblStyle/@w:val='Annotatie']"/>
  </xsl:param>
  <xsl:param name="w:styles" select="collection(concat($basedir,'?select=styles.xml'))/w:styles"/>

  <!-- OIN-lijst -->
  <xsl:param name="OIN" select="document('OIN.xml')//item"/>

  <!-- lees stijlen in -->
  <xsl:param name="title" select="$w:styles/w:style[w:name/@w:val='Title']/@w:styleId" as="xs:string"/>
  <xsl:param name="headings" select="$w:styles/w:style[fn:matches(w:name/@w:val,'heading\s[1-7]')]/@w:styleId"/>
  <xsl:param name="heading_1" select="$headings[1]" as="xs:string"/>
  <xsl:param name="heading_2" select="$headings[2]" as="xs:string"/>
  <xsl:param name="heading_3" select="$headings[3]" as="xs:string"/>
  <xsl:param name="heading_4" select="$headings[4]" as="xs:string"/>
  <xsl:param name="heading_5" select="$headings[5]" as="xs:string"/>
  <xsl:param name="heading_6" select="$headings[6]" as="xs:string"/>
  <xsl:param name="heading_7" select="$headings[7]" as="xs:string"/>
  <xsl:param name="heading" select="translate($headings[1],'1','#')"/>

  <xsl:param name="check" select="($title,$heading_1,$heading_2,$heading_3,$heading_4,$heading_5,$heading_6,'Lidmetnummering','Divisiekop1','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7','Divisiekop8','Divisiekop9')"/>

  <!-- table of content bevat alle Titel, Artikel, Lid, Divisie -->
  <xsl:param name="TOC">
    <xsl:for-each select="//w:body/w:p[w:pPr/w:pStyle/@w:val=$check]">
      <xsl:element name="para">
        <xsl:attribute name="para" select="./@w14:paraId"/>
        <xsl:attribute name="style" select="./w:pPr/w:pStyle/@w:val"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- list of comments bevat alle comments met attribuut id is paraId van het bovenliggende Artikel, Lid, Divisie -->
  <xsl:param name="LOC">
    <xsl:for-each-group select="//w:body/element()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$check]">
      <xsl:variable name="comment_id" select="current-group()//(w:commentRangeStart,w:commentRangeEnd,w:commentReference)[1]/@w:id"/>
      <xsl:variable name="comment" select="$w:comments/w:comment[@w:id=$comment_id]"/>
      <xsl:for-each select="$comment">
        <xsl:variable name="w:tbl" select="./w:tbl"/>
        <xsl:variable name="id" select="current-group()[1]/self::w:p/@w14:paraId"/>
        <xsl:element name="comment">
          <xsl:attribute name="index" select="count(.|preceding-sibling::w:comment)"/>
          <xsl:choose>
            <xsl:when test="$TOC/para[./@para=$id]/@style=$heading_6 and $TOC/para[./@para=$id]/following-sibling::para[1]/@style='Lidmetnummering'">
              <!-- comment verhuist naar het eerste onderstaande lid -->
              <xsl:attribute name="para" select="$TOC/para[./@para=$id]/following-sibling::para[1]/@para"/>
              <xsl:attribute name="style" select="$TOC/para[./@para=$id]/following-sibling::para[1]/@style"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="para" select="$TOC/para[./@para=$id]/@para"/>
              <xsl:attribute name="style" select="$TOC/para[./@para=$id]/@style"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:element name="object">
            <xsl:attribute name="type" select="$w:tbl/w:tr[1]/w:tc[1]/lower-case(fn:string-join(descendant::w:t))"/>
            <xsl:for-each select="$w:tbl/w:tr[not(w:trPr)]">
              <xsl:choose>
                <xsl:when test="./w:trPr">
                  <!-- doe niets -->
                </xsl:when>
                <xsl:when test=".//w:tbl">
                  <!-- plaats het onderliggende object -->
                  <xsl:for-each select=".//w:tbl">
                    <xsl:variable name="w:tbl" select="."/>
                    <xsl:element name="object">
                      <xsl:attribute name="type" select="$w:tbl/w:tr[1]/w:tc[1]/lower-case(fn:string-join(descendant::w:t))"/>
                      <xsl:for-each select="$w:tbl/w:tr[not(w:trPr)]">
                        <!-- plaats de waarde -->
                        <xsl:variable name="w:tr" select="."/>
                        <xsl:for-each select="$w:tr/w:tc[2]/fn:tokenize(fn:string-join(descendant::w:t),';\s*')">
                          <xsl:element name="waarde">
                            <xsl:attribute name="naam" select="$w:tr/w:tc[1]/fn:string-join(descendant::w:t)"/>
                            <xsl:value-of select="."/>
                          </xsl:element>
                        </xsl:for-each>
                      </xsl:for-each>
                    </xsl:element>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <!-- plaats de waarde -->
                  <xsl:variable name="w:tr" select="."/>
                  <xsl:for-each select="$w:tr/w:tc[2]/fn:tokenize(fn:string-join(descendant::w:t),';\s*')">
                    <xsl:element name="waarde">
                      <xsl:attribute name="naam" select="$w:tr/w:tc[1]/fn:string-join(descendant::w:t)"/>
                      <xsl:value-of select="."/>
                    </xsl:element>
                  </xsl:for-each>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:param>

  <!-- unieke waarden -->
  <xsl:param name="unique_activiteit" as="xs:anyAtomicType*">
    <xsl:for-each-group select="$LOC/comment/object[@type='activiteit']" group-by="((waarde[@naam='activiteiten'],waarde[@naam='bovenliggendeActiviteit']),'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='bovenliggendeActiviteit'],'ActInOmgevingsplanGem')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='activiteitengroep'],'geen')[1]">
          <xsl:variable name="index_3" select="current-grouping-key()"/>
          <xsl:sequence select="fn:string-join(($index_1,$index_2,$index_3),'|')"/>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </xsl:param>
  <xsl:param name="unique_activiteit_locatie" as="xs:anyAtomicType*">
    <xsl:for-each-group select="$LOC/comment/object[@type='activiteit']" group-by="((waarde[@naam='activiteiten'],waarde[@naam='bovenliggendeActiviteit']),'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='bovenliggendeActiviteit'],'ActInOmgevingsplanGem')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='activiteitengroep'],'geen')[1]">
          <xsl:variable name="index_3" select="current-grouping-key()"/>
          <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='activiteitregelkwalificatie'],'geen')[1]">
            <xsl:variable name="index_4" select="current-grouping-key()"/>
            <xsl:sequence select="fn:string-join(($index_1,$index_2,$index_3,$index_4),'|')"/>
          </xsl:for-each-group>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </xsl:param>
  <xsl:param name="unique_gebiedsaanwijzing" as="xs:anyAtomicType*">
    <xsl:for-each-group select="$LOC/comment/object[@type='gebiedsaanwijzing']" group-by="(waarde[@naam='gebiedsaanwijzing'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='type'],'geen')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='groep'],'geen')[1]">
          <xsl:variable name="index_3" select="current-grouping-key()"/>
          <xsl:sequence select="fn:string-join(($index_1,$index_2,$index_3),'|')"/>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </xsl:param>
  <xsl:param name="unique_geometrie" as="xs:anyAtomicType*">
    <xsl:for-each-group select="$LOC/comment/object[@type='geometrie']" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:sequence select="fn:string-join(($index_1,$index_2),'|')"/>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </xsl:param>
  <xsl:param name="unique_hoofdlijn" as="xs:anyAtomicType*">
    <xsl:for-each-group select="$LOC/comment/object[@type='hoofdlijn']" group-by="(waarde[@naam='soort'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='naam'],'geen')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:sequence select="fn:string-join(($index_1,$index_2),'|')"/>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </xsl:param>
  <xsl:param name="unique_omgevingsnorm" as="xs:anyAtomicType*">
    <xsl:for-each-group select="$LOC/comment/object[@type='omgevingsnorm']" group-by="(waarde[@naam='omgevingsnorm'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='omgevingsnormgroep'],'geen')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='typeWaarde'],'geen')[1]">
          <xsl:variable name="index_3" select="current-grouping-key()"/>
          <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='kwalitatieveWaarde'],'geen')[1]">
            <xsl:variable name="index_4" select="current-grouping-key()"/>
            <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='waarde'],'geen')[1]">
              <xsl:variable name="index_5" select="current-grouping-key()"/>
              <xsl:sequence select="fn:string-join(($index_1,$index_2,$index_3,$index_4,$index_5),'|')"/>
            </xsl:for-each-group>
          </xsl:for-each-group>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </xsl:param>

  <!-- lees metadata work in -->
  <xsl:param name="D01" select="($LOC/comment/object[@type='document']/waarde[@naam='idWerk']/text(),'geen')[1]"/>
  <xsl:param name="D02" select="($LOC/comment/object[@type='document']/waarde[@naam='versieSTOP']/text(),'geen')[1]"/>
  <xsl:param name="D03" select="($LOC/comment/object[@type='document']/waarde[@naam='versieTPOD']/text(),'geen')[1]"/>
  <!-- lees metadata regeling in -->
  <xsl:param name="D04" select="($LOC/comment/object[@type='document']/waarde[@naam='officieleTitel']/text(),'geen')[1]"/>
  <xsl:param name="D05" select="($LOC/comment/object[@type='document']/waarde[@naam='citeertitel']/text(),'geen')[1]"/>
  <xsl:param name="D06" select="($LOC/comment/object[@type='document']/waarde[@naam='soortRegeling']/text(),'geen')[1]"/>
  <xsl:param name="D07" select="($LOC/comment/object[@type='document']/waarde[@naam='versieRegeling']/text(),'geen')[1]"/>
  <xsl:param name="D08" select="($LOC/comment/object[@type='document']/waarde[@naam='overheidsdomein']/text(),'geen')[1]"/>
  <xsl:param name="D09" select="tokenize(($LOC/comment/object[@type='document']/waarde[@naam='onderwerpen']/text(),'geen')[1],'\|')"/>
  <xsl:param name="D10" select="tokenize(($LOC/comment/object[@type='document']/waarde[@naam='rechtsgebieden']/text(),'geen')[1],',\|')"/>
  <!-- lees metadata organisatie in -->
  <xsl:param name="D11" select="($LOC/comment/object[@type='document']/waarde[@naam='soortOrganisatie']/text(),'geen')[1]"/>
  <xsl:param name="D12" select="tokenize(($LOC/comment/object[@type='document']/waarde[@naam='idOrganisatie']/text(),'geen')[1],'/')[last()]"/>
  <!-- stel gebied samen -->
  <xsl:param name="D13">
    <xsl:choose>
      <xsl:when test="$D11='ministerie'">
        <xsl:value-of select="string('Nederland')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$OIN[BG=fn:string-join(('','tooi','id',$D11,$D12),'/')]/naam"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <!-- lees ow_objecten_vrijetekst in -->
  <xsl:param name="ow_objecten_vrijetekst" select="$w:comments/w:comment[contains(('Gebiedsaanwijzing|Hoofdlijn|Thema'),fn:string-join(w:tbl[1]/w:tr[1]/w:tc[1]//w:t))]"/>

  <!-- belangrijke identifiers -->
  <xsl:param name="ID_bill_work" select="concat('/akn/nl/bill/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01)"/>
  <xsl:param name="ID_bill_expression" select="concat('/akn/nl/bill/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01,'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'),';',$D07)"/>
  <xsl:param name="ID_act_work" select="concat('/akn/nl/act/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01)"/>
  <xsl:param name="ID_act_expression" select="concat('/akn/nl/act/',$D12,'/',format-date(current-date(),'[Y0001]'),'/',$D01,'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'),';',$D07)"/>

  <!-- algemeen -->
  <xsl:template match="*">
    <!--xsl:comment><xsl:value-of select="concat('GW: ',name())"/></xsl:comment-->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- bouw het document op -->
  <xsl:template match="w:document">
    <xsl:element name="AanleveringBesluit">
      <xsl:namespace name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
      <xsl:namespace name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
      <xsl:namespace name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
      <xsl:namespace name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
      <xsl:namespace name="rg" select="string('http://www.geostandaarden.nl/imow/regelingsgebied')"/>
      <xsl:namespace name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
      <xsl:namespace name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
      <xsl:namespace name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
      <xsl:namespace name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
      <!-- geef informatie door aan AKN.xsl -->
      <xsl:processing-instruction name="akn">
        <xsl:value-of select="fn:string-join(($D12,$D07),'_')"/>
      </xsl:processing-instruction>
      <xsl:element name="sl:standBestand">
        <xsl:element name="sl:dataset">
          <xsl:value-of select="$D04"/>
        </xsl:element>
        <xsl:element name="sl:inhoud">
          <xsl:element name="sl:gebied">
            <xsl:value-of select="$D13"/>
          </xsl:element>
          <xsl:element name="sl:leveringsId">
            <xsl:value-of select="$D01"/>
          </xsl:element>
        </xsl:element>
        <xsl:call-template name="ow_objecten"/>
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
    <xsl:for-each-group select="$regeling/element()" group-ending-with="w:p[w:pPr/w:pStyle/@w:val=$title][1]">
      <xsl:choose>
        <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$title]">
          <xsl:element name="RegelingOpschrift">
            <xsl:apply-templates select="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$title]"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each-group select="current-group()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val='Divisiekop1nawerk'][1]">
            <xsl:choose>
              <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val='Divisiekop1nawerk']">
                <xsl:for-each-group select="current-group()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val='Divisiekop1nawerk']">
                  <!-- section_nawerk plaatst de vrijtekststructuur -->
                  <xsl:call-template name="section_nawerk">
                    <xsl:with-param name="group" select="current-group()"/>
                    <xsl:with-param name="index" select="1"/>
                  </xsl:call-template>
                </xsl:for-each-group>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="Lichaam">
                  <xsl:for-each-group select="current-group()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=($heading_1,'Divisiekop1')][1]">
                    <xsl:choose>
                      <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$heading_1]">
                        <!-- section_lichaam_artikel plaatst de artikelstructuur -->
                        <xsl:call-template name="section_lichaam_artikel">
                          <xsl:with-param name="group" select="current-group()"/>
                          <xsl:with-param name="index" select="1"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$heading_6]">
                        <xsl:element name="Conditie">
                          <!-- section_lichaam_artikel plaatst de artikelstructuur -->
                          <xsl:call-template name="section_lichaam_artikel">
                            <xsl:with-param name="group" select="current-group()"/>
                            <xsl:with-param name="index" select="6"/>
                          </xsl:call-template>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val='Divisiekop1']">
                        <!-- section_lichaam_vrijetekst plaatst de vrijtekststructuur -->
                        <xsl:call-template name="section_lichaam_vrijetekst">
                          <xsl:with-param name="group" select="current-group()"/>
                          <xsl:with-param name="index" select="1"/>
                        </xsl:call-template>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:for-each-group>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each-group>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:param name="section_lichaam_artikel_word" select="($heading_1,$heading_2,$heading_3,$heading_4,$heading_5,$heading_6,'Lidmetnummering')"/>
  <xsl:param name="section_lichaam_artikel_imop" select="('Hoofdstuk','Afdeling','Paragraaf','Subparagraaf','Subsubparagraaf','Artikel','Lid')"/>

  <xsl:template name="section_lichaam_artikel">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_lichaam_artikel_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/self::w:p/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:variable name="para" select="current-group()[1]/self::w:p/@w14:paraId"/>
      <xsl:choose>
        <xsl:when test="$styleId=$section_lichaam_artikel_word[$index]">
          <xsl:element name="{$section_lichaam_artikel_imop[$index]}">
            <xsl:call-template name="ow_regeltekst">
              <xsl:with-param name="para" select="$para"/>
            </xsl:call-template>
            <xsl:apply-templates select="current-group()[1]"/>
            <xsl:call-template name="section_lichaam_artikel">
              <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
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
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_nawerk_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/self::w:p/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:variable name="para" select="current-group()[1]/self::w:p/@w14:paraId"/>
      <xsl:choose>
        <xsl:when test="$styleId=fn:format-number($index,'Divisiekop#')">
          <xsl:element name="{$section_lichaam_vrijtekst_imop[$index]}">
            <xsl:call-template name="ow_vrijetekst">
              <xsl:with-param name="para" select="$para"/>
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

  <xsl:param name="section_nawerk_word" select="('Divisiekop1nawerk','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7','Divisiekop8','Divisiekop9')"/>
  <xsl:param name="section_nawerk_imop" select="('Bijlage|Motivering|Toelichting','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie')"/>

  <xsl:template name="section_nawerk">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_nawerk_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/self::w:p/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:choose>
        <xsl:when test="$styleId=fn:format-number($index,'Divisiekop#')">
          <xsl:element name="{$section_nawerk_imop[$index]}">
            <xsl:apply-templates select="current-group()[1]"/>
            <xsl:call-template name="section_nawerk">
              <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$index gt count($section_nawerk_word)">
          <!-- doe niets -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="section_nawerk">
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
      <xsl:when test="$styleId=($heading_1,$heading_2,$heading_3,$heading_4,$heading_5,$heading_6,$heading_7,'Divisiekop1','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7','Divisiekop8','Divisiekop9')">
        <xsl:element name="Kop">
          <xsl:choose>
            <xsl:when test="w:r[w:tab]">
              <xsl:for-each-group select="*" group-starting-with="(w:r[w:tab])[1]">
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
        <xsl:choose>
          <xsl:when test="w:r[w:tab]">
            <xsl:for-each-group select="*" group-starting-with="(w:r[w:tab])[1]">
              <xsl:if test="position()=1">
                <xsl:element name="LidNummer">
                  <xsl:value-of select="current-group()[last()]"/>
                </xsl:element>
              </xsl:if>
            </xsl:for-each-group>
          </xsl:when>
          <xsl:otherwise>
            <!-- doe niets -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- plaats de regeltekst-objecten -->

  <xsl:template name="ow_regeltekst">
    <xsl:param name="para"/>
    <xsl:variable name="objects">
      <xsl:sequence select="$LOC/comment[@para=$para]/object"/>
    </xsl:variable>
    <xsl:if test="$objects/object">
      <xsl:variable name="index_regeltekst" select="count(fn:distinct-values(($LOC/comment[@para=$para])[1]/preceding-sibling::comment/@para))"/>
      <xsl:element name="sl:stand">
        <xsl:element name="ow-dc:owObject">
          <xsl:element name="r:Regeltekst">
            <xsl:element name="r:identificatie">
              <xsl:value-of select="concat('nl.imow-',$D12,'.regeltekst.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_regeltekst,'000000'))"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="sl:stand">
        <xsl:element name="ow-dc:owObject">
          <xsl:element name="r:RegelVoorIedereen">
            <xsl:element name="r:identificatie">
              <xsl:value-of select="concat('nl.imow-',$D12,'.juridischeregel.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_regeltekst,'000000'))"/>
            </xsl:element>
            <xsl:element name="r:idealisatie">
              <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/idealisatie/id/concept/Exact')"/>
            </xsl:element>
            <xsl:element name="r:artikelOfLid">
              <xsl:element name="r:RegeltekstRef">
                <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.regeltekst.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_regeltekst,'000000'))"/>
              </xsl:element>
            </xsl:element>
            <xsl:if test="$objects/object[@type='thema']">
              <xsl:for-each select="fn:distinct-values($objects/object[@type='thema']/waarde[@naam='thema'])">
                <xsl:element name="r:thema">
                  <xsl:value-of select="string(.)"/>
                </xsl:element>
              </xsl:for-each>
            </xsl:if>
            <xsl:element name="r:locatieaanduiding">
              <xsl:for-each-group select="$objects/(object[@type='geometrie'],descendant::object[@type='locatie'])" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
                <xsl:variable name="index_1" select="current-grouping-key()"/>
                <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
                  <xsl:variable name="index_2" select="current-grouping-key()"/>
                  <xsl:variable name="hash_geometrie">
                    <xsl:call-template name="adler32">
                      <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:element name="l:LocatieRef">
                    <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.gebied.',$hash_geometrie)"/>
                  </xsl:element>
                </xsl:for-each-group>
              </xsl:for-each-group>
            </xsl:element>
            <xsl:if test="$objects/object[@type='gebiedsaanwijzing']">
              <xsl:element name="r:gebiedsaanwijzing">
                <xsl:for-each-group select="$objects/object[@type='gebiedsaanwijzing']" group-by="(waarde[@naam='gebiedsaanwijzing'],'geen')[1]">
                  <xsl:variable name="index_1" select="current-grouping-key()"/>
                  <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='type'],'geen')[1]">
                    <xsl:variable name="index_2" select="current-grouping-key()"/>
                    <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='groep'],'geen')[1]">
                      <xsl:variable name="index_3" select="current-grouping-key()"/>
                      <xsl:variable name="hash_gebiedsaanwijzing">
                        <xsl:call-template name="adler32">
                          <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3),'|')"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:element name="ga:GebiedsaanwijzingRef">
                        <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.gebiedsaanwijzing.',$hash_gebiedsaanwijzing)"/>
                      </xsl:element>
                    </xsl:for-each-group>
                  </xsl:for-each-group>
                </xsl:for-each-group>
              </xsl:element>
            </xsl:if>
            <xsl:if test="$objects/object[@type='activiteit']">
              <xsl:for-each-group select="$objects/object[@type='activiteit']" group-by="((waarde[@naam='activiteiten'],waarde[@naam='bovenliggendeActiviteit']),'geen')[1]">
                <xsl:variable name="index_1" select="current-grouping-key()"/>
                <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='bovenliggendeActiviteit'],'ActInOmgevingsplanGem')[1]">
                  <xsl:variable name="index_2" select="current-grouping-key()"/>
                  <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='activiteitengroep'],'geen')[1]">
                    <xsl:variable name="index_3" select="current-grouping-key()"/>
                    <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='activiteitregelkwalificatie'],'geen')[1]">
                      <xsl:variable name="index_4" select="current-grouping-key()"/>
                      <xsl:variable name="hash_activiteit">
                        <xsl:call-template name="adler32">
                          <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3),'|')"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:variable name="hash_activiteit_locatieaanduiding">
                        <xsl:call-template name="adler32">
                          <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3,$index_4),'|')"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:element name="r:activiteitaanduiding">
                        <xsl:element name="rol:ActiviteitRef">
                          <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.activiteit.',$hash_activiteit)"/>
                        </xsl:element>
                        <xsl:element name="r:ActiviteitLocatieaanduiding">
                          <xsl:element name="r:identificatie">
                            <xsl:value-of select="concat('nl.imow-',$D12,'.activiteitlocatieaanduiding.',$hash_activiteit_locatieaanduiding)"/>
                          </xsl:element>
                          <xsl:element name="r:activiteitregelkwalificatie">
                            <xsl:value-of select="$index_4"/>
                          </xsl:element>
                          <xsl:element name="r:locatieaanduiding">
                            <xsl:for-each-group select="current-group()/object[@type='locatie']" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
                              <xsl:variable name="index_1" select="current-grouping-key()"/>
                              <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
                                <xsl:variable name="index_2" select="current-grouping-key()"/>
                                <xsl:variable name="hash_geometrie">
                                  <xsl:call-template name="adler32">
                                    <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                                  </xsl:call-template>
                                </xsl:variable>
                                <xsl:element name="l:LocatieRef">
                                  <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.gebied.',$hash_geometrie)"/>
                                </xsl:element>
                              </xsl:for-each-group>
                            </xsl:for-each-group>
                          </xsl:element>
                        </xsl:element>
                      </xsl:element>
                    </xsl:for-each-group>
                  </xsl:for-each-group>
                </xsl:for-each-group>
              </xsl:for-each-group>
            </xsl:if>
            <xsl:if test="$objects/object[@type='omgevingsnorm']">
              <xsl:element name="r:omgevingsnormaanduiding">
                <xsl:for-each-group select="$objects/object[@type='omgevingsnorm']" group-by="(waarde[@naam='omgevingsnorm'],'geen')[1]">
                  <xsl:variable name="index_1" select="current-grouping-key()"/>
                  <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='omgevingsnormgroep'],'geen')[1]">
                    <xsl:variable name="index_2" select="current-grouping-key()"/>
                    <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='typeWaarde'],'geen')[1]">
                      <xsl:variable name="index_3" select="current-grouping-key()"/>
                      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='kwalitatieveWaarde'],'geen')[1]">
                        <xsl:variable name="index_4" select="current-grouping-key()"/>
                        <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='waarde'],'geen')[1]">
                          <xsl:variable name="index_5" select="current-grouping-key()"/>
                          <xsl:variable name="hash_omgevingsnorm">
                            <xsl:call-template name="adler32">
                              <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3,$index_4,$index_5),'|')"/>
                            </xsl:call-template>
                          </xsl:variable>
                          <xsl:element name="rol:OmgevingsnormRef">
                            <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.omgevingsnorm.',$hash_omgevingsnorm)"/>
                          </xsl:element>
                        </xsl:for-each-group>
                      </xsl:for-each-group>
                    </xsl:for-each-group>
                  </xsl:for-each-group>
                </xsl:for-each-group>
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template name="ow_vrijetekst">
    <xsl:param name="para"/>
    <xsl:variable name="objects">
      <xsl:sequence select="$LOC/comment[@para=$para]/object"/>
    </xsl:variable>
    <xsl:if test="$objects/object">
      <xsl:variable name="index_divisie" select="count(fn:distinct-values(($LOC/comment[@para=$para])[1]/preceding-sibling::comment/@para))"/>
      <xsl:element name="sl:stand">
        <xsl:element name="ow-dc:owObject">
          <xsl:element name="vt:Divisie">
            <xsl:element name="vt:identificatie">
              <xsl:value-of select="concat('nl.imow-',$D12,'.divisie.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_divisie,'000000'))"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="sl:stand">
        <xsl:element name="ow-dc:owObject">
          <xsl:element name="vt:Tekstdeel">
            <xsl:element name="vt:identificatie">
              <xsl:value-of select="concat('nl.imow-',$D12,'.tekstdeel.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_divisie,'000000'))"/>
            </xsl:element>
            <xsl:element name="vt:idealisatie">
              <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/idealisatie/id/concept/Exact')"/>
            </xsl:element>
            <xsl:if test="$objects/object[@type='thema']">
              <xsl:for-each select="fn:distinct-values($objects/object[@type='thema']/waarde[@naam='thema'])">
                <xsl:element name="r:thema">
                  <xsl:value-of select="string(.)"/>
                </xsl:element>
              </xsl:for-each>
            </xsl:if>
            <xsl:element name="vt:divisieaanduiding">
              <xsl:element name="vt:DivisieRef">
                <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.divisie.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_divisie,'000000'))"/>
              </xsl:element>
            </xsl:element>
            <xsl:if test="$objects/object[@type='geometrie']">
              <xsl:element name="vt:locatieaanduiding">
                <xsl:for-each-group select="$objects/object[@type='geometrie']" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
                  <xsl:variable name="index_1" select="current-grouping-key()"/>
                  <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
                    <xsl:variable name="index_2" select="current-grouping-key()"/>
                    <xsl:variable name="hash_geometrie">
                      <xsl:call-template name="adler32">
                        <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:element name="l:LocatieRef">
                      <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.gebied.',$hash_geometrie)"/>
                    </xsl:element>
                  </xsl:for-each-group>
                </xsl:for-each-group>
              </xsl:element>
            </xsl:if>
            <xsl:if test="$objects/object[@type='gebiedsaanwijzing']">
              <xsl:element name="vt:gebiedsaanwijzing">
                <xsl:for-each-group select="$objects/object[@type='gebiedsaanwijzing']" group-by="(waarde[@naam='gebiedsaanwijzing'],'geen')[1]">
                  <xsl:variable name="index_1" select="current-grouping-key()"/>
                  <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='type'],'geen')[1]">
                    <xsl:variable name="index_2" select="current-grouping-key()"/>
                    <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='groep'],'geen')[1]">
                      <xsl:variable name="index_3" select="current-grouping-key()"/>
                      <xsl:variable name="hash_gebiedsaanwijzing">
                        <xsl:call-template name="adler32">
                          <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3),'|')"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:element name="ga:GebiedsaanwijzingRef">
                        <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.gebiedsaanwijzing.',$hash_gebiedsaanwijzing)"/>
                      </xsl:element>
                    </xsl:for-each-group>
                  </xsl:for-each-group>
                </xsl:for-each-group>
              </xsl:element>
            </xsl:if>
            <xsl:if test="$objects/object[@type='hoofdlijn']">
              <xsl:element name="vt:hoofdlijnaanduiding">
                <xsl:for-each-group select="$LOC/comment/object[@type='hoofdlijn']" group-by="(waarde[@naam='soort'],'geen')[1]">
                  <xsl:variable name="index_1" select="current-grouping-key()"/>
                  <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='naam'],'geen')[1]">
                    <xsl:variable name="index_2" select="current-grouping-key()"/>
                    <xsl:variable name="hash_hoofdlijn">
                      <xsl:call-template name="adler32">
                        <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:element name="vt:HoofdlijnRef">
                      <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.hoofdlijn.',$hash_hoofdlijn)"/>
                    </xsl:element>
                  </xsl:for-each-group>
                </xsl:for-each-group>
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- plaats de ow-objecten -->

  <xsl:template name="ow_objecten">
    <!--xsl:variable name="unique_activiteit" select="fn:distinct-values($LOC/comment/object[@type='activiteit']/waarde[@naam='activiteiten']/fn:tokenize(.,';\s*'))"/>
    <xsl:variable name="unique_gebiedsaanwijzing" select="fn:distinct-values($LOC/comment/object[@type='gebiedsaanwijzing']/waarde[@naam='gebiedsaanwijzing'])"/>
    <xsl:variable name="unique_geometrie" select="fn:distinct-values($LOC/comment/object[@type='geometrie']/waarde[@naam='bestandsnaam']/fn:tokenize(.,';\s*'))"/>
    <xsl:variable name="unique_hoofdlijn" select="fn:distinct-values($LOC/comment/object[@type='hoofdlijn']/fn:string-join(waarde,'_'))"/>
    <xsl:variable name="unique_omgevingsnorm" select="fn:distinct-values($LOC/comment/object[@type='omgevingsnorm']/waarde[@naam='omgevingsnorm'])"/-->
    <!-- activiteit -->
    <xsl:for-each-group select="$LOC/comment/object[@type='activiteit']" group-by="((waarde[@naam='activiteiten'],waarde[@naam='bovenliggendeActiviteit']),'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='bovenliggendeActiviteit'],'ActInOmgevingsplanGem')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='activiteitengroep'],'geen')[1]">
          <xsl:variable name="index_3" select="current-grouping-key()"/>
          <xsl:variable name="hash_activiteit">
            <xsl:call-template name="adler32">
              <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3),'|')"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:element name="sl:stand">
            <xsl:element name="ow-dc:owObject">
              <xsl:element name="rol:Activiteit">
                <xsl:element name="rol:identificatie">
                  <xsl:value-of select="concat('nl.imow-',$D12,'.activiteit.',$hash_activiteit)"/>
                </xsl:element>
                <xsl:element name="rol:naam">
                  <xsl:value-of select="string($index_1)"/>
                </xsl:element>
                <xsl:element name="rol:groep">
                  <xsl:value-of select="string($index_3)"/>
                </xsl:element>
                <xsl:element name="rol:bovenliggendeActiviteit">
                  <xsl:variable name="bovenliggendeActiviteit" select="($LOC/comment/object[@type='activiteit'][waarde[@naam='activiteiten']=$index_2][not(waarde[@naam='bovenliggendeActiviteit'])])[1]"/>
                  <xsl:variable name="hash_bovenliggendeActiviteit">
                    <xsl:call-template name="adler32">
                      <xsl:with-param name="text" select="fn:string-join(($index_2,'ActInOmgevingsplanGem',$bovenliggendeActiviteit/waarde[@naam='activiteitengroep']))"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:comment><xsl:value-of select="$index_2"/></xsl:comment>
                  <xsl:element name="rol:ActiviteitRef">
                    <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.activiteit.',$hash_bovenliggendeActiviteit)"/>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:for-each-group>
    <!-- ambtsgebied -->
    <xsl:element name="sl:stand">
      <xsl:element name="ow-dc:owObject">
        <xsl:element name="l:Ambtsgebied">
          <xsl:element name="l:identificatie">
            <xsl:value-of select="fn:upper-case($D12)"/>
          </xsl:element>
          <xsl:element name="l:noemer">
            <xsl:value-of select="$D13"/>
          </xsl:element>
          <xsl:element name="l:domein">
            <xsl:value-of select="string('NL.BI.BestuurlijkGebied')"/>
          </xsl:element>
          <xsl:element name="l:geldigOp">
            <xsl:value-of select="string('2021-01-01')"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
    <!-- gebiedsaanwijzing -->
    <xsl:for-each-group select="$LOC/comment/object[@type='gebiedsaanwijzing']" group-by="(waarde[@naam='gebiedsaanwijzing'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='type'],'geen')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='groep'],'geen')[1]">
          <xsl:variable name="index_3" select="current-grouping-key()"/>
          <xsl:variable name="hash_gebiedsaanwijzing">
            <xsl:call-template name="adler32">
              <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3),'|')"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:element name="sl:stand">
            <xsl:element name="ow-dc:owObject">
              <xsl:element name="ga:Gebiedsaanwijzing">
                <xsl:element name="ga:identificatie">
                  <xsl:value-of select="concat('nl.imow-',$D12,'.gebiedsaanwijzing.',$hash_gebiedsaanwijzing)"/>
                </xsl:element>
                <xsl:element name="ga:type">
                  <xsl:value-of select="string($index_2)"/>
                </xsl:element>
                <xsl:element name="ga:naam">
                  <xsl:value-of select="string($index_1)"/>
                </xsl:element>
                <xsl:element name="ga:groep">
                  <xsl:value-of select="string($index_3)"/>
                </xsl:element>
                <xsl:element name="ga:locatieaanduiding">
                  <xsl:for-each-group select="current-group()/object[@type='locatie']" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
                    <xsl:variable name="index_1" select="current-grouping-key()"/>
                    <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
                      <xsl:variable name="index_2" select="current-grouping-key()"/>
                      <xsl:variable name="hash_geometrie">
                        <xsl:call-template name="adler32">
                          <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:element name="l:LocatieRef">
                        <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.gebied.',$hash_geometrie)"/>
                      </xsl:element>
                    </xsl:for-each-group>
                  </xsl:for-each-group>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:for-each-group>
    <!-- geometrie -->
    <xsl:for-each-group select="$LOC/comment/(object[@type='geometrie'],descendant::object[@type='locatie'])" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:variable name="hash_geometrie">
          <xsl:call-template name="adler32">
            <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:element name="sl:stand">
          <xsl:element name="ow-dc:owObject">
            <xsl:comment><xsl:value-of select="string($index_1)"/></xsl:comment>
            <xsl:element name="l:Gebied">
              <xsl:element name="l:identificatie">
                <xsl:value-of select="concat('nl.imow-',$D12,'.gebied.',$hash_geometrie)"/>
              </xsl:element>
              <xsl:element name="l:noemer">
                <xsl:value-of select="string($index_2)"/>
              </xsl:element>
              <xsl:element name="l:geometrie">
                <xsl:element name="l:GeometrieRef">
                  <xsl:attribute name="xlink:href" select="string('[guid]')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each-group>
    </xsl:for-each-group>
    <!-- hoofdlijn -->
    <xsl:for-each-group select="$LOC/comment/object[@type='hoofdlijn']" group-by="(waarde[@naam='soort'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='naam'],'geen')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:variable name="hash_hoofdlijn">
          <xsl:call-template name="adler32">
            <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:element name="sl:stand">
          <xsl:element name="ow-dc:owObject">
            <xsl:element name="vt:Hoofdlijn">
              <xsl:element name="vt:identificatie">
                <xsl:value-of select="concat('nl.imow-',$D12,'.hoofdlijn.',$hash_hoofdlijn)"/>
              </xsl:element>
              <xsl:element name="vt:soort">
                <xsl:value-of select="string($index_1)"/>
              </xsl:element>
              <xsl:element name="vt:naam">
                <xsl:value-of select="string($index_2)"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each-group>
    </xsl:for-each-group>
    <!-- omgevingsnorm -->
    <xsl:for-each-group select="$LOC/comment/object[@type='omgevingsnorm']" group-by="(waarde[@naam='omgevingsnorm'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='omgevingsnormgroep'],'geen')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='typeWaarde'],'geen')[1]">
          <xsl:variable name="index_3" select="current-grouping-key()"/>
          <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='kwalitatieveWaarde'],'geen')[1]">
            <xsl:variable name="index_4" select="current-grouping-key()"/>
            <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='waarde'],'geen')[1]">
              <xsl:variable name="index_5" select="current-grouping-key()"/>
              <xsl:variable name="hash_omgevingsnorm">
                <xsl:call-template name="adler32">
                  <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3,$index_4,$index_5),'|')"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:element name="sl:stand">
                <xsl:element name="ow-dc:owObject">
                  <xsl:element name="rol:Omgevingsnorm">
                    <xsl:element name="rol:identificatie">
                      <xsl:value-of select="concat('nl.imow-',$D12,'.omgevingsnorm.',$hash_omgevingsnorm)"/>
                    </xsl:element>
                    <xsl:element name="rol:naam">
                      <xsl:value-of select="string($index_1)"/>
                    </xsl:element>
                    <xsl:element name="rol:groep">
                      <xsl:value-of select="string($index_2)"/>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:for-each-group>
          </xsl:for-each-group>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:for-each-group>
    <!-- regelingsgebied -->
    <xsl:element name="sl:stand">
      <xsl:element name="ow-dc:owObject">
        <xsl:element name="rg:Regelingsgebied">
          <xsl:element name="rg:identificatie">
            <xsl:value-of select="concat('nl.imow-',$D12,'.regelingsgebied.',fn:format-date(current-date(),'[Y0001][M01][D01]'),'000001')"/>
          </xsl:element>
          <xsl:element name="rg:locatieaanduiding">
            <xsl:call-template name="regelingsgebied"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- bepaal het regelingsgebied -->

  <xsl:template name="regelingsgebied">
    <xsl:variable name="geometrie" select="fn:distinct-values(($LOC/comment/object[@type='geometrie'][waarde[@naam='regelingsgebied']=('Waar','True')]/waarde[@naam='bestandsnaam']/fn:tokenize(.,';\s*'),'geen'))[1]"/>
    <xsl:variable name="index_geometrie" select="fn:index-of($unique_geometrie,$geometrie)"/>
    <xsl:choose>
      <xsl:when test="$index_geometrie gt 0">
        <xsl:element name="l:LocatieRef">
          <xsl:attribute name="xlink:href" select="concat('nl.imow-',$D12,'.gebied.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_geometrie,'000000'))"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="l:AmbtsgebiedRef">
          <xsl:attribute name="domein" select="string('NL.BI.BestuurlijkGebied')"/>
          <xsl:attribute name="xlink:href" select="fn:upper-case($D12)"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>