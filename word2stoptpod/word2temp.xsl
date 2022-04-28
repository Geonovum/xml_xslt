<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wx="http://schemas.microsoft.com/office/word/2006/auxHint" xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture" xmlns:uuid="java.util.UUID" exclude-result-prefixes="uuid">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <xsl:param name="basedir" select="fn:substring-before(fn:base-uri(),'document.xml')"/>

  <xsl:include href="adler32.xslt"/>

  <xsl:param name="w:comments">
    <xsl:sequence select="collection(concat($basedir,'?select=comments.xml'))/w:comments/w:comment[w:tbl/w:tblPr/w:tblStyle/@w:val='Annotatie']"/>
  </xsl:param>
  <xsl:param name="w:styles" select="collection(concat($basedir,'?select=styles.xml'))/w:styles"/>
  <xsl:param name="w:footnotes" select="collection(concat($basedir,'?select=footnotes.xml'))/w:footnotes"/>
  <xsl:param name="w:relationships" select="collection(concat($basedir,'?select=document.xml.rels;recurse=yes'))/Relationships" xpath-default-namespace="http://schemas.openxmlformats.org/package/2006/relationships"/>

  <!-- namespace opdracht -->
  <xsl:param name="opdracht" select="string('http://www.overheid.nl/2017/lvbb')"/>
  <!-- namespaces OP -->
  <xsl:param name="data" select="string('https://standaarden.overheid.nl/stop/imop/data/')"/>
  <xsl:param name="dso" select="string('https://www.dso.nl/')"/>
  <xsl:param name="lvbb" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering/')"/>
  <xsl:param name="tekst" select="string('https://standaarden.overheid.nl/stop/imop/tekst/')"/>
  <!-- namespaces OW -->
  <xsl:param name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
  <xsl:param name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
  <xsl:param name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
  <xsl:param name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
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

  <!-- OIN-lijst -->
  <xsl:param name="OIN" select="document('OIN.xml')/lijst"/>

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

  <xsl:param name="check" select="($title,$heading_1,$heading_2,$heading_3,$heading_4,$heading_5,$heading_6,'Lidmetnummering','Divisiekop1','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7','Divisiekop8','Divisiekop9','Wijziging')"/>

  <!-- document bevat de tekst van het besluit in relevante onderdelen -->
  <xsl:param name="document">
    <!-- de eerste sectie is de tekst van het besluit, overige secties zijn teksten van één of meer regelingen -->
    <xsl:for-each-group select="//w:body/element()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$title][1]">
      <xsl:if test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$title]">
        <xsl:for-each-group select="current-group()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$title]">
          <xsl:choose>
            <xsl:when test="position() eq 1">
              <!-- besluitdeel -->
              <xsl:for-each-group select="current-group()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val='Divisiekop1nawerk']">
                <!-- het besluitdeel kan het besluit en een mogelijke bijlage (Bijlage, Motivering, Toelichting) bevatten -->
                <xsl:choose>
                  <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val='Divisiekop1nawerk']">
                    <xsl:element name="bijlage">
                      <xsl:attribute name="id" select="fn:string-join(('bijlage',position()),'_')"/>
                      <xsl:attribute name="index" select="position()"/>
                      <xsl:copy-of select="current-group()"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:element name="besluit">
                      <xsl:attribute name="id" select="fn:string-join(('besluit',position()),'_')"/>
                      <xsl:attribute name="index" select="position()"/>
                      <xsl:copy-of select="current-group()"/>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each-group>
            </xsl:when>
            <xsl:when test="position() gt 1">
              <!-- het regelingdeel is regeling, regelingdeel of regelingmutatie -->
              <xsl:variable name="index" select="position()-1"/>
              <xsl:element name="regeling">
                <xsl:attribute name="id" select="fn:string-join(('regeling',$index),'_')"/>
                <xsl:attribute name="index" select="$index"/>
                <xsl:copy-of select="current-group()"/>
              </xsl:element>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each-group>
      </xsl:if>
    </xsl:for-each-group>
  </xsl:param>

  <!-- table of content bevat alle Titel, Artikel, Lid, Divisie -->
  <xsl:param name="TOC">
    <xsl:for-each select="$document/(besluit,regeling,bijlage)/w:p[w:pPr/w:pStyle/@w:val=$check]">
      <xsl:element name="para">
        <xsl:attribute name="para" select="./@w14:paraId"/>
        <xsl:attribute name="style" select="./w:pPr/w:pStyle/@w:val"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- list of comments bevat alle comments met attribuut id is paraId van het bovenliggende Artikel, Lid, Divisie -->
  <xsl:param name="LOC">
    <xsl:for-each-group select="$document/(besluit,regeling,bijlage)/element()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$check]">
      <xsl:variable name="comment_id" select="current-group()//(w:commentRangeStart,w:commentRangeEnd,w:commentReference)[1]/@w:id"/>
      <xsl:variable name="comment" select="$w:comments/w:comment[@w:id=$comment_id]"/>
      <xsl:variable name="parent_type" select="./parent::element()/name()"/>
      <xsl:variable name="parent_index" select="./parent::element()/@index" as="xs:integer"/>
      <xsl:for-each select="$comment">
        <xsl:variable name="w:tbl" select="./w:tbl"/>
        <xsl:variable name="id" select="current-group()[1]/self::w:p/@w14:paraId"/>
        <xsl:element name="comment">
          <xsl:attribute name="parent_id" select="fn:string-join(($parent_type,$parent_index),'_')"/>
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
  <xsl:param name="unique_geometrie">
    <xsl:variable name="metadata" select="$LOC/comment/object[@type=('besluit')]"/>
    <xsl:variable name="bg_code_besluit" select="(fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'geen')[1]"/>
    <xsl:for-each-group select="$LOC/comment/object[@type='geometrie']" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:variable name="hash_geometrie">
          <xsl:call-template name="adler32">
            <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:element name="gio">
          <xsl:attribute name="id" select="fn:string-join(($index_1,$index_2),'|')"/>
          <xsl:element name="gml">
            <xsl:value-of select="$index_1"/>
          </xsl:element>
          <xsl:element name="noemer">
            <xsl:value-of select="$index_2"/>
          </xsl:element>
          <xsl:element name="join">
            <xsl:value-of select="concat('/join/id/regdata/',$bg_code_besluit,'/',format-date(current-date(),'[Y0001]'),'/',$hash_geometrie,'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'))"/>
          </xsl:element>
        </xsl:element>
      </xsl:for-each-group>
    </xsl:for-each-group>
  </xsl:param>

  <!-- algemeen -->
  <xsl:template match="*">
    <!--xsl:comment><xsl:value-of select="concat('GW: ',name())"/></xsl:comment-->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- bouw het document op -->
  <xsl:template match="w:document">
    <!-- verzamel alle op- en ow-objecten in stap_1.xml -->
    <xsl:element name="document">
      <xsl:for-each select="$document/besluit">
        <xsl:call-template name="lvbb_opdracht"/>
      </xsl:for-each>
      <xsl:for-each select="$document/regeling">
        <xsl:call-template name="ow_bestand"/>
      </xsl:for-each>
      <xsl:for-each select="$document/besluit">
        <xsl:call-template name="op_besluit"/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- LVBB -->

  <xsl:template name="lvbb_opdracht">
    <xsl:variable name="id" select="./@id"/>
    <xsl:variable name="metadata" select="$LOC/comment[@parent_id=$id]/object[@type=('besluit','procedure')]"/>
    <xsl:variable name="bg_code_besluit" select="(fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'geen')[1]"/>
    <xsl:variable name="oin_code_besluit" select="$OIN/item[fn:ends-with(BG,$bg_code_besluit)]/OIN"/>
    <xsl:variable name="oin_naam_besluit" select="$OIN/item[fn:ends-with(BG,$bg_code_besluit)]/naam"/>
    <xsl:element name="publicatieOpdracht" namespace="{$opdracht}">
      <xsl:element name="idLevering" namespace="{$opdracht}">
        <xsl:value-of select="fn:string-join(($metadata[@type=('besluit')]/waarde[@naam='idWerk'],format-date(current-date(),'[Y0001]-[M01]-[D01]')),'_')"/>
      </xsl:element>
      <xsl:element name="idBevoegdGezag" namespace="{$opdracht}">
        <xsl:value-of select="$oin_code_besluit"/>
      </xsl:element>
      <xsl:element name="idAanleveraar" namespace="{$opdracht}">
        <xsl:value-of select="$oin_code_besluit"/>
      </xsl:element>
      <xsl:element name="publicatie" namespace="{$opdracht}">
        <xsl:value-of select="fn:string-join((fn:string-join(($metadata[@type=('besluit')]/waarde[@naam='idWerk'],format-date(current-date(),'[Y0001]-[M01]-[D01]')),'_'),'xml'),'.')"/>
      </xsl:element>
      <xsl:element name="datumBekendmaking" namespace="{$opdracht}">
        <xsl:value-of select="$metadata[@type=('procedure')]/waarde[@naam='inWerkingOp']"/>
        <!--xsl:value-of select="fn:format-date(current-date() + xs:dayTimeDuration('P1D'),'[Y0001]-[M01]-[D01]')"/-->
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- OW -->

  <xsl:template name="ow_bestand">
    <xsl:variable name="id" select="./@id"/>
    <xsl:variable name="metadata" select="($LOC/comment[@parent_id=$id]/object[@type=('regeling')],$LOC/comment/object[@type=('besluit')])"/>
    <xsl:variable name="bg_code_besluit" select="(fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'geen')[1]"/>
    <xsl:variable name="bg_code_regeling" select="(fn:tokenize($metadata[@type=('regeling')]/waarde[@naam='idOrganisatie'],'/')[last()],$bg_code_besluit,'geen')[1]"/>
    <xsl:variable name="oin_code_regeling" select="$OIN/item[fn:ends-with(BG,$bg_code_regeling)]/OIN"/>
    <xsl:variable name="oin_naam_regeling" select="$OIN/item[fn:ends-with(BG,$bg_code_regeling)]/naam"/>
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
      <xsl:element name="sl:standBestand" namespace="{$sl}">
        <xsl:element name="sl:dataset" namespace="{$sl}">
          <xsl:value-of select="($metadata[@type=('regeling')]/waarde[@naam='officieleTitel'],$metadata[@type=('besluit')]/waarde[@naam='officieleTitel'],'geen')[1]"/>
        </xsl:element>
        <xsl:element name="sl:inhoud" namespace="{$sl}">
          <xsl:element name="sl:gebied" namespace="{$sl}">
            <xsl:value-of select="($oin_naam_regeling,'geen')[1]"/>
          </xsl:element>
          <xsl:element name="sl:leveringsId" namespace="{$sl}">
            <xsl:value-of select="fn:string-join((($metadata[@type=('besluit')]/waarde[@naam='idWerk'],'geen')[1],format-date(current-date(),'[Y0001]-[M01]-[D01]')),'_')"/>
          </xsl:element>
        </xsl:element>
        <xsl:call-template name="ow_objecten"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template name="ow_objecten">
    <xsl:variable name="id" select="./@id"/>
    <xsl:variable name="metadata" select="($LOC/comment[@parent_id=$id]/object[@type=('regeling')],$LOC/comment/object[@type=('besluit')])"/>
    <xsl:variable name="bg_code_besluit" select="(fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'geen')[1]"/>
    <xsl:variable name="bg_code_regeling" select="(fn:tokenize($metadata[@type=('regeling')]/waarde[@naam='idOrganisatie'],'/')[last()],$bg_code_besluit,'geen')[1]"/>
    <xsl:variable name="oin_code_regeling" select="$OIN/item[fn:ends-with(BG,$bg_code_regeling)]/OIN"/>
    <xsl:variable name="oin_naam_regeling" select="$OIN/item[fn:ends-with(BG,$bg_code_regeling)]/naam"/>
    <!-- activiteit -->
    <xsl:for-each-group select="$LOC/comment[@parent_id=$id]/object[@type='activiteit']" group-by="((waarde[@naam='activiteiten'],waarde[@naam='bovenliggendeActiviteit']),'geen')[1]">
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
          <xsl:element name="sl:stand" namespace="{$sl}">
            <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
              <xsl:element name="rol:Activiteit" namespace="{$rol}">
                <xsl:element name="rol:identificatie" namespace="{$rol}">
                  <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.activiteit.',$oin_code_regeling,$hash_activiteit)"/>
                </xsl:element>
                <xsl:element name="rol:naam" namespace="{$rol}">
                  <xsl:value-of select="string($index_1)"/>
                </xsl:element>
                <xsl:element name="rol:groep" namespace="{$rol}">
                  <xsl:value-of select="string($index_3)"/>
                </xsl:element>
                <xsl:element name="rol:bovenliggendeActiviteit" namespace="{$rol}">
                  <xsl:variable name="bovenliggendeActiviteit" select="($LOC/comment[@parent_id=$id]/object[@type='activiteit'][waarde[@naam='activiteiten']=$index_2][not(waarde[@naam='bovenliggendeActiviteit'])])[1]"/>
                  <xsl:variable name="hash_bovenliggendeActiviteit">
                    <xsl:call-template name="adler32">
                      <xsl:with-param name="text" select="fn:string-join(($index_2,'ActInOmgevingsplanGem',$bovenliggendeActiviteit/waarde[@naam='activiteitengroep']))"/>
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:comment><xsl:value-of select="$index_2"/></xsl:comment>
                  <xsl:element name="rol:ActiviteitRef" namespace="{$rol}">
                    <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.activiteit.',$oin_code_regeling,$hash_bovenliggendeActiviteit)" namespace="{$xlink}"/>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:for-each-group>
    <!-- ambtsgebied -->
    <xsl:element name="sl:stand" namespace="{$sl}">
      <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
        <xsl:element name="l:Ambtsgebied" namespace="{$l}">
          <xsl:element name="l:identificatie" namespace="{$l}">
            <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.ambtsgebied.',$oin_code_regeling)"/>
          </xsl:element>
          <xsl:element name="l:noemer" namespace="{$l}">
            <xsl:value-of select="$oin_naam_regeling"/>
          </xsl:element>
          <xsl:element name="l:bestuurlijkeGrenzenVerwijzing" namespace="{$l}">
            <xsl:element name="l:BestuurlijkeGrenzenVerwijzing" namespace="{$l}">
              <xsl:element name="l:bestuurlijkeGrenzenID" namespace="{$l}">
                <xsl:value-of select="fn:upper-case($bg_code_regeling)"/>
              </xsl:element>
              <xsl:element name="l:domein" namespace="{$l}">
                <xsl:value-of select="string('NL.BI.BestuurlijkGebied')"/>
              </xsl:element>
              <xsl:element name="l:geldigOp" namespace="{$l}">
                <xsl:value-of select="string('2021-01-01')"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
    <!-- gebiedsaanwijzing -->
    <xsl:for-each-group select="$LOC/comment[@parent_id=$id]/object[@type='gebiedsaanwijzing']" group-by="(waarde[@naam='waarde'],'geen')[1]">
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
          <xsl:element name="sl:stand" namespace="{$sl}">
            <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
              <xsl:element name="ga:Gebiedsaanwijzing" namespace="{$ga}">
                <xsl:element name="ga:identificatie" namespace="{$ga}">
                  <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.gebiedsaanwijzing.',$oin_code_regeling,$hash_gebiedsaanwijzing)"/>
                </xsl:element>
                <xsl:element name="ga:type" namespace="{$ga}">
                  <xsl:value-of select="string($index_2)"/>
                </xsl:element>
                <xsl:element name="ga:naam" namespace="{$ga}">
                  <xsl:value-of select="string($index_1)"/>
                </xsl:element>
                <xsl:element name="ga:groep" namespace="{$ga}">
                  <xsl:value-of select="string($index_3)"/>
                </xsl:element>
                <xsl:element name="ga:locatieaanduiding" namespace="{$ga}">
                  <xsl:for-each-group select="current-group()/object[@type='geometrie']" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
                    <xsl:variable name="index_1" select="current-grouping-key()"/>
                    <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
                      <xsl:variable name="index_2" select="current-grouping-key()"/>
                      <xsl:variable name="hash_geometrie">
                        <xsl:call-template name="adler32">
                          <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:element name="l:LocatieRef" namespace="{$l}">
                        <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.gebied.',$oin_code_regeling,$hash_geometrie)" namespace="{$xlink}"/>
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
    <xsl:for-each-group select="$LOC/comment[@parent_id=$id]/(object[@type='geometrie'],descendant::object[@type='geometrie'])" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:variable name="hash_geometrie">
          <xsl:call-template name="adler32">
            <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:element name="sl:stand" namespace="{$sl}">
          <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
            <xsl:comment><xsl:value-of select="string($index_1)"/></xsl:comment>
            <xsl:element name="l:Gebied" namespace="{$l}">
              <xsl:element name="l:identificatie" namespace="{$l}">
                <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.gebied.',$oin_code_regeling,$hash_geometrie)"/>
              </xsl:element>
              <xsl:element name="l:noemer" namespace="{$l}">
                <xsl:value-of select="string($index_2)"/>
              </xsl:element>
              <xsl:element name="l:geometrie" namespace="{$l}">
                <xsl:element name="l:GeometrieRef" namespace="{$l}">
                  <xsl:attribute name="xlink:href" select="uuid:randomUUID()" namespace="{$xlink}"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each-group>
    </xsl:for-each-group>
    <!-- hoofdlijn -->
    <xsl:for-each-group select="$LOC/comment[@parent_id=$id]/object[@type='hoofdlijn']" group-by="(waarde[@naam='soort'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='naam'],'geen')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:variable name="hash_hoofdlijn">
          <xsl:call-template name="adler32">
            <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:element name="sl:stand" namespace="{$sl}">
          <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
            <xsl:element name="vt:Hoofdlijn" namespace="{$vt}">
              <xsl:element name="vt:identificatie" namespace="{$vt}">
                <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.hoofdlijn.',$oin_code_regeling,$hash_hoofdlijn)"/>
              </xsl:element>
              <xsl:element name="vt:soort" namespace="{$vt}">
                <xsl:value-of select="string($index_1)"/>
              </xsl:element>
              <xsl:element name="vt:naam" namespace="{$vt}">
                <xsl:value-of select="string($index_2)"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each-group>
    </xsl:for-each-group>
    <!-- omgevingsnorm -->
    <xsl:for-each-group select="$LOC/comment[@parent_id=$id]/object[@type='omgevingsnorm']" group-by="(waarde[@naam='omgevingsnorm'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='omgevingsnormgroep'],'geen')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='typeNorm'],'geen')[1]">
          <xsl:variable name="index_3" select="current-grouping-key()"/>
          <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='eenheid'],'geen')[1]">
            <xsl:variable name="index_4" select="current-grouping-key()"/>
            <xsl:variable name="hash_omgevingsnorm">
              <xsl:call-template name="adler32">
                <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3,$index_4),'|')"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:element name="sl:stand" namespace="{$sl}">
              <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
                <xsl:element name="rol:Omgevingsnorm" namespace="{$rol}">
                  <xsl:element name="rol:identificatie" namespace="{$rol}">
                    <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.omgevingsnorm.',$oin_code_regeling,$hash_omgevingsnorm)"/>
                  </xsl:element>
                  <xsl:element name="rol:naam" namespace="{$rol}">
                    <xsl:value-of select="string($index_1)"/>
                  </xsl:element>
                  <xsl:element name="rol:type" namespace="{$rol}">
                    <xsl:value-of select="string($index_3)"/>
                  </xsl:element>
                  <xsl:if test="$index_4 ne 'geen'">
                    <xsl:element name="rol:eenheid" namespace="{$rol}">
                      <xsl:value-of select="string($index_4)"/>
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="rol:normwaarde" namespace="{$rol}">
                    <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='kwalitatieveWaarde'],'geen')[1]">
                      <xsl:variable name="index_1" select="current-grouping-key()"/>
                      <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='kwantitatieveWaarde'],'geen')[1]">
                        <xsl:variable name="index_2" select="current-grouping-key()"/>
                        <xsl:variable name="hash_omgevingsnorm">
                          <xsl:call-template name="adler32">
                            <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:element name="rol:Normwaarde" namespace="{$rol}">
                          <xsl:element name="rol:identificatie" namespace="{$rol}">
                            <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.normwaarde.',$oin_code_regeling,$hash_omgevingsnorm)"/>
                          </xsl:element>
                          <xsl:if test="$index_1 ne 'geen'">
                            <xsl:element name="rol:kwalitatieveWaarde" namespace="{$rol}">
                              <xsl:value-of select="string($index_1)"/>
                            </xsl:element>
                          </xsl:if>
                          <xsl:if test="$index_2 ne 'geen'">
                            <xsl:element name="rol:kwantitatieveWaarde" namespace="{$rol}">
                              <xsl:value-of select="string($index_2)"/>
                            </xsl:element>
                          </xsl:if>
                          <xsl:element name="rol:locatieaanduiding" namespace="{$rol}">
                            <xsl:for-each-group select="current-group()/object[@type='geometrie']" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
                              <xsl:variable name="index_1" select="current-grouping-key()"/>
                              <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
                                <xsl:variable name="index_2" select="current-grouping-key()"/>
                                <xsl:variable name="hash_geometrie">
                                  <xsl:call-template name="adler32">
                                    <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                                  </xsl:call-template>
                                </xsl:variable>
                                <xsl:element name="l:LocatieRef" namespace="{$l}">
                                  <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.gebied.',$oin_code_regeling,$hash_geometrie)" namespace="{$xlink}"/>
                                </xsl:element>
                              </xsl:for-each-group>
                            </xsl:for-each-group>
                          </xsl:element>
                        </xsl:element>
                      </xsl:for-each-group>
                    </xsl:for-each-group>
                  </xsl:element>
                  <xsl:element name="rol:groep" namespace="{$rol}">
                    <xsl:value-of select="string($index_2)"/>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:for-each-group>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:for-each-group>
    <!-- omgevingswaarde -->
    <xsl:for-each-group select="$LOC/comment[@parent_id=$id]/object[@type='omgevingswaarde']" group-by="(waarde[@naam='omgevingswaarde'],'geen')[1]">
      <xsl:variable name="index_1" select="current-grouping-key()"/>
      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='omgevingswaardegroep'],'geen')[1]">
        <xsl:variable name="index_2" select="current-grouping-key()"/>
        <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='typeNorm'],'geen')[1]">
          <xsl:variable name="index_3" select="current-grouping-key()"/>
          <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='eenheid'],'geen')[1]">
            <xsl:variable name="index_4" select="current-grouping-key()"/>
            <xsl:variable name="hash_omgevingswaarde">
              <xsl:call-template name="adler32">
                <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3,$index_4),'|')"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:element name="sl:stand" namespace="{$sl}">
              <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
                <xsl:element name="rol:Omgevingswaarde" namespace="{$rol}">
                  <xsl:element name="rol:identificatie" namespace="{$rol}">
                    <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.omgevingswaarde.',$oin_code_regeling,$hash_omgevingswaarde)"/>
                  </xsl:element>
                  <xsl:element name="rol:naam" namespace="{$rol}">
                    <xsl:value-of select="string($index_1)"/>
                  </xsl:element>
                  <xsl:element name="rol:type" namespace="{$rol}">
                    <xsl:value-of select="string($index_3)"/>
                  </xsl:element>
                  <xsl:if test="$index_4 ne 'geen'">
                    <xsl:element name="rol:eenheid" namespace="{$rol}">
                      <xsl:value-of select="string($index_4)"/>
                    </xsl:element>
                  </xsl:if>
                  <xsl:element name="rol:normwaarde" namespace="{$rol}">
                    <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='kwalitatieveWaarde'],'geen')[1]">
                      <xsl:variable name="index_1" select="current-grouping-key()"/>
                      <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='kwantitatieveWaarde'],'geen')[1]">
                        <xsl:variable name="index_2" select="current-grouping-key()"/>
                        <xsl:variable name="hash_omgevingswaarde">
                          <xsl:call-template name="adler32">
                            <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:element name="rol:Normwaarde" namespace="{$rol}">
                          <xsl:element name="rol:identificatie" namespace="{$rol}">
                            <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.normwaarde.',$oin_code_regeling,$hash_omgevingswaarde)"/>
                          </xsl:element>
                          <xsl:if test="$index_1 ne 'geen'">
                            <xsl:element name="rol:kwalitatieveWaarde" namespace="{$rol}">
                              <xsl:value-of select="string($index_1)"/>
                            </xsl:element>
                          </xsl:if>
                          <xsl:if test="$index_2 ne 'geen'">
                            <xsl:element name="rol:kwantitatieveWaarde" namespace="{$rol}">
                              <xsl:value-of select="string($index_2)"/>
                            </xsl:element>
                          </xsl:if>
                          <xsl:element name="rol:locatieaanduiding" namespace="{$rol}">
                            <xsl:for-each-group select="current-group()/object[@type='geometrie']" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
                              <xsl:variable name="index_1" select="current-grouping-key()"/>
                              <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
                                <xsl:variable name="index_2" select="current-grouping-key()"/>
                                <xsl:variable name="hash_geometrie">
                                  <xsl:call-template name="adler32">
                                    <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                                  </xsl:call-template>
                                </xsl:variable>
                                <xsl:element name="l:LocatieRef" namespace="{$l}">
                                  <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.gebied.',$oin_code_regeling,$hash_geometrie)" namespace="{$xlink}"/>
                                </xsl:element>
                              </xsl:for-each-group>
                            </xsl:for-each-group>
                          </xsl:element>
                        </xsl:element>
                      </xsl:for-each-group>
                    </xsl:for-each-group>
                  </xsl:element>
                  <xsl:element name="rol:groep" namespace="{$rol}">
                    <xsl:value-of select="string($index_2)"/>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:for-each-group>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </xsl:for-each-group>
    <!-- regelingsgebied -->
    <xsl:element name="sl:stand" namespace="{$sl}">
      <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
        <xsl:element name="rg:Regelingsgebied" namespace="{$rg}">
          <xsl:element name="rg:identificatie" namespace="{$rg}">
            <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.regelingsgebied.',$oin_code_regeling)"/>
          </xsl:element>
          <xsl:element name="rg:locatieaanduiding" namespace="{$rg}">
            <xsl:variable name="geometrie" select="fn:distinct-values(($LOC/comment/object[@type='geometrie'][waarde[@naam='regelingsgebied']=('Waar','True')]/waarde[@naam='bestandsnaam']/fn:tokenize(.,';\s*'),'geen'))[1]"/>
            <xsl:variable name="index_geometrie" select="fn:index-of($unique_geometrie/gio/@id,$geometrie)"/>
            <xsl:choose>
              <xsl:when test="$index_geometrie gt 0">
                <xsl:element name="l:LocatieRef" namespace="{$l}">
                  <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.gebied.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_geometrie,'000000'))" namespace="{$xlink}"/>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="l:LocatieRef" namespace="{$l}">
                  <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.ambtsgebied.',$oin_code_regeling)" namespace="{$xlink}"/>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- plaats de regeltekst-objecten -->

  <xsl:template name="ow_regeltekst">
    <xsl:param name="para"/>
    <xsl:variable name="objects">
      <xsl:sequence select="$LOC/comment[@para=$para]/object"/>
    </xsl:variable>
    <xsl:variable name="id" select="ancestor::regeling/@id"/>
    <xsl:variable name="metadata" select="($LOC/comment[@parent_id=$id]/object[@type=('regeling')],$LOC/comment/object[@type=('besluit')])"/>
    <xsl:variable name="bg_code_besluit" select="(fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'geen')[1]"/>
    <xsl:variable name="bg_code_regeling" select="(fn:tokenize($metadata[@type=('regeling')]/waarde[@naam='idOrganisatie'],'/')[last()],$bg_code_besluit,'geen')[1]"/>
    <xsl:variable name="oin_code_regeling" select="$OIN/item[fn:ends-with(BG,$bg_code_regeling)]/OIN"/>
    <xsl:variable name="oin_naam_regeling" select="$OIN/item[fn:ends-with(BG,$bg_code_regeling)]/naam"/>
    <xsl:if test="$objects/object">
      <xsl:variable name="index_regeltekst" select="count(fn:distinct-values(($LOC/comment[@para=$para])[1]/preceding-sibling::comment/@para))"/>
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
        <xsl:element name="sl:standBestand" namespace="{$sl}">
          <xsl:element name="sl:dataset" namespace="{$sl}">
            <xsl:value-of select="($metadata[@type=('regeling')]/waarde[@naam='officieleTitel'],$metadata[@type=('besluit')]/waarde[@naam='officieleTitel'],'geen')[1]"/>
          </xsl:element>
          <xsl:element name="sl:inhoud" namespace="{$sl}">
            <xsl:element name="sl:gebied" namespace="{$sl}">
              <xsl:value-of select="($oin_naam_regeling,'geen')[1]"/>
            </xsl:element>
            <xsl:element name="sl:leveringsId" namespace="{$sl}">
              <xsl:value-of select="fn:string-join((($metadata[@type=('besluit')]/waarde[@naam='idWerk'],'geen')[1],format-date(current-date(),'[Y0001]-[M01]-[D01]')),'_')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element name="sl:stand" namespace="{$sl}">
            <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
              <xsl:element name="r:Regeltekst" namespace="{$r}">
                <xsl:element name="r:identificatie" namespace="{$r}">
                  <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.regeltekst.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_regeltekst,'000000'))"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          <xsl:element name="sl:stand" namespace="{$sl}">
            <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
              <xsl:element name="r:RegelVoorIedereen" namespace="{$r}">
                <xsl:element name="r:identificatie" namespace="{$r}">
                  <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.juridischeregel.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_regeltekst,'000000'))"/>
                </xsl:element>
                <xsl:element name="r:idealisatie" namespace="{$r}">
                  <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/idealisatie/id/concept/Exact')"/>
                </xsl:element>
                <xsl:element name="r:artikelOfLid" namespace="{$r}">
                  <xsl:element name="r:RegeltekstRef" namespace="{$r}">
                    <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.regeltekst.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_regeltekst,'000000'))" namespace="{$xlink}"/>
                  </xsl:element>
                </xsl:element>
                <xsl:if test="$objects/object[@type='thema']">
                  <xsl:for-each select="fn:distinct-values($objects/object[@type='thema']/waarde[@naam='thema'])">
                    <xsl:element name="r:thema" namespace="{$r}">
                      <xsl:value-of select="string(.)"/>
                    </xsl:element>
                  </xsl:for-each>
                </xsl:if>
                <xsl:element name="r:locatieaanduiding" namespace="{$r}">
                  <xsl:for-each-group select="$objects/(object[@type='geometrie'],descendant::object[@type='geometrie'])" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
                    <xsl:variable name="index_1" select="current-grouping-key()"/>
                    <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
                      <xsl:variable name="index_2" select="current-grouping-key()"/>
                      <xsl:variable name="hash_geometrie">
                        <xsl:call-template name="adler32">
                          <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                        </xsl:call-template>
                      </xsl:variable>
                      <xsl:element name="l:LocatieRef" namespace="{$l}">
                        <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.gebied.',$hash_geometrie)" namespace="{$xlink}"/>
                      </xsl:element>
                    </xsl:for-each-group>
                  </xsl:for-each-group>
                </xsl:element>
                <xsl:if test="$objects/object[@type='gebiedsaanwijzing']">
                  <xsl:element name="r:gebiedsaanwijzing" namespace="{$r}">
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
                          <xsl:element name="ga:GebiedsaanwijzingRef" namespace="{$ga}">
                            <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.gebiedsaanwijzing.',$hash_gebiedsaanwijzing)" namespace="{$xlink}"/>
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
                          <xsl:element name="r:activiteitaanduiding" namespace="{$r}">
                            <xsl:element name="rol:ActiviteitRef" namespace="{$rol}">
                              <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.activiteit.',$hash_activiteit)" namespace="{$xlink}"/>
                            </xsl:element>
                            <xsl:element name="r:ActiviteitLocatieaanduiding" namespace="{$r}">
                              <xsl:element name="r:identificatie" namespace="{$r}">
                                <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.activiteitlocatieaanduiding.',$hash_activiteit_locatieaanduiding)"/>
                              </xsl:element>
                              <xsl:element name="r:activiteitregelkwalificatie" namespace="{$r}">
                                <xsl:value-of select="$index_4"/>
                              </xsl:element>
                              <xsl:element name="r:locatieaanduiding" namespace="{$r}">
                                <xsl:for-each-group select="current-group()/object[@type='geometrie']" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
                                  <xsl:variable name="index_1" select="current-grouping-key()"/>
                                  <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
                                    <xsl:variable name="index_2" select="current-grouping-key()"/>
                                    <xsl:variable name="hash_geometrie">
                                      <xsl:call-template name="adler32">
                                        <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                                      </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:element name="l:LocatieRef" namespace="{$l}">
                                      <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.gebied.',$hash_geometrie)" namespace="{$xlink}"/>
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
                  <xsl:element name="r:omgevingsnormaanduiding" namespace="{$r}">
                    <xsl:for-each-group select="$objects/object[@type='omgevingsnorm']" group-by="(waarde[@naam='omgevingsnorm'],'geen')[1]">
                      <xsl:variable name="index_1" select="current-grouping-key()"/>
                      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='omgevingsnormgroep'],'geen')[1]">
                        <xsl:variable name="index_2" select="current-grouping-key()"/>
                        <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='typeNorm'],'geen')[1]">
                          <xsl:variable name="index_3" select="current-grouping-key()"/>
                          <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='eenheid'],'geen')[1]">
                            <xsl:variable name="index_4" select="current-grouping-key()"/>
                            <xsl:variable name="hash_omgevingsnorm">
                              <xsl:call-template name="adler32">
                                <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3,$index_4),'|')"/>
                              </xsl:call-template>
                            </xsl:variable>
                            <xsl:element name="rol:OmgevingsnormRef" namespace="{$rol}">
                              <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.omgevingsnorm.',$hash_omgevingsnorm)" namespace="{$xlink}"/>
                            </xsl:element>
                          </xsl:for-each-group>
                        </xsl:for-each-group>
                      </xsl:for-each-group>
                    </xsl:for-each-group>
                  </xsl:element>
                </xsl:if>
                <xsl:if test="$objects/object[@type='omgevingswaarde']">
                  <xsl:element name="r:omgevingswaardeaanduiding" namespace="{$r}">
                    <xsl:for-each-group select="$objects/object[@type='omgevingswaarde']" group-by="(waarde[@naam='omgevingswaarde'],'geen')[1]">
                      <xsl:variable name="index_1" select="current-grouping-key()"/>
                      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='omgevingswaardegroep'],'geen')[1]">
                        <xsl:variable name="index_2" select="current-grouping-key()"/>
                        <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='typeNorm'],'geen')[1]">
                          <xsl:variable name="index_3" select="current-grouping-key()"/>
                          <xsl:for-each-group select="current-group()" group-by="(object[@type='waarde']/waarde[@naam='eenheid'],'geen')[1]">
                            <xsl:variable name="index_4" select="current-grouping-key()"/>
                            <xsl:variable name="hash_omgevingswaarde">
                              <xsl:call-template name="adler32">
                                <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2,$index_3,$index_4),'|')"/>
                              </xsl:call-template>
                            </xsl:variable>
                            <xsl:element name="rol:OmgevingswaardeRef" namespace="{$rol}">
                              <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.omgevingswaarde.',$hash_omgevingswaarde)" namespace="{$xlink}"/>
                            </xsl:element>
                          </xsl:for-each-group>
                        </xsl:for-each-group>
                      </xsl:for-each-group>
                    </xsl:for-each-group>
                  </xsl:element>
                </xsl:if>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template name="ow_vrijetekst">
    <xsl:param name="objecttype"/>
    <xsl:param name="para"/>
    <xsl:variable name="objects">
      <xsl:sequence select="$LOC/comment[@para=$para]/object"/>
    </xsl:variable>
    <xsl:variable name="id" select="ancestor::regeling/@id"/>
    <xsl:variable name="metadata" select="($LOC/comment[@parent_id=$id]/object[@type=('regeling')],$LOC/comment/object[@type=('besluit')])"/>
    <xsl:variable name="bg_code_besluit" select="(fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'geen')[1]"/>
    <xsl:variable name="bg_code_regeling" select="(fn:tokenize($metadata[@type=('regeling')]/waarde[@naam='idOrganisatie'],'/')[last()],$bg_code_besluit,'geen')[1]"/>
    <xsl:variable name="oin_code_regeling" select="$OIN/item[fn:ends-with(BG,$bg_code_regeling)]/OIN"/>
    <xsl:variable name="oin_naam_regeling" select="$OIN/item[fn:ends-with(BG,$bg_code_regeling)]/naam"/>
    <xsl:if test="$objects/object">
      <xsl:variable name="index_divisie" select="count(fn:distinct-values(($LOC/comment[@para=$para])[1]/preceding-sibling::comment/@para))"/>
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
        <xsl:element name="sl:standBestand" namespace="{$sl}">
          <xsl:element name="sl:dataset" namespace="{$sl}">
            <xsl:value-of select="($metadata[@type=('regeling')]/waarde[@naam='officieleTitel_wordt'],$metadata[@type=('besluit')]/waarde[@naam='officieleTitel'],'geen')[1]"/>
          </xsl:element>
          <xsl:element name="sl:inhoud" namespace="{$sl}">
            <xsl:element name="sl:gebied" namespace="{$sl}">
              <xsl:value-of select="($oin_naam_regeling,'geen')[1]"/>
            </xsl:element>
            <xsl:element name="sl:leveringsId" namespace="{$sl}">
              <xsl:value-of select="fn:string-join((($metadata[@type=('besluit')]/waarde[@naam='idWerk'],'geen')[1],format-date(current-date(),'[Y0001]-[M01]-[D01]')),'_')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element name="sl:stand" namespace="{$sl}">
            <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
              <xsl:element name="{concat('vt:',$objecttype)}" namespace="{$vt}">
                <xsl:element name="vt:identificatie" namespace="{$vt}">
                  <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.',fn:lower-case($objecttype),'.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_divisie,'000000'))"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
          <xsl:element name="sl:stand" namespace="{$sl}">
            <xsl:element name="ow-dc:owObject" namespace="{$ow-dc}">
              <xsl:element name="vt:Tekstdeel" namespace="{$vt}">
                <xsl:element name="vt:identificatie" namespace="{$vt}">
                  <xsl:value-of select="concat('nl.imow-',$bg_code_besluit,'.tekstdeel.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_divisie,'000000'))"/>
                </xsl:element>
                <xsl:element name="vt:idealisatie" namespace="{$vt}">
                  <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/idealisatie/id/concept/Exact')"/>
                </xsl:element>
                <xsl:if test="$objects/object[@type='thema']">
                  <xsl:for-each select="fn:distinct-values($objects/object[@type='thema']/waarde[@naam='thema'])">
                    <xsl:element name="vt:thema" namespace="{$vt}">
                      <xsl:value-of select="string(.)"/>
                    </xsl:element>
                  </xsl:for-each>
                </xsl:if>
                <xsl:element name="vt:divisieaanduiding" namespace="{$vt}">
                  <xsl:element name="{concat('vt:',$objecttype,'Ref')}" namespace="{$vt}">
                    <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.',fn:lower-case($objecttype),'.',fn:format-date(current-date(),'[Y0001][M01][D01]'),fn:format-number($index_divisie,'000000'))" namespace="{$xlink}"/>
                  </xsl:element>
                </xsl:element>
                <xsl:if test="$objects/object[@type='hoofdlijn']">
                  <xsl:element name="vt:hoofdlijnaanduiding" namespace="{$vt}">
                    <xsl:for-each-group select="$LOC/comment/object[@type='hoofdlijn']" group-by="(waarde[@naam='soort'],'geen')[1]">
                      <xsl:variable name="index_1" select="current-grouping-key()"/>
                      <xsl:for-each-group select="current-group()" group-by="(waarde[@naam='naam'],'geen')[1]">
                        <xsl:variable name="index_2" select="current-grouping-key()"/>
                        <xsl:variable name="hash_hoofdlijn">
                          <xsl:call-template name="adler32">
                            <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:element name="vt:HoofdlijnRef" namespace="{$vt}">
                          <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.hoofdlijn.',$oin_code_regeling,$hash_hoofdlijn)" namespace="{$xlink}"/>
                        </xsl:element>
                      </xsl:for-each-group>
                    </xsl:for-each-group>
                  </xsl:element>
                </xsl:if>
                <xsl:if test="$objects/object[@type='geometrie']">
                  <xsl:element name="vt:locatieaanduiding" namespace="{$vt}">
                    <xsl:for-each-group select="$objects/object[@type='geometrie']" group-by="(waarde[@naam='bestandsnaam'],'geen')[1]">
                      <xsl:variable name="index_1" select="current-grouping-key()"/>
                      <xsl:for-each-group select="current-group()" group-by="waarde[@naam='noemer']">
                        <xsl:variable name="index_2" select="current-grouping-key()"/>
                        <xsl:variable name="hash_geometrie">
                          <xsl:call-template name="adler32">
                            <xsl:with-param name="text" select="fn:string-join(($index_1,$index_2),'|')"/>
                          </xsl:call-template>
                        </xsl:variable>
                        <xsl:element name="l:LocatieRef" namespace="{$l}">
                          <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.gebied.',$oin_code_regeling,$hash_geometrie)" namespace="{$xlink}"/>
                        </xsl:element>
                      </xsl:for-each-group>
                    </xsl:for-each-group>
                  </xsl:element>
                </xsl:if>
                <xsl:if test="$objects/object[@type='gebiedsaanwijzing']">
                  <xsl:element name="vt:gebiedsaanwijzing" namespace="{$vt}">
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
                          <xsl:element name="ga:GebiedsaanwijzingRef" namespace="{$ga}">
                            <xsl:attribute name="xlink:href" select="concat('nl.imow-',$bg_code_besluit,'.gebiedsaanwijzing.',$oin_code_regeling,$hash_gebiedsaanwijzing)" namespace="{$xlink}"/>
                          </xsl:element>
                        </xsl:for-each-group>
                      </xsl:for-each-group>
                    </xsl:for-each-group>
                  </xsl:element>
                </xsl:if>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- OP -->

  <xsl:template name="op_besluit">
    <xsl:variable name="id" select="./@id"/>
    <xsl:variable name="metadata" select="$LOC/comment[@parent_id=$id]/object[@type=('besluit','procedure')]"/>
    <xsl:variable name="idOrganisatie" select="fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()]"/>
    <xsl:variable name="idVersie" select="$metadata[@type=('besluit')]/waarde[@naam='versieBesluit']"/>
    <xsl:variable name="id_bill_work" select="concat('/akn/nl/bill/',$idOrganisatie,'/',format-date(current-date(),'[Y0001]'),'/',$metadata[@type=('besluit')]/waarde[@naam='idWerk'])"/>
    <xsl:variable name="id_bill_expression" select="concat('/akn/nl/bill/',$idOrganisatie,'/',format-date(current-date(),'[Y0001]'),'/',$metadata[@type=('besluit')]/waarde[@naam='idWerk'],'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'),';',$idVersie)"/>
    <xsl:element name="AanleveringBesluit" namespace="{$lvbb}">
      <xsl:namespace name="dso" select="string('https://www.dso.nl/')"/>
      <xsl:attribute name="schemaversie" select="string('1.2.0')"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering https://standaarden.overheid.nl/lvbb/1.2.0/lvbb-stop-aanlevering.xsd')"/>
      <!-- geef informatie door aan AKN.xsl -->
      <xsl:processing-instruction name="akn">
        <xsl:value-of select="fn:string-join(($idOrganisatie,$idVersie),'_')"/>
      </xsl:processing-instruction>
      <!-- BesluitVersie -->
      <xsl:element name="BesluitVersie" namespace="{$lvbb}">
        <!-- ExpressionIdentificatie -->
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
        <!-- BesluitMetadata -->
        <xsl:element name="BesluitMetadata" namespace="{$data}">
          <xsl:element name="eindverantwoordelijke" namespace="{$data}">
            <xsl:value-of select="$metadata[@type=('besluit')]/waarde[@naam='idOrganisatie']"/>
          </xsl:element>
          <xsl:element name="maker" namespace="{$data}">
            <xsl:value-of select="$metadata[@type=('besluit')]/waarde[@naam='idOrganisatie']"/>
          </xsl:element>
          <xsl:element name="soortBestuursorgaan" namespace="{$data}">
            <xsl:value-of select="$metadata[@type=('besluit')]/waarde[@naam='soortBestuursorgaan']"/>
          </xsl:element>
          <xsl:element name="officieleTitel" namespace="{$data}">
            <xsl:value-of select="$metadata[@type=('besluit')]/waarde[@naam='officieleTitel']"/>
          </xsl:element>
          <xsl:if test="normalize-space($metadata[@type=('besluit')]/waarde[@naam='citeertitel']) ne ''">
            <xsl:element name="heeftCiteertitelInformatie" namespace="{$data}">
              <xsl:element name="CiteertitelInformatie" namespace="{$data}">
                <xsl:element name="citeertitel" namespace="{$data}">
                  <xsl:value-of select="$metadata[@type=('besluit')]/waarde[@naam='citeertitel']"/>
                </xsl:element>
                <xsl:element name="isOfficieel" namespace="{$data}">
                  <xsl:value-of select="string('true')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:if>
          <xsl:element name="onderwerpen" namespace="{$data}">
            <xsl:for-each select="$metadata[@type=('besluit')]/waarde[@naam='onderwerpen']">
              <xsl:element name="onderwerp" namespace="{$data}">
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
          <xsl:element name="rechtsgebieden" namespace="{$data}">
            <xsl:for-each select="$metadata[@type=('besluit')]/waarde[@naam='rechtsgebieden']">
              <xsl:element name="rechtsgebied" namespace="{$data}">
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
          <xsl:element name="soortProcedure" namespace="{$data}">
            <xsl:value-of select="string('/join/id/stop/proceduretype_definitief')"/>
          </xsl:element>
          <xsl:if test="$unique_geometrie/gio">
            <xsl:element name="informatieobjectRefs" namespace="{$data}">
              <xsl:for-each select="$unique_geometrie/gio">
                <xsl:element name="informatieobjectRef" namespace="{$data}">
                  <xsl:value-of select="./join"/>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:if>
        </xsl:element>
        <!-- Procedure -->
        <xsl:element name="Procedureverloop" namespace="{$data}">
          <xsl:element name="bekendOp" namespace="{$data}">
            <xsl:value-of select="$metadata[@type=('procedure')]/waarde[@naam='bekendOp']"/>
          </xsl:element>
          <xsl:element name="ontvangenOp" namespace="{$data}">
            <xsl:value-of select="$metadata[@type=('procedure')]/waarde[@naam='ontvangenOp']"/>
          </xsl:element>
          <xsl:element name="procedurestappen" namespace="{$data}">
            <xsl:for-each select="$metadata[@type=('procedure')]/waarde[contains(@naam,'procedure')]">
              <xsl:element name="Procedurestap" namespace="{$data}">
                <xsl:element name="soortStap" namespace="{$data}">
                  <xsl:value-of select="@naam"/>
                </xsl:element>
                <xsl:element name="voltooidOp" namespace="{$data}">
                  <xsl:value-of select="text()"/>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
        <!-- ConsolidatieInformatie -->
        <xsl:element name="ConsolidatieInformatie" namespace="{$data}">
          <xsl:element name="BeoogdeRegelgeving" namespace="{$data}">
            <xsl:for-each select="$document/regeling">
              <xsl:variable name="id" select="./@id"/>
              <xsl:variable name="index" select="./@index"/>
              <xsl:element name="BeoogdeRegeling" namespace="{$data}">
                <xsl:element name="doelen" namespace="{$data}">
                  <xsl:element name="doel" namespace="{$data}">
                    <xsl:value-of select="concat('/join/id/proces/',fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'/',format-date(current-date(),'[Y0001]'),'/Instelling')"/>
                  </xsl:element>
                </xsl:element>
                <xsl:element name="instrumentVersie" namespace="{$data}">
                  <xsl:value-of select="concat('/akn/nl/act/',fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'/',format-date(current-date(),'[Y0001]'),'/',$metadata[@type=('besluit')]/waarde[@naam='idWerk'],'-',fn:format-number($index,'000'),'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'),';',$LOC/comment[@parent_id=$id]/object[@type=('regeling')]/waarde[@naam='versieRegeling_wordt'])"/>
                </xsl:element>
                <xsl:element name="eId" namespace="{$data}">
                  <xsl:comment>Geef aan welk artikel van het besluit verwijst naar de beoogde regeling. Let erop dat het artikel een IntRef naar de WijzigBijlage bevat.</xsl:comment>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="$unique_geometrie/gio">
              <xsl:element name="BeoogdInformatieobject" namespace="{$data}">
                <xsl:element name="doelen" namespace="{$data}">
                  <xsl:element name="doel" namespace="{$data}">
                    <xsl:value-of select="concat('/join/id/proces/',fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'/',format-date(current-date(),'[Y0001]'),'/Instelling')"/>
                  </xsl:element>
                </xsl:element>
                <xsl:element name="instrumentVersie" namespace="{$data}">
                  <xsl:value-of select="./join"/>
                </xsl:element>
                <xsl:element name="eId" namespace="{$data}"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
          <xsl:element name="Tijdstempels" namespace="{$data}">
            <xsl:element name="Tijdstempel" namespace="{$data}">
              <xsl:element name="doel" namespace="{$data}">
                <xsl:value-of select="concat('/join/id/proces/',fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'/',format-date(current-date(),'[Y0001]'),'/Instelling')"/>
              </xsl:element>
              <xsl:element name="soortTijdstempel" namespace="{$data}">
                <xsl:value-of select="string('juridischWerkendVanaf')"/>
              </xsl:element>
              <xsl:element name="datum" namespace="{$data}">
                <xsl:value-of select="$metadata[@type=('procedure')]/waarde[@naam='inWerkingOp']"/>
              </xsl:element>
              <xsl:element name="eId" namespace="{$data}">
                <xsl:comment>Geef aan in welk artikel van het besluit de inwerkingtreding wordt vastgesteld.</xsl:comment>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <!-- BesluitKlassiek, BesluitCompact -->
        <xsl:choose>
          <xsl:when test="$metadata[@type=('besluit')]/waarde[@naam='soortBesluit']=('BesluitCompact')">
            <xsl:call-template name="besluit_compact"/>
          </xsl:when>
          <xsl:when test="$metadata[@type=('besluit')]/waarde[@naam='soortBesluit']=('BesluitKlassiek')">
            <xsl:call-template name="besluit_klassiek"/>
          </xsl:when>
        </xsl:choose>
      </xsl:element>
      <xsl:for-each select="$document/regeling">
        <xsl:variable name="id" select="./@id"/>
        <xsl:variable name="index" select="./@index"/>
        <xsl:variable name="metadata" select="($LOC/comment/object[@type=('besluit')],$LOC/comment[@parent_id=$id]/object[@type=('regeling')],$LOC/comment[@parent_id=$id]/object[@type=('mutatie')])"/>
        <xsl:variable name="id_act_work" select="concat('/akn/nl/act/',fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'/',format-date(current-date(),'[Y0001]'),'/',$metadata[@type=('besluit')]/waarde[@naam='idWerk'],'-',fn:format-number($index,'000'))"/>
        <xsl:variable name="id_act_expression" select="concat('/akn/nl/act/',fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()],'/',format-date(current-date(),'[Y0001]'),'/',$metadata[@type=('besluit')]/waarde[@naam='idWerk'],'-',fn:format-number($index,'000'),'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'),';',$metadata[@type=('regeling')]/waarde[@naam='versieRegeling_wordt'])"/>
        <!-- RegelingVersieInformatie -->
        <xsl:element name="RegelingVersieInformatie" namespace="{$lvbb}">
          <!-- ExpressionIdentificatie -->
          <xsl:element name="ExpressionIdentificatie" namespace="{$data}">
            <xsl:element name="FRBRWork" namespace="{$data}">
              <xsl:value-of select="$id_act_work"/>
            </xsl:element>
            <xsl:element name="FRBRExpression" namespace="{$data}">
              <xsl:value-of select="$id_act_expression"/>
            </xsl:element>
            <xsl:element name="soortWork" namespace="{$data}">
              <xsl:value-of select="string('/join/id/stop/work_019')"/>
            </xsl:element>
            <xsl:choose>
              <xsl:when test="$metadata[@type=('regeling')]/waarde[@naam='soortRegeling_wordt']='RegelingTijdelijkdeel'">
                <xsl:element name="isTijdelijkDeelVan" namespace="{$data}">
                  <xsl:element name="WorkIdentificatie" namespace="{$data}">
                    <xsl:element name="FRBRWork" namespace="{$data}">
                      <xsl:value-of select="($metadata[@type=('regeling')]/waarde[@naam='aknRegeling_was'],'geen')[1]"/>
                    </xsl:element>
                    <xsl:element name="soortWork" namespace="{$data}">
                      <xsl:value-of select="($metadata[@type=('regeling')]/waarde[@naam='soortRegeling_was'],'geen')[1]"/>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:when>
              <xsl:when test="$metadata[@type=('mutatie')]">
                <xsl:variable name="test" select="$metadata[@type=('mutatie')]"/>
                <xsl:comment>test</xsl:comment>
              </xsl:when>
            </xsl:choose>
          </xsl:element>
          <!-- RegelingVersieMetadata -->
          <xsl:element name="RegelingVersieMetadata" namespace="{$data}">
            <xsl:element name="versienummer" namespace="{$data}">
              <xsl:value-of select="$metadata[@type=('regeling')]/waarde[@naam='versieRegeling_wordt']"/>
            </xsl:element>
          </xsl:element>
          <!-- RegelingMetadata -->
          <xsl:element name="RegelingMetadata" namespace="{$data}">
            <xsl:element name="soortRegeling" namespace="{$data}">
              <xsl:variable name="test" select="$metadata[@type=('regeling')]"/>
              <xsl:value-of select="$metadata[@type=('regeling')]/waarde[@naam='soortRegeling_wordt']"/>
            </xsl:element>
            <xsl:element name="eindverantwoordelijke" namespace="{$data}">
              <xsl:value-of select="$metadata[@type=('besluit')]/waarde[@naam='idOrganisatie']"/>
            </xsl:element>
            <xsl:element name="maker" namespace="{$data}">
              <xsl:value-of select="$metadata[@type=('besluit')]/waarde[@naam='idOrganisatie']"/>
            </xsl:element>
            <xsl:element name="soortBestuursorgaan" namespace="{$data}">
              <xsl:value-of select="$metadata[@type=('besluit')]/waarde[@naam='soortBestuursorgaan']"/>
            </xsl:element>
            <xsl:element name="officieleTitel" namespace="{$data}">
              <xsl:value-of select="($metadata[@type=('regeling')]/waarde[@naam='officieleTitel_wordt'],$metadata[@type=('besluit')]/waarde[@naam='officieleTitel'])[1]"/>
            </xsl:element>
            <xsl:if test="normalize-space(($metadata[@type=('regeling')]/waarde[@naam='citeertitel_wordt'],$metadata[@type=('besluit')]/waarde[@naam='citeertitel'])[1]) ne ''">
              <xsl:element name="heeftCiteertitelInformatie" namespace="{$data}">
                <xsl:element name="CiteertitelInformatie" namespace="{$data}">
                  <xsl:element name="citeertitel" namespace="{$data}">
                    <xsl:value-of select="($metadata[@type=('regeling')]/waarde[@naam='citeertitel_wordt'],$metadata[@type=('besluit')]/waarde[@naam='citeertitel'])[1]"/>
                  </xsl:element>
                  <xsl:element name="isOfficieel" namespace="{$data}">
                    <xsl:value-of select="string('true')"/>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:if>
            <xsl:element name="overheidsdomeinen" namespace="{$data}">
              <xsl:element name="overheidsdomein" namespace="{$data}">
                <xsl:value-of select="$metadata[@type=('besluit')]/waarde[@naam='overheidsdomein']"/>
              </xsl:element>
            </xsl:element>
            <xsl:element name="onderwerpen" namespace="{$data}">
              <xsl:for-each select="$metadata[@type=('besluit')]/waarde[@naam='onderwerpen']">
                <xsl:element name="onderwerp" namespace="{$data}">
                  <xsl:value-of select="."/>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
            <xsl:element name="rechtsgebieden" namespace="{$data}">
              <xsl:for-each select="$metadata[@type=('besluit')]/waarde[@naam='rechtsgebieden']">
                <xsl:element name="rechtsgebied" namespace="{$data}">
                  <xsl:value-of select="."/>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="besluit_klassiek">
    <xsl:element name="BesluitKlassiek" namespace="{$tekst}">
      <!-- verwerk alleen regelingen -->
      <xsl:for-each select="$document/regeling">
        <xsl:call-template name="regeling"/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="besluit_compact">
    <xsl:element name="BesluitCompact" namespace="{$tekst}">
      <xsl:for-each select="$document/besluit">
        <xsl:call-template name="besluit"/>
      </xsl:for-each>
      <xsl:for-each select="$document/regeling">
        <xsl:element name="WijzigBijlage" namespace="{$tekst}">
          <xsl:element name="Kop" namespace="{$tekst}">
            <xsl:element name="Label" namespace="{$tekst}">
              <xsl:value-of select="string('Bijlage')"/>
            </xsl:element>
            <xsl:element name="Nummer" namespace="{$tekst}">
              <xsl:number format="I"/>
            </xsl:element>
            <xsl:element name="Opschrift" namespace="{$tekst}">
              <xsl:value-of select="string('[Optioneel opschrift]')"/>
            </xsl:element>
          </xsl:element>
          <xsl:call-template name="regeling"/>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="$document/bijlage">
        <xsl:call-template name="besluit"/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="besluit">
    <xsl:for-each-group select="./element()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$heading_6][1]|w:p[w:pPr/w:pStyle/@w:val='Divisiekop1nawerk']">
      <xsl:choose>
        <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$title]">
          <xsl:for-each-group select="current-group()" group-adjacent="if (self::w:p/w:pPr/w:pStyle/@w:val=$title) then 'RegelingOpschrift' else 'Aanhef'">
            <xsl:element name="{current-grouping-key()}" namespace="{$tekst}">
              <xsl:call-template name="group_adjacent">
                <xsl:with-param name="group" select="current-group()"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$heading_6]">
          <xsl:element name="Lichaam" namespace="{$tekst}">
            <xsl:for-each-group select="current-group()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$heading_6]">
              <xsl:choose>
                <xsl:when test="current-group()/self::w:p/w:r[w:rPr/w:rStyle/@w:val='Wijzigbijlage']">
                  <xsl:element name="WijzigArtikel" namespace="{$tekst}">
                    <xsl:for-each-group select="current-group()" group-adjacent="if (self::w:p/w:pPr/w:pStyle/@w:val=$heading_6) then 'Kop' else 'Wat'">
                      <xsl:choose>
                        <xsl:when test="current-grouping-key()='Kop'">
                          <xsl:apply-templates select="current-group()"/>
                        </xsl:when>
                        <xsl:when test="current-grouping-key()='Wat'">
                          <xsl:element name="Wat" namespace="{$tekst}">
                            <xsl:apply-templates select="current-group()/node()"/>
                          </xsl:element>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each-group>
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:element name="Artikel" namespace="{$tekst}">
                    <xsl:for-each-group select="current-group()" group-adjacent="if (self::w:p/w:pPr/w:pStyle/@w:val=$heading_6) then 'Kop' else 'Inhoud'">
                      <xsl:choose>
                        <xsl:when test="current-grouping-key()='Kop'">
                          <xsl:apply-templates select="current-group()"/>
                        </xsl:when>
                        <xsl:when test="current-grouping-key()='Inhoud'">
                          <xsl:element name="Inhoud" namespace="{$tekst}">
                            <xsl:apply-templates select="current-group()"/>
                          </xsl:element>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each-group>
                  </xsl:element>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each-group>
          </xsl:element>
        </xsl:when>
        <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val='Divisiekop1nawerk']">
          <xsl:for-each-group select="current-group()" group-starting-with="w:p[w:pPr/w:pStyle/@w:val='Divisiekop1nawerk']">
            <!-- section_nawerk plaatst de vrijtekststructuur -->
            <xsl:call-template name="section_nawerk">
              <xsl:with-param name="group" select="current-group()"/>
              <xsl:with-param name="index" select="1"/>
            </xsl:call-template>
          </xsl:for-each-group>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <!-- maak de lijst van informatieobjecten -->
  <xsl:template name="ExtIoRef">
    <xsl:element name="Bijlage" namespace="{$tekst}">
      <xsl:element name="Kop" namespace="{$tekst}">
        <xsl:element name="Label" namespace="{$tekst}">
          <xsl:value-of select="string('Bijlage')"/>
        </xsl:element>
        <xsl:element name="Opschrift" namespace="{$tekst}">
          <xsl:value-of select="string('Overzicht van informatieobjecten')"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="Divisietekst" namespace="{$tekst}">
        <xsl:element name="Inhoud" namespace="{$tekst}">
          <xsl:comment><xsl:text>diagnose: controleer dat elke ExtIoRef een bijbehorend IntIoRef heeft</xsl:text></xsl:comment>
          <xsl:element name="Begrippenlijst" namespace="{$tekst}">
            <xsl:for-each select="$unique_geometrie/gio">
              <xsl:element name="Begrip" namespace="{$tekst}">
                <xsl:comment><xsl:value-of select="./gml"/></xsl:comment>
                <xsl:element name="Term" namespace="{$tekst}">
                  <xsl:value-of select="./noemer"/>
                </xsl:element>
                <xsl:element name="Definitie" namespace="{$tekst}">
                  <xsl:element name="Al" namespace="{$tekst}">
                    <xsl:element name="ExtIoRef" namespace="{$tekst}">
                      <xsl:attribute name="ref" select="./join"/>
                      <xsl:value-of select="./join"/>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- maak de regelingen (regeling, mutatie) -->
  <xsl:template name="regeling">
    <xsl:variable name="id" select="./@id"/>
    <xsl:variable name="index" select="./@index"/>
    <xsl:variable name="metadata" select="($LOC/comment/object[@type=('besluit')],$LOC/comment[@parent_id=$id]/object[@type=('regeling')],$LOC/comment[@parent_id=$id]/object[@type=('mutatie')])"/>
    <xsl:choose>
      <!-- regeling -->
      <xsl:when test="$metadata[@type='regeling']">
        <xsl:variable name="idOrganisatie" select="fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()]"/>
        <xsl:variable name="idVersie" select="$metadata[@type=('regeling')]/waarde[@naam='versieRegeling_wordt']"/>
        <xsl:element name="{$metadata[@type=('regeling')]/waarde[@naam='soortRegeling_wordt']}" namespace="{$tekst}">
          <xsl:attribute name="componentnaam" select="string('initieel_reg')"/>
          <xsl:attribute name="wordt" select="concat('/akn/nl/act/',$idOrganisatie,'/',format-date(current-date(),'[Y0001]'),'/',$metadata[@type=('besluit')]/waarde[@naam='idWerk'],'-',fn:format-number($index,'000'),'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'),';',$idVersie)"/>
          <!-- geef informatie door aan AKN.xsl -->
          <xsl:processing-instruction name="akn">
            <xsl:value-of select="fn:string-join(($idOrganisatie,$idVersie),'_')"/>
          </xsl:processing-instruction>
          <xsl:for-each-group select="./element()" group-ending-with="w:p[w:pPr/w:pStyle/@w:val=$title][1]">
            <xsl:choose>
              <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$title]">
                <xsl:element name="RegelingOpschrift" namespace="{$tekst}">
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
                      <xsl:element name="Lichaam" namespace="{$tekst}">
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
                              <xsl:element name="Conditie" namespace="{$tekst}">
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
          <xsl:if test="$unique_geometrie/gio">
            <xsl:call-template name="ExtIoRef"/>
          </xsl:if>
        </xsl:element>
      </xsl:when>
      <!-- mutatie -->
      <xsl:when test="$metadata[@type='mutatie']">
        <xsl:variable name="aknRegelingWas" select="$metadata[@type=('mutatie')]/waarde[@naam='aknRegeling_was']"/>
        <xsl:variable name="versieRegelingWas" select="$metadata[@type=('mutatie')]/waarde[@naam='versieRegeling_was']"/>
        <xsl:variable name="idOrganisatie" select="fn:tokenize($metadata[@type=('besluit')]/waarde[@naam='idOrganisatie'],'/')[last()]"/>
        <xsl:variable name="idVersie" select="$metadata[@type=('mutatie')]/waarde[@naam='versieRegeling_wordt']"/>
        <xsl:element name="RegelingMutatie" namespace="{$tekst}">
          <xsl:attribute name="componentnaam" select="string('mutatie_reg')"/>
          <xsl:attribute name="was" select="$aknRegelingWas"/>
          <xsl:attribute name="wordt" select="concat('/akn/nl/act/',$idOrganisatie,'/',format-date(current-date(),'[Y0001]'),'/',$metadata[@type=('besluit')]/waarde[@naam='idWerk'],'-',fn:format-number($index,'000'),'/nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'),';',$idVersie)"/>
          <!-- geef informatie door aan AKN.xsl -->
          <xsl:processing-instruction name="akn">
            <xsl:value-of select="fn:string-join(($idOrganisatie,$idVersie),'_')"/>
          </xsl:processing-instruction>
          <xsl:for-each-group select="./element()" group-ending-with="w:p[w:pPr/w:pStyle/@w:val=$title][1]">
            <!-- section_mutatie plaatst de mutatie -->
            <xsl:choose>
              <xsl:when test="current-group()/self::w:p[1][w:pPr/w:pStyle/@w:val=$title]">
                <!-- doe niets -->
              </xsl:when>
              <xsl:otherwise>
                <!-- dit ombouwen zodat dit ook voor vrijetekst werkt -->
                <xsl:call-template name="section_mutatie">
                  <xsl:with-param name="group" select="current-group()"/>
                  <xsl:with-param name="index" select="1"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each-group>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:param name="section_lichaam_artikel_word" select="($heading_1,$heading_2,$heading_3,$heading_4,$heading_5,$heading_6,'Lidmetnummering')"/>
  <xsl:param name="section_lichaam_artikel_imop" select="('Hoofdstuk','Afdeling','Paragraaf','Subparagraaf','Subsubparagraaf','Artikel','Lid')"/>

  <xsl:template name="section_lichaam_artikel">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_lichaam_artikel_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:variable name="para" select="current-group()[1]/self::w:p/@w14:paraId"/>
      <xsl:choose>
        <xsl:when test="$styleId=fn:format-number($index,$heading)">
          <xsl:element name="{$section_lichaam_artikel_imop[$index]}" namespace="{$tekst}">
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
        <xsl:when test="$styleId=$section_lichaam_artikel_word[$index]">
          <xsl:element name="Lid" namespace="{$tekst}">
            <xsl:call-template name="ow_regeltekst">
              <xsl:with-param name="para" select="$para"/>
            </xsl:call-template>
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

  <xsl:param name="section_lichaam_vrijtekst_word" select="('Divisiekop1','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7','Divisiekop8','Divisiekop9')"/>
  <xsl:param name="section_lichaam_vrijtekst_imop" select="('Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie')"/>

  <xsl:template name="section_lichaam_vrijetekst">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_lichaam_vrijtekst_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:variable name="para" select="current-group()[1]/self::w:p/@w14:paraId"/>
      <xsl:choose>
        <xsl:when test="$styleId=fn:format-number($index,'Divisiekop#')">
          <xsl:variable name="check" select="current-group()/w:pPr/w:pStyle[fn:index-of($section_lichaam_vrijtekst_word,@w:val) gt 0]/@w:val"/>
          <xsl:choose>
            <xsl:when test="count($check) eq 1">
              <xsl:element name="Divisietekst" namespace="{$tekst}">
                <xsl:attribute name="dso:niveau" namespace="{$dso}" select="$index"/>
                <xsl:call-template name="ow_vrijetekst">
                  <xsl:with-param name="objecttype" select="string('Divisietekst')"/>
                  <xsl:with-param name="para" select="$para"/>
                </xsl:call-template>
                <xsl:apply-templates select="current-group()[1]"/>
                <xsl:element name="Inhoud" namespace="{$tekst}">
                  <xsl:call-template name="group_adjacent">
                    <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
                  </xsl:call-template>
                </xsl:element>
              </xsl:element>
            </xsl:when>
            <xsl:when test="count($check) gt 1">
              <xsl:element name="{$section_lichaam_vrijtekst_imop[$index]}" namespace="{$tekst}">
                <xsl:attribute name="dso:niveau" namespace="{$dso}" select="$index"/>
                <xsl:call-template name="ow_vrijetekst">
                  <xsl:with-param name="objecttype" select="$section_lichaam_vrijtekst_imop[$index]"/>
                  <xsl:with-param name="para" select="$para"/>
                </xsl:call-template>
                <xsl:apply-templates select="current-group()[1]"/>
                <xsl:call-template name="section_lichaam_vrijetekst">
                  <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
                  <xsl:with-param name="index" select="$index+1"/>
                </xsl:call-template>
              </xsl:element>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$index gt count($section_lichaam_vrijtekst_word)">
          <xsl:element name="Divisietekst" namespace="{$tekst}">
            <xsl:element name="Inhoud" namespace="{$tekst}">
              <xsl:call-template name="group_adjacent">
                <xsl:with-param name="group" select="current-group()"/>
              </xsl:call-template>
            </xsl:element>
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

  <xsl:param name="section_nawerk_word" select="('Divisiekop1nawerk','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7','Divisiekop8','Divisiekop9')"/>
  <xsl:param name="section_nawerk_imop" select="('Bijlage|Motivering|Toelichting','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie','Divisie')"/>

  <xsl:template name="section_nawerk">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_nawerk_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:choose>
        <xsl:when test="$styleId='Divisiekop1nawerk'">
          <!-- aanpassen, deze selecteert altijd 'Bijlage' -->
          <xsl:element name="{fn:tokenize($section_nawerk_imop[$index],'\|')[1]}" namespace="{$tekst}">
            <xsl:attribute name="dso:niveau" namespace="{$dso}" select="$index"/>
            <xsl:apply-templates select="current-group()[1]"/>
            <xsl:call-template name="section_nawerk">
              <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="$styleId=fn:format-number($index,'Divisiekop#')">
          <xsl:variable name="check" select="current-group()/w:pPr/w:pStyle[fn:index-of($section_nawerk_word,@w:val) gt 0]/@w:val"/>
          <xsl:choose>
            <xsl:when test="count($check) eq 1">
              <xsl:element name="Divisietekst" namespace="{$tekst}">
                <xsl:attribute name="dso:niveau" namespace="{$dso}" select="$index"/>
                <xsl:apply-templates select="current-group()[1]"/>
                <xsl:element name="Inhoud" namespace="{$tekst}">
                  <xsl:call-template name="group_adjacent">
                    <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
                  </xsl:call-template>
                </xsl:element>
              </xsl:element>
            </xsl:when>
            <xsl:when test="count($check) gt 1">
              <xsl:element name="{$section_nawerk_imop[$index]}" namespace="{$tekst}">
                <xsl:attribute name="dso:niveau" namespace="{$dso}" select="$index"/>
                <xsl:apply-templates select="current-group()[1]"/>
                <xsl:call-template name="section_nawerk">
                  <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
                  <xsl:with-param name="index" select="$index+1"/>
                </xsl:call-template>
              </xsl:element>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$index gt count($section_nawerk_word)">
          <xsl:element name="Divisietekst" namespace="{$tekst}">
            <xsl:element name="Inhoud" namespace="{$tekst}">
              <xsl:call-template name="group_starting_with">
                <xsl:with-param name="group" select="current-group()"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:element>
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

  <xsl:template name="section_mutatie">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <!-- als $group een element wijziging is, dan met 'Vervang|Verwijder|VoegToe', anders is het een vervanging door een nieuwe initiële regeling -->
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$section_lichaam_artikel_word[$index]]">
      <xsl:variable name="styleId" select="(current-group()[1]/w:pPr/w:pStyle/@w:val,'Geen')[1]"/>
      <xsl:variable name="para" select="current-group()[1]/self::w:p/@w14:paraId"/>
      <xsl:choose>
        <xsl:when test="$styleId='Wijziging'">
          <xsl:variable name="metadata" select="$LOC/comment[@para=$para]/object[@type='wijziging']"/>
          <xsl:element name="{$metadata/waarde[@naam='soortWijziging']}" namespace="{$tekst}">
            <xsl:choose>
              <xsl:when test="$metadata/waarde[@naam='soortWijziging']=('Vervang','Verwijder')">
                <xsl:attribute name="wat" select="$metadata/waarde[@naam='wId']"/>
                <xsl:apply-templates select="current-group()[1]"/>
                <xsl:call-template name="section_lichaam_artikel">
                  <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
                  <xsl:with-param name="index" select="$index+1"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="$metadata/waarde[@naam='soortWijziging']=('VoegToe')">
                <xsl:attribute name="context" select="$metadata/waarde[@naam='wId']"/>
                <xsl:attribute name="positie" select="$metadata/waarde[@naam='positie']"/>
                <xsl:apply-templates select="current-group()[1]"/>
                <xsl:call-template name="section_lichaam_artikel">
                  <xsl:with-param name="group" select="fn:subsequence(current-group(),2)"/>
                  <xsl:with-param name="index" select="$index+1"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
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
    <xsl:for-each-group select="$group" group-adjacent="if (self::w:p[w:r/w:drawing]|self::w:p[contains(w:pPr/w:pStyle/@w:val,'Figuurbijschrift')]) then 'figuur' else if (self::w:tbl|self::w:p[contains(w:pPr/w:pStyle/@w:val,'Tabeltitel')]) then 'tabel' else if (self::w:p[fn:ends-with(fn:string-join(w:r/w:t),':')][contains(following-sibling::*[1]/w:pPr/w:pStyle/@w:val,'Opsommingmetnummering')]|self::w:p[contains(w:pPr/w:pStyle/@w:val,'Opsomming')]) then 'lijst' else 'standaard'">
      <xsl:choose>
        <xsl:when test="current-grouping-key()='figuur'">
          <xsl:element name="Figuur" namespace="{$tekst}">
            <xsl:apply-templates select="current-group()/w:r/w:drawing"/>
            <xsl:apply-templates select="current-group()/self::w:p[not(w:r/w:drawing)]"/>
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
                  <xsl:for-each-group select="current-group()[1]/*" group-starting-with="(w:r[w:tab])[1]">
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
                <xsl:for-each-group select="current-group()[1]/*" group-starting-with="(w:r[w:tab])[1]">
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
  <xsl:template match="w:p[descendant::w:t|descendant::w:drawing]">
    <xsl:variable name="styleId" select="w:pPr/w:pStyle/@w:val"/>
    <xsl:choose>
      <xsl:when test="$styleId=($heading_1,$heading_2,$heading_3,$heading_4,$heading_5,$heading_6,$heading_7,'Divisiekop1nawerk','Divisiekop1','Divisiekop2','Divisiekop3','Divisiekop4','Divisiekop5','Divisiekop6','Divisiekop7','Divisiekop8','Divisiekop9')">
        <xsl:element name="Kop" namespace="{$tekst}">
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
                        <xsl:element name="Nummer" namespace="{$tekst}">
                          <xsl:value-of select="$nummer[last()]"/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:when test="count($nummer) gt 1">
                        <xsl:element name="Label" namespace="{$tekst}">
                          <xsl:value-of select="fn:subsequence($nummer,1,count($nummer)-1)"/>
                        </xsl:element>
                        <xsl:element name="Nummer" namespace="{$tekst}">
                          <xsl:value-of select="$nummer[last()]"/>
                        </xsl:element>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:element name="Opschrift" namespace="{$tekst}">
                      <xsl:apply-templates select="current-group()"/>
                    </xsl:element>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each-group>
            </xsl:when>
            <xsl:otherwise>
              <xsl:element name="Opschrift" namespace="{$tekst}">
                <xsl:apply-templates/>
              </xsl:element>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$styleId=('Lidmetnummering')">
        <xsl:for-each-group select="*" group-starting-with="(w:r[w:tab])[1]">
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
        <xsl:for-each-group select="*" group-starting-with="(w:r[w:tab])[1]">
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
      <xsl:when test="$styleId=('Figuurbijschrift')">
        <xsl:element name="Bijschrift" namespace="{$tekst}">
          <xsl:attribute name="locatie" select="if (following::w:p[w:r/w:drawing]) then string('boven') else string('onder')"/>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$styleId=('Tabeltitel')">
        <!-- table plaatst title -->
      </xsl:when>
      <xsl:when test="$styleId=('Wijziging')">
        <xsl:element name="Wat" namespace="{$tekst}">
          <xsl:apply-templates/>
        </xsl:element>
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
    <xsl:variable name="styleId" select="('Noemer','b','i','u','sup','sub')"/>
    <xsl:choose>
      <xsl:when test="$index gt count($styleId)">
        <xsl:apply-templates select="$node/node()"/>
      </xsl:when>
      <xsl:when test="$node/w:rPr[w:rStyle/@w:val eq $styleId[$index]]">
        <xsl:element name="IntIoRef" namespace="{$tekst}">
          <xsl:attribute name="ref"/>
          <xsl:call-template name="range">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="index" select="$index+1"/>
          </xsl:call-template>
        </xsl:element>
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
    <xsl:variable name="id" select="@r:id"/>
    <xsl:variable name="relationship" select="$w:relationships/Relationship[@Id=$id]" xpath-default-namespace="http://schemas.openxmlformats.org/package/2006/relationships"/>
    <xsl:choose>
      <xsl:when test="contains($relationship/@TargetMode,'External')">
        <xsl:element name="ExtRef" namespace="{$tekst}">
          <xsl:attribute name="ref" select="$relationship/@Target"/>
          <xsl:attribute name="soort" select="string('URL')"/>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
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
      <xsl:attribute name="dso:class" namespace="{$dso}" select="string('standaard')"/>
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
            <xsl:attribute name="colwidth" select="concat(@w:w,'*')"/>
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
        <xsl:variable name="imageName" select="fn:tokenize($w:relationships/Relationship[@Id=$imageId]/@Target,'/')[last()]" xpath-default-namespace="http://schemas.openxmlformats.org/package/2006/relationships"/>
        <!-- waarden in dxa, dat is 1/20 pt -->
        <xsl:element name="Illustratie" namespace="{$tekst}">
          <xsl:attribute name="naam" select="$imageName"/>
          <xsl:attribute name="formaat" select="concat('image/',tokenize($imageName,'\.')[last()])"/>
          <xsl:attribute name="breedte" select="string(round((wp:anchor/wp:extent|wp:inline/a:graphic/a:graphicData/pic:pic/pic:spPr/a:xfrm/a:ext)[1]/@cx div 635))"/>
          <xsl:attribute name="hoogte" select="string(round((wp:anchor/wp:extent|wp:inline/a:graphic/a:graphicData/pic:pic/pic:spPr/a:xfrm/a:ext)[1]/@cy div 635))"/>
          <xsl:attribute name="dpi" select="string('72')"/>
          <xsl:attribute name="uitlijning" select="string('start')"/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- voetnoten toevoegen -->

  <xsl:template match="w:footnoteReference">
    <xsl:variable name="footnoteId" select="@w:id"/>
    <xsl:variable name="footnote" select="$w:footnotes/w:footnote[@w:id=$footnoteId]"/>
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